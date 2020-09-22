library("data.table")
# 1.1 Getting datasets
# wk_dir <- getwd()
wk_dir <- "D:/Coursera/Exploratory Data Analysis/Week1"

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filepath <- paste(wk_dir, "rawData.zip", sep = "/")

if (!file.exists(filepath)) {
    download.file(data_url, destfile = filepath)
    unzip(zipfile = filepath, exdir = wk_dir)
}

data_file <- paste(wk_dir, "household_power_consumption.txt", sep = "/")

# Getting data
power <- read.table(data_file,skip=1,sep=";")
names(power) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

# Subsetting data
subpower <- subset(power,power$Date=="1/2/2007" | power$Date =="2/2/2007")

# Transforming Date and Time variables
subpower$Date <- as.Date(subpower$Date, format="%d/%m/%Y")
subpower$Time <- strptime(subpower$Time, format="%H:%M:%S")
subpower[1:1440,"Time"] <- format(subpower[1:1440,"Time"],"2007-02-01 %H:%M:%S")
subpower[1441:2880,"Time"] <- format(subpower[1441:2880,"Time"],"2007-02-02 %H:%M:%S")

# Composite plot with many graphs
#png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))

# Plotting data
globalActivePower <- as.numeric(as.character(subpower$Global_active_power))
plot(subpower$Time, globalActivePower, type="l", xlab="", ylab="Global Active Power", cex=0.2)

voltage <- as.numeric(as.character(subpower$Voltage))
plot(subpower$Time, voltage, type="l", xlab="datetime", ylab="Voltage")

subMetering1 <- as.numeric(subpower$Sub_metering_1)
subMetering2 <- as.numeric(subpower$Sub_metering_2)
subMetering3 <- as.numeric(subpower$Sub_metering_3)
plot(subpower$Time, subMetering1, type="l", ylab="Energy Submetering", xlab="")
lines(subpower$Time, subMetering2, type="l", col="red")
lines(subpower$Time, subMetering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="o")

globalReactivePower <- as.numeric(as.character(subpower$Global_reactive_power))
plot(subpower$Time, globalReactivePower, type="l", xlab="datetime", ylab="Global_reactive_power")

#Generate png file
dev.off()