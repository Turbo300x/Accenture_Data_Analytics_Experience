--------------------------------------- Welcome!!! ------------------------------------------------------------------------------------

USE Accenture;

----------------------------------------------------- DATA CLEANING --------------------------------------------------------------------
----------------------------- I will start by cleaning Reactions table -----------------------------------------------------------------
SELECT *
FROM Reactions

-------- Split Datetime column into seperate columns for the Date and Time

-------------- Starting with creating a Date column
SELECT Datetime
FROM Reactions

SELECT Datetime, CONVERT(DATE, Datetime) AS Date
FROM Reactions

ALTER TABLE Reactions
ADD Date DATE

UPDATE Reactions
SET Date = CONVERT(DATE, Datetime)
		   FROM Reactions


------------------------ Second i'll be creating a Time column
SELECT Datetime
FROM Reactions

SELECT Datetime, CONVERT(TIME, Datetime) AS Time
FROM Reactions

ALTER TABLE Reactions
ADD Time TIME

UPDATE Reactions
SET Time = CONVERT(Time, Datetime)
		   FROM Reactions


--------------------- Remove Datetime column
ALTER TABLE Reactions
DROP COLUMN Datetime

SELECT *
FROM Reactions
ORDER BY [Row Index] ASC


----------------------------------- Now i will clean up the Content Table -------------------------------------------------------------

SELECT *
FROM Content
ORDER BY [Row Index]

-- First i will get rid of the URL column
ALTER TABLE Content
DROP COLUMN URL


-- Clean the Category Column
-- Change "culture" to culture
SELECT *
FROM Content
WHERE Category LIKE '"culture"'

UPDATE Content
SET Category = 'culture'
WHERE Category = '"culture"'

-- Change "animals" to animals
SELECT *
FROM Content
WHERE Category LIKE '"animals"'

UPDATE Content
SET Category = 'animals'
WHERE Category = '"animals"'

-- Change "studying" to studying
SELECT *
FROM Content
WHERE Category LIKE '"studying"'

UPDATE Content
SET Category = 'studying'
WHERE Category = '"studying"'

-- Change "soccer" to soccer
SELECT *
FROM Content
WHERE Category LIKE '"soccer"'

UPDATE Content
SET Category = 'soccer'
WHERE Category = '"soccer"'

-- Change "dogs" to dogs
SELECT *
FROM Content
WHERE Category LIKE '"dogs"'

UPDATE Content
SET Category = 'dogs'
WHERE Category = '"dogs"'

-- Change "tennis" to tennis
SELECT *
FROM Content
WHERE Category LIKE '"tennis"'

UPDATE Content
SET Category = 'tennis'
WHERE Category = '"tennis"'

-- Change "food" to food
SELECT *
FROM Content
WHERE Category LIKE '"food"'

UPDATE Content
SET Category = 'food'
WHERE Category = '"food"'

-- Change "technology" to technology
SELECT *
FROM Content
WHERE Category LIKE '"technology"'

UPDATE Content
SET Category = 'technology'
WHERE Category = '"technology"'

-- change "public speaking" to public speaking
SELECT *
FROM Content
WHERE Category LIKE '"public speaking"'

UPDATE Content
SET Category = 'public speaking'
WHERE Category = '"public speaking"'

-- Change "veganism" to veganism
SELECT *
FROM Content
WHERE Category LIKE '"veganism"'

UPDATE Content
SET Category = 'veganism'
WHERE Category = '"veganism"'

-- Change "science" to science
SELECT *
FROM Content
WHERE Category LIKE '"science"'

UPDATE Content
SET Category = 'science'
WHERE Category = '"science"'

-- Change "cooking" to cooking
SELECT *
FROM Content
WHERE Category LIKE '"cooking"'

UPDATE Content
SET Category = 'cooking'
WHERE Category = '"cooking"'


---------- Change the values in the Category column to lower case
SELECT Category, LOWER(Category)
FROM Content

