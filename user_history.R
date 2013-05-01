# Goal: User Vector = [between day x-1 to x-n count number of days where activity exists]

GenerateHitory<-function(user,n,duration){
  day0=start-((n-1)*(duration*DAY))
  #print(as.Date(as.POSIXlt(day0, origin="1970-01-01 00:00.00 UTC")))
  user_history<-UserHistory(user,day0,duration)
  usr=as.numeric(user)
  history[paste0("pedometer", n)][history["user"]==user] <<- length(user_history$pedometer[user_history$pedometer>0])
  history[paste0("login",     n)][history["user"]==user] <<- length(user_history$login[user_history$login>0])
  history[paste0("bp",        n)][history["user"]==user] <<- length(user_history$bp[user_history$bp>0])
  history[paste0("glucose",   n)][history["user"]==user] <<- length(user_history$glucose[user_history$glucose>0])
  history[paste0("weight",    n)][history["user"]==user] <<- length(user_history$weight[user_history$weight>0])
  history[paste0("weekend",   n)][history["user"]==user] <<- length(user_history$weekend[user_history$weekend>0])
  history[paste0("questions", n)][history["user"]==user] <<- length(user_history$questions[user_history$questions>0])
  history[paste0("tracking",  n)][history["user"]==user] <<- length(user_history$tracking[user_history$tracking>0])
  history[paste0("tenure",    n)][history["user"]==user] <<- (day0 - as.numeric(login$initdate[login$UserId==as.numeric(user)][1]))/DAY
}

UserHistory<-function(user,start,duration){
    user=as.numeric(user)

    print(user)
    Sys.setenv(TZ='GMT')    
    day0 = start - (start %% DAY)
    #print(as.POSIXlt(day0, origin="1970-01-01 00:00.00 UTC"))
    
    if(!is.na(as.numeric(pedometer$initdate[pedometer$UserId==user][1])))
        pedometer_init=as.numeric(pedometer$initdate[pedometer$UserId==user][1])
    else
        pedometer_init=as.numeric(pedometer$date[pedometer$date==max(pedometer$date)])[1]
    
    if(!is.na(as.numeric(login$initdate[login$UserId==user][1])))
        login_init=as.numeric(login$initdate[login$UserId==user][1])
    else
        login_init=as.numeric(login$date[login$date==max(login$date)])[1]

    minim=min(pedometer_init,login_init)
    userinit=minim-(minim %% DAY)
    #print(as.POSIXlt(userinit, origin="1970-01-01 00:00.00 UTC"))
    rm(pedometer_init,login_init)

    c_dates<-c()
    c_login<-c()
    c_pedometer<-c()
    c_bp<-c()
    c_weight<-c()
    c_glucose<-c()
    c_weekend<-c()
    c_questions<-c()
    c_selftracking<-c()

    length(c_dates)<-duration
    length(c_login)<-duration
    length(c_pedometer)<-duration
    length(c_bp)<-duration
    length(c_weight)<-duration
    length(c_glucose)<-duration
    length(c_weekend)<-duration
    length(c_questions)<-duration
    length(c_selftracking)<-duration
    
    for(i in 1:duration){
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
            c_questions[i]<-NA
            c_selftracking[i]<-NA
        }
        else{
            c_login[i]=length(login[login$UserId==user & login$date >= d-DAY & login$date < d,1])
            c_pedometer[i]=length(pedometer[pedometer$UserId==user & pedometer$date >= d-DAY & pedometer$date < d,1])
            c_bp[i]=length(bp[bp$UserId==user & bp$date >= d-DAY & bp$date < d,1])
            c_weight[i]=length(weight[weight$UserId==user & weight$date >= d-DAY & weight$date < d,1])
            c_glucose[i]=length(glucose[glucose$UserId==user & glucose$date >= d-DAY & glucose$date < d,1])
            c_weekend[i]=length(login[login$UserId==user & login$date >= d-DAY & login$date < d & 
                                     (login$dayofweek==0 | login$dayofweek==6),1])
            c_questions[i]=length(questions[questions$UserId==user & questions$date >= d-DAY & questions$date < d,1])
            c_selftracking[i]=c_weight+c_bp+c_glucose
        }       
    }
    user_history<-merge(data.frame("day"=1:duration, c_dates), data.frame("day"=1:duration, c_login), by="day")
    user_history<-merge(user_history, data.frame("day"=1:duration, c_pedometer), by="day")
    user_history<-merge(user_history, data.frame("day"=1:duration, c_bp), by="day")
    user_history<-merge(user_history, data.frame("day"=1:duration, c_weight), by="day")
    user_history<-merge(user_history, data.frame("day"=1:duration, c_glucose), by="day")
    user_history<-merge(user_history, data.frame("day"=1:duration, c_weekend), by="day")
    user_history<-merge(user_history, data.frame("day"=1:duration, c_questions), by="day")
    user_history<-merge(user_history, data.frame("day"=1:duration, c_selftracking), by="day")
    colnames(user_history)=c("day","dates","login","pedometer","bp","weight","glucose","weekend","tracking")
    
    return(user_history)
    # rm(c_bp,c_glucose,c_login,c_pedometer,c_selftracking,c_weekend,c_weight,c_dates)
}