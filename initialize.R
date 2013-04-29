load('./data/pedometer.RData')
load('./data/login.RData')
load('./data/weight.RData')
load('./data/bp.RData')
load('./data/glucose.RData')
load('./data/questions.RData')
load('./data/init.RData')

# Define time periods in seconds.
YEAR  = 31536000
MONTH = 2592000
WEEK  = 604800
DAY   = 86400
HOUR  = 3600

colnames(pedometer)=c("UserId",colnames(pedometer)[2:15])
colnames(weight)[2]<-"UserId"
colnames(bp)[1]<-"UserId"
colnames(questions)[1]<-"UserId"

#------------------------------------------------------------------------------------- Pedometer
colnames(init)=c("UserId", "initdate")

init2=data.frame(init, inityear=substr(init$initdate,1,4),
                initmonth=substr(init$initdate,6,7),
                initday=substr(init$initdate,9,10))

pedometer=merge(pedometer, init2, by="UserId")
pedometer$date=ISOdate(pedometer$years,pedometer$months,pedometer$days)
pedometer$initdate=ISOdate(pedometer$inityear,pedometer$initmonth,pedometer$initday)

pedometer$xdate=(pedometer$date-pedometer$initdate)/3600/24
pedometer$xdate=as.numeric(pedometer$xdate)
pedometer$dayofweek=as.POSIXlt(pedometer$date)$wday
initdate=sqldf("SELECT DISTINCT UserID, date, initdate,xdate, dayofweek, sum_steps 
                FROM pedometer ORDER BY userid, xdate, initdate")

rm(init, init2)

#---------------------------------------------------------------------------------------- Logins
#Note in above, sql datepart(weekday, ...) command gives SUNDAY as day 1!!!!
colnames(login)=c("UserId",colnames(login)[2:length(colnames(login))])
#check=sqldf("select userid, min(starttime) init from login group by userid")

load('./data/login_init.RData')
colnames(login_init)=c("UserId", "initdate")

login_init2=data.frame(login_init, inityear=substr(login_init$initdate,1,4),
                   initmonth=substr(login_init$initdate,6,7),
                   initday=substr(login_init$initdate,9,10))

#merge two datasets, one with date and one with initdate
ld=merge(login, login_init2, by="UserId") 

#Obtain necessary dates and time periods in correct form
ld$date=ISOdate(ld$years,ld$months,ld$days)
ld$initdate=ISOdate(ld$inityear,ld$initmonth,ld$initday)
ld$xdate=(ld$date-ld$initdate)/3600/24
ld$xdate=as.numeric(ld$xdate)

#eliminate multiple counts per day
ld=sqldf("select distinct UserId, date, initdate,xdate
                 from ld order by userid,xdate,initdate")

#looks at properties of all logins
ld$dayofweek=as.POSIXlt(ld$date)$wday
ld$initdayofweek=as.POSIXlt(ld$initdate)$wday
ld$dayofweek_n=c("Sunday","Monday", "Tuesday", "Wednesday", 
                "Thursday","Friday", "Saturday")[as.POSIXlt(ld$date)$wday+1]
login = ld
rm(login_init,login_init2,ld)


#--------------------------------------------------------------------Weight
colnames(weight)=c("WeightReadingId","UserId",colnames(weight)[3:10])

weight2=data.frame(weight, years=substr(weight$ReadingDateTime,1,4),
                           months=substr(weight$ReadingDateTime,6,7),
                           days=substr(weight$ReadingDateTime,9,10))

load('./data/weightinit.RData')
colnames(weight_init)=c("UserId", "initdate")

w_init=data.frame(weight_init, inityear=substr(weight_init$initdate,1,4),
                              initmonth=substr(weight_init$initdate,6,7),
                              initday=substr(weight_init$initdate,9,10))

wmerge=merge(weight2, w_init, by="UserId")
wmerge$date=ISOdate(wmerge$years,wmerge$months,wmerge$days)
wmerge$initdate=ISOdate(wmerge$inityear,wmerge$initmonth,wmerge$initday)
wmerge$xdate=(wmerge$date-wmerge$initdate)/3600/24
wmerge$xdate=as.numeric(wmerge$xdate)
wmerge$dayofweek=as.POSIXlt(wmerge$date)$wday
wmerge=sqldf("select distinct UserID, date, initdate,xdate, dayofweek, Weight
                 from wmerge order by userid,xdate,initdate")
weight=wmerge

rm(weight2,wmerge,w_init,weight_init)

#-------------------------------------------------------------------------------------------- BP
colnames(bp)=c("UserId",colnames(bp)[2:7])

load('./data/bpinit.RData')
colnames(bp_init)=c("UserId", "initdate")
bp2=data.frame(bp_init, inityear=substr(bp_init$initdate,1,4),
                initmonth=substr(bp_init$initdate,6,7),
                initday=substr(bp_init$initdate,9,10))

bp3=merge(bp, bp2, by="UserId")
bp3$date=ISOdate(bp3$years,bp3$months,bp3$days)
bp3$initdate=ISOdate(bp3$inityear,bp3$initmonth,bp3$initday)
bp3$xdate=(bp3$date-bp3$initdate)/3600/24
bp3$xdate=as.numeric(bp3$xdate)
#uniqusr=sqldf("select distinct xdate, UserId from bp3")
bp3$dayofweek=as.POSIXlt(bp3$date)$wday
bp3=sqldf("select distinct UserID, date, initdate,xdate, dayofweek
             from bp3 order by userid,xdate,initdate")
bp=bp3

rm(bp_init, bp2, bp3)

#--------------------------------------------------------------------------------------- Glucose
glucose2=data.frame(glucose, years=substr(glucose$MeasurementDate,1,4),
                             months=substr(glucose$MeasurementDate,6,7),
                             days=substr(glucose$MeasurementDate,9,10))

load('./data/glucoseinit.RData')
colnames(glucose_init)=c("UserId", "initdate")
g_init=data.frame(glucose_init, inityear=substr(glucose_init$initdate,1,4),
                               initmonth=substr(glucose_init$initdate,6,7),
                               initday=substr(glucose_init$initdate,9,10))

gmerge=merge(glucose2, g_init, by="UserId")
gmerge$date=ISOdate(gmerge$years,gmerge$months,gmerge$days)
gmerge$initdate=ISOdate(gmerge$inityear,gmerge$initmonth,gmerge$initday)
gmerge$xdate=(gmerge$date-gmerge$initdate)/3600/24
gmerge$xdate=as.numeric(gmerge$xdate)
gmerge$dayofweek=as.POSIXlt(gmerge$date)$wday
gmerge=sqldf("select distinct UserID, date, initdate,xdate, dayofweek, GlucoseLevel
             from gmerge order by userid,xdate,initdate")
glucose=gmerge
rm(glucose2, glucose_init, gmerge, g_init)

#------------------------------------------------------------------------------------- Questions
questions2=data.frame(questions,years=substr(questions$AnsweredDateTime,1,4),
                          months=substr(questions$AnsweredDateTime,6,7),
                          days=substr(questions$AnsweredDateTime,9,10))
colnames(questions2)=c("UserId",colnames(questions2)[2:6])
questions_init<-sqldf("SELECT DISTINCT UserId, initdate FROM login")
#questions_init<-subset(login, select=c("UserId","initdate"))

questions=merge(questions2, questions_init, by.x="UserId")
questions$date=ISOdate(questions$years,questions$months,questions$days)
#questions$initdate=ISOdate(questions$inityear,questions$initmonth,questions$initday)
questions$xdate=(questions$date-questions$initdate)/3600/24
questions$xdate=as.numeric(questions$xdate)
questions$years=as.integer(as.character(questions$years))
questions$months=as.integer(as.character(questions$months))
questions$days=as.integer(as.character(questions$days))

rm(questions2,questions_init)
