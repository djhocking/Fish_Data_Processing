Processing Raw Brook Trout Data
========================================================

### Daniel J. Hocking
### 11 February 2014

Set working directory and load packages

```r
setwd("/Users/Dan/Documents/Research/Stream_Climate_Change/Brook_Trout_Data/")

library(dplyr)
library(data.table)
library(reshape2)
library(ggplot2)
```


## CT
The `Yoichiro_data_08212012 v2.xlsx` would not save as a csv or txt file from excel, so saved as a `.xls` file and opened in **LibreOffice**, which was able to convert it to a csv. Use `fread` function from the `data.table` package to read in large files much quicker. Thankfully, the commas entered in the data did not cause a problem with importing the csv file appropriately, likely because it recognized it as part of the string since the entire column was characters. This occus in both the "Landmark" and "Common Name" columns. I did have to do a find `"` and replace with nothing to get the data to parse correctly.


```r
ct.raw <- fread("CT_Raw/CT_Raw.csv")
str(ct.raw)
summary(ct.raw)
head(ct.raw, 30)
```


Add unique key and state for resorting, error checking, and combining with other datasets. Replace column names with something more sensible, concise, and lacking spaces and special characters. Use `setnames()` rather than `names() <-` because setnames doesn't create a copy of the dataframe in the process, therefore saves memory and time.


```r
ct.raw$state.key <- seq(from = 1, to = length(ct.raw[, 1]))
ct.raw$state <- "CT"
names(ct.raw)
setnames(ct.raw, c("date1", "run.samplebysite", "stream.name", "proximity", 
    "landmark", "basin", "municipality", "official", "lat", "lon", "metadata.samplybysite", 
    "expr1011", "pass", "sample.length", "shock.time", "stream.width", "species", 
    "tl.cm", "wild", "count", "sci.name", "common.name", "site", "state.key", 
    "state"))
names(ct.raw)
head(ct.raw, 30)
```


### Clean Data
Replace sample.length of 0 with NA, shock.time of 0 with NA, tl.cm of -99 and 9999 with NA, count -99 with NA. Check some really high values.


```r
summary(ct.raw)
ct.raw$count[which(ct.raw$count < 0)] <- NA
ct.raw$shock.time[which(ct.raw$shock.time == 0)] <- NA
ct.raw$stream.width[which(ct.raw$stream.width == 0)] <- NA
ct.raw$stream.width[which(ct.raw$stream.width > 50)] <- NA
ct.raw$sample.length[which(ct.raw$sample.length == 0)] <- NA
ct.raw$tl.cm[which(ct.raw$tl.cm == -99)] <- NA
ct.raw$tl.cm[which(ct.raw$tl.cm == 9999)] <- NA

summary(ct.raw)

hist(ct.raw$sample.length)  # consider cutting over 600 (break) or 1000m because methods could differ signicantly
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) 

```r
hist(ct.raw$count)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) 

```r
hist(ct.raw$shock.time)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-33.png) 

```r
hist(ct.raw$stream.width)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-34.png) 

```r
hist(ct.raw$tl.cm[which(ct.raw$sci.name == "Salvelinus fontinalis")])
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-35.png) 

```r
summary(ct.raw$tl.cm[which(ct.raw$sci.name == "Salvelinus fontinalis")])

ct.raw[which(ct.raw$tl.cm > 30 & ct.raw$sci.name == "Salvelinus fontinalis"), 
    c(sci.name, tl.cm)]  # find mis-entered length data for brook trout
ct.raw$tl.cm[which(ct.raw$tl.cm == 112 & ct.raw$sci.name == "Salvelinus fontinalis")] <- NA

plot(ct.raw$shock.time, ct.raw$count)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-36.png) 

```r
plot(ct.raw$sample.length, ct.raw$count)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-37.png) 

```r
plot(ct.raw$shock.time, ct.raw$sample.length)  # large values match so are likely not typos
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-38.png) 

```r
ggplot(data = ct.raw, aes(sample.length, count)) + geom_point()
```

```
## Warning: Removed 665 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-39.png) 

```r

ct.raw$date <- as.Date(ct.raw$date1, "%m/%d/%Y")
```


strptime for date

Add calculated fields (turn length into stage - at least for brook trout >80 mm in August = adult)

What to do about timing of surveys affecting detection of YOY, include stage at all?


Separate fish data for combining with other datasets



Collapse to unique site-visit


## MA


```r
setwd("/Users/Dan/Documents/Research/Stream_Climate_Change/Brook_Trout_Data/MA_Raw/")

ma.raw <- read.table("Mass_fish_data_EBTJV_7-15-13.csv", sep = ",", header = TRUE)
```



ME
-------------------------

Use the `read.dbf` function in the `foreign` package to read in data from the shapefile. 


```r
library(foreign)

setwd("/Users/Dan/Documents/Research/Stream_Climate_Change/Brook_Trout_Data/ME_Raw/")
me.raw <- read.dbf("Data_Request_EBTJV_Maine.dbf")

str(me.raw)
summary(me.raw)
head(me.raw, 30)

levels(as.factor(me.raw$RUNNUM))
levels(as.factor(me.raw$LIFE_STAGE))

me.raw2 <- read.dbf("DATA_REQ.dbf")
str(me.raw2)
summary(me.raw2)
head(me.raw2, 20)

dim(me.raw)
dim(me.raw2)
```


**ISSUES**
1. The UTM coordinates are strange and will need conversion.
2. RUNNUM = pass?
3. Unify NA, Unknown, unknown, etc.
  * Adults/Juveniles
  * Sublegal
  * Legal
  * YOY/Juveniles/Adults
4. Currently no sample length
5. SPP merge with species codes file
6. Two .dbf files are almost identical but have slightly different mean abundances and NA (NA stored as 0 in one?)

















