pckgs<-list("dplyr","ggplot2","gridExtra","ggcorrplot","rpart","partykit","caret")

pck_in<-pckgs[!pckgs %in% installed.packages()]
for(libs in pck_in) install.packages(libs, dependences = TRUE)
sapply(pckgs, require, character = TRUE)


scare_train<-read.csv("C:/Users/prasenjeet.s/Projects/Kaggle/Ghouls, Goblins, and Ghosts... Boo!/train.csv")
colSums(is.na(scare_train))
attach(scare_train)

summary(scare_train)

# Plots of variables to analyse basic categorization

var_cor<-cor(scare_train[,c(2,3,4,5)])
# qplot(bone_length,geom = "histogram")

# the has_soul parameter is evenly spread in compared to the other 3. The others are a bit skewed.
ggplot(scare_train,aes(has_soul))+geom_histogram(breaks=seq(0,1,by=0.015),col="black",aes(fill=..count..))+geom_density(col="grey")+ geom_hline(yintercept=0, colour="white", size=1)
sd(bone_length);sd(hair_length);sd(rotting_flesh);sd(has_soul)
ggplot(scare_train,aes(y=bone_length))+geom_boxplot(aes(x=type))

scare_train$has_soul_cat<-case_when(
  has_soul<0.3070651~"A",
  has_soul>0.3070651 & has_soul<0.4442019~"B",
  has_soul>0.4442019 & has_soul<0.5423316~"C",
  has_soul>0.5423316~"D")
scare_train$rotting_flesh_soul<-scare_train$rotting_flesh*scare_train$has_soul
scare_train$log_add_all<-log(scare_train$bone_length+scare_train$rotting_flesh+scare_train$hair_length+scare_train$has_soul)
scare_train$log_rotting_flesh_soul<-(-1)*log(scare_train$rotting_flesh_soul)*scare_train$hair_length

p<-list()
p[[2]]=ggplot(scare_train,aes(bone_length))+geom_histogram(breaks=seq(0,1,by=0.02),col="black",alpha=0.5)+geom_density(aes(fill=type),col="grey",alpha=0.5)+ geom_hline(yintercept=0, colour="white", size=1)
p[[3]]=ggplot(scare_train,aes(rotting_flesh))+geom_histogram(aes(fill=type),breaks=seq(0,1,by=0.015),alpha=0.5)+geom_density(aes(fill=type),col="grey",alpha=0.5)+ geom_hline(yintercept=0, colour="white", size=1)
p[[4]]=ggplot(scare_train,aes(has_soul))+geom_histogram(aes(fill=type),breaks=seq(0,1,by=0.02),col="black",alpha=0.5)+geom_density(aes(fill=type),col="grey",alpha=0.5)+geom_hline(yintercept=0, colour="white", size=1)
p[[1]]=ggcorrplot(var_cor,method = "circle", lab = TRUE,type = "lower")
ggplot(scare_train,aes(fill=type))+geom_bar(aes(color))

do.call(grid.arrange,p)

# A histogram plot to fing features of each type
s="Ghost";ggplot(scare_train[which(type==s),])+geom_histogram(aes(rotting_flesh,fill="rotting_flesh"),breaks=seq(0,1,by=0.015),alpha=0.5)+geom_histogram(aes(has_soul,fill="has_soul"),breaks=seq(0,1,by=0.015),alpha=0.5)+geom_histogram(aes(hair_length,fill="hair_length"),breaks=seq(0,1,by=0.015),alpha=0.5)+labs(title=s,x="", y = "Count")
# Findings:
# Ghouls:
#   Most have longer hairs. 
# Ghosts:
#   Most have their flesh rotting.
# Goblins:
# Similar to Ghouls but percentage of souls is lower compared to Ghoul

# Now the time for actual fun. Let's find out which model hunts down monsters

rows<-sample(1:nrow(scare_train),0.7*nrow(scare_train),replace = FALSE)
scare_train1<-scare_train[rows,]
scare_test1<-scare_train[-rows,]

# decision tree
fit1<-rpart(type~., data=scare_train1[-c(1,6,8,9)], method="class")
plot(fit1,uniform = TRUE)
text(fit1, use.n=TRUE, all=TRUE, cex=.6)
scare_test1$type_fit1<-predict(fit1,scare_test1,type = "class")

fit2<-rpart(type~., data=scare_train1[-c(1,6,8,9,10)], method="class")
plot(fit2,uniform = TRUE)
text(fit2, use.n=TRUE, all=TRUE, cex=.6)
scare_test1$type_fit2<-predict(fit2,scare_test1,type = "class")

print(fit3)
plotcp(fit3);printcp(fit3)

confusionMatrix(scare_test1$type,scare_test1$type_fit1)

plot(as.party(fit1))
plot(as.party(fit2))
