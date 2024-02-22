Q1

SELECT ProductID ,Name,Color,ListPrice,Size
FROM Production.Product
WHERE   NOT EXISTS (SELECT ProductID
					FROM  Sales.SalesOrderDetail   
					WHERE productid=Production.Product.productid
					)
ORDER BY ProductID

--UPDATE BEFORE EX 2--
UPDATE sales.customer SET personid=customerid
WHERE customerid <=290
UPDATE sales.customer SET personid=customerid+1700
WHERE customerid >= 300 AND customerid<=350
UPDATE sales.customer SET personid=customerid+1700
WHERE customerid >= 352 AND customerid<=701



Q2

SELECT  SC.CustomerID,
	CASE WHEN pp.FirstName <> ' ' THEN  pp.LastName
		ELSE 'UNKNOWN' END AS LASTNAME ,
	CASE WHEN pp.FirstName <> ' ' THEN  pp.FirstName
		ELSE 'UNKNOWN' END AS FIRSTNAME
	
FROM	Sales.Customer SC LEFT JOIN Person.Person pp
		ON	SC.PersonID=pp.BusinessEntityID
	

WHERE  NOT  EXISTS (SELECT CustomerID
					from Sales.SalesOrderHeader SSO
					WHERE SC.CustomerID=SSO.CustomerID
				   )
ORDER BY sc.CustomerID




Q3

SELECT CustomerID,FirstName,LastName,[SUMOFORDERS] 
FROM(
	SELECT SC.CustomerID,PP.FirstName,PP.LastName,
	COUNT(SC.CustomerID) SUMOFORDERS,
	ROW_NUMBER()OVER(ORDER BY COUNT(SC.CustomerID) DESC) RNK
	FROM
	Sales.Customer SC JOIN Person.Person PP
	ON SC.PersonID=PP.BusinessEntityID
	JOIN Sales.SalesOrderHeader SSO
	ON SSO.CustomerID=SC.CustomerID
	GROUP BY SC.CustomerID,PP.FirstName,PP.LastName)A
	WHERE RNK<=10



Q4

SELECT pp.FirstName,pp.LastName,he.JobTitle,he.HireDate,ABC.CountOfTitle
	FROM 		
		Person.Person PP JOIN HumanResources.Employee HE
		ON pp.BusinessEntityID=he.BusinessEntityID
		JOIN 
		(	SELECT JobTitle,COUNT(*) CountOfTitle 
			FROM HumanResources.Employee
			GROUP BY JobTitle
		) ABC ON ABC.JobTitle=HE.JobTitle 
ORDER BY HE.JobTitle,HE.HireDate




Q5

WITH RankedOrders AS (
    SELECT
        so.SalesOrderID,
        c.CustomerID,
        p.LastName,
        p.FirstName,
        so.OrderDate,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY so.OrderDate DESC) AS RowNum
    FROM
        Sales.SalesOrderHeader so
        JOIN Sales.Customer c ON so.CustomerID = c.CustomerID
        JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
)

SELECT
    r1.SalesOrderID,
    r1.CustomerID,
    r1.LastName,
    r1.FirstName,
    r1.OrderDate AS [Last Order Date],
    r2.OrderDate AS [Previous Order Date]
FROM
    RankedOrders r1
    LEFT JOIN RankedOrders r2 ON r1.CustomerID = r2.CustomerID AND r2.RowNum = 2
WHERE
    r1.RowNum = 1
ORDER BY
    r1.CustomerID;



Q6

WITH ctetotal AS (
					SELECT YEAR(orderdate) as [year],CustomerID,
					MAX(SubTotal) OVER (PARTITION BY YEAR(orderdate)) Total
					FROM Sales.SalesOrderHeader
				  )

SELECT ctetotal.year,SOH.SalesOrderID,pp.LastName,pp.FirstName,FORMAT(MAX(ctetotal.Total),'N', 'en-us') as Total
FROM Sales.SalesOrderHeader SOH JOIN ctetotal 
	ON SOH.CustomerID=ctetotal.CustomerID
	AND YEAR(SOH.OrderDate)=ctetotal.year
	JOIN Sales.Customer SC
	ON sc.CustomerID=SOH.CustomerID
	JOIN Person.Person PP
	ON sc.PersonID=pp.BusinessEntityID
	WHERE SOH.SubTotal=ctetotal.Total

GROUP BY  ctetotal.year,SOH.SalesOrderID,pp.LastName,pp.FirstName



Q7

SELECT	MONTH,	ISNULL([2011],0) as [2011],
				ISNULL([2012],0) as [2012],
				ISNULL([2013],0) as [2013],
				ISNULL([2014],0) as [2014]
FROM (	SELECT YEAR(OrderDate) as y, MONTH(OrderDate) as [MONTH],COUNT(SalesOrderID) CNT
		FROM Sales.SalesOrderHeader
		GROUP BY YEAR(OrderDate) , MONTH(OrderDate) 
		) A
PIVOT(SUM(A.CNT) FOR Y IN ([2011],[2012],[2013],[2014])) PIV
ORDER BY [MONTH]



Q9

SELECT DepartmentName,"Employee'sId",
	   "Employee'sFullName",HireDate,Seniority,
	   PriviuseEmpName,PriviuseEmpHDate,
	   DATEDIFF(DAY,PriviuseEmpHDate,HireDate) AS DiffDays
FROM
(
	  SELECT DepartmentName,"Employee'sId",
			"Employee'sFullName",HireDate,Seniority,
			LAG("Employee'sFullName",1)OVER(PARTITION BY DepartmentName 
					ORDER BY HireDate) AS PriviuseEmpName,
			LAG(HireDate,1)OVER(PARTITION BY DepartmentName 
					ORDER BY HireDate) AS PriviuseEmpHDate
	FROM
	   (
		SELECT HD.Name AS DepartmentName,
				PP.BusinessEntityID AS "Employee'sId",
				PP.FirstName+' '+PP.LastName AS "Employee'sFullName",
				HRE.HireDate,
				DATEDIFF(MONTH,HRE.HireDate,GETDATE())AS Seniority
		FROM HumanResources.Employee AS HRE
				JOIN Person.Person AS PP
				ON HRE.BusinessEntityID=PP.BusinessEntityID
				JOIN HumanResources.EmployeeDepartmentHistory AS HRED
				ON HRE.BusinessEntityID=HRED.BusinessEntityID
				JOIN HumanResources.Department AS HD
				ON HRED.DepartmentID=HD.DepartmentID
		)AB
)ABC
ORDER BY DepartmentName,HireDate DESC







Q10

WITH EmployeeCTE AS (
    SELECT 
        e.HireDate,
        edh.DepartmentID,
        e.BusinessEntityID AS EmployeeID,
        CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName
    FROM 
        HumanResources.Employee e
        INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
        INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
)
, TeamCTE AS (
    SELECT 
        HireDate,
        DepartmentID,
        STRING_AGG(CONCAT(EmployeeID, ':', EmployeeName), ', ') AS TeamEmployees
    FROM 
        EmployeeCTE
    GROUP BY 
        HireDate, DepartmentID
)
SELECT 
    HireDate,
    DepartmentID,
    TeamEmployees
FROM 
    TeamCTE
ORDER BY 
    HireDate DESC;
