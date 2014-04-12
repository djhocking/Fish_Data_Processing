Processing Southern Fish Data
========================================================


### Setup
Import data, load packages, set working directory

Cleaning before entry into R:
* Replaced `,` with blank to read csv properly
* Replaced `'` and `"` with blank to avoid problems reading in text columns
* Replaced `ND` (No Data) with `NA` for missing data
* Changed `Species` to `Code` in the fish data headers to be able to merge with the species data (could do in R after import)


```r
library(data.table)
library(dplyr)
library(ggplot2)

setwd("/Users/Dan/Documents/Research/Stream_Climate_Change/Brook_Trout_Data/Southern/")

fish <- fread("Southern_Fish.csv", header = TRUE, sep = ",")
sites <- fread("Southern_Site_Info.csv", header = TRUE, sep = ",")
spp <- fread("Southern_Spp_Codes.csv", header = TRUE, sep = ",")
```


Add primary key for resorting back to original data


```r
summary(fish)
fish$fish.key <- 1:length(fish$Pass)
sites$site.key <- 1:length(sites$SiteID)
spp$spp.key <- 1:length(spp$Code)
```


### Merge data sets, organize dates, and export


```r
data <- left_join(fish, sites, by = "SiteID")
summary(data)
```

```
##     TripID             SiteID              Date                Year     
##  Length:252951      Length:252951      Length:252951      Min.   :1982  
##  Class :character   Class :character   Class :character   1st Qu.:1995  
##  Mode  :character   Mode  :character   Mode  :character   Median :2001  
##                                                           Mean   :2000  
##                                                           3rd Qu.:2006  
##                                                           Max.   :2012  
##                                                                         
##       Pass          Code               Length        Weight     
##  Min.   :1.00   Length:252951      Min.   :  1   Min.   :   0   
##  1st Qu.:1.00   Class :character   1st Qu.: 68   1st Qu.:   3   
##  Median :1.00   Mode  :character   Median :100   Median :  10   
##  Mean   :1.32                      Mean   :109   Mean   :  21   
##  3rd Qu.:1.00                      3rd Qu.:142   3rd Qu.:  26   
##  Max.   :4.00                      Max.   :713   Max.   :2186   
##  NA's   :17                        NA's   :15    NA's   :57825  
##   DataSource          Location            fish.key         State          
##  Length:252951      Length:252951      Min.   :     1   Length:252951     
##  Class :character   Class :character   1st Qu.: 63238   Class :character  
##  Mode  :character   Mode  :character   Median :126476   Mode  :character  
##                                        Mean   :126476                     
##                                        3rd Qu.:189714                     
##                                        Max.   :252951                     
##                                                                           
##     site.key       Datum               LatDD        Contact         
##  Min.   :  1    Length:252951      Min.   :34.6   Length:252951     
##  1st Qu.:131    Class :character   1st Qu.:35.8   Class :character  
##  Median :195    Mode  :character   Median :38.4   Mode  :character  
##  Mean   :196                       Mean   :37.7                     
##  3rd Qu.:272                       3rd Qu.:38.6                     
##  Max.   :414                       Max.   :41.7                     
##  NA's   :1272                      NA's   :1272                     
##      LonDD      
##  Min.   :-84.2  
##  1st Qu.:-83.1  
##  Median :-78.7  
##  Mean   :-80.0  
##  3rd Qu.:-78.4  
##  Max.   :-76.4  
##  NA's   :1272
```

```r
sites[which(is.na(sites$LonDD)), ]
```

```
##                  SiteID State LatDD LonDD Datum Contact site.key
##  1:        Steels Creek    NC    NA    NA          Rash      354
##  2:       Beetree Creek    NC    NA    NA          Rash      355
##  3: Looking Glass Creek    NC    NA    NA          Rash      356
##  4:     Big Horse Creek    NC    NA    NA          Rash      357
##  5:     Three Top Creek    NC    NA    NA          Rash      358
##  6:     South Toe River    NC    NA    NA          Rash      359
##  7:         Upper Creek    NC    NA    NA          Rash      360
##  8:     Greenland Creek    NC    NA    NA          Rash      361
##  9:   Panthertown Creek    NC    NA    NA          Rash      362
## 10:      Mitchell River    NC    NA    NA          Rash      363
## 11:          Boone Fork    NC    NA    NA          Rash      364
```

