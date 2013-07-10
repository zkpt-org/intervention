#Add columns for pre-existing conditions
user_data['Diabetes']<-0
user_data['HighBloodPressure']<-0
user_data['HighCholesterol']<-0
user_data['HeartDisease']<-0
user_data['MetabolicSyndrome']<-0
user_data['Other']<-0

#Extract pre-existing conditions
hiblood=sqldf("SELECT UserId FROM condition WHERE Key = 'QUESTION_CHRONIC' AND Value LIKE '%High Blood Pressure'
                        OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%High Blood Pressure' 
                        OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%High Blood Pressure'
                        OR Key = 'QUESTION_HYPERTENSION'   AND Value LIKE '%High Blood Pressure'                                        
                        OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%High Blood Pressure'
                        OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%High Blood Pressure'")
hiblood['hiblood']<-1

diabetes=sqldf("SELECT UserId FROM condition WHERE Key = 'QUESTION_CHRONIC' AND Value LIKE '%Diabetes'
                        OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%Diabetes'
                        OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%Diabetes'
                        OR Key = 'QUESTION_HYPERTENSION'   AND Value LIKE '%Diabetes'
                        OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%Diabetes'
                        OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%Diabetes'")
diabetes['diabetes']<-1

highcol=sqldf("SELECT UserId FROM condition WHERE Key = 'QUESTION_CHRONIC' AND Value LIKE '%High Cholesterol'
                        OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%High Cholesterol'
                        OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%High Cholesterol'
                        OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%High Cholesterol'
                        OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%High Cholesterol'
                        OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%High Cholesterol'")
highcol['hicol']<-1

heartdis=sqldf("SELECT UserId FROM condition WHERE Key = 'QUESTION_CHRONIC' AND Value LIKE '%Heart Disease'
                        OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%Heart Disease'
                        OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%Heart Disease'
                        OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%Heart Disease'
                        OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%Heart Disease'
                        OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%Heart Disease'")
heartdis['heartdis']<-1

metabo=sqldf("SELECT UserId FROM condition WHERE Key = 'QUESTION_CHRONIC' AND Value LIKE '%Metabolic Syndrome'
                        OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%Metabolic Syndrome'
                        OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%Metabolic Syndrome'
                        OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%Metabolic Syndrome'
                        OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%Metabolic Syndrome'
                        OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%Metabolic Syndrome'")
metabo['metabo']<-1

other=sqldf("SELECT UserId FROM condition WHERE Key = 'QUESTION_CHRONIC' AND Value LIKE '%Other'
    OR Key = 'QUESTION_CHRONIC'   AND Value LIKE '%pre- or gestatiolHypertension'
    OR Key = 'QUESTION_CHRONIC'   AND Value LIKE '%Depression anxiety or stress related'
    OR Key = 'QUESTION_CHRONIC'   AND Value LIKE '%pre- or gestatiolOsteoarthritis'
    OR Key = 'QUESTION_CHRONIC'   AND Value LIKE '%Osteoarthritis'
    OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%Other'
    OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%pre- or gestatiolHypertension'
    OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%Depression anxiety or stress related'
    OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%pre- or gestatiolOsteoarthritis'
    OR Key = 'QUESTION_CHRONIC_2' AND Value LIKE '%Osteoarthritis'
    OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%Other'
    OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%pre- or gestatiolHypertension'
    OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%Depression anxiety or stress related'
    OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%pre- or gestatiolOsteoarthritis'
    OR Key = 'QUESTION_CHRONIC_3' AND Value LIKE '%Osteoarthritis'
    OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%Other'
    OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%pre- or gestatiolHypertension'
    OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%Depression anxiety or stress related'
    OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%pre- or gestatiolOsteoarthritis'
    OR Key = 'QUESTION_HYPERTENSION' AND Value LIKE '%Osteoarthritis'
    OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%Other'
    OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%pre- or gestatiolHypertension'
    OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%Depression anxiety or stress related'
    OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%pre- or gestatiolOsteoarthritis'
    OR Key = 'QUESTION_HYPERTENSION_2' AND Value LIKE '%Osteoarthritis'
    OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%Other'
    OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%pre- or gestatiolHypertension'
    OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%Depression anxiety or stress related'
    OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%pre- or gestatiolOsteoarthritis'
    OR Key = 'QUESTION_HYPERTENSION_3' AND Value LIKE '%Osteoarthritis'")
other['others']<-1

# Merge pre-existing conditions.
user_data=merge(user_data, hiblood, by="UserId", all.x=TRUE)
user_data$HighBloodPressure[user_data$hiblood==1]=1

user_data=merge(user_data, diabetes, by="UserId", all.x=TRUE)
user_data$Diabetes[user_data$diabetes==1]=1

user_data=merge(user_data, highcol, by="UserId", all.x=TRUE)
user_data$HighCholesterol[user_data$hicol==1]=1

user_data=merge(user_data, heartdis, by="UserId", all.x=TRUE)
user_data$HeartDisease[user_data$heartdis==1]=1
    
user_data=merge(user_data, metabo, by="UserId", all.x=TRUE)
user_data$MetabolicSyndrome[user_data$metabo==1]=1
    
user_data=merge(user_data, other, by="UserId", all.x=TRUE)
user_data$Other[user_data$others==1]=1

user_data=subset(user_data, select=-c(hiblood, diabetes, hicol, heartdis, metabo, others))
rm(hiblood, diabetes, highcol, heartdis, metabo, other)

user_data=unique(user_data)

stress=sqldf("SELECT UserId, Value AS Stress  FROM condition WHERE Key = 'QUESTION_STRESS'")
smoking=sqldf("SELECT UserId, Value AS Smoking FROM condition WHERE Key = 'QUESTION_TOBACCO'")
health=sqldf("SELECT UserId, Value AS Health FROM condition WHERE Key = 'QUESTION_HEALTH'")

user_data=merge(user_data, stress, by="UserId", all.x=TRUE)
user_data=unique(user_data)

user_data=merge(user_data, smoking, by="UserId", all.x=TRUE)
user_data=unique(user_data)

user_data=merge(user_data, health, by="UserId", all.x=TRUE)
user_data=unique(user_data)

rm(stress, smoking, health)

user_data=user_data[!duplicated(user_data[,1]),] 
colnames(user_data)[1] <- "user"
colnames(user_data)[2] <- "state"
