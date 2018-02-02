#Processing the election data into a better form.
#Mostly I want the pollbypoll results to be for the party not the candidate.

#Notes
#-table 8 - votes per party by province, for list of party names
#-table 11 - results per riding
#-table 12 - results per candidate

library(dplyr)
library(magrittr)

dir.create("clean_data")

#Table 8 -> partiesbyprovice - Votes per party, by province 
table8 <- read.csv("election_data/vote_data/table_tableau08.csv",
                   stringsAsFactors = FALSE)
#clean up column names
provinces <- names(table8) %>% strsplit(".Valid.Votes") %>% unlist %>% .[seq(2,26,2)] 
names(table8) <- c("Political.affiliation", provinces)
#simplify Political.affiliation column.
table8$Political.affiliation <- strsplit(table8$Political.affiliation,"/") %>% 
  unlist %>% .[seq(1,49,2)] %>% 
  sub(pattern = "New Democratic Party", replacement = "NDP") %>% 
  gsub(pattern = " Party", replacement = "") %>% 
  gsub(pattern = " of Canada", replacement = "") %>%
  gsub(pattern = "Party for ", replacement = "") %>%
  gsub(pattern = "Accountability, Competency and Transparency", replacement = "Accountability") %>%
  iconv(to = "ASCII//TRANSLIT")
#Writing file
write.csv(table8, file = "clean_data/election_table8.csv", quote = FALSE,
          row.names = FALSE)

#Tabel 11 - Riding results
table11 <- read.csv("election_data/vote_data/table_tableau11.csv",
                    stringsAsFactors = FALSE)
#Cleaning up column names, removing french
names(table11) <- readLines("election_data/vote_data/table_tableau11.csv", n = 1) %>%
  strsplit(",") %>% unlist %>% lapply(function(x) strsplit(x, "/")[[1]][1]) %>% unlist %>% 
  gsub(pattern = " ", replacement = ".") 
#Removing french and simplifying pary names
table11$Electoral.District.Name <- lapply(table11$Electoral.District.Name, function(x)
  strsplit(x, "/")[[1]][1]) %>% unlist 
table11$Province <- lapply(table11$Province, function(x) strsplit(x, "/")[[1]][1]) %>% 
  unlist 
table11$Elected.Candidate <- 
  lapply(table11$Elected.Candidate, function(x) strsplit(x, "/")[[1]][1]) %>% 
  gsub(pattern = "-New Democratic Party", replacement = "") %>% 
  gsub(pattern = "Green Party", replacement = "Green") %>%
  iconv(to = "ASCII//TRANSLIT")#Get simple party names
#Creating new column with the elected party
parties <- paste("Bloc Quebecois", "Conservative", "Green", "Liberal", "NDP", sep="|")
table11$Elected.Party <- lapply(table11$Elected.Candidate, function(x) grepRaw(parties, x) %>%  
                                  substr(x, start = ., stop = nchar(x))) %>%  
  unlist %>% trimws(which = "both") #Get winning party
#Changing Elected.Candidate to first name last name format
table11$Elected.Candidate <- 
  lapply(table11$Elected.Candidate, function(x) strsplit(x, "/")[[1]][1] ) %>% unlist %>%
  lapply(function(x) strsplit(x, parties)[[1]][1]) %>% unlist %>% trimws(which = "both")
first <- lapply(table11$Elected.Candidate, function(x) strsplit(x, ",")[[1]]) %>% unlist %>%
  .[seq(2,676,2)] %>% trimws(which = "both")
last <- lapply(table11$Elected.Candidate, function(x) strsplit(x, ",")[[1]]) %>% unlist %>%
  .[seq(1,676,2)] %>% trimws(which = "both")
table11$Elected.Candidate <- paste(first, last, sep = " ")
#writing file
write.csv(table11, file = "clean_data/election_table11.csv", quote = FALSE,
          row.names = FALSE)

#Table 12
table12 <- read.csv("election_data/vote_data/table_tableau12.csv",
                    stringsAsFactors = FALSE)
#Remove french from column names
names(table12) <- readLines("election_data/vote_data/table_tableau12.csv", n = 1) %>%
  strsplit(",") %>% unlist %>% lapply(function(x) strsplit(x, "/")[[1]][1]) %>% unlist %>% 
  gsub(pattern = " ", replacement = ".") 
