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

##Create a Line Plot of Global Active Power by Date&Time 
dateTime <- strptime(paste(dataSubset$Date, dataSubset$Time), format="%d/%m/%Y %H:%M:%S")
plot(dateTime, as.numeric(dataSubset$Global_active_power), type="l", ylab="Global Active Power (kilowatts)", xlab="")

##Output Line Plot to PNG "plot2.png"
dev.copy(png, filename=file.path("./plot2.png"), width=480, height=480)
dev.off()