```r

data <- left_join(data, spp, by = "Code")
summary(data)
```

```
##     TripID             SiteID              Date                Year     
##  Length:252951      Length:252951      Length:252951      Min.   :1982  
##  Class :character   Class :character   Class :character   1st Qu.:1995  
##  Mode  :character   Mode  :character   Mode  :character   Median :2001  
##                                                           Mean   :2000  
##                                                           3rd Qu.:2006  
##                                                           Max.   :2012  
##                                                                         
##       Pass          Code               Length        Weight     
##  Min.   :1.00   Length:252951      Min.   :  1   Min.   :   0   
##  1st Qu.:1.00   Class :character   1st Qu.: 68   1st Qu.:   3   
##  Median :1.00   Mode  :character   Median :100   Median :  10   
##  Mean   :1.32                      Mean   :109   Mean   :  21   
##  3rd Qu.:1.00                      3rd Qu.:142   3rd Qu.:  26   
##  Max.   :4.00                      Max.   :713   Max.   :2186   
##  NA's   :17                        NA's   :15    NA's   :57825  
##   DataSource          Location            fish.key         State          
##  Length:252951      Length:252951      Min.   :     1   Length:252951     
##  Class :character   Class :character   1st Qu.: 63238   Class :character  
##  Mode  :character   Mode  :character   Median :126476   Mode  :character  
##                                        Mean   :126476                     
##                                        3rd Qu.:189714                     
##                                        Max.   :252951                     
##                                                                           
##     site.key       Datum               LatDD        Contact         
##  Min.   :  1    Length:252951      Min.   :34.6   Length:252951     
##  1st Qu.:131    Class :character   1st Qu.:35.8   Class :character  
##  Median :195    Mode  :character   Median :38.4   Mode  :character  
##  Mean   :196                       Mean   :37.7                     
##  3rd Qu.:272                       3rd Qu.:38.6                     
##  Max.   :414                       Max.   :41.7                     
##  NA's   :1272                      NA's   :1272                     
##      LonDD         Sci name            spp.key     Common Name       
##  Min.   :-84.2   Length:252951      Min.   : 1.0   Length:252951     
##  1st Qu.:-83.1   Class :character   1st Qu.:15.0   Class :character  
##  Median :-78.7   Mode  :character   Median :15.0   Mode  :character  
##  Mean   :-80.0                      Mean   :14.7                     
##  3rd Qu.:-78.4                      3rd Qu.:15.0                     
##  Max.   :-76.4                      Max.   :17.0                     
##  NA's   :1272
```

```r

data$date <- as.Date(data$Date, format = "%m/%d/%Y")
data$month <- as.numeric(format(data$date, format = "%m"))
data$doy <- strptime(data$Date, "%m/%d/%Y")$yday + 1

head(data)
```

```
##       TripID SiteID      Date Year Pass Code Length Weight DataSource
## 1 1F001_1982  1F001 6/16/1982 1982    1 SAFO     50     NA    Wofford
## 2 1F001_1982  1F001 6/16/1982 1982    1 SAFO     50     NA    Wofford
## 3 1F001_1982  1F001 6/16/1982 1982    1 SAFO     55     NA    Wofford
## 4 1F001_1982  1F001 6/16/1982 1982    1 SAFO     60     NA    Wofford
## 5 1F001_1982  1F001 6/16/1982 1982    1 SAFO     60     NA    Wofford
## 6 1F001_1982  1F001 6/16/1982 1982    1 SAFO     60     NA    Wofford
##   Location fish.key State site.key Datum LatDD Contact LonDD
## 1     SHEN        1    VA      111 NAD83 38.82 Wofford -78.2
## 2     SHEN        2    VA      111 NAD83 38.82 Wofford -78.2
## 3     SHEN        3    VA      111 NAD83 38.82 Wofford -78.2
## 4     SHEN        4    VA      111 NAD83 38.82 Wofford -78.2
## 5     SHEN        5    VA      111 NAD83 38.82 Wofford -78.2
## 6     SHEN        6    VA      111 NAD83 38.82 Wofford -78.2
##                Sci name spp.key Common Name       date month doy
## 1 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167
## 2 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167
## 3 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167
## 4 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167
## 5 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167
## 6 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167
```

