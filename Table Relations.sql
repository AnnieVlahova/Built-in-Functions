---1---
CREATE TABLE Passports(
PassportID int Primary key,
PassportNumber varchar(60)
)

CREATE TABLE Persons(
PersonID int Primary KEy,
FirstName varchar(50),
Salary float,
PassportID int UNIQUE,
CONSTRAINT FK_Persons_Passports FOREIGN KEY(PassportID)
REFERENCES Passports(PassportID)
)
---2---
CREATE TABLE Manufacturers(
ManufacturerID int PRIMARY KEY IDENTITY, 
Name varchar(70) UNIQUE,
EstablishedOn date
)

CREATE TABLE Models(
ModelID int PRIMARY KEY IDENTITY,
Name varchar(80),
ManufacturerID int,
CONSTRAINT FK_Models_Manufacturers FOREIGN KEY(ManufacturerID)
REFERENCES Manufacturers(ManufacturerID)
)
---3---
CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTitY,
Name varchar(60)
)

CREATE TABLE Exams(
ExamID INT PRIMARY KEY IDENTITY(101, 1),
Name varchar(90)
)

CREATE TABLE StudentsExams(
StudentID int,
ExamID int,
PRIMARY KEY (StudentID, ExamID),
CONSTRAINT FK_StudentsExams_Students FOREIGN KEY(StudentID)
REFERENCES Students(StudentID),
CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY(ExamID)
REFERENCES Exams(ExamID)

)
---4---
CREATE TABLE Teachers(
TeacherID int PRIMARY KEY Identity,
Name varchar(60),
ManagerID int,
CONSTRAINT FK_Teachers_Managers FOREIGN KEY(ManagerID)
REFERENCES Teachers(TeacherID)
)
---5---
CREATE TABLE Cities(
CityID int PRIMARY KEY IDENtITY,
Name varchar(50)
)
CREATE TABLE Customers(
CustomerID int PRIMARY KEY IDENTITY,
Name varchar(50),
Birthday date,
CityID int,
CONSTRAINT FK_Customers_Cities FOREIGN KEY(CityID)
REFERENCES Cities(CityID)
)
CREATE TABLE Orders(
OrderID int PRIMARY KEY IDENTITY,
CustomerID int
CONSTRAINT FK_Orders_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)
)
CREATE TABLE ItemTypes(
ItemTypeID INT PRIMARY KEY IDENTITY,
Name VARCHAR(50)
)
CREATE TABLE Items(
ItemID int Primary key identity,
Name varchar(50),
ItemTypeID int,
CONSTRAINT FK_Items_ItemTypes FOREIGN KEY(ItemTypeID)
REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems(
OrderID int,
ItemID int,
PRIMARY KEY(OrderID, ItemID),
CONSTRAINT FK_OrderItems_Orders FOREIGN KEY(OrderID)
REFERENCES Orders(OrderID),
CONSTRAINT FK_OrderItems_Items FOREIGN KEY(ItemID)
REFERENCES Items(ItemID)
)
---6---
CREATE TABLE Majors(
MajorID INT PRIMARY KEY IDENTITY,
Name varchar(50)
)
CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTITY,
StudentNumber int,
StudentName varchar(60),
MajorID int,
CONSTRAINT FK_Students_Majors FOREIGN KEY(MajorID)
REFERENCES Majors(MajorID)
)
CREATE TABLE Payments(
PaymentID INT PRIMARY KEY IDENTITY,
PaymentDate date,
PaymentAmount float,
StudentID int,
CONSTRAINT FK_Payments_Students FOREIGN KEY(StudentID)
REFERENCES Students(StudentID)
)
CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY IDENTITY,
SubjectName varchar(70)
)

CREATE TABLE Agenda(
StudentID int,
SubjectID int,
PRIMARY KEY(StudentID, SubjectID),
CONSTRAINT FK_Agenda_Students FOREIGN KEY(StudentID)
REFERENCES Students(StudentID),
CONSTRAINT FK_Agenda_Subjects FOREIGN KEY(SubjectID)
REFERENCES Subjects(SubjectID)
)
---9---
SELECT MountainRange, PeakName, Elevation FROM Peaks
JOIN Mountains ON Mountains.Id = Peaks.MountainId WHERE MountainId = 17 ORDER BY Elevation DESC