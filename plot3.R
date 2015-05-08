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

data <- na.omit(fread(targetFile, stringsAsFactors=TRUE, header=TRUE, sep=";", colClasses=columnClasses, data.table=FALSE, na.strings=c("?")))
dataSubset <- data[as.Date(as.character(data$Date), format="%d/%m/%Y") %in% as.Date(c('01/02/2007', '02/02/2007'), format="%d/%m/%Y"),]

##Create a Line Plots of Sub metering values _1, _2, and _3 by Date&Time 
dateTime <- strptime(paste(dataSubset$Date, dataSubset$Time), format="%d/%m/%Y %H:%M:%S")

with(dataSubset, plot(dateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab=""))
with(dataSubset, lines(dateTime, Sub_metering_2, col="red"))
with(dataSubset, lines(dateTime, Sub_metering_3, col="blue"))

##Add legend to plot
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1, 1, 1), lwd=c(2.5, 2.5, 2.5), col=c("black", "red", "blue"))


##Output Line Plot to PNG "plot3.png"
dev.copy(png, filename=file.path("./plot3.png"), width=480, height=480)
dev.off()
