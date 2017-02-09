---1---
SELECT TOP 5 EmployeeID, JobTitle, e.AddressID, AddressText FROM Employees e JOIN Addresses AS a ON e.AddressID = a.AddressID ORDER BY AddressID
---2---
SELECT TOP 50 e.FirstName, e.LastName, t.Name AS Town, a.AddressText FROM Employees e 
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Towns t ON a.TownID = t.TownID 
ORDER BY FirstName, LastName
---3---
SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name FROM Employees e 
JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE d.Name = 'Sales'
ORDER BY EmployeeID ASC 
---4---
SELECT TOP 5 e.EmployeeID, e.FirstName, e.Salary, d.Name AS DepartmentName FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID WHERE e.Salary > 15000 ORDER BY e.DepartmentID
---5---
SELECT TOP 3 e.EmployeeID, e.FirstName FROM Employees e 
LEFT OUTER JOIN EmployeesProjects p ON e.EmployeeID = p.EmployeeID
WHERE p.ProjectID IS NULL 
ORDER BY e.EmployeeID ASC 
---6---
SELECT e.FirstName, e.LastName, e.HireDate, d.Name as DeptName FROM Employees e 
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > '1999-01-01' AND d.Name IN('Sales', 'Finance')
---7---
SELECT TOP 5 e.EmployeeID, e.FirstName, p.Name As ProjectName FROM Employees e 
JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID
---8---
SELECT e.EmployeeID, e.FirstName,
CASE 
WHEN p.StartDate > '2005-01-01' THEN NULL
ELSE p.Name
END As ProjectName FROM Employees e 
JOIN EmployeesProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24
---9---
SELECT e.EmployeeID, e.FirstName, e.ManagerID, e2.FirstName as ManagerName
FROM Employees e JOIN Employees e2 ON e.ManagerID = e2.EmployeeID
WHERE e.ManagerID IN(3, 7) ORDER BY e.EmployeeID
---10---
SELECT TOP 50 e.EmployeeID, e.FirstName + ' ' + e.LastName As EmployeeName,  e2.FirstName + ' '+e2.LastName as ManagerName, d.Name as DepartmentName
FROM Employees e JOIN Employees e2 ON e.ManagerID = e2.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID
---11---
SELECT MIN(a.Salary) AS MinAverageSalary FROM 
(SELECT AVG(e.Salary) As Salary FROM Employees e GROUP BY e.DepartmentID) a
---12---
SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation 
FROM MountainsCountries mc
JOIN Mountains m ON mc.MountainId = m.Id
JOIN Peaks p ON m.Id = p.MountainId
WHERE mc.CountryCode LIKE 'BG' AND p.Elevation > 2835 
ORDER BY p.Elevation DESC
---13---
SELECT mc.CountryCode, COUNT(m.MountainRange) AS MountainRanges 
FROM MountainsCountries mc
JOIN Mountains m ON mc.MountainId = m.Id
GROUP BY mc.CountryCode
HAVING mc.CountryCode IN ('BG', 'US', 'RU')
---14---
SELECT TOP 5 c.CountryName, r.RiverName FROM Countries c 
LEFT JOIN CountriesRivers cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers r ON cr.RiverId = r.Id
WHERE c.ContinentCode LIKE 'AF'
ORDER BY c.CountryName
---15---
SELECT usages.ContinentCode, usages.CurrencyCode, usages.Usage FROM
(SELECT ContinentCode, CurrencyCode, COUNT(*) AS Usage FROM Countries
	GROUP BY ContinentCode, CurrencyCode
	HAVING COUNT(*)>1) AS Usages
	INNER JOIN 
(
   SELECT Usages.ContinentCode, MAX(Usages.Usage) AS MaxUsage FROM
	(SELECT ContinentCode, CurrencyCode, COUNT(*) AS Usage FROM Countries
	GROUP BY ContinentCode, CurrencyCode) AS Usages
	GROUP BY Usages.ContinentCode
) AS MaxUsages ON Usages.ContinentCode = MaxUsages.ContinentCode
AND MaxUsages.MaxUsage = Usages.Usage
ORDER BY Usages.ContinentCode
---16---
SELECT(SELECT COUNT(CountryCode) AS CountryCode FROM Countries) -
(SELECT COUNT(c.CountryCode) FROM
(SELECT CountryCode FROM MountainsCountries GROUP BY CountryCode) AS c) AS CountryCode
---17---
SELECT TOP 5 c.CountryName, MAX(p.Elevation) AS HighestPeakElevation, MAX(r.Length) AS LongestRiverLenght FROM Countries c
LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks p ON mc.MountainId = p.MountainId
LEFT JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLenght DESC, c.CountryName
---18---
SELECT TOP 5 c.CountryName AS Country, 
ISNULL(p.PeakName, '(no highest peak)') as HighestPeakName, 
ISNULL(MAX(p.Elevation),0) AS HighestPeakElevation, 
ISNULL(m.MountainRange, '(no mountain)') AS Mountain 
FROM Countries c
LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks p ON mc.MountainId = p.MountainId
LEFT JOIN Mountains m ON p.MountainId = m.Id
GROUP BY c.CountryName, p.Elevation, p.PeakName, m.MountainRange
ORDER BY c.CountryName, HighestPeakName
