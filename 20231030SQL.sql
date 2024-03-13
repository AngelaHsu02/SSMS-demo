--DB中有幾張資料表
SELECT *
FROM AdventureWorks2022.INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

--常用指令
--ex1 
--[HumanResources].[Employee]
SELECT JobTitle
FROM HumanResources.Employee

--ex2
SELECT DISTINCT JobTitle
FROM HumanResources.Employee

--ex3
SELECT BusinessEntityID, JobTitle, Gender, HireDate
FROM HumanResources.Employee
WHERE JobTitle='Design Engineer' AND Gender='F'

--ex4
SELECT BusinessEntityID, Gender, HireDate, JobTitle
FROM HumanResources.Employee 
WHERE Gender='F' 
ORDER BY HireDate
--ORDER BY HireDate DESC

--ex5
SELECT *
FROM HumanResources.Employee
WHERE JobTitle LIKE 'Marketing%'

--ex6
SELECT *
FROM HumanResources.Employee
WHERE JobTitle NOT LIKE 'Marketing%'

--算術運算子
--ex7
SELECT BusinessEntityID, VacationHours
FROM HumanResources.Employee
--WHERE VacationHours BETWEEN 40 AND 45
WHERE VacationHours >= 40 AND VacationHours <= 45

--ex8
SELECT BusinessEntityID,VacationHours
FROM HumanResources.Employee
WHERE VacationHours >= 40 AND VacationHours <= 45
ORDER BY VacationHours DESC

--資料表合併
--ex9
--[HumanResources].[Employee]
--[HumanResources].[EmployeeDepartmentHistory]
SELECT HumanResources.Employee.BusinessEntityID, Gender, JobTitle, DepartmentID
FROM HumanResources.Employee , HumanResources.EmployeeDepartmentHistory
WHERE HumanResources.Employee.BusinessEntityID = HumanResources.EmployeeDepartmentHistory.BusinessEntityID

--Table簡寫
SELECT e.BusinessEntityID, Gender, JobTitle, DepartmentID
FROM HumanResources.Employee as e , HumanResources.EmployeeDepartmentHistory as edh
WHERE e.BusinessEntityID = edh.BusinessEntityID

--交集 JOIN
SELECT e.BusinessEntityID, Gender, JobTitle, DepartmentID
FROM HumanResources.Employee as e FULL JOIN HumanResources.EmployeeDepartmentHistory as edh
ON e.BusinessEntityID = edh.BusinessEntityID

--ex10
--HumanResources.Department
--HumanResources.EmployeeDepartmentHistory
SELECT BusinessEntityID, Department.DepartmentID, Name, GroupName --模稜兩可的資料行名稱 'DepartmentID'。
FROM HumanResources.Department, HumanResources.EmployeeDepartmentHistory
WHERE HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID

--Table簡寫
SELECT BusinessEntityID, dp.DepartmentID, Name, GroupName
FROM HumanResources.Department as dp, HumanResources.EmployeeDepartmentHistory as edh
WHERE dp.DepartmentID = edh.DepartmentID

--也可以不用as
SELECT BusinessEntityID, dp.DepartmentID, Name, GroupName
FROM HumanResources.Department  dp, HumanResources.EmployeeDepartmentHistory  edh
WHERE dp.DepartmentID = edh.DepartmentID

--交集 JOIN
SELECT BusinessEntityID, dp.DepartmentID, Name, GroupName
FROM HumanResources.Department dp JOIN HumanResources.EmployeeDepartmentHistory edh
ON dp.DepartmentID = edh.DepartmentID

--JOIN左右順序相反會得到同樣的結果
SELECT BusinessEntityID, dp.DepartmentID, Name, GroupName 
FROM HumanResources.EmployeeDepartmentHistory edh JOIN HumanResources.Department dp 
ON dp.DepartmentID = edh.DepartmentID

--ex11
--[Person].[Person]
--[HumanResources].[Employee]
--LEFT JOIN 
SELECT p.BusinessEntityID, p.FirstName, p.LastName, e.Gender, e.BirthDate, e.HireDate, e.JobTitle 
FROM Person.Person p LEFT JOIN HumanResources.Employee e 
ON p.BusinessEntityID = e.BusinessEntityID
--FULL JOIN 
SELECT p.BusinessEntityID, p.FirstName, p.LastName, e.Gender, e.BirthDate, e.HireDate, e.JobTitle 
FROM Person.Person p FULL JOIN HumanResources.Employee e 
ON p.BusinessEntityID = e.BusinessEntityID

