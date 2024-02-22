CREATE DATABASE Sales
USE Sales

-- Table_1_Person.Address

CREATE TABLE [Address (Person)]
(AddressID INT CONSTRAINT PADD_ADDID_PK PRIMARY KEY NOT NULL, 
AddressLine1 NVARCHAR (60) NOT NULL, 
AddressLine2 NVARCHAR (60), 
City NVARCHAR (30) NOT NULL,
StateProvinceID INT NOT NULL,
PostalCode NVARCHAR (15) NOT NULL,
rowgiud UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL)

-- Definition of Data Types
CREATE TYPE Name
FROM NVARCHAR(50)

-- Table_2_Purchasing.ShipMethod

CREATE TABLE [ShipMethod (Purchasing)]
(ShipMethodID INT CONSTRAINT PSHM_SHMID_PK PRIMARY KEY NOT NULL, 
Name NAME NOT NULL,
ShipBase MONEY NOT NULL,
ShipRate MONEY NOT NULL,
rowgiud UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL)

-- Table_3_Sales.CurrencyRate

CREATE TABLE [CurrencyRate (Sales)]
(CurrencyRatelID INT CONSTRAINT SCR_SCRID_PK PRIMARY KEY NOT NULL, 
CurrencyRatelDate DATETIME NOT NULL,
FromCurrencyCode NCHAR(3) NOT NULL,
ToCurrencyCode NCHAR(3) NOT NULL,
AverageRate MONEY NOT NULL,
EndOfDayRate MONEY NOT NULL,
ModifiedDate DATETIME NOT NULL)

-- Table_4_Sales.SpecialOfferProduct 

CREATE TABLE [SpecialOfferProduct (Sales)]
(SpecialOfferID INT NOT NULL, 
ProductID INT NOT NULL, 
rowgiud UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT SSOP_SEPID_PK PRIMARY KEY (SpecialOfferID,ProductID))

-- Table_5_Sales.CreditCard

CREATE TABLE [CreditCard (Sales)]
(CreditCardID INT CONSTRAINT SCC_CCID_PK PRIMARY KEY NOT NULL, 
CardType NVARCHAR (50) NOT NULL,
CardNumber NVARCHAR (25) NOT NULL,
ExpMonth TINYINT NOT NULL,
ExpYear SMALLINT NOT NULL,
ModifiedDate DATETIME NOT NULL)

-- Table_6_Sales.SalesTerritory

CREATE TABLE [SalesTerritory (Sales)] 
(TerritoryID INT CONSTRAINT SSTER_TERID_PK PRIMARY KEY NOT NULL, 
Name NAME NOT NULL,
CountryRegionCode NVARCHAR(3),
[Group] NVARCHAR(50),
SalesYTD MONEY NOT NULL,
SalesLasYear MONEY NOT NULL,
CostYTD MONEY NOT NULL,
CostLasYear MONEY NOT NULL,
rowgiud UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL)

-- Table_7_Sales.Customer

CREATE TABLE [Customer (Sales)] 
(CustomerID INT CONSTRAINT CUST_CUSTID_PK PRIMARY KEY NOT NULL, 
PresonID INT,
StoreID INT,
TerritoryID INT,
AccountNumber Varchar(25), 
rowgiud UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT CUST_TERID_FK FOREIGN KEY (TerritoryID) REFERENCES [SalesTerritory (Sales)](TerritoryID))

-- Table_8_Sales.SalesPerson 

CREATE TABLE [SalesPerson (Sales)] 
(BusinessEntityID INT CONSTRAINT SP_BISENTID_PK PRIMARY KEY NOT NULL, 
TerritoryID INT,
SalesQuota MONEY,
Bonus MONEY NOT NULL,
CommissionPct SMALLMONEY NOT NULL,
SalesYTD MONEY NOT NULL,
SalesLasYear MONEY NOT NULL,
rowgiud UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT SP_TERID_FK FOREIGN KEY (TerritoryID) REFERENCES [SalesTerritory (Sales)](TerritoryID))

-- Definition of Data Types
CREATE TYPE Flag
FROM BIT NOT NULL 
CREATE TYPE OrderNumber
FROM NVARCHAR(25)
CREATE TYPE AccountNumber
FROM NVARCHAR(25)








-- Table_9_Sales.SalesOrderHeader

