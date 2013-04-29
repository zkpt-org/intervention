# Goal: User Vector = [between day x-1 to x-n count number of days where activity exists]
UserHistory<-function(user,start){
    Sys.setenv(TZ='GMT')
    
    zeroday=start
    #zeroday=as.numeric(sqldf(paste0("SELECT MIN(date)+", MONTH+DAY, " from login")))
    day0 = zeroday - (zeroday %% DAY)
    print(as.POSIXlt(day0, origin="1970-01-01 00:00.00 UTC"))

    pedometer_init=as.numeric(sqldf(paste0("SELECT MIN(date) FROM pedometer WHERE UserID=",user)))
    login_init=as.numeric(sqldf(paste0("SELECT MIN(date) FROM login WHERE UserID=",user)))
    userinit=min(pedometer_init,login_init)-(min(pedometer_init,login_init) %% DAY)
    print(as.POSIXlt(userinit, origin="1970-01-01 00:00.00 UTC"))
    rm(pedometer_init,login_init)

    c_dates<-c()
    c_login<-c()
    c_pedometer<-c()
    c_bp<-c()
    c_weight<-c()
    c_glucose<-c()
    c_weekend<-c()
    c_selftracking<-c()
    length(c_dates)<-30
    length(c_login)<-30
    length(c_pedometer)<-30
    length(c_bp)<-30
    length(c_weight)<-30
    length(c_glucose)<-30
    length(c_weekend)<-30
    length(c_selftracking)<-30

    for(i in 1:30){
        d = day0 - (i*DAY) + DAY
        c_dates[i]=d
        #print(as.POSIXlt(d, origin="1970-01-01 00:00.00 UTC"))
    
        if(d<userinit){
            c_login[i]<-NA
            c_pedometer[i]<-NA
            c_bp[i]<-NA
            c_weight[i]<-NA
            c_glucose[i]<-NA
            c_weekend[i]<-NA       
        }
        else{
            c_login[i]=length(login[login$UserId==user & login$date >= d-DAY & login$date < d,1])
            c_pedometer[i]=length(pedometer[pedometer$UserId==user & pedometer$date >= d-DAY & pedometer$date < d,1])
            c_bp[i]=length(bp[bp$UserId==user & bp$date >= d-DAY & bp$date < d,1])
            c_weight[i]=length(weight[weight$UserId==user & weight$date >= d-DAY & weight$date < d,1])
            c_glucose[i]=length(glucose[glucose$UserId==user & glucose$date >= d-DAY & glucose$date < d,1])
            c_weekend[i]=length(login[login$UserId==user & login$date >= d-DAY & login$date < d & (login$dayofweek==0 | login$dayofweek==6),1])
            # c_login[i]=as.numeric(sqldf(paste0("SELECT COUNT(UserId) FROM login WHERE UserId=", user, " AND date >=", d-DAY, " AND date <", d)))
            # c_pedometer[i]=as.numeric(sqldf(paste0("SELECT COUNT(UserId) FROM pedometer WHERE UserId=", user, " AND date >=", d-DAY, " AND date <", d)))
            # c_bp[i]=as.numeric(sqldf(paste0("SELECT COUNT(UserId) FROM bp WHERE UserId=", user, " AND date >=", d-DAY, " AND date <", d)))
            # c_weight[i]=as.numeric(sqldf(paste0("SELECT COUNT(UserId) FROM weight WHERE UserId=", user, " AND date >=", d-DAY, " AND date <", d)))
            # c_glucose[i]=as.numeric(sqldf(paste0("SELECT COUNT(UserId) FROM glucose WHERE UserId=", user, " AND date >=", d-DAY, " AND date <", d)))
            # c_weekend[i]=as.numeric(sqldf(paste0("SELECT COUNT(UserId) FROM login WHERE UserId=", user, " AND date >=", d-DAY, " AND date <", d, " AND (dayofweek = 0 OR dayofweek = 6)")))
        }
        c_selftracking[i]=c_weight+c_bp+c_glucose
    }
    user_history<-merge(data.frame("day"=1:30, c_dates), data.frame("day"=1:30, c_login), by="day")
    user_history<-merge(user_history, data.frame("day"=1:30, c_pedometer), by="day")
    user_history<-merge(user_history, data.frame("day"=1:30, c_bp), by="day")
    user_history<-merge(user_history, data.frame("day"=1:30, c_weight), by="day")
    user_history<-merge(user_history, data.frame("day"=1:30, c_glucose), by="day")
    user_history<-merge(user_history, data.frame("day"=1:30, c_weekend), by="day")
    user_history<-merge(user_history, data.frame("day"=1:30, c_selftracking), by="day")
    colnames(user_history)=c("day","dates","login","pedometer","bp","weight","glucose","weekend","tracking")
    
    return(user_history)
    # rm(c_bp,c_glucose,c_login,c_pedometer,c_selftracking,c_weekend,c_weight,c_dates)
}
start=as.numeric(sqldf("SELECT MAX(date) from login"))
user=8099
user_history<-UserHistory(user,start)