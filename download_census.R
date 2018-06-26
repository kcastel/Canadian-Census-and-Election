# Download cenus data
# http://www12.statcan.gc.ca/datasets/Index-eng.cfm?Temporal=2016&Theme=-1&VNAMEE=&GA=-1&S=0
# http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/index-eng.cfm
# Trying to get this information for as small an area as possible,
# so data was only available for census tracts and dissemination areas.

dir.create("census_data")

#Downloads data
#Takes - char, char
DL_data <- function(name, data.url){
  print(data.url)
  destination.folder <- paste(paste("census_data/", name, sep = ""))
  destination.file <- paste(destination.folder, ".zip", sep = "")
  download.file(data.url,
                destfile = destination.file)
  dir.create(destination.folder)
  unzip(destination.file, exdir = destination.folder)
}#DL_data

# 2013 Federal Electoral Districts

sources.elect <- data.frame(data.name = c("age_sex", #Age and Sex 98-400-X2016006
                                    "marital", #Marital Status 98-400-X2016034
                                    "language_spoken", #First official language spoken 98-400-X2016073
                                    "mother_tongue"), #Mother Tongue 98-400-X2016051 
                      data.url = c("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109528&OFT=CSV",
                                   "http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109656&OFT=CSV",
                                   "http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109983&OFT=CSV",
                                   "http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109667&OFT=CSV"),
                       stringsAsFactors = FALSE)

for (i in 1:nrow(sources.elect)){
  DL_data(paste(sources.elect$data.name[i], "-election", sep = ""), sources.elect$data.url[i])
}#for


# Dissemination area data (400-700 people)

sources.dissem <- data.frame(data.name = c("age_sex", #Age and sex 98-400-X2016003
                                           "family_marital", # Family marital 98-400-X2016034 
                                           "mother_tongue"), #Mother Tongue 98-400-X2016055 
                             data.url = c("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109525&OFT=CSV",
                                          "http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109653&OFT=CSV",
                                          "http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109977&OFT=CSV"),
                             stringsAsFactors = FALSE)

for (i in 1:nrow(sources.dissem)){
  DL_data(sources.dissem$data.name[i], sources.dissem$data.url[i])
}#for

# Census Tracts (2500-8000 people)

sources.tract <- data.frame(data.name = c("families", #Families 98-400-X2016026
                                          "income"), #Income 98-400-X2016121 
                            data.url = c("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109645&OFT=CSV",
                                         "http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=110262&OFT=CSV"),
                            stringsAsFactors = FALSE)

for (i in 1:nrow(sources.tract)){
  DL_data(sources.tract$data.name[i], sources.tract$data.url[i])
}#for

# Boundary Files (http://www.statcan.gc.ca/pub/92-160-g/92-160-g2016002-eng.htm)
# From here: http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2016-eng.cfm
# Downloading the digital boundary files, geographic markup language

boundary.files <- data.frame(data.name = c("dissemination_areas", # Dissemination areas
                                           "tracts"), # Census Tracts
                             data.url = c("http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lda_000a16g_e.zip",
                                          "http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lct_000a16g_e.zip"),
                             stringsAsFactors = FALSE)

for (i in 1:nrow(boundary.files)){
  DL_data(boundary.files$data.name[i], boundary.files$data.url[i])
}#for

