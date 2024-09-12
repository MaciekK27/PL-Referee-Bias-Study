-- Create a table to store Premier League match data
CREATE TABLE premier_league_matches (
    MatchID TEXT PRIMARY KEY, -- Unique identifier for each match
    Season TEXT, -- Season of the match (e.g., 2018/2019)
    MatchWeek INTEGER, -- The week of the match in the season
    MatchDate DATE, -- Date of the match
    MatchTime TIME, -- Time of the match
    HomeTeam TEXT, -- Name of the home team
    AwayTeam TEXT, -- Name of the away team
    FullTimeHomeGoals INTEGER, -- Full-time goals scored by home team
    FullTimeAwayGoals INTEGER, -- Full-time goals scored by away team
    FullTimeResult CHAR(1), -- Result of the match ('H' for home win, 'A' for away win, 'D' for draw)
    HalfTimeHomeGoals INTEGER, -- Half-time goals scored by home team
    HalfTimeAwayGoals INTEGER, -- Half-time goals scored by away team
    HalfTimeResult CHAR(1), -- Half-time result of the match
    Referee TEXT, -- Name of the referee
    HomeTeamShots INTEGER, -- Number of shots by home team
    AwayTeamShots INTEGER, -- Number of shots by away team
    HomeTeamShotsOnTarget INTEGER, -- Shots on target by home team
    AwayTeamShotsOnTarget INTEGER, -- Shots on target by away team
    HomeTeamCorners INTEGER, -- Number of corners by home team
    AwayTeamCorners INTEGER, -- Number of corners by away team
    HomeTeamFouls INTEGER, -- Fouls committed by home team
    AwayTeamFouls INTEGER, -- Fouls committed by away team
    HomeTeamYellowCards INTEGER, -- Yellow cards issued to home team
    AwayTeamYellowCards INTEGER, -- Yellow cards issued to away team
    HomeTeamRedCards INTEGER, -- Red cards issued to home team
    AwayTeamRedCards INTEGER, -- Red cards issued to away team
    B365HomeTeam NUMERIC, -- Betting odds for home team win
    B365Draw NUMERIC, -- Betting odds for draw
    B365AwayTeam NUMERIC, -- Betting odds for away team win
    B365Over2_5Goals NUMERIC, -- Betting odds for over 2.5 goals
    B365Under2_5Goals NUMERIC, -- Betting odds for under 2.5 goals
    MarketMaxHomeTeam NUMERIC, -- Maximum market odds for home team win
    MarketMaxDraw NUMERIC, -- Maximum market odds for draw
    MarketMaxAwayTeam NUMERIC, -- Maximum market odds for away team win
    MarketAvgHomeTeam NUMERIC, -- Average market odds for home team win
    MarketAvgDraw NUMERIC, -- Average market odds for draw
    MarketAvgAwayTeam NUMERIC, -- Average market odds for away team win
    MarketMaxOver2_5Goals NUMERIC, -- Maximum market odds for over 2.5 goals
    MarketMaxUnder2_5Goals NUMERIC, -- Maximum market odds for under 2.5 goals
    MarketAvgOver2_5Goals NUMERIC, -- Average market odds for over 2.5 goals
    MarketAvgUnder2_5Goals NUMERIC, -- Average market odds for under 2.5 goals
    HomeTeamPoints INTEGER, -- Points earned by home team
    AwayTeamPoints INTEGER -- Points earned by away team
);
-- Select overall average percentage of home team yellow and red cards per foul,
-- relative to total yellow and red cards per foul for both home and away teams.



SELECT
    -- Calculate the average percentage of yellow cards given to the home team, per foul committed.
    -- The formula calculates the yellow cards per foul for home teams, then divides it by the
    -- total yellow cards per foul for both home and away teams.
    ROUND(
        -- Calculate the average yellow cards per foul for the home team
        CAST(AVG(HomeTeamYellowCards) AS NUMERIC) / AVG(HomeTeamFouls) /
        (
            -- Calculate the total yellow cards per foul for both away and home teams
            CAST(AVG(AwayTeamYellowCards) AS NUMERIC) / AVG(AwayTeamFouls) +
            CAST(AVG(HomeTeamYellowCards) AS NUMERIC) / AVG(HomeTeamFouls)
        ) * 100, 2  -- Multiply by 100 to convert the result into a percentage and round to 2 decimal places
    ) AS avg_percent_of_home_yc,  -- Alias for the average percentage of yellow cards given to home teams
    -- Calculate the total sample size for yellow cards (sum of home and away yellow cards)
	SUM(HomeTeamYellowCards) + SUM(AwayTeamYellowCards) AS yc_sample_size,
    -- Calculate the average percentage of red cards given to the home team, per foul committed.
    -- This formula follows the same logic as the yellow card calculation above.
    ROUND(
        -- Calculate the average red cards per foul for the home team
        CAST(AVG(HomeTeamRedCards) AS NUMERIC) / AVG(HomeTeamFouls) /
        (
            -- Calculate the total red cards per foul for both away and home teams
            CAST(AVG(AwayTeamRedCards) AS NUMERIC) / AVG(AwayTeamFouls) +
            CAST(AVG(HomeTeamRedCards) AS NUMERIC) / AVG(HomeTeamFouls)
        ) * 100, 2  -- Multiply by 100 to convert the result into a percentage and round to 2 decimal places
    ) AS avg_percent_of_home_rc,  -- Alias for the average percentage of red cards given to home teams
    -- Calculate the total sample size for red cards (sum of home and away red cards)
    SUM(HomeTeamRedCards) + SUM(AwayTeamRedCards) AS rc_sample_size
-- From the Premier League matches table
FROM premier_league_matches;



-- Analysis by season, calculating yellow/red cards percentage per season
SELECT 
    season,
	ROUND(CAST(AVG(HomeTeamYellowCards) AS NUMERIC) /
	NULLIF(
	(AVG(HomeTeamYellowCards) + AVG(AwayTeamYellowCards)),
	0)
	* 100, 2) AS hometeam_yc_per_all_yc, -- Percentage of yellow cards for home teams
	SUM(HomeTeamYellowCards) + SUM(AwayTeamYellowCards) AS yc_sample_size, -- Total number of yellow cards
	ROUND(CAST(AVG(HomeTeamRedCards) AS NUMERIC) /
	NULLIF(
	(AVG(HomeTeamRedCards) + AVG(AwayTeamRedCards)),
	0)
	* 100, 2) AS hometeam_rc_per_all_rc, -- Percentage of red cards for home teams
	SUM(HomeTeamRedCards) + SUM(AwayTeamRedCards) AS rc_sample_size -- Total number of red cards
FROM premier_league_matches
WHERE HomeTeamFouls IS NOT NULL AND HomeTeamYellowCards IS NOT NULL
GROUP BY season
ORDER BY season DESC; -- Sort by season (most recent first)
