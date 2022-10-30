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

png("plot4.png")

par(mfrow = c(2,2), mar =c(4,4,2,1))
plot(df$datetime,df$Global_active_power, type="l", ylab = "Global Active Power (kilowatts)", xlab = "")
plot(df$datetime,df$Voltage, type="l", ylab = "Voltage", xlab = "datetime")
with(df, {
  plot(datetime,Sub_metering_1,  ylab = "Energy sub metering", xlab = "", type = "l", col = "black")
  points(datetime,Sub_metering_2,   type = "l", col = "red")
  points(datetime,Sub_metering_3,   type = "l", col = "blue")
  legend("topright", pch = 151, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
})
plot(df$datetime,df$Global_reactive_power, type = "l")

dev.off() 

