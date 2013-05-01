#!/usr/bin/Rscript

# Include config file.
source("config.R")

# Run all initializing queries to the database
# source("database.R")

# Run all initialization sequencs
source("initialize.R")

# Consrtruct user history
source("user_history.R")


start=as.numeric(sqldf("SELECT MAX(date) from login"))
# duration in days and number of iterations of the duration.
duration=28
iterations=3

# current MAX UserId is 19441
user_min=8099
user_max=8108
users=sqldf(paste0("SELECT DISTINCT UserId FROM login WHERE UserId >=",user_min," AND UserId<=",user_max))

history<-data.frame("user"=users$UserId)
for (i in 1:iterations){
  history[paste("login",1:iterations,sep="")] <- NA
  history[paste("pedometer",1:iterations,sep="")] <- NA
  history[paste("bp",1:iterations,sep="")] <- NA
  history[paste("glucose",1:iterations,sep="")] <- NA
  history[paste("weight",1:iterations,sep="")] <- NA
  history[paste("weekend",1:iterations,sep="")] <- NA
  history[paste("questions",1:iterations,sep="")] <- NA
  history[paste("tracking",1:iterations,sep="")] <- NA
  history[paste("tenure",1:iterations,sep="")] <- NA
}

for(j in 1:iterations){
  apply(history["user"],1, function(user) GenerateHitory(user,j,duration))
}