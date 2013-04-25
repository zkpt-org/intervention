# =================================================
# = Set the working directory of the script below =
# =================================================
setwd("/Path/To/R/Scripts")

# ==============================================================
# = Set the ODBC connection name, username, and password below =
# ==============================================================
db_connection=""
db_user=""
db_password=""

# =================================
# = DO NOT RECONFIGURE BELOW THIS =
# =================================
# Import required libraries.
library(sqldf)
library(RODBC)
library(plyr)
# library(lubridate)
# library(reshape)
# library(stringr)
# library(dataframes2xls)
# library(rjson)