```r

write.table(data, "All_Field_Data.csv", row.names = FALSE, sep = ",")
```


11 sites have not lat and lon recorded which results in 1272 records with missing location data out of 252,951 records (0.5%)

### Add stages

Plot histograms of all species lengths to get estimates of cutoffs for stage (hopefully doesn't have to be done by month)


```r
# Plot to find cutoffs
for (i in 1:length(unique(fish$Code))) {
    g <- ggplot(filter(fish, Code == unique(fish$Code)[i]), aes(Length))
    print(g + geom_histogram(binwidth = 10) + ggtitle(unique(fish$Code)[i]) + 
        scale_x_continuous(breaks = seq(0, max(fish[which(fish$Code == unique(fish$Code)[i]), 
            ]$Length, na.rm = T), 20)))
}
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-21.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-22.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-23.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-24.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-25.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-26.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-27.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-28.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-29.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-210.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-211.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-212.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-213.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-214.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-215.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-216.png) ![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-217.png) 

```r

i = 13
g <- ggplot(filter(fish, Code == unique(fish$Code)[i] & Length < 200), aes(Length))
print(g + geom_histogram(binwidth = 5) + ggtitle(unique(fish$Code)[i]) + scale_x_continuous(breaks = seq(0, 
    200, 10)))
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-218.png) 

```r

i = 14
g <- ggplot(filter(fish, Code == unique(fish$Code)[i]), aes(Length))
print(g + geom_histogram(binwidth = 10) + ggtitle(unique(fish$Code)[i]) + scale_x_continuous(breaks = seq(0, 
    200, 10)))
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-219.png) 


Potential Outlier Lengths:
* SAFO > 300
* SATR > ~350?
* ONMY > ~320?
* RHCA > 200
* COBA > 150

YOY cutoffs:
* SAFO: 90 mm
* LEGI: Insufficient Data
* AMRU: Unclear
* MIDO: 70 mm (not clear)
* AMNA: Insufficient Data
* SATR: 100 mm
* LEAU: Insufficient Data
* LEMA: Insufficient Data
* HXTR: Insufficient Data
* ONMY: 90 mm
* AMNE: Insufficient Data
* MISA: Insufficient Data
* RHCA: 20 mm
* RHAT: 10 mm
* COBA: 40 mm (maybe 45 mm)
* CAAN: Insufficient Data
* SEAT: Insufficient Data


```r
# Add stage
data$stage <- NA
data[which(data$Length < 90 & data$Code == "SAFO"), ]$stage <- 0  # YOY
data$stage[which(data$Length >= 90 & data$Code == "SAFO")] <- 1  # Adult

data[which(data$Length < 70 & data$Code == "MIDO"), ]$stage <- 0  # YOY
data$stage[which(data$Length >= 70 & data$Code == "MIDO")] <- 1  # Adult

data$stage[which(data$Length < 100 & data$Code == "SATR")] <- 0  # YOY
data$stage[which(data$Length >= 100 & data$Code == "SATR")] <- 1  # Adult

data$stage[which(data$Length < 90 & data$Code == "ONMY")] <- 0  # YOY
data$stage[which(data$Length >= 90 & data$Code == "ONMY")] <- 1  # Adult

data$stage[which(data$Length < 20 & data$Code == "RHCA")] <- 0  # YOY
data$stage[which(data$Length >= 20 & data$Code == "RHCA")] <- 1  # Adult

data$stage[which(data$Length < 10 & data$Code == "RHAT")] <- 0  # YOY
data$stage[which(data$Length >= 10 & data$Code == "RHAT")] <- 1  # Adult

data$stage[which(data$Length < 40 & data$Code == "COBA")] <- 0  # YOY
data$stage[which(data$Length >= 40 & data$Code == "COBA")] <- 1  # Adult
```


Convert to count data (problem of how to fill in zeros) - maybe should do this for all species before subsetting to bkt. Would have to assign stage wherever possible first


```r
count <- summarise(group_by(data, TripID, Pass, Code), count = n(), length.mean = mean(Length), 
    mass.mean = mean(Weight))

count.stage <- summarise(group_by(data, TripID, Pass, Code, stage), count = n(), 
    length.mean = mean(Length))
