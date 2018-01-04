#Download elections data for 2015 Federal election

dir.create("election_data")


# boundary data - http://geogratis.gc.ca/api/en/nrcan-rncan/ess-sst/157fcaf7-e1f7-4f6d-8fc9-564ec925c1ee.html#distribution
download.file("http://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/electoral/2015/pd338.2015.zip",
              destfile = "election_data/boundaries.zip")
dir.create("election_data/boundaries")
unzip("election_data/boundaries.zip", exdir = "election_data/boundaries")

#election data
#http://www.elections.ca/content.aspx?section=res&dir=rep/off/42gedata&document=bypro&lang=e
download.file("http://www.elections.ca/res/rep/off/ovr2015app/41/data_donnees/pollbypoll_bureauparbureauCanada.zip",
              destfile = "election_data/votes.zip")
dir.create("election_data/vote_data")
unzip("election_data/votes.zip", exdir = "election_data/vote_data")

