library(lubridate)
library(dplyr)

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
library(pryr)
object_size(temp)
# Roughly how much memory is required to store this dataframe? https://rdpeng.github.io/Biostat776/lecture-getting-and-cleaning-data.html
# 2,075,259 rows x 9 columns  x 8bytes/numeric = 2075259* 9*8 bytes => 1mb =2^20 bytes => 2075259* 9*8/(2^20) = 142 MB needed


initial <- read.table(unzip(temp)
                      , sep=";", header = T
                      , nrows = 100
)
classes <- sapply(initial, class)

df <- read.table( unzip(temp)
                  , sep=";", header = T
                  # , colClasses = classes
)
unique(df$Date)
str(df)
summary(df)
df <- df %>% filter(Date %in% c("1/2/2007", "2/2/2007"))

df$Date <- as.Date(df$Date, "%d/%m/%Y")
df$datetime<- paste(df$Date, df$Time)
df$datetime<- strptime(df$datetime, "%Y-%m-%d %H:%M:%S")
sapply(df, function(x) sum(is.na(x)))
df[, 3:9] <- lapply(3:9, function(x) as.numeric(df[[x]]))

png("plot2.png")
plot(df$datetime,df$Global_active_power, type="l", ylab = "Global Active Power (kilowatts)", xlab = "")
dev.off() 
