# Merging data from table 8 and 12 of the election data
# and several election level data sets from the census

library(dplyr)
library(magrittr)

master.names <- character()

#election data
table8 <- read.csv("clean_data/election_table8.csv",
                   stringsAsFactors = FALSE)
table11 <- read.csv("clean_data/election_table11.csv",
                    stringsAsFactors = FALSE)
table12 <- read.csv("clean_data/election_table12.csv",
                    stringsAsFactors = FALSE)



#census data
age.sex <- read.csv("census_data/age_sex-election/98-400-X2016006_English_CSV_data.csv",
                    stringsAsFactors = FALSE)
language <- read.csv("census_data/language_spoken-election/98-400-X2016073_English_CSV_data.csv",
                     stringsAsFactors = FALSE)
mother.tounge <- read.csv("census_data/mother_tounge-election/98-400-X2016051_English_CSV_data.csv",
                          stringsAsFactors = FALSE)


#creating master.table names

#names from census age data
age.names <- character()
min.age <- 0
while (min.age < 100){
  age.names <- c(age.names,
                 paste(min.age, "to", min.age+4, "years", sep = "."))
  min.age <- min.age + 5
}#while
age.names <- c(age.names, "100.years.and.over", "average")
age.names <- c(paste(age.names, "male", sep = "."), paste(age.names, "female", sep = "."))

#Language spoken at home 
#english = 4, french = 5, other = 1 - 4 - 5
language.names <- c("english.home", "french.home", "other.home")

#Mother tounge
#english = column 15, french = column 16, other = col 14 - col 15 - col 16
mother.tounge.names <- c("english.mother", "french.mother", "other.mother")

master.names <- c(names(table11)[c(1:3,12,14)], 
                  gsub(pattern = " ", replacement = ".", table8$Political.affiliation),
                  age.names, language.names, mother.tounge.names)


#Merging data.tables
master.table <- matrix(data = NA, nrow = nrow(table11), ncol = length(master.names)) %>% 
  as.data.frame
names(master.table) <- master.names
master.table[,1:5] <- table11[,c(1:3,12,14)]

#Adding voting results
for (i in 1:nrow(table12)){
  row.num <- grep(table12$Electoral.District.Number[i], master.table$Electoral.District.Number)
  col.num <- grep(table12$Political.affiliation[i], master.names)
  print(paste(i,table12$Votes.Obtained[i]))
  master.table[row.num,col.num] <- table12$Votes.Obtained[i]
}#for 

#Adding age data
age.indexes <- c(3,9,15,22,28,34,40,46,52,58,64,70,76,83,89,95,101,108,114,120,126,127)

for (i in 1:nrow(master.table)){
  temp <- filter(age.sex, GEO_CODE..POR. == master.table$Electoral.District.Number[i])
  age.count <- c(temp$Dim..Sex..3...Member.ID...2...Male[age.indexes],
              temp$Dim..Sex..3...Member.ID...3...Female[age.indexes]) %>% 
    as.integer %>% as.data.frame %>% t
  first.column <- grep("0.to.4.years.male", master.names)
  master.table[i,first.column:(first.column + ncol(age.count) - 1)] <- age.count
}#for

#Adding language spoken at home 
language.indexes <- c(4:6)

for (i in 1:nrow(master.table)){
  temp <- filter(language, GEO_CODE..POR. == master.table$Electoral.District.Number[i])
  language.count <- temp[language.indexes, 17] %>%
    as.data.frame %>% t
  first.column <- grep("english.home", master.names)
  master.table[i,first.column:(first.column+2)] <- language.count
}#for

#Adding mother tounges
for (i in 1:nrow(master.table)){
  temp <- filter(mother.tounge, GEO_CODE..POR. == master.table$Electoral.District.Number[i])
  mother.count <- c(temp$Dim..Mother.tongue..10...Member.ID...2...English[1],
                    temp$Dim..Mother.tongue..10...Member.ID...3...French[1],
                    (temp$Dim..Mother.tongue..10...Member.ID...1...Total...Mother.tongue[1] - 
                       temp$Dim..Mother.tongue..10...Member.ID...2...English[1] -
                       temp$Dim..Mother.tongue..10...Member.ID...3...French[1])) %>%
    as.data.frame %>% t
  first.column <- grep("english.mother", master.names)
  master.table[i,first.column:(first.column+2)] <- mother.count
}#for


#writing to file
write.csv(master.table, file = "clean_data/master_election_level.csv", row.names = FALSE,
          quote = FALSE)
