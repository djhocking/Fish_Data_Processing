
#RHODE ISLAND
setwd("/Users/Dan/Documents/Research/Stream_Climate_Change/Brook_Trout_Data/RIocc_ONeil/")

sheet1 <- read.csv("kanno1.csv")
sheet2 <- read.csv("kanno2.csv")
sheet3 <- read.csv("kanno3.csv")
sheet4 <- read.csv("kanno4.csv")
sheet5 <- read.csv("kanno5.csv")
sheet6 <- read.csv("kanno6.csv")
sheet7 <- read.csv("kanno7.csv")
sheet8 <- read.csv("kanno8.csv")
sheet9 <- read.csv("kanno9.csv")
sheet10 <- read.csv("kanno10.csv")


#Join all of the tables:
#-----------------------
sheets <- list(sheet1, sheet2, sheet3, sheet4, sheet5, sheet6, sheet7, sheet8, sheet9, sheet10)

for ( i in 1:10){
  if (i == 1) { master <- data.frame(sheets[[i]][c("Basin", "Stem", "Station", "Species", "Latitude", "Longitude")]) }
    else{master <- rbind(master, sheets[[i]][c("Basin", "Stem", "Station", "Species", "Latitude", "Longitude")])}                                                                   
}
  

#Create SiteIDs and a column for occupancy:
#------------------------------------------
master <- data.frame(master, paste(master$Basin, master$Stem, master$Station), 0)
names(master)[7:8] <- c("SiteID", "BrktrtOccupancy")



#Select sites with brookies and save em:
#---------------------------------------
brookies <- master[(which(master$Species == 'brktrt')),]
Present <- brookies$SiteID

master$BrktrtOccupancy[which(master$SiteID %in% Present & master$Species == 'brktrt')] <- 1


#Fix the Lat/Lon Errors
#----------------------

#Some had decimal errors:
decimal <- which(master$Latitude > 100)
master$Latitude[decimal] <- master$Latitude[decimal]/10000
master$Longitude[decimal] <- -master$Longitude[decimal]/10000


#Other Lon values were missing signs:
master$Longitude[which(master$Longitude > 0 )] <- - master$Longitude[which(master$Longitude > 0 )] 


#Save the output:
#----------------
write.csv(master, "Occupancy.csv", row.names = FALSE)


