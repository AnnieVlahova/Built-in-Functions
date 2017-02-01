---1---
SELECT FirstName, LastName FROM Employees WHERE FirstName LIKE 'SA%'
---2---
SELECT FirstName, LastName FROM Employees WHERE LastName LIKE '%ei%'
---3---
SELECT FirstName FROM Employees  WHERE DepartmentID = 3 OR DepartmentID = 10
AND YEAR([HireDate]) BETWEEN 1995 AND 2005
---4---
SELECT FirstName, LastName FROM Employees  WHERE JobTitle NOT LIKE '%engineer%'
---5---
SELECT Name FROM Towns  WHERE DATALENGTH(Name) IN (5,6) ORDER BY Name
---6---
SELECT * FROM Towns  WHERE LEFT(Name, 1) IN ('M', 'B', 'K', 'E') ORDER BY Name
---7---
SELECT * FROM Towns  WHERE LEFT(Name, 1) NOT IN ('R', 'B', 'D') ORDER BY Name
---8---
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees WHERE YEAR([HireDate]) > 2000
---9---
SELECT FirstName, LastName FROM Employees WHERE DATALENGTH(LastName) = 5
---10---
SELECT CountryName, IsoCode FROM Countries WHERE Lower(CountryName) Like Lower('%a%a%a%') ORDER BY IsoCode
---11---
SELECT p.PeakName, r.RiverName,
lower(p.PeakName + SUBSTRING(r.RiverName, 2, len(r.RiverName) - 1)) AS Mix
FROM Peaks p
JOIN Rivers r
ON RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY Mix
---12---
SELECT TOP 50 Name, convert(varchar(10),Start,120) FROM Games WHERE YEAR(Start) = 2011 OR YEAR(Start) = 2012 ORDER BY Start, Name
---13---
select Username, SUBSTRING(Email, CHARINDEX('@', Email)+1, LEN(Email)) AS EmailProvider FROM Users ORDER BY EmailProvider, Username
---14---
SELECT Username, IpAddress FROM Users WHERE IpAddress LIKE '___.1_%._%.___' ORDER BY Username
---15---
SELECT Name AS Game,
CASE 
WHEN DATEPART(HOUR, Start) BETWEEN 0 AND 11 THEN 'Morning'
WHEN DATEPART(HOUR, Start) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN DATEPART(HOUR, Start) BETWEEN 18 AND 23 THEN 'Evening'
END AS PartofDay,
CASE 
WHEN Duration <= 3 THEN 'Extra Short'
WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
WHEN Duration > 6 THEN 'Long'
WHEN Duration IS NULL THEN 'Extra Long'
END AS Duration
FROM Games ORDER BY Name, Duration, PartofDay
---16---
SELECT ProductName, OrderDate,
DATEADD(DAY, 3 , OrderDate) AS PayDue,
DATEADD(MONTH, 1, OrderDate) AS DeliverDue
FROM Orders