```


Expand data to include zeros for all species per trip and pass. Then merge back with day and site information based on TripID.


```r

count$TripID <- as.factor(count$TripID)

mergedData <- merge(expand.grid(TripID = unique(data$TripID), Code = unique(data$Code), 
    Pass = unique(data$Pass)), y = count, by = c("TripID", "Code", "Pass"), 
    all.x = T)
head(mergedData, 100)
```

```
##         TripID Code Pass count length.mean mass.mean
## 1   1F001_1982 SAFO    1    21       117.6        NA
## 2   1F001_1982 SAFO    2    NA          NA        NA
## 3   1F001_1982 SAFO    3    NA          NA        NA
## 4   1F001_1982 SAFO    4    NA          NA        NA
## 5   1F001_1982 SAFO   NA    NA          NA        NA
## 6   1F001_1982 LEGI    1    NA          NA        NA
## 7   1F001_1982 LEGI    2    NA          NA        NA
## 8   1F001_1982 LEGI    3    NA          NA        NA
## 9   1F001_1982 LEGI    4    NA          NA        NA
## 10  1F001_1982 LEGI   NA    NA          NA        NA
## 11  1F001_1982 AMRU    1    NA          NA        NA
## 12  1F001_1982 AMRU    2    NA          NA        NA
## 13  1F001_1982 AMRU    3    NA          NA        NA
## 14  1F001_1982 AMRU    4    NA          NA        NA
## 15  1F001_1982 AMRU   NA    NA          NA        NA
## 16  1F001_1982 MIDO    1    NA          NA        NA
## 17  1F001_1982 MIDO    2    NA          NA        NA
## 18  1F001_1982 MIDO    3    NA          NA        NA
## 19  1F001_1982 MIDO    4    NA          NA        NA
## 20  1F001_1982 MIDO   NA    NA          NA        NA
## 21  1F001_1982 AMNA    1    NA          NA        NA
## 22  1F001_1982 AMNA    2    NA          NA        NA
## 23  1F001_1982 AMNA    3    NA          NA        NA
## 24  1F001_1982 AMNA    4    NA          NA        NA
## 25  1F001_1982 AMNA   NA    NA          NA        NA
## 26  1F001_1982 SATR    1    NA          NA        NA
## 27  1F001_1982 SATR    2    NA          NA        NA
## 28  1F001_1982 SATR    3    NA          NA        NA
## 29  1F001_1982 SATR    4    NA          NA        NA
## 30  1F001_1982 SATR   NA    NA          NA        NA
## 31  1F001_1982 LEAU    1    NA          NA        NA
## 32  1F001_1982 LEAU    2    NA          NA        NA
## 33  1F001_1982 LEAU    3    NA          NA        NA
## 34  1F001_1982 LEAU    4    NA          NA        NA
## 35  1F001_1982 LEAU   NA    NA          NA        NA
## 36  1F001_1982 LEMA    1    NA          NA        NA
## 37  1F001_1982 LEMA    2    NA          NA        NA
## 38  1F001_1982 LEMA    3    NA          NA        NA
## 39  1F001_1982 LEMA    4    NA          NA        NA
## 40  1F001_1982 LEMA   NA    NA          NA        NA
## 41  1F001_1982 HXTR    1    NA          NA        NA
## 42  1F001_1982 HXTR    2    NA          NA        NA
## 43  1F001_1982 HXTR    3    NA          NA        NA
## 44  1F001_1982 HXTR    4    NA          NA        NA
## 45  1F001_1982 HXTR   NA    NA          NA        NA
## 46  1F001_1982 ONMY    1    NA          NA        NA
## 47  1F001_1982 ONMY    2    NA          NA        NA
## 48  1F001_1982 ONMY    3    NA          NA        NA
## 49  1F001_1982 ONMY    4    NA          NA        NA
## 50  1F001_1982 ONMY   NA    NA          NA        NA
## 51  1F001_1982 AMNE    1    NA          NA        NA
## 52  1F001_1982 AMNE    2    NA          NA        NA
## 53  1F001_1982 AMNE    3    NA          NA        NA
## 54  1F001_1982 AMNE    4    NA          NA        NA
## 55  1F001_1982 AMNE   NA    NA          NA        NA
## 56  1F001_1982 MISA    1    NA          NA        NA
## 57  1F001_1982 MISA    2    NA          NA        NA
## 58  1F001_1982 MISA    3    NA          NA        NA
## 59  1F001_1982 MISA    4    NA          NA        NA
## 60  1F001_1982 MISA   NA    NA          NA        NA
## 61  1F001_1982 RHCA    1    NA          NA        NA
## 62  1F001_1982 RHCA    2    NA          NA        NA
## 63  1F001_1982 RHCA    3    NA          NA        NA
## 64  1F001_1982 RHCA    4    NA          NA        NA
## 65  1F001_1982 RHCA   NA    NA          NA        NA
## 66  1F001_1982 RHAT    1    NA          NA        NA
## 67  1F001_1982 RHAT    2    NA          NA        NA
## 68  1F001_1982 RHAT    3    NA          NA        NA
## 69  1F001_1982 RHAT    4    NA          NA        NA
## 70  1F001_1982 RHAT   NA    NA          NA        NA
## 71  1F001_1982 COBA    1    NA          NA        NA
## 72  1F001_1982 COBA    2    NA          NA        NA
## 73  1F001_1982 COBA    3    NA          NA        NA
## 74  1F001_1982 COBA    4    NA          NA        NA
## 75  1F001_1982 COBA   NA    NA          NA        NA
## 76  1F001_1982 CAAN    1    NA          NA        NA
## 77  1F001_1982 CAAN    2    NA          NA        NA
## 78  1F001_1982 CAAN    3    NA          NA        NA
## 79  1F001_1982 CAAN    4    NA          NA        NA
## 80  1F001_1982 CAAN   NA    NA          NA        NA
## 81  1F001_1982 SEAT    1    NA          NA        NA
## 82  1F001_1982 SEAT    2    NA          NA        NA
## 83  1F001_1982 SEAT    3    NA          NA        NA
## 84  1F001_1982 SEAT    4    NA          NA        NA
## 85  1F001_1982 SEAT   NA    NA          NA        NA
## 86  1F001_1984 SAFO    1     8       150.6        NA
## 87  1F001_1984 SAFO    2    NA          NA        NA
## 88  1F001_1984 SAFO    3    NA          NA        NA
## 89  1F001_1984 SAFO    4    NA          NA        NA
## 90  1F001_1984 SAFO   NA    NA          NA        NA
## 91  1F001_1984 LEGI    1    NA          NA        NA
## 92  1F001_1984 LEGI    2    NA          NA        NA
## 93  1F001_1984 LEGI    3    NA          NA        NA
## 94  1F001_1984 LEGI    4    NA          NA        NA
## 95  1F001_1984 LEGI   NA    NA          NA        NA
## 96  1F001_1984 AMRU    1    NA          NA        NA
## 97  1F001_1984 AMRU    2    NA          NA        NA
## 98  1F001_1984 AMRU    3    NA          NA        NA
## 99  1F001_1984 AMRU    4    NA          NA        NA
## 100 1F001_1984 AMRU   NA    NA          NA        NA
```

```r
summary(mergedData)
```

```
##         TripID            Code             Pass           count       
##  1F001_1982:    85   SAFO   : 16050   Min.   :1       Min.   :  1     
##  1F001_1984:    85   LEGI   : 16050   1st Qu.:2       1st Qu.:  4     
##  1F001_1985:    85   AMRU   : 16050   Median :2       Median : 11     
##  1F001_1986:    85   MIDO   : 16050   Mean   :2       Mean   : 26     
##  1F001_1987:    85   AMNA   : 16050   3rd Qu.:3       3rd Qu.: 33     
##  1F001_1988:    85   SATR   : 16050   Max.   :4       Max.   :438     
##  (Other)   :272340   (Other):176550   NA's   :54570   NA's   :263163  
##   length.mean       mass.mean     
##  Min.   :  1      Min.   :   0    
##  1st Qu.: 88      1st Qu.:  10    
##  Median :107      Median :  17    
##  Mean   :110      Mean   :  30    
##  3rd Qu.:129      3rd Qu.:  28    
##  Max.   :532      Max.   :1507    
##  NA's   :263164   NA's   :264662
```

```r

