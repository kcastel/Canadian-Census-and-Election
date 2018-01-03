# Download cenus data
# http://www12.statcan.gc.ca/datasets/Index-eng.cfm?Temporal=2016&Theme=-1&VNAMEE=&GA=-1&S=0
# Trying to get this information for as small an area as possible,
# so data was only available for census tracts and dissemination areas.

dir.create("census_data")

# Dissemination area data (400-700 people)

# 98-400-X2016003 
# Age and sex
download.file("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109525&OFT=CSV",
              destfile = "census_data/age_sex.zip")
dir.create("census_data/age_sex")
unzip("census_data/age_sex.zip", exdir = "census_data/age_sex")


# 98-400-X2016034 
# family_marital
download.file("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109653&OFT=CSV",
              destfile = "census_data/family_marital.zip")
dir.create("census_data/family_marital")
unzip("census_data/family_marital.zip", exdir = "census_data/family_marital")

# 98-400-X2016055 
# Mother Tounge
download.file("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109977&OFT=CSV",
              destfile = "census_data/mother_tounge.zip")
dir.create("census_data/mother_tounge")
unzip("census_data/mother_tounge.zip", exdir = "census_data/mother_tounge")

# Census Tracts (2500-8000 people)

# 98-400-X2016026
# Families
download.file("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=109645&OFT=CSV",
              destfile = "census_data/families.zip")
dir.create("census_data/families")
unzip("census_data/families.zip", exdir = "census_data/families")

# 98-400-X2016121 
# Income
download.file("http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/CompDataDownload.cfm?LANG=E&PID=110262&OFT=CSV",
              destfile = "census_data/income.zip")
dir.create("census_data/income")
unzip("census_data/income.zip", exdir = "census_data/income")

# Boundary Files (http://www.statcan.gc.ca/pub/92-160-g/92-160-g2016002-eng.htm)
# From here: http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2016-eng.cfm
# Downloading the digital boundary files, geographic markup language

# Dissemination areas
download.file("http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lda_000a16g_e.zip",
              destfile = "census_data/dissemination_areas.zip")
dir.create("census_data/dissemination_areas")
unzip("census_data/dissemination_areas.zip", exdir = "census_data/dissemination_areas")

# census tracts
download.file("http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lct_000a16g_e.zip",
              destfile = "census_data/tracts.zip")
dir.create("census_data/tracts")
unzip("census_data/tracts.zip", exdir = "census_data/tracts")
