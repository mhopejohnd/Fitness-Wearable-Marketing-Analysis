-- BELLABEAT DATA ANALYSIS
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
USE MYFITBIT_DATABASE;
SHOW TABLES;
CREATE TABLE FB_daily_activity(
    ID BIGINT,
    ActivityDate TEXT,
    TotalSteps INT,
    TotalDistance FLOAT,
    TrackerDistance FLOAT,
    LoggedActivitiesDistance FLOAT,
    VeryActiveDistance FLOAT,
    ModeratelyActiveDistance FLOAT,
    LightActiveDistance FLOAT,
    SedentaryActiveDistance FLOAT,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories INT
    );
    
INSERT INTO FB_daily_activity(
	ID,
    ActivityDate,
    TotalSteps,
    TotalDistance,
    TrackerDistance,
    LoggedActivitiesDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
    )
SELECT 
	ID + 0 ,
	ActivityDate,
    TotalSteps,
    TotalDistance,
    TrackerDistance,
    LoggedActivitiesDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
FROM FB_daily_activity_MAR_APR
WHERE ID REGEXP '^[0-9]+$';

INSERT INTO FB_daily_activity(
	ID,
    ActivityDate,
    TotalSteps,
    TotalDistance,
    TrackerDistance,
    LoggedActivitiesDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
    )
SELECT 
	ID + 0 ,
	ActivityDate,
    TotalSteps,
    TotalDistance,
    TrackerDistance,
    LoggedActivitiesDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
FROM FB_daily_activity_APR_MAY
WHERE ID REGEXP '^[0-9]+$';

SHOW COLUMNS FROM FB_daily_activity;
SELECT * FROM FB_daily_activity;


ALTER TABLE FB_daily_activity
MODIFY COLUMN ActivityDate DATE;



SELECT COUNT(DISTINCT ID) FROM FB_daily_activity;  -- THERE ARE 35 DIFFERENT USERS

SELECT COUNT(DISTINCT ID), ActivityDate            -- NUMBER OF DIFFERENT USERS PER DAY THAT TOOK AT LEAST 1 STEP  
FROM FB_daily_activity
WHERE TotalSteps > 0
GROUP BY ActivityDate;                                                  

SELECT * FROM FB_daily_activity ORDER BY ActivityDate; -- ORDERS DATA IN CRONOLOGICAL ORDER
SELECT * FROM FB_daily_activity;

ALTER TABLE FB_daily_activity
ADD COLUMN DayofTheWeek TEXT AFTER ActivityDate;

ALTER TABLE FB_daily_activity
MODIFY COLUMN DayofTheWeek VARCHAR(10);

ALTER TABLE FB_daily_activity
ADD COLUMN EntryNumber INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE FB_daily_activity                               -- adds a DayofTheWeek column
ADD COLUMN DayofTheWeek VARCHAR(20)GENERATED ALWAYS AS (DAYNAME(ActivityDate)) STORED AFTER ActivityDate;

SELECT COUNT(ID), COUNT(DISTINCT ID), DayoftheWeek           -- NUMBER OF DIFFERENT USERS PER DAY OF THE WEEK THAT TOOK AT LEAST 1 STEP  
FROM FB_daily_activity
WHERE TotalSteps > 0 -- AND (DayofTheWeek = 'Saturday' or DayofTheWeek = 'Sunday')
GROUP BY DayoftheWeek;

SELECT ID, TrackerDistance, LoggedActivitiesDistance       -- UNLESS THEY ARE BOTH ZERO, TrackerDistance != LoggedActivitiesDistance --> so what does this measure??
FROM FB_daily_activity
WHERE TrackerDistance = LoggedActivitiesDistance 
	AND TrackerDistance != 0 ;
    
    
SELECT * FROM fb_sleptday_apr_may;  

CREATE TABLE WeekDaySleepAverages_APRMAY (
	ID BIGINT,
    YEAR INT,
    Monday FLOAT,
    Tuesday FLOAT,
    Wednesday FLOAT,
    Thursday FLOAT,
    Friday FLOAT,
    Saturday FLOAT,
    Sunday FLOAT,
    AvgSleep FLOAT 
);


SELECT * FROM WeekDaySleepAverages_APRMAY; -- MADE A TABLE OF SLEEP WEEKDAY AVERAGES NOW WANT TO DO WEEKLY AVERAGES FROM WEEK _ TO WEEK _

INSERT INTO WeekDaySleepAverages_APRMAY ( 
	ID,
    YEAR,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
    AvgSleep
    )                                         #weekly sleep averages
SELECT 
	ID,
    YEAR(SleepDay) as Year,
    -- Week(TheDate,1) as WeekNumber,
    AVG(CASE WHEN DAYNAME(SleepDay) = 'Monday' THEN TotalMinutes END)/60 as Monday,
    AVG(CASE WHEN DAYNAME(SleepDay) = 'Tuesday' THEN TotalMinutes END)/60 as Tuesday,
    AVG(CASE WHEN DAYNAME(SleepDay) = 'Wednesday' THEN TotalMinutes END)/60 as Wednesday,
    AVG(CASE WHEN DAYNAME(SleepDay) = 'Thursday' THEN TotalMinutes END)/60 as Thursday,
    AVG(CASE WHEN DAYNAME(SleepDay) = 'Friday' THEN TotalMinutes END)/60 as Friday,
    AVG(CASE WHEN DAYNAME(SleepDay) = 'Saturday' THEN TotalMinutes END)/60 as Saturday,
    AVG(CASE WHEN DAYNAME(SleepDay) = 'Sunday' THEN TotalMinutes END)/60 as Sunday,
    -- DATE(TheDate) AS Dateof,
    avg(TotalMinutes)/60 AS AVGHoursSlept
FROM fb_sleptday_apr_may
GROUP BY ID, Year
ORDER BY ID, Year,
	FIELD( 'Monday', 'Tuesday', 'Wednesday','Thursday', 'Friday', 'Saturday', 'Sunday');

SELECT * FROM fb_minutesleep_apr_may;

SELECT * FROM FB_daily_activity;


CREATE TABLE WeekDayStepAverages_APRMAY (
	ID BIGINT,
    YEAR INT,
    Monday INT,
    Tuesday INT,
    Wednesday INT,
    Thursday INT,
    Friday INT,
    Saturday INT,
    Sunday INT,
    AvgSleep INT 
);
INSERT INTO WeekDayStepAverages_APRMAY ( 
	ID,
    YEAR,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
    AvgSleep
    )                                         #weekly step averages
SELECT 
	ID,
    YEAR(ActivityDate) as Year,
    -- Week(TheDate,1) as WeekNumber,
    ROUND(AVG(CASE WHEN DAYNAME(ActivityDate) = 'Monday' THEN TotalSteps END)) as Monday,
    ROUND(AVG(CASE WHEN DAYNAME(ActivityDate) = 'Tuesday' THEN TotalSteps END)) as Tuesday,
    ROUND(AVG(CASE WHEN DAYNAME(ActivityDate) = 'Wednesday' THEN TotalSteps END)) as Wednesday,
    ROUND(AVG(CASE WHEN DAYNAME(ActivityDate) = 'Thursday' THEN TotalSteps END)) as Thursday,
    ROUND(AVG(CASE WHEN DAYNAME(ActivityDate) = 'Friday' THEN TotalSteps END)) as Friday,
    ROUND(AVG(CASE WHEN DAYNAME(ActivityDate) = 'Saturday' THEN TotalSteps END)) as Saturday,
    ROUND(AVG(CASE WHEN DAYNAME(ActivityDate) = 'Sunday' THEN TotalSteps END)) as Sunday,
    -- DATE(TheDate) AS Dateof,
    ROUND(avg(TotalSteps)) AS AVGSteps
FROM FB_daily_activity
GROUP BY ID, Year
ORDER BY ID, Year,
	FIELD( 'Monday', 'Tuesday', 'Wednesday','Thursday', 'Friday', 'Saturday', 'Sunday');
    
SELECT MAX( WEEK(ActivityDate)) FROM FB_daily_activity;




CREATE TABLE WeeklyStepAverages(
	ID BIGINT,
    YEAR INT,
    WEEK1 INT,
    WEEK2 INT,
    WEEK3 INT,
    WEEK4 INT,
    WEEK5 INT,
    WEEK6 INT,
    WEEK7 INT,
    WEEK8 INT,
    WEEK9 INT,
    WEEK10 INT,
    AVG_STEPS INT
);

INSERT INTO WeeklyStepAverages (
	ID,
    YEAR,
    WEEK1,
    WEEK2,
    WEEK3,
    WEEK4,
    WEEK5,
    WEEK6,
    WEEK7,
    WEEK8,
    WEEK9,
    WEEK10,
    AVG_STEPS
    )
SELECT 
	ID,
    YEAR(ActivityDate) as Year,
    AVG(CASE WHEN Week(ActivityDate,1) = 10 THEN TotalSteps END) as WEEK1,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 11 THEN TotalSteps END)) as WEEK2,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 12 THEN TotalSteps END)) as WEEK3,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 13 THEN TotalSteps END)) as WEEK4,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 14 THEN TotalSteps END)) as WEEK5,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 15 THEN TotalSteps END)) as WEEK6,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 16 THEN TotalSteps END)) as WEEK7,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 17 THEN TotalSteps END)) as WEEK8,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 18 THEN TotalSteps END)) as WEEK9,
    ROUND(AVG(CASE WHEN Week(ActivityDate,1) = 19 THEN TotalSteps END)) as WEEK10,
    ROUND(avg(TotalSteps)) AS AVGSteps
FROM FB_daily_activity
GROUP BY ID, Year
ORDER BY ID, Year;    

CREATE TABLE WeeklySleepAveragesAPR_MAY (
	ID BIGINT,
    YEAR INT,
    WEEK6 FLOAT,
    WEEK7 FLOAT,
    WEEK8 FLOAT,
    WEEK9 FLOAT,
    WEEK10 FLOAT,
    AVG_HoursSlept FLOAT
    );

INSERT INTO WeeklySleepAveragesAPR_MAY (
	ID,
    YEAR,
    WEEK6,
    WEEK7,
    WEEK8,
    WEEK9,
    WEEK10,
    AVG_HoursSlept
    )
SELECT 
	ID,
    YEAR(SleepDay) as Year,
    ROUND(AVG(CASE WHEN Week(SleepDay,1) = 15 THEN SleptHours END),2) as WEEK6,
    ROUND(AVG(CASE WHEN Week(SleepDay,1) = 16 THEN SleptHours END),2) as WEEK7,
    ROUND(AVG(CASE WHEN Week(SleepDay,1) = 17 THEN SleptHours END),2) as WEEK8,
    ROUND(AVG(CASE WHEN Week(SleepDay,1) = 18 THEN SleptHours END),2) as WEEK9,
    ROUND(AVG(CASE WHEN Week(SleepDay,1) = 19 THEN SleptHours END),2) as WEEK10,
    ROUND(avg(SleptHours),2) AS AVG_HoursSlept
FROM fb_sleptday_apr_may
GROUP BY ID, Year
ORDER BY ID, Year;

SELECT * FROM WeeklySleepAveragesAPR_MAY;

SHOW TABLES;