mergedData[is.na(mergedData$y), ]$y <- 0
```

```
## Warning: is.na() applied to non-(list or vector) of type 'NULL'
```

```
## Error: replacement has 1 row, data has 0
```

```r

# Need to remerge/join the environmental variables

# could probably do this better with SQL query coding
count <- left_join(count, data, by = "TripID")  # Add site & observational info (date)
```

```
## Error: cannot create join visitor from incompatible types
```

```r
count$Code <- count$Code.x
count <- left_join(count, spp, by = "Code")
```

```
## Error: index out of bounds
```

```r
str(count)
```

```
## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	9687 obs. of  5 variables:
##  $ TripID     : Factor w/ 3210 levels "1F001_1982","1F001_1984",..: 3210 3208 3206 3206 3205 3204 3203 3199 3198 3197 ...
##  $ Pass       : int  1 1 1 1 1 1 1 1 2 3 ...
##  $ count      : int  21 7 1 8 8 32 8 1 3 3 ...
##  $ length.mean: num  126 182 266 156 103 ...
##  $ mass.mean  : num  NA NA NA NA NA NA NA 20 17 3.8 ...
##  - attr(*, "vars")=List of 2
##   ..$ : symbol TripID
##   ..$ : symbol Pass
##  - attr(*, "drop")= logi TRUE
```

```r
summary(data)
```

```
##     TripID             SiteID              Date                Year     
##  Length:252951      Length:252951      Length:252951      Min.   :1982  
##  Class :character   Class :character   Class :character   1st Qu.:1995  
##  Mode  :character   Mode  :character   Mode  :character   Median :2001  
##                                                           Mean   :2000  
##                                                           3rd Qu.:2006  
##                                                           Max.   :2012  
##                                                                         
##       Pass          Code               Length        Weight     
##  Min.   :1.00   Length:252951      Min.   :  1   Min.   :   0   
##  1st Qu.:1.00   Class :character   1st Qu.: 68   1st Qu.:   3   
##  Median :1.00   Mode  :character   Median :100   Median :  10   
##  Mean   :1.32                      Mean   :109   Mean   :  21   
##  3rd Qu.:1.00                      3rd Qu.:142   3rd Qu.:  26   
##  Max.   :4.00                      Max.   :713   Max.   :2186   
##  NA's   :17                        NA's   :15    NA's   :57825  
##   DataSource          Location            fish.key         State          
##  Length:252951      Length:252951      Min.   :     1   Length:252951     
##  Class :character   Class :character   1st Qu.: 63238   Class :character  
##  Mode  :character   Mode  :character   Median :126476   Mode  :character  
##                                        Mean   :126476                     
##                                        3rd Qu.:189714                     
##                                        Max.   :252951                     
##                                                                           
##     site.key       Datum               LatDD        Contact         
##  Min.   :  1    Length:252951      Min.   :34.6   Length:252951     
##  1st Qu.:131    Class :character   1st Qu.:35.8   Class :character  
##  Median :195    Mode  :character   Median :38.4   Mode  :character  
##  Mean   :196                       Mean   :37.7                     
##  3rd Qu.:272                       3rd Qu.:38.6                     
##  Max.   :414                       Max.   :41.7                     
##  NA's   :1272                      NA's   :1272                     
##      LonDD         Sci name            spp.key     Common Name       
##  Min.   :-84.2   Length:252951      Min.   : 1.0   Length:252951     
##  1st Qu.:-83.1   Class :character   1st Qu.:15.0   Class :character  
##  Median :-78.7   Mode  :character   Median :15.0   Mode  :character  
##  Mean   :-80.0                      Mean   :14.7                     
##  3rd Qu.:-78.4                      3rd Qu.:15.0                     
##  Max.   :-76.4                      Max.   :17.0                     
##  NA's   :1272                                                        
##       date                month            doy          stage     
##  Min.   :1982-06-16   Min.   : 5.00   Min.   :137   Min.   :0.00  
##  1st Qu.:1995-06-19   1st Qu.: 6.00   1st Qu.:179   1st Qu.:0.00  
##  Median :2001-06-28   Median : 7.00   Median :198   Median :1.00  
##  Mean   :2000-09-13   Mean   : 7.06   Mean   :199   Mean   :0.54  
##  3rd Qu.:2006-08-14   3rd Qu.: 8.00   3rd Qu.:215   3rd Qu.:1.00  
##  Max.   :2012-09-14   Max.   :12.00   Max.   :347   Max.   :1.00  
##                                                     NA's   :145
```

```r
sites[which(is.na(sites$LonDD)), ]
```

```
##                  SiteID State LatDD LonDD Datum Contact site.key
##  1:        Steels Creek    NC    NA    NA          Rash      354
##  2:       Beetree Creek    NC    NA    NA          Rash      355
##  3: Looking Glass Creek    NC    NA    NA          Rash      356
##  4:     Big Horse Creek    NC    NA    NA          Rash      357
##  5:     Three Top Creek    NC    NA    NA          Rash      358
##  6:     South Toe River    NC    NA    NA          Rash      359
##  7:         Upper Creek    NC    NA    NA          Rash      360
##  8:     Greenland Creek    NC    NA    NA          Rash      361
##  9:   Panthertown Creek    NC    NA    NA          Rash      362
## 10:      Mitchell River    NC    NA    NA          Rash      363
## 11:          Boone Fork    NC    NA    NA          Rash      364
```

```r

