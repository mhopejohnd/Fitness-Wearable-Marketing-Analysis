USE myfitbit_database;

-- CREATE TABLE NEW_daily_activity_MAR_APR(
--     ID int,
--     ActivityDate VARCHAR(10),
--     TotalSteps int,
--     TotalDistance float(53),
--     TrackerDistance float(53),
--     LoggedActivitiesDistance float(53),
--     VeryActiveDistance float(53),
--     ModeratelyActiveDistance float(53),
--     LightActiveDistance float(53),
--     SedentaryActiveDistance float(53),
--     VeryActiveMinutes int,
--     FairlyActiveMinutes int,
--     LightlyActiveMinutes int,
--     SedentaryMinutes int,
--     Calories int
-- );

CREATE TABLE TEMP_daily_activity_MAR_APR(
    ID TEXT,
    ActivityDate TEXT,
    TotalSteps TEXT,
    TotalDistance TEXT,
    TrackerDistance TEXT,
    LoggedActivitiesDistance TEXT,
    VeryActiveDistance TEXT,
    ModeratelyActiveDistance TEXT,
    LightActiveDistance TEXT,
    SedentaryActiveDistance TEXT,
    VeryActiveMinutes TEXT,
    FairlyActiveMinutes TEXT,
    LightlyActiveMinutes TEXT,
    SedentaryMinutes TEXT,
    Calories TEXT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dailyActivity_mergedMAR_APR.csv"
INTO TABLE TEMP_daily_activity_MAR_APR
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT ID FROM TEMP_daily_activity_MAR_APR
WHERE ID NOT REGEXP '^[0-9]+$'
OR LENGTH(ID) != 10;
-- RESULT: NONE ; 	so everything in the ID column should be formatted correctly

SELECT TotalSteps FROM TEMP_daily_activity_MAR_APR
WHERE TotalSteps NOT REGEXP '[0-9]'
OR LENGTH(TotalSteps) >5 ;
-- RESULT: everythiing in the TotalSteps column is an integer with a length less than 5

SELECT 
	DATE_FORMAT(STR_TO_DATE(ActivityDate, '%m/%d/%y'), '%Y-%m-%d') 
FROM TEMP_daily_activity_MAR_APR;
-- RESULT: date is still a string, but it's formated correctly otherwise

SELECT TotalDistance 
FROM TEMP_daily_activity_MAR_APR;

SELECT TrackerDistance 
FROM TEMP_daily_activity_MAR_APR;
-- FIGURE OUT what this tracks!!

SELECT LoggedActivitiesDistance
FROM TEMP_daily_activity_MAR_APR;
-- fyi MOST OF THESE ARE ZEROS

SELECT VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance
FROM TEMP_daily_activity_MAR_APR;

SELECT VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes
FROM TEMP_daily_activity_MAR_APR;

SELECT Calories 
FROM TEMP_daily_activity_MAR_APR;

-- DATA IS CLEANED NOW!! [for first csv]  onto the next !!!
-- ----------------------------------------------------------------------------------------------------------------------
CREATE TABLE TEMP_daily_activity_APR_MAY(
    ID TEXT,
    ActivityDate TEXT,
    TotalSteps TEXT,
    TotalDistance TEXT,
    TrackerDistance TEXT,
    LoggedActivitiesDistance TEXT,
    VeryActiveDistance TEXT,
    ModeratelyActiveDistance TEXT,
    LightActiveDistance TEXT,
    SedentaryActiveDistance TEXT,
    VeryActiveMinutes TEXT,
    FairlyActiveMinutes TEXT,
    LightlyActiveMinutes TEXT,
    SedentaryMinutes TEXT,
    Calories TEXT
);
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dailyActivity_mergedAPR_MAY.csv"
INTO TABLE TEMP_daily_activity_APR_MAY
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 
	DATE_FORMAT(STR_TO_DATE(ActivityDate, '%m/%d/%y'), '%Y-%m-%d')
FROM TEMP_daily_activity_APR_MAY;
-- RESULT: date is still a string, but it's formated correctly otherwise

-- NOW THE THIS CSV IS CLEANED/PREPPED
-- ---------------------------------------------------------------------------------------------
CREATE TABLE TEMP_hourlySteps_APR_MAY(
    ID TEXT,
    ActivityHour TEXT,
    StepTotal TEXT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hourlySteps_mergedAPR_MAY.csv"
INTO TABLE TEMP_hourlySteps_APR_MAY
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
  DATE_FORMAT(STR_TO_DATE(ActivityHour, '%m/%d/%Y %r'), '%Y-%m-%d %H:%i:%s') AS ActivityHour_datetime
FROM TEMP_hourlySteps_APR_MAY
LIMIT 30;
-- NOW the activityhour is in datetime format, ready to be converted to the datetime type
-- NEED TO : HAVE SEPARATE ACTIVITYDAY AND ACTIVITYHOUR COLUMNS


-- ----------------------------------------------------------------------------------------------------

CREATE TABLE TEMP_minuteSleep_APR_MAY(
    ID TEXT,
    thedate TEXT,
    vaue TEXT,
    logID TEXT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/minuteSleep_mergedAPR_MAY.csv"
INTO TABLE TEMP_minuteSleep_APR_MAY
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 
	DATE_FORMAT(STR_TO_DATE(thedate, '%m/%d/%Y %r'), '%Y-%m-%d %H:%i:%s') AS SleepDatetime
FROM TEMP_minuteSleep_APR_MAY
LIMIT 30;
-- changed date into datetime format, ready to be transported into a table

-- ----------------------------------------------------------------------------------------------------------
CREATE TABLE TEMP_SleptDay_APR_MAY(
    ID TEXT,
    SleepDay TEXT,
    TotalSleep TEXT,
    TotalMinutes TEXT,
    TotalTimeInBed TEXT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sleepDay_mergedAPR_MAY.csv"
INTO TABLE TEMP_SleptDay_APR_MAY
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT (TotalTimeInBed/60) AS TotalSleepHour
FROM TEMP_SleptDay_APR_MAY
LIMIT 20;

SELECT (TotalMinutes/60) AS TotalSleepHour
FROM TEMP_SleptDay_APR_MAY
LIMIT 20;

SELECT * FROM TEMP_SleptDay_APR_MAY
LIMIT 28;

SELECT 
	DATE_FORMAT(STR_TO_DATE(SleepDay, '%m/%d/%Y %r'), '%Y-%m-%d %H:%i:%s') AS SleepDatetime
FROM TEMP_SleptDay_APR_MAY
LIMIT 30;

SELECT LEFT(SleepDay, LOCATE(' ', SleepDay) - 1) FROM TEMP_SleptDay_APR_MAY
LIMIT 30;
-- now can change format and only use date, instead of whole datetime

-- ---------------------------------------------------------------------------------------------------------------

CREATE TABLE weightLogInfo_APR_MAY(
    ID TEXT,
    TheDate TEXT,
    WeightKg TEXT,
    WeightLbs TEXT,
    Fat TEXT,
    BMI TEXT,
    IsManualReport TEXT,
    LogID TEXT
    
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/weightLogInfo_mergedAPR_MAY.csv"
INTO TABLE weightLogInfo_APR_MAY
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM weightLogInfo_APR_MAY
LIMIT 5;

SELECT 
	DATE_FORMAT(STR_TO_DATE(TheDate, '%m/%d/%Y %r'), '%Y-%m-%d %H:%i:%s') AS WeightDatetime
FROM weightLogInfo_APR_MAY
LIMIT 30;
-- changed into datetime, though i'm not sure how useful the time will be.
-- ----------------------------------------------------------------------------------------------------------------