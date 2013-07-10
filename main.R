#!/usr/bin/Rscript

# Include config file.
source("config.R")

# Run all initializing queries to the database
# source("database.R")

# Run all initialization sequencs
source("initialize.R")

# Source the routines used to consrtruct user history
source("user_history.R")

# Create the questions asked answered table
source("questions.R")

# User profiling and pre-existing conditions 
source("demographics.R")

# duration in days and number of iterations of the duration.
duration=28
iterations=3

#subsample to develop code and also run fast:
indsy = sample(1:nrow(data.frame(uniqueQ[uniqueQ$answered=='Y',c(1,2,3,5,4)])),5000)
quedf = uniqueQ[uniqueQ$answered=='Y',c(1,2,3,5,4)][indsy, ]
indsn = sample(1:nrow(data.frame(uniqueQ[uniqueQ$answered=='N',c(1,2,3,5,4)])),5000)
quedf = rbind(uniqueQ[uniqueQ$answered=='N',c(1,2,3,5,4)][indsn, ],quedf)

#quedf=data.frame(uniqueQ[uniqueQ$UserId==104, c(1,2,3,5,4)])

history<-data.frame("user"=quedf$UserId, "date"=quedf$epoch, "answered"=quedf$answered)

for (i in 1:iterations){
  history[paste("login",1:iterations,sep="")] <- NA
  history[paste("pedometer",1:iterations,sep="")] <- NA
  history[paste("bp",1:iterations,sep="")] <- NA
  history[paste("glucose",1:iterations,sep="")] <- NA
  history[paste("weight",1:iterations,sep="")] <- NA
  history[paste("weekend",1:iterations,sep="")] <- NA
  history[paste("questions",1:iterations,sep="")] <- NA
  history[paste("tenure",1:iterations,sep="")] <- NA
}

for(j in 1:iterations){
	c<-1  
	mapply(GenerateHitory, history$user, history$date, j, duration)
}

history=merge(history, user_data, by="user", all.x=TRUE)
save(history,file="./data/history.RData")
write.csv(history,file="./output/history.csv", quote=TRUE, row.names=FALSE, na="")