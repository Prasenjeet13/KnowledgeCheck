install.packages("shiny")
library(data.table)
library(caret)
require(rcompanion)
library(ggplot2)
require(scales)

features <- fread("features.csv",sep = ',',data.table = FALSE)
stores <- fread("stores.csv",sep = ',')
wal_train <- fread("train.csv",sep = ',')

wal_train <- merge(wal_train,stores,by='Store',all = TRUE)
wal_train <- merge(wal_train,features[c("Store","Date","Temperature","Fuel_Price","CPI")],by=c('Store','Date'),all.x = TRUE)
wal_train$Store <- as.factor(wal_train$Store)
wal_train$IsHoliday <- as.factor(wal_train$IsHoliday)
wal_train$Type <- as.factor(wal_train$Type)

cormat <- cor(wal_train[,-c(1,2,5,6)])
kruskal.test(wal_train$Weekly_Sales,wal_train$IsHoliday)
kruskal.test(wal_train$Weekly_Sales,wal_train$Type)

wal_train=as.data.frame(wal_train)
wal_train$Store=as.factor(wal_train$Store)
wal_train2=wal_train[which(wal_train$Store==2),]
wal_train2$Date=as.Date(wal_train2$Date)
ggplot(wal_train2[which(wal_train2$Dept==2),c(2,4)])+geom_line(aes(x=Date,y=Weekly_Sales,group=1))+scale_x_date(labels = date_format("%Y/%m"))

d <- c(2,3,4)
ggplot(wal_train2[which(wal_train2$Dept==6),])+geom_line(aes(x=Date,y=Weekly_Sales,group=1))+scale_x_date(labels = date_format("%Y/%m"))
ggplot(wal_train2[which(wal_train2$Dept %in% c(20)),])+geom_line(aes(x=Date,y=Weekly_Sales,group=1,colour=Dept))+scale_x_date(labels = date_format("%Y/%m"))
x <- c(1,2,3,4,5,6)
y <- c(45,87,23,98,56,98)
df <- data.frame(x,y)
rm(x,y,df,d)

dept_sales <- function(store=1,dept){
  wal_train_x=wal_train[which(wal_train$Store %in% store),]
  wal_train_x$Date=as.Date(wal_train_x$Date)
  wal_train_x$Dept=as.factor(wal_train_x$Dept)
  
  ggplot(wal_train_x[which(wal_train_x$Dept %in% dept),],aes(x=Date,y=Weekly_Sales,group=1,colour=Store,shape=Dept))+ggtitle(paste("Store:",list(store),sep=" ","Dept:",list(dept)))+geom_point()+scale_x_date(date_breaks = "17 week",labels = date_format("%W/%Y"))
}
dept_sales(c(3,7,10,13),c(8,10,12))
dept_sales(store = c(5,6),dept = c(5))

(t.test(wal_train[which(wal_train2$IsHoliday==FALSE),4],wal_train[which(wal_train2$IsHoliday==TRUE),4]))$statistic
var.test(wal_train[which(wal_train2$IsHoliday==FALSE),4],wal_train[which(wal_train2$IsHoliday==TRUE),4])