# Remove extra columns and rename remaining columns**********************

data$date <- as.Date(data$Date, format = "%m/%d/%Y")
data$month <- as.numeric(format(data$date, format = "%m"))
data$doy <- strptime(data$Date, "%m/%d/%Y")$yday + 1

head(data)
```

```
##       TripID SiteID      Date Year Pass Code Length Weight DataSource
## 1 1F001_1982  1F001 6/16/1982 1982    1 SAFO     50     NA    Wofford
## 2 1F001_1982  1F001 6/16/1982 1982    1 SAFO     50     NA    Wofford
## 3 1F001_1982  1F001 6/16/1982 1982    1 SAFO     55     NA    Wofford
## 4 1F001_1982  1F001 6/16/1982 1982    1 SAFO     60     NA    Wofford
## 5 1F001_1982  1F001 6/16/1982 1982    1 SAFO     60     NA    Wofford
## 6 1F001_1982  1F001 6/16/1982 1982    1 SAFO     60     NA    Wofford
##   Location fish.key State site.key Datum LatDD Contact LonDD
## 1     SHEN        1    VA      111 NAD83 38.82 Wofford -78.2
## 2     SHEN        2    VA      111 NAD83 38.82 Wofford -78.2
## 3     SHEN        3    VA      111 NAD83 38.82 Wofford -78.2
## 4     SHEN        4    VA      111 NAD83 38.82 Wofford -78.2
## 5     SHEN        5    VA      111 NAD83 38.82 Wofford -78.2
## 6     SHEN        6    VA      111 NAD83 38.82 Wofford -78.2
##                Sci name spp.key Common Name       date month doy stage
## 1 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167     0
## 2 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167     0
## 3 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167     0
## 4 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167     0
## 5 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167     0
## 6 Salvelinus fontinalis      15 brook trout 1982-06-16     6 167     0
```

```r