UPDATE Content
SET Category = LOWER(Category)

SELECT *
FROM ReactionTypes
ORDER BY [Row Index]


----------- Create a VIEW Named Social_Buzz by joining the Content, Reactions, and ReactionTypes tables ---------------------------------
------------------------- The created VIEW will be exported as an excel file into Power BI ----------------------------------------------

GO
CREATE VIEW Social_Buzz AS 
SELECT
	r.[Row Index],
	r.[Content ID],
	c.[User ID],
	r.Type AS reaction_type,
	Date,
	c.Type AS content_type,
	Category,
	Sentiment,
	Score
FROM Reactions r
LEFT JOIN Content c
ON r.[Content ID] = c.[Content ID]
LEFT JOIN ReactionTypes rt
ON rt.Type = r.Type
GO

SELECT *
FROM Social_Buzz


----------------------------------------------------- DATA ANALYSIS & INSIGHTS -----------------------------------------------------------
------------------------------------------------ KPIs / Insights -------------------------------------------------------------------------

----------------- Get the distinct Count of the categories
SELECT COUNT(DISTINCT Category) AS Count_of_Category
FROM Social_Buzz


----------------- Get the distinct count of the content_type
SELECT COUNT(DISTINCT content_type) AS count_of_content_type
FROM Social_Buzz


----------------- Get the Month with the highest number of posts
SELECT TOP 1
	DATENAME(month, DATEADD(month, DATEPART(Month, Date), -1)) AS Month,
	COUNT(*) AS Posts
FROM Social_Buzz
GROUP BY DATEPART(Month, Date)
--ORDER BY DATEPART(Month, Date)
ORDER BY 2 DESC

----------------- Get the Category with the highest number of posts
SELECT TOP 1
	Category,
	COUNT(*) AS Posts
FROM Social_Buzz
GROUP BY Category
ORDER BY 2 DESC

----------------- Get the average score
--SELECT ROUND(AVG(Score),2) AS Average_score
--FROM Social_Buzz


------------------------------------------------ Analysis / Visuals -------------------------------------------------------------------------

---------------- Get top 5 categories by Score
SELECT TOP 5
	Category,
	SUM(Score) AS Total_Score
FROM Social_Buzz
GROUP BY Category
ORDER BY 2 DESC

---------------- Get popularity % share for top 5
WITH Top5 AS (
SELECT TOP 5 Category, SUM(Score) AS Scr
FROM Social_Buzz
GROUP BY Category
ORDER BY 2 DESC
)
SELECT 
	Category, 
	ROUND((Scr / (SELECT SUM(Scr) FROM Top5)),4) * 100 AS percentage_share
FROM Top5
GROUP BY Category, Scr
ORDER BY 2 DESC

--------------------- Get the number of posts per month
SELECT
	DATENAME(month, DATEADD(month, DATEPART(Month, Date), -1)) AS Month,
	COUNT(*) AS Posts
FROM Social_Buzz
GROUP BY DATEPART(Month, Date)
ORDER BY DATEPART(Month, Date)

------------------------- Get the total number of posts by category
SELECT
	Category,
	COUNT(*) AS Posts
FROM Social_Buzz
GROUP BY Category
ORDER BY 2 DESC

-------------------- Get the total number of posts by content_type
SELECT
	content_type,
	COUNT(*) AS Posts
FROM Social_Buzz
GROUP BY content_type
ORDER BY 2 DESC

-------------------- Get the total score by content_type
--SELECT
--	content_type,
--	SUM(Score) AS Posts
--FROM Social_Buzz
--GROUP BY content_type
--ORDER BY 2 DESC

-------------------- Get the total number of reactions by reaction_type
--SELECT
--	reaction_type,
--	COUNT(*) AS num_of_reactions
--FROM Social_Buzz
--WHERE reaction_type != 'NULL'
--GROUP BY reaction_type
--ORDER BY 2 DESC

--------------------------------------- Thank you for taking the time to look through my queries ----------------------------------------------