table12$Candidate.Residence <- NULL #this collumn in unneeded and caused some issues
table12$Candidate.Occupation <- NULL #same reason as above
#district.numbers <- unique(table12$Electoral.District.Number)
#Removing french from whole table
for (i in 1:ncol(table12)){
  if (is.character(table12[,i])){
    table12[,i] <- lapply(table12[,i], function(x) strsplit(x, "/")[[1]][1]) %>% unlist
  }#if
}#for
#Getting clean party names
table12$Candidate <- lapply(table12$Candidate, function(x) strsplit(x, "/")[[1]][1]) %>% 
  gsub(pattern = "-New Democratic Party", replacement = "") %>% 
  gsub(pattern = "Green Party", replacement = "Green") %>%
  gsub(pattern = "ATN", replacement = "Alliance of the North") %>%
  gsub(pattern = "CAP", replacement = "Canadian Action") %>%
  gsub(pattern = "PC Party", replacement = " Progressive Canadian") %>%
  gsub(pattern = "PACT", replacement = "Accountability, Competency and Transparency") %>%
  gsub(pattern = "Animal Alliance", replacement = "Animal Alliance Environment Voters") %>%
  gsub(pattern = "Party", replacement = "") %>%
  gsub(pattern = ", Competency and Transparency", replacement = "") %>%
  gsub(pattern = "\\*", replacement = "") %>%
  iconv(to = "ASCII//TRANSLIT") %>%
  gsub(pattern = " - Allier les forces de nos regions", replacement = "") 
#Creating a Political.Affiliation column in table12
table12 <- mutate(table12, Political.affiliation = NA)
for (i in 1:length(table8$Political.affiliation)){
  table12$Political.affiliation[grep(table8$Political.affiliation[i],
                                     table12$Candidate)] <-
    table8$Political.affiliation[i]
}#for
#Removing the party names from table12$Candidate
#Strings need to be reversed to remove the party name from the end.
#This is a problem for people whose name has "Green" in it and are from the Green party
for (i in 1:nrow(table12)){
  if (!grepl("Green", table12$Candidate[i])){
    table12$Candidate[i] <- sub(pattern = table12$Political.affiliation[i],
         replacement = "",
         x = table12$Candidate[i]) %>%
      trimws(which = "both")
  } else {
    p <- strsplit(table12$Political.affiliation[i], NULL)[[1]] %>% 
      rev %>% paste(collapse = "")
    r <- strsplit(table12$Candidate[i], NULL)[[1]] %>% 
      rev %>% paste(collapse = "")
    table12$Candidate[i] <- sub(pattern = p, replacement = "", x = r)
    table12$Candidate[i] <- strsplit(table12$Candidate[i], NULL)[[1]] %>% rev %>% paste(collapse = "")
  }#else
}#for
#writing file
write.csv(table12, file = "clean_data/election_table12.csv",
          quote = FALSE, row.names = FALSE)


#pollbypoll data
#Want to create master file with all data
pollbypoll <- list.files("election_data/vote_data/") %>%
  .[grep(pattern = "pollbypoll+", x = .)]
all.ridings <- data.frame()

for (i in 1:length(pollbypoll)){ 
  riding.number <- gsub("[a-z_.]", "", pollbypoll[i])
  riding.results <- read.csv(paste("election_data/vote_data/", 
                                   pollbypoll[i], sep = ""),
                             stringsAsFactors = FALSE)
  #Remove french from column names
  names(riding.results) <- readLines(paste("election_data/vote_data/", 
                                           pollbypoll[i], sep = ""), 
                                     n = 1) %>%
    iconv(to = "ASCII//TRANSLIT") %>%
    strsplit(",") %>% unlist %>% lapply(function(x) strsplit(x, "/")[[1]][1]) %>% unlist %>% 
    gsub(pattern = " ", replacement = ".") 
  #removing french district name
  riding.results$Electoral.District.Name <- 
    strsplit(riding.results$Electoral.District.Name[1], "/")[[1]][1] %>% unlist %>% 
    gsub(pattern = " ", replacement = ".") 
  #changing candidate names to party names
  temp <- names(riding.results) %>% gsub("[.]", " ", .) %>% gsub("  ", " ", .)
  for (j in 5:(length(temp) - 3)){
    #Need to do this to prevent agrep from finding multiple matches
    index <- agrep(temp[j], 
                   filter(table12, Electoral.District.Number == riding.number)$Candidate)
    temp[j] <- table12$Political.affiliation[index]
  }#for
  names(riding.results) <- gsub(" ", ".", temp)
  
  #writing file
  file.name <- paste("clean_data/election_", riding.number, ".csv", sep = "")
  write.csv(riding.results, file = file.name, quote = FALSE, row.names = FALSE)
}#for

