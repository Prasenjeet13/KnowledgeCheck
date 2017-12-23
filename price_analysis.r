pckgs<-list("lubridate","dplyr","ggplot2")

pck_in<-pckgs[!pckgs %in% installed.packages()]
for(libs in pck_in) install.packages(libs, dependences = TRUE)
sapply(pckgs, require, character = TRUE)

price=read.csv("C:/Users/prasenjeet.s/Projects/Data.World/Price analysis/India_Key_Commodities_Retail_Prices_1997_2015.csv")
price$Date=as.Date(price$Date,"%d-%m-%Y")
price$month_year=format(as.Date(price$Date),"%m-%Y")

price<-price[order(as.Date(price$Date)),]

attach(price)

summary(price)

#table(price$Commodity=="Milk")
comm<-table(month_year,Commodity)
comm_df<-as.data.frame.matrix(comm)

mean_p<-aggregate(Price.per.Kg,by=list(Commodity,month_year),mean)
mean_price<-reshape(mean_p,idvar = "Group.2", timevar = "Group.1", direction = "wide")

# Let's Analyse the price growth of Rice, Onion, Tea, Dal
mean_sample<-data.frame(mean_price$Group.2,mean_price$x.Rice,mean_price$x.Onion,mean_price$`x.Tea Loose`,mean_price$`x.Tur/Arhar Dal`)
mean_sample$year<-substring(mean_sample$mean_price.Group.2,4,7)
mean_sample$index<-dplyr::case_when(
  mean_sample$year=="1997"~1,
  mean_sample$year=="1998"~2,
  mean_sample$year=="1999"~3,
  mean_sample$year=="2000"~4,
  mean_sample$year=="2001"~5,
  mean_sample$year=="2002"~6,
  mean_sample$year=="2003"~7,
  mean_sample$year=="2004"~8,
  mean_sample$year=="2005"~9,
  mean_sample$year=="2006"~10,
  mean_sample$year=="2007"~11,
  mean_sample$year=="2008"~12,
  mean_sample$year=="2009"~13,
  mean_sample$year=="2010"~14,
  mean_sample$year=="2011"~15,
  mean_sample$year=="2012"~16,
  mean_sample$year=="2013"~17,
  mean_sample$year=="2014"~18,
  mean_sample$year=="2015"~19)
mean_sample<-mean_sample[order(mean_sample$index),]
write.csv(mean_sample,"C:/Users/prasenjeet.s/Projects/Data.World/Price analysis/mean_sample.csv")

plot(mean_sample$mean_price.Group.2,mean_sample$mean_price.x.Rice)
plot(mean_sample$mean_price.Group.2,mean_sample$mean_price.x.Onion)
# par(mfrow=c(2,1))
# plot(mean_sample[which(mean_sample$year %in% c("2001")),c(1,3)])
 plot(mean_sample[which(mean_sample$year %in% c("2001")),c(1,2)])
# dev.off()

plot(mean_sample[,c(1,4)] %>% filter(mean_sample$year %in% c("2001","2002","2003")))

attach(mean_sample)
ggplot(mean_sample[,c(1,4)])+geom_point(aes(mean_price.Group.2,mean_price..x.Tea.Loose.))

ggplot(mean_sample[which(mean_sample$year %in% c("2001")),c(1,2)])+geom_point(aes(mean_price.Group.2,mean_price.x.Rice))
ggplot(mean_sample[which(mean_sample$year %in% c("2002")),c(1,5,3)])+geom_point(aes(mean_price.Group.2,mean_price..x.Tur.Arhar.Dal.),colour="blue")+geom_point(aes(mean_price.Group.2,mean_price.x.Onion),colour="red")
ggplot(mean_sample[which(mean_sample$year %in% c("2002")),c(1,5,3)],aes(x=mean_price.Group.2,group=1))+geom_line(aes(y=mean_price..x.Tur.Arhar.Dal.),colour="blue")+geom_line(aes(y=mean_price.x.Onion),colour="red")
