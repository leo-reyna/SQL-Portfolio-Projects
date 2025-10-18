-- Active: 1745290413437@@127.0.0.1@3306@journey_to_space

SELECT * FROM space_missions;

/* 
From Maven Analytics - Return to Space Challenge Oct 2025
The Ultimate Rocket Ranking: Which rocket (by name, cost, or size) is the true champion of space?

The Golden Era of Space: Which decade or time period had the highest success rate, the most launches, or the most bang-for-its-buck in terms of space exploration?

The Winning Team: Which country or organization has quietly dominated the space race over the long term, and what does their winning strategy look like?

About the Data Set
All space missions from 1957 to August 2022, including details on the location, date, and result of the launch, the company responsible, and the name, price, and status of the rocket used for the mission.

*/

-- Most Successful Rocket by Launch Count
WITH cte1 AS (SELECT Rocket, COUNT(*) AS TotalLaunches
                FROM space_missions
                WHERE MissionStatus = 'Success'
                GROUP BY Rocket
                ORDER BY TotalLaunches DESC),

    cte2 as (SELECT Rocket, COUNT(*) AS TotalLaunches
                FROM space_missions
                WHERE MissionStatus = 'Failure'
                GROUP BY Rocket
                ORDER BY TotalLaunches DESC),

    cte3 as (SELECT Rocket, COUNT(*) AS TotalLaunches
                FROM space_missions
                WHERE MissionStatus = 'Partial Failure'
                GROUP BY Rocket
                ORDER BY TotalLaunches DESC)
SELECT 
    cte1.Rocket,
    cte1.TotalLaunches as "Successful",
    COALESCE(cte2.TotalLaunches, 0) as "Failed",
    COALESCE(cte3.TotalLaunches,0)  as "Partial Failure"
FROM cte1
LEFT JOIN cte2
    ON cte1.rocket = cte2.rocket
LEFT JOIN cte3
    ON cte2.rocket = cte3.rocket;
