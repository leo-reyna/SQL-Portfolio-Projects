-- Active: 1745290413437@@127.0.0.1@3306
/*
  WORK IN PROGRESS - OCT 2025
*/
USE journey_to_space;

SELECT * FROM space_missions;

SELECT * FROM space_missions
WHERE Rocket like '%cosmos-3m%'
ORDER BY MissionStatus;


SELECT COUNT(MissionStatus) 
FROM space_missions
WHERE Rocket like '%cosmos-3m%'
ORDER BY MissionStatus;

/* 
From Maven Analytics - Return to Space Challenge Oct 2025
The Ultimate Rocket Ranking: Which rocket (by name, cost, or size) is the true champion of space?

The Golden Era of Space: Which decade or time period had the highest success rate, the most launches, or the most bang-for-its-buck in terms of space exploration?

The Winning Team: Which country or organization has quietly dominated the space race over the long term, and what does their winning strategy look like?

About the Data Set
All space missions from 1957 to August 2022, including details on the location, date, and result of the launch, the company responsible, and the name, price, and status of the rocket used for the mission.

*/

-- Most Successful Rocket by Launch Count
WITH 
cte_success AS (
    SELECT Rocket, COUNT(*) AS Successful
    FROM space_missions
    WHERE MissionStatus = 'Success'
    GROUP BY Rocket
),
cte_failure AS (
    SELECT Rocket, COUNT(*) AS Failed
    FROM space_missions
    WHERE MissionStatus = 'Failure'
    GROUP BY Rocket
),
cte_partial AS (
    SELECT Rocket, COUNT(*) AS PartialFailure
    FROM space_missions
    WHERE MissionStatus = 'Partial Failure'
    GROUP BY Rocket
),
all_rockets AS (
    SELECT Rocket FROM space_missions GROUP BY Rocket
)
SELECT 
    r.Rocket,
    COALESCE(s.Successful, 0) AS Successful,
    COALESCE(f.Failed, 0) AS Failed,
    COALESCE(p.PartialFailure, 0) AS PartialFailure
FROM all_rockets AS r
LEFT JOIN cte_success s ON r.Rocket = s.Rocket
LEFT JOIN cte_failure f ON r.Rocket = f.Rocket
LEFT JOIN cte_partial p ON r.Rocket = p.Rocket;


-- Count of Missions
SELECT *
FROM space_missions

SELECT 
        date,
        company,
        count(*) AS TotalMissions,
            COUNT(CASE WHEN MissionStatus = 'Success' THEN 1 END) AS SuccessfulMissions,
            COUNT(CASE WHEN MissionStatus = 'Failure' THEN 1 END) AS FailedMissions,
            COUNT(CASE WHEN MissionStatus = 'Partial Failure' THEN 1 END) AS PartialFailures 
FROM space_missions
GROUP BY Company, date;


-- Success Rate by Decade
SELECT     
        FLOOR(YEAR(date) / 10) * 10 AS Decade,
        COUNT(*) AS TotalMissions,
        COUNT(CASE WHEN MissionStatus = 'Success' THEN 1 END) AS SuccessfulMissions,
        ROUND(
            (COUNT(CASE WHEN MissionStatus = 'Success' THEN 1 END) * 100.0) / COUNT(*), 2
        ) AS SuccessRatePercentage
FROM space_missions
GROUP BY FLOOR(YEAR(date) / 10) * 10
ORDER BY FLOOR(YEAR(date) / 10) * 10;