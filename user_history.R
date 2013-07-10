# Goal: User Vector = [between day x-1 to x-n count number of days where activity exists]

GenerateHitory<-function(user,start,n,duration){
  date = start - (start %% DAY)
  dayn = date  - ((n-1)*(duration*DAY))
  
  print(paste("user:",user,"pass:",n,c))
  #print(as.Date(as.POSIXlt(dayn, origin="1970-01-01 00:00.00 UTC")))
  
  user_history<-UserHistory(user,dayn,duration)
  
  history[c,paste0("pedometer", n)] <<- length(user_history$pedometer[user_history$pedometer>0])
  history[c,paste0("login",     n)] <<- length(user_history$login[user_history$login>0])
  history[c,paste0("bp",        n)] <<- length(user_history$bp[user_history$bp>0])
  history[c,paste0("glucose",   n)] <<- length(user_history$glucose[user_history$glucose>0])
  history[c,paste0("weight",    n)] <<- length(user_history$weight[user_history$weight>0])
  history[c,paste0("weekend",   n)] <<- length(user_history$weekend[user_history$weekend>0])
  history[c,paste0("questions", n)] <<- length(user_history$questions[user_history$questions>0])
  history[c,paste0("tenure",    n)] <<- (dayn - as.numeric(initdate(user)))/DAY

  c<<-c+1
  rm(user_history)
}

UserHistory<-function(user,day0,duration){
    user=as.numeric(user)
    
    Sys.setenv(TZ='GMT')
    #day0 = start - (start %% DAY)
    #print(as.POSIXlt(day0, origin="1970-01-01 00:00.00 UTC"))
    userinit=initdate(user)
    
    c_dates<-c()
    c_login<-c()
    c_pedometer<-c()
    c_bp<-c()
    c_weight<-c()
    c_glucose<-c()
    c_weekend<-c()
    c_questions<-c()

    length(c_dates)<-duration
    length(c_login)<-duration
    length(c_pedometer)<-duration
    length(c_bp)<-duration
    length(c_weight)<-duration
    length(c_glucose)<-duration
    length(c_weekend)<-duration
    length(c_questions)<-duration
    
    for(i in 1:duration){
        d = day0 - (i*DAY) + DAY
        c_dates[i]=d
        #print(as.POSIXlt(d, origin="1970-01-01 00:00.00 UTC"))
        if(d<userinit){
            c_login[i]<-0
            c_pedometer[i]<-0
            c_bp[i]<-0
            c_weight[i]<-0
            c_glucose[i]<-0
            c_weekend[i]<-0
            c_questions[i]<-0
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
        }       
    }
    usrhist<-merge(data.frame("day"=1:duration, c_dates), data.frame("day"=1:duration, c_login), by="day")
    usrhist<-merge(usrhist, data.frame("day"=1:duration, c_pedometer), by="day")
    usrhist<-merge(usrhist, data.frame("day"=1:duration, c_bp), by="day")
    usrhist<-merge(usrhist, data.frame("day"=1:duration, c_weight), by="day")
    usrhist<-merge(usrhist, data.frame("day"=1:duration, c_glucose), by="day")
    usrhist<-merge(usrhist, data.frame("day"=1:duration, c_weekend), by="day")
    usrhist<-merge(usrhist, data.frame("day"=1:duration, c_questions), by="day")
    colnames(usrhist)=c("day","dates","login","pedometer","bp","weight","glucose","weekend")
    
    return(usrhist)
}

initdate<-function(user){
  if(!is.na(as.numeric(pedometer$initdate[pedometer$UserId==user][1])))
    pedometer_init=as.numeric(pedometer$initdate[pedometer$UserId==user][1])
  else
    pedometer_init=as.numeric(pedometer$date[pedometer$date==max(pedometer$date)])[1]
  
  if(!is.na(as.numeric(login$initdate[login$UserId==user][1])))
    login_init=as.numeric(login$initdate[login$UserId==user][1])
  else
    login_init=as.numeric(login$date[login$date==max(login$date)])[1]
  
  if(!is.na(as.numeric(bp$initdate[bp$UserId==user][1])))
    bp_init=as.numeric(bp$initdate[bp$UserId==user][1])
  else
    bp_init=as.numeric(bp$date[bp$date==max(bp$date)])[1]
  
  if(!is.na(as.numeric(glucose$initdate[glucose$UserId==user][1])))
    glucose_init=as.numeric(glucose$initdate[glucose$UserId==user][1])
  else
    glucose_init=as.numeric(glucose$date[glucose$date==max(glucose$date)])[1]

  if(!is.na(as.numeric(weight$initdate[weight$UserId==user][1])))
    weight_init=as.numeric(weight$initdate[weight$UserId==user][1])
  else
    weight_init=as.numeric(weight$date[weight$date==max(weight$date)])[1]
  
  minim=min(pedometer_init,login_init,bp_init,glucose_init,weight_init)
  
  userinit=minim-(minim %% DAY)
  #print(as.POSIXlt(userinit, origin="1970-01-01 00:00.00 UTC"))
  rm(pedometer_init,login_init,bp_init,glucose_init,weight_init)
  return(userinit)
}