# Need to do this for stage-based data too (then separate adults)


count.adult <- filter(count.stage, filter = stage == 1)

summary(count)
```

```
##         TripID          Pass          count        length.mean   
##  COS-1_1995:  15   Min.   :1.00   Min.   :  1.0   Min.   :  1.0  
##  COS-1_1996:  15   1st Qu.:1.00   1st Qu.:  4.0   1st Qu.: 87.7  
##  COS-1_2001:  15   Median :2.00   Median : 11.0   Median :107.0  
##  COS-1_2007:  15   Mean   :1.82   Mean   : 26.1   Mean   :110.0  
##  COS-1_2009:  15   3rd Qu.:3.00   3rd Qu.: 33.0   3rd Qu.:129.3  
##  COS-1_2012:  15   Max.   :4.00   Max.   :438.0   Max.   :532.0  
##  (Other)   :9597   NA's   :3                      NA's   :1      
##    mass.mean     
##  Min.   :   0.0  
##  1st Qu.:  10.2  
##  Median :  17.2  
##  Mean   :  30.1  
##  3rd Qu.:  28.4  
##  Max.   :1507.1  
##  NA's   :1499
```

```r
head(count, 50)
```

```
## Source: local data frame [50 x 5]
## Groups: TripID, Pass
## 
##               TripID Pass count length.mean mass.mean
## 1      YOUG-432_2012    1    21      126.00        NA
## 2      YOUG-432_2010    1     7      182.43        NA
## 3      YOUG-432_2008    1     1      266.00        NA
## 4      YOUG-432_2008    1     8      155.75        NA
## 5      YOUG-432_2007    1     8      102.75        NA
## 6      YOUG-432_2004    1    32      127.16        NA
## 7      YOUG-432_2003    1     8      133.12        NA
## 8  Woods Branch_2012    1     1      131.00    20.000
## 9  Woods Branch_2011    2     3      120.33    17.000
## 10        WCP-2_2012    3     3       71.00     3.800
## 11        WCP-2_2012    3    15       51.80     2.733
## 12        WCP-2_2012    2    16       64.06     9.381
## 13        WCP-2_2012    1    34       93.44    13.659
## 14        WCP-2_2011    2     3       83.33     9.400
## 15        WCP-2_2010    2     5      108.80    16.020
## 16        WCP-2_2010    2     2      153.00    41.100
## 17        WCP-2_2010    1    24      138.21    30.921
## 18        WCP-2_2009    3     1      132.00    22.600
## 19        WCP-2_2009    3     3      139.00    31.300
## 20        WCP-2_2009    2     6      110.00    17.233
## 21        WCP-2_2009    1    32       88.31    10.447
## 22        WCP-2_2009    1     1      124.00    28.600
## 23        WCP-2_2008    3     2      100.50    10.900
## 24        WCP-2_2008    2     1      106.00    22.400
## 25        WCP-2_2007    3     3       94.00    10.133
## 26        WCP-2_2007    2     4      154.75    37.100
## 27        WCP-2_2007    1     8      138.88    26.613
## 28        WCP-2_2006    3     3      109.00    10.533
## 29        WCP-2_2006    2     7      119.71    16.286
## 30        WCP-2_2006    2     3      116.00    16.667
## 31        WCP-2_2006    1    16      127.06    24.325
## 32        WCP-2_2005    3    14       82.86     5.571
## 33        WCP-2_2005    3     7       51.57     1.929
## 34        WCP-2_2005    2    15       83.00     7.467
## 35        WCP-2_2005    2     9       60.11     4.156
## 36        WCP-2_2005    1    80       90.61    11.460
## 37        WCP-2_2005    1    30       80.87    17.117
## 38        WCP-2_2004    3     4      118.50    21.250
## 39        WCP-2_2004    2     6       56.17     5.650
## 40        WCP-2_2004    1    14      125.50    29.443
## 41        WCP-2_2004    1    16       86.50    23.962
## 42        WCP-2_2003    3     2      107.00    15.000
## 43        WCP-2_2003    1    29      135.38    30.252
## 44        WCP-2_2003    1    11      135.18    25.173
## 45        WCP-2_2002    3     6       96.17    11.167
## 46        WCP-2_2002    2    15       64.93     5.200
## 47        WCP-2_2001    3     4       82.75     9.075
## 48        WCP-2_2001    2    10       81.90    12.710
## 49        WCP-2_2000    3     6      106.67    20.217
## 50        WCP-2_2000    1    40      119.33    20.050
```


### Subset brook trout data and clean
 Consider keeping brown trout to use as a covariate


```r
summary(filter(fish, Species == "SAFO"))  # check lengths around min and max
```

```
## Error: object 'Species' not found
```

```r

ggplot(filter(fish, Species == "SAFO" & Length < 250), aes(Length), ) + geom_histogram(binwidth = 10) + 
    scale_x_continuous(breaks = seq(0, 250, 20))
```

```
## Error: object 'Species' not found
```

```r

safo <- filter(fish, Species == "SAFO")
```

```
## Error: object 'Species' not found
```

```r

summarise(filter(group_by(data, Pass), Code == "SAFO"), mean(Length, na.rm = TRUE))  # catch biggest SAFO first 
```

```
## Source: local data frame [5 x 2]
## 
##   Pass mean(Length, na.rm = TRUE)
## 1   NA                     128.35
## 2    4                      80.07
## 3    3                      93.76
## 4    2                      98.37
## 5    1                     110.75
```