CREATE TABLE [SalesOrderHeader (Sales)]
(SalesOrderID INT CONSTRAINT SOH_SLID_PK PRIMARY KEY NOT NULL, 
RevisionNumber TINYINT NOT NULL,
OrderDate DATETIME NOT NULL,
DueDate DATETIME NOT NULL,
ShipDate DATETIME,
Status TINYINT NOT NULL,
OnlineOrderFlag Flag NOT NULL, -- [0 'false' or 1 'ture']
SalesOrderNumber NVARCHAR(25) NOT NULL,
PurchaseOrderNumber OrderNumber,
AccountNumber AccountNumber,
CustomerID INT NOT NULL,
SalePersonID INT ,
TerritoryID INT ,
BillToAddressID INT NOT NULL,
ShipToAddressID INT NOT NULL,
ShipMethodID INT NOT NULL,
CreditCardID INT ,
CreditCardApprovalCode VARCHAR(15),
CurrencyRatelID INT,
SubTotal MONEY NOT NULL,
TaxAmt MONEY NOT NULL,
Freight MONEY NOT NULL,
TotalDue NVARCHAR(20) NOT NULL,
Comment  NVARCHAR(128),
Rowgiud UNIQUEIDENTIFIER NOT NULL, 
ModifiedDate DATETIME NOT NULL,
CONSTRAINT SOH_CUSID_FK FOREIGN KEY (CustomerID) REFERENCES [Customer (Sales)](CustomerID),
CONSTRAINT SOH_BILID_FK FOREIGN KEY (SalePersonID) REFERENCES [SalesPerson (Sales)](BusinessEntityID),
CONSTRAINT SOH_TERID_FK FOREIGN KEY (TerritoryID) REFERENCES [SalesTerritory (Sales)](TerritoryID),
CONSTRAINT SOH_SHADID_FK FOREIGN KEY (ShipToAddressID) REFERENCES [Address (Person)](AddressID),
CONSTRAINT SOH_SHMEID_FK FOREIGN KEY (ShipMethodID) REFERENCES [ShipMethod (Purchasing)](ShipMethodID),
CONSTRAINT SOH_CEADID_FK FOREIGN KEY (CreditCardID) REFERENCES [CreditCard (Sales)](CreditCardID),
CONSTRAINT SOH_RATID_FK FOREIGN KEY (CurrencyRatelID) REFERENCES [CurrencyRate (Sales)](CurrencyRatelID))















-- Table_10_SalesOrderDetail

CREATE TABLE [SalesOrderDetail (Sales)]
(SalesOrderID INT NOT NULL, 
SalesOrderDetailID INT NOT NULL, 
CarrierTrackingNumber NVARCHAR (25), 
OrderQty SMALLINT NOT NULL,
ProductID INT NOT NULL,
SpecialOfferID INT NOT NULL,
UnitPrice MONEY NOT NULL,
UnitPriceDiscount MONEY NOT NULL,
LineToatl MONEY NOT NULL,
rowgiud UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT SOID_SOD_PK PRIMARY KEY (SalesOrderID,SalesOrderDetailID),
CONSTRAINT SOID_SOD_FK FOREIGN KEY (SalesOrderID) REFERENCES [SalesOrderHeader (Sales)](SalesOrderID),
CONSTRAINT SOID_SPID_FK FOREIGN KEY (SpecialOfferID,ProductID) REFERENCES 
[SpecialOfferProduct (Sales)](SpecialOfferID,ProductID))

-- Inserting data into tables

INSERT INTO [Address (Person)]
SELECT *
FROM [Address fixed_Temp]

INSERT INTO [ShipMethod (Purchasing)]
SELECT *
FROM ShipMethod_Temp

INSERT INTO [CurrencyRate (Sales)]
SELECT *
FROM [CurrencyRate fixed_Temp]

INSERT INTO [SpecialOfferProduct (Sales)]
SELECT *
FROM [SpecialOfferProduct_Temp]

INSERT INTO [CreditCard (Sales)]
SELECT *
FROM [CreditCard fixed_Temp]

INSERT INTO [SalesTerritory (Sales)] 
SELECT *
FROM [SalesTerritory_Temp]

INSERT INTO [Customer (Sales)]
SELECT *
FROM [customer fixed_Temp]
 
 -- SalesOrderHeader לא ניתן להכניס את הנתונים מהטבלה הזמנית של 
 --  Address (Person) בטבלת P.K יש ערכים שלא מוגדרים בעמודת ה F.K בגלל שבעומדה שמוגדרת כ

INSERT INTO [SalesOrderHeader (Sales)]
SELECT *
FROM [SalesOrderHeader_Temp]




INSERT INTO [SalesOrderDetail (Sales)]
SELECT *
FROM SalesOrderDetail_Temp

