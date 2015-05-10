##Load dependencies
packages <- c("data.table", "sqldf")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
lapply(packages, library, character.only=TRUE)

##Download and unzip the course data
dataFileName <- "exdata-data-household_power_consumption.zip"
dataUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists(file.path(dataFileName))){
  download.file(dataUrl, destfile=file.path(dataFileName), method="auto")  
}
unzip(zipfile=file.path(dataFileName), exdir=file.path("exdata-014"))

##Load large data file into R
targetFile <- file.path("exdata-014", "household_power_consumption.txt")
dataSample <- fread(targetFile, nrows=100, stringsAsFactors=FALSE, header=TRUE, sep=";")
colNames <- dataSample[0,]
columnClasses <- sapply(dataSample, class)

##Subset the data to include observations from 01/02/2007 and 02/02/2007, and omit na values
data <- na.omit(fread(targetFile, stringsAsFactors=TRUE, header=TRUE, sep=";", colClasses=columnClasses, data.table=FALSE, na.strings=c("?")))
dataSubset <- data[as.Date(as.character(data$Date), format="%d/%m/%Y") %in% as.Date(c('01/02/2007', '02/02/2007'), format="%d/%m/%Y"),]

##Create a vector of Date&Time for plotting other variables
dateTime <- strptime(paste(dataSubset$Date, dataSubset$Time), format="%d/%m/%Y %H:%M:%S")

##Use the par() function to divide window into 2 columns and 2 rows
par(mfrow=c(2,2))

##Create a Line Plot of Global Active Power vs. Date&Time 
with(dataSubset, plot(dateTime, as.numeric(Global_active_power), type="l", ylab="Global Active Power (kilowatts)", xlab=""))

##Create a Line Plot of Voltage vs. Date&Time
with(dataSubset, plot(dateTime, as.numeric(Voltage), type="l", ylab="Voltage", xlab="datetime"))

##Create Line Plots of Sub metering values _1, _2, and _3 vs. Date&Time 
with(dataSubset, plot(dateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab=""))
with(dataSubset, lines(dateTime, Sub_metering_2, col="red"))
with(dataSubset, lines(dateTime, Sub_metering_3, col="blue"))
##Add legend to plot
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1, 1, 1), lwd=c(1, 1, 1), col=c("black", "red", "blue"), cex=0.75)

##Create a Line Plot of Global_reactive_power vs. Date&Time
with(dataSubset, plot(dateTime, as.numeric(Global_reactive_power), type="l", ylab="Global_reactive_power", xlab="datetime"))

##Output Line Plot to PNG "plot3.png" and clear the plot window
dev.copy(png, filename=file.path("./plot4.png"), width=480, height=480)
dev.off()
