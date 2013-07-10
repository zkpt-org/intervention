load('./data/la_msg.RData')
la_msg=sqldf("select distinct UserId,years,months,days,LoginType from la_msg")

load('./data/que_asked.RData')
que_asked_2= data.frame(que_asked,
                        years=substr(que_asked$DeliveryDate,1,4),
                        months=substr(que_asked$DeliveryDate,6,7),
                        days=substr(que_asked$DeliveryDate,9,10))

que_asked_2$years=as.integer(as.character(que_asked_2$years))
que_asked_2$months=as.integer(as.character(que_asked_2$months))
que_asked_2$days=as.integer(as.character(que_asked_2$days))

qud_asked=merge(que_asked_2,la_msg,
                by.x=c("UserId","years","months","days"), 
                by.y=c("UserId","years","months","days"))


load('./data/que_answered.RData')
qud_answered=data.frame(que_answered,
                        years=substr(que_answered$AnsweredDateTime,1,4),
                        months=substr(que_answered$AnsweredDateTime,6,7),
                        days=substr(que_answered$AnsweredDateTime,9,10))
                        
qud_answered$years=as.integer(as.character(qud_answered$years))
qud_answered$months=as.integer(as.character(qud_answered$months))
qud_answered$days=as.integer(as.character(qud_answered$days))

colnames(qud_asked)=c("UserId","years","months","days","QuestionId","date","LoginType")
colnames(qud_answered)=c("UserId","QuestionId","date","years","months","days")

asked_answered=merge(qud_asked,qud_answered, 
                by.x=c("UserId","QuestionId","years","months","days"), 
                by.y=c("UserId","QuestionId","years","months","days"),
                all.x=TRUE)

asked_answered$answered[is.na(asked_answered$date.y)]="N"
asked_answered$answered[!is.na(asked_answered$date.y)]="Y"

uniqueQ=unique(data.frame(asked_answered$UserId,asked_answered$QuestionId,asked_answered$date.x,asked_answered$answered))
colnames(uniqueQ)=c("UserId","QuestionId","date","answered")
uniqueQ=data.frame(uniqueQ,epoch=as.numeric(uniqueQ$date))

rm(qud_asked,que_asked,que_asked_2, que_answered,qud_answered,la_msg)