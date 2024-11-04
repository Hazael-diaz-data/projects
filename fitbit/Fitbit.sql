CREATE TABLE daily_activity_03_05 (Id text, Date text, TotalSteps integer, 
TotalDistance float, TrackerDistance float, 
LoggedActivitiesDistance float, VeryActiveDistance float, 
ModeratelyActiveDistance float, LightActiveDistance float, SedentaryActiveDistance float, 
VeryActiveMinutes integer, FairlyActiveMinutes integer, LightlyActiveMinutes integer, 
SedentaryMinutes integer, Calories integer);

SELECT COUNT(*)
FROM daily_activity_03_04_v02;

SELECT *
FROM daily_activity_04_05;

INSERT INTO daily_activity_03_04_v02 
SELECT  Id, Date, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories 
FROM daily_activity_04_05_v02;

SELECT COUNT(date)
FROM daily_activity_03_04_v02;
-- I created a new table which contains data from 03 to 05 (Data merging)
CREATE TABLE daily_activity_03_05 (Id text, Date text, TotalSteps integer, 
TotalDistance float, TrackerDistance float, 
LoggedActivitiesDistance float, VeryActiveDistance float, 
ModeratelyActiveDistance float, LightActiveDistance float, SedentaryActiveDistance float, 
VeryActiveMinutes integer, FairlyActiveMinutes integer, LightlyActiveMinutes integer, 
SedentaryMinutes integer, Calories integer);

SELECT *
FROM daily_activity_03_05;



INSERT INTO daily_activity_03_05 
SELECT  Id, Date, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories 
FROM daily_activity_03_04_v02;

SELECT *
FROM daily_activity_03_05
WHERE id = '1503960366';

-- data cleaning 1) Duplicates, 2) Nulls and missing values, 3) Remove columns aka irrelevant data

SELECT Id, Date, TotalSteps, COUNT(*)
FROM daily_activity_03_05
GROUP BY Id, Date, TotalSteps
HAVING COUNT(*) > 1;
-- There aren't any duplicates
SELECT DISTINCT Id
FROM daily_activity_03_05;
-- There are 35 subjects, no nulls
SELECT DISTINCT date
FROM daily_activity_03_05;
-- 62 days
SELECT COUNT(totalsteps)
FROM daily_activity_03_05
WHERE TotalSteps IS NOT NULL;
-- 
SELECT distinct totalsteps
FROM daily_activity_03_05
ORDER BY totalsteps ASC;
-- Fitbit dataset has not any missing value, dataset is clean
-- There is one more step to do before analysis, I need to convert the date column into date
-- Changing date from  string to date
ALTER TABLE daily_activity_03_05
ADD COLUMN activitydate;

SELECT date, 
TO_DATE(date, 'YYYY/MM/DD')
FROM daily_activity_03_05;

UPDATE daily_activity_03_05
SET activitydate = TO_DATE(date, 'YYYY/MM/DD');
-- I have to get rid of date column
SELECT *
FROM daily_activity_03_05;
-- ANALYSIS
-- FIRST QUESTION: HOW MANY DAYS WITHOUT ACTIVITY DO HAVE EVERY SUBJECT
SELECT *
FROM daily_activity_03_05
ORDER BY sedentaryminutes DESC;

SELECT *
FROM daily_activity_03_05
ORDER BY  totalsteps ASC;

SELECT COUNT (trackerdistance), id
FROM daily_activity_03_04
GROUP BY id
HAVING COUNT(trackerdistance) = 0;

-- New issue, SQL DOESN'T IDENTIFY 0 
ALTER TABLE daily_activity_03_05
ADD COLUMN totalsteps_02 INTEGER;

SELECT CAST(totalsteps AS INTEGER)
FROM daily_activity_03_05;

UPDATE daily_activity_03_05
SET totalsteps_02 = CAST(totalsteps AS INTEGER);

-- DELETE USELESS COLUMNS
ALTER TABLE daily_activity_03_05
DROP COLUMN trackerdistance;

ALTER TABLE daily_activity_03_05
DROP COLUMN date;

ALTER TABLE daily_activity_03_05
DROP COLUMN totalsteps_02;

SELECT *
FROM daily_activity_03_05;