--FOR REFERENCE--INNER JOIN
SELECT p.BusinessEntityID, p.FirstName, p.LastName, e.Gender, e.BirthDate, e.HireDate, e.JobTitle 
FROM Person.Person p JOIN HumanResources.Employee e 
ON p.BusinessEntityID = e.BusinessEntityID
--FOR REFERENCE----RIGHT JOIN
SELECT p.BusinessEntityID, p.FirstName, p.LastName, e.Gender, e.BirthDate, e.HireDate, e.JobTitle 
FROM Person.Person p RIGHT JOIN HumanResources.Employee e 
ON p.BusinessEntityID = e.BusinessEntityID

--ex12
--Use 1 statement
SELECT Person.Person.BusinessEntityID
FROM HumanResources.Employee FULL JOIN Person.Person
ON HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID

--Use 2 Statements_Union
SELECT BusinessEntityID
FROM HumanResources.Employee
UNION 
SELECT BusinessEntityID
FROM Person.Person

--Union All
SELECT BusinessEntityID
FROM HumanResources.Employee
UNION ALL
SELECT BusinessEntityID
FROM Person.Person;

--員工BusinessEntityID重複
WITH temp AS(
SELECT BusinessEntityID
FROM HumanResources.Employee
UNION ALL
SELECT BusinessEntityID
FROM Person.Person
) 
SELECT BusinessEntityID, COUNT(BusinessEntityID) AS Counts
FROM temp
GROUP BY BusinessEntityID 
HAVING COUNT(BusinessEntityID) > 1  --The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.

--ex13
--Use 1 statement
SELECT BusinessEntityID, Gender, SickLeaveHours
FROM HumanResources.Employee
WHERE Gender='M' OR SickLeaveHours>30
ORDER BY SickLeaveHours

--Use 2 statements_Union
SELECT BusinessEntityID, Gender, SickLeaveHours
FROM HumanResources.Employee
WHERE Gender='M'
UNION
SELECT BusinessEntityID, Gender, SickLeaveHours
FROM HumanResources.Employee
WHERE SickLeaveHours>30
ORDER BY SickLeaveHours

--Aggregate
--ex14 
SELECT COUNT(JobTitle) JobTitleNumbers, AVG(VacationHours) AvgVacationHours, MIN(VacationHours) MinVacationHours, MAX(VacationHours) MaxVacationHours
FROM HumanResources.Employee

--先DISTINCT再計數、中文欄位名稱
SELECT COUNT(DISTINCT JobTitle) 職位種類數, COUNT(BusinessEntityID) 員工總數
FROM HumanResources.Employee

--Grouping + Aggregate
--ex15
SELECT JobTitle, COUNT(BusinessEntityID) TotalNumber
FROM HumanResources.Employee
GROUP BY JobTitle

--ex16
--[HumanResources].[Department]
--[HumanResources].[EmployeeDepartmentHistory]
SELECT  dp.Name, dp.GroupName, COUNT(edp.BusinessEntityID) TotalNumber
FROM HumanResources.Department dp JOIN　HumanResources.EmployeeDepartmentHistory edp
ON dp.DepartmentID = edp.DepartmentID
GROUP BY dp.Name, dp.GroupName 

--ex17
SELECT BusinessEntityID, Rate
FROM HumanResources.EmployeePayHistory
WHERE Rate >　
　(SELECT AVG(Rate)
　FROM HumanResources.EmployeePayHistory)

--資料表合併
--ex18
--[HumanResources].[EmployeeDepartmentHistory]
--[HumanResources].[Department]

SELECT e.BusinessEntityID, e.Jobtitle, e.Gender, cb.DepartmentID, cb.Name
FROM HumanResources.Employee as e, (
	SELECT edh.BusinessEntityID, dp.DepartmentID, dp.Name
	FROM HumanResources.Department dp, HumanResources.EmployeeDepartmentHistory edh
	WHERE dp.DepartmentID = edh.DepartmentID
) AS cb
WHERE e.BusinessEntityID = cb.BusinessEntityID

-- WITH寫法
WITH cb AS(
	SELECT edh.BusinessEntityID, dp.DepartmentID, dp.Name
	FROM HumanResources.Department dp, HumanResources.EmployeeDepartmentHistory edh
	WHERE dp.DepartmentID = edh.DepartmentID
)
SELECT e.BusinessEntityID, e.Jobtitle, e.Gender, cb.DepartmentID, cb.Name
FROM HumanResources.Employee AS e, cb
WHERE e.BusinessEntityID = cb.BusinessEntityID


--練習(1)
SELECT e.BusinessEntityID, FirstName, Gender, BirthDate,
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM HumanResources.Employee AS e 
LEFT JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
WHERE FirstName LIKE 'A%'


--練習(2)
WITH A AS(
SELECT BusinessEntityID, d.DepartmentID, Name
FROM HumanResources.EmployeeDepartmentHistory AS edh, HumanResources.Department AS d
WHERE edh.DepartmentID = d.DepartmentID
)
SELECT e.BusinessEntityID, Gender, BirthDate, JobTitle, A.Name,
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age,
       DATEDIFF(YEAR, HireDate, '2018-01-01') AS WorkExperience
FROM HumanResources.Employee AS e INNER JOIN A
ON e.BusinessEntityID = A.BusinessEntityID
WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) >= 32 AND Gender='F'
ORDER BY WorkExperience DESC

--練習(3)
WITH ledh AS(
SELECT edh.BusinessEntityID, edh.DepartmentID, d.Name, edh.ModifiedDate, 
ROW_NUMBER() OVER (PARTITION BY edh.BusinessEntityID ORDER BY edh.ModifiedDate DESC) AS rn
FROM HumanResources.EmployeeDepartmentHistory AS edh
FULL JOIN HumanResources.Department AS d
ON edh.DepartmentID = d.DepartmentID
),
A AS(
SELECT ledh.BusinessEntityID, Gender, Name, ledh.ModifiedDate, rn
FROM ledh FULL JOIN HumanResources.Employee AS e
ON ledh.BusinessEntityID = e.BusinessEntityID
WHERE rn = 1 AND Name LIKE 'Marketing'
)
SELECT Gender, Count(BusinessEntityID) TotalNumbers
FROM A
GROUP BY Gender;

--練習(4)
WITH lr AS(
SELECT e.BusinessEntityID, eph.Rate, eph.ModifiedDate ephModifiedDate,
ROW_NUMBER() OVER (PARTITION BY e.BusinessEntityID ORDER BY eph.ModifiedDate DESC) AS latestp
FROM HumanResources.EmployeePayHistory AS eph
JOIN HumanResources.Employee AS e
ON eph.BusinessEntityID = e.BusinessEntityID
),
A AS(
SELECT lr.BusinessEntityID, Rate, DepartmentID, edh.ModifiedDate edhModifiedDate,
ROW_NUMBER() OVER (PARTITION BY lr.BusinessEntityID ORDER BY edh.ModifiedDate DESC) AS latestd
FROM lr JOIN HumanResources.EmployeeDepartmentHistory AS edh
ON lr.BusinessEntityID = edh.BusinessEntityID
WHERE latestp = 1
),
B AS(
SELECT A.BusinessEntityID, A.Rate, A.DepartmentID, d.Name, A.latestd
FROM A JOIN HumanResources.Department AS d
ON A.DepartmentID = d.DepartmentID
WHERE latestd = 1
),
C AS( 
SELECT B.BusinessEntityID, B.Rate, B.DepartmentID, B.Name, FirstName, LastName
FROM B JOIN Person.Person AS p
ON B.BusinessEntityID = p.BusinessEntityID
),
D AS(
SELECT DISTINCT C.BusinessEntityID,  C.Name, C.FirstName, C.LastName, C.DepartmentID, C.Rate, 
DENSE_RANK() OVER (PARTITION BY C.DepartmentID ORDER BY C.Rate) AS lowestrate
FROM C
)
SELECT BusinessEntityID,  Name, FirstName, LastName, DepartmentID, Rate
FROM D
WHERE lowestrate = 1
ORDER BY D.DepartmentID

--練習(5)
WITH LatestPayHistory AS(
SELECT eph.BusinessEntityID, e.JobTitle, e.VacationHours, eph.Rate, eph.ModifiedDate,
ROW_NUMBER() OVER (PARTITION BY eph.BusinessEntityID ORDER BY eph.ModifiedDate DESC) AS rn
FROM HumanResources.Employee e
FULL JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
)
SELECT JobTitle, COUNT(BusinessEntityID) TotalNumber, AVG(VacationHours) AvgVacationHours, AVG(Rate) AvgRate
FROM LatestPayHistory
WHERE rn = 1
GROUP BY JobTitle
ORDER BY AVG(Rate) DESC, AVG(VacationHours) DESC

