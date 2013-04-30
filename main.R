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
duration=28

# MAX UserId is 19441
user_min=8099
user_max=8110
users=sqldf(paste0("SELECT DISTINCT UserId FROM login WHERE UserId >=",user_min," AND UserId<=",user_max))

history<-data.frame("user"=users$UserId,"login"=NA,"pedometer"=NA,"bp"=NA,"glucose"=NA,
                     "weight"=NA,"weekend"=NA,"questions"=NA,"tracking"=NA)
i=1
apply(history["user"],1,function(user){
    user_history<-UserHistory(user,start,duration)
    history$pedometer[i] <<- length(user_history$pedometer[user_history$pedometer>0])
    history$login[i]     <<- length(user_history$login[user_history$login>0])
    history$bp[i]        <<- length(user_history$bp[user_history$bp>0])
    history$glucose[i]   <<- length(user_history$glucose[user_history$glucose>0])
    history$weight[i]    <<- length(user_history$weight[user_history$weight>0])
    history$weekend[i]   <<- length(user_history$weekend[user_history$weekend>0])
    history$questions[i] <<- length(user_history$questions[user_history$questions>0])
    history$tracking[i]  <<- length(user_history$tracking[user_history$tracking>0])
    
    i<<-i+1
})