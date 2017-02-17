---1. Data Definition
CREATE TABLE Flights(
FlightID INT PRIMARY KEY,
DepartureTime DATETIME NOT NULL,
ArrivalTime DATETIME NOT NULL,
Status VARCHAR(9),
CONSTRAINT chk_Status 
	CHECK (Status IN ('Departing', 'Delayed', 'Arrived', 'Cancelled')),
OriginAirportID INT,
CONSTRAINT FK_Flights_Airports1
	FOREIGN KEY (OriginAirportID) REFERENCES Airports(AirportID),
DestinationAirportID INT,
CONSTRAINT FK_Flights_Airports2
	FOREIGN KEY (DestinationAirportID) REFERENCES Airports(AirportID),
AirlineID INT,
CONSTRAINT FK_Flights_Airlines
	FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
)

CREATE TABLE Tickets(
TicketID INT PRIMARY KEY,
Price DECIMAL(8,2) NOT NULL,
Class VARCHAR(6),
CONSTRAINT chk_Class
	CHECK (Class IN ('First', 'Second', 'Third')),
Seat VARCHAR(5) NOT NULL,
CustomerID INT,
CONSTRAINT FK_Tickets_Customers
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FlightID INT,
CONSTRAINT FK_Tickets_Flights
	FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
)
---2. Data Manipulation
--1. Data Insertion
INSERT INTO Flights(FLightID, DepartureTime, ArrivalTime, Status, OriginAirportID, DestinationAirportID, AirlineID)
VALUES(1, '2016-10-13 06:00 AM', '2016-10-13 10:00 AM', 'Delayed', 1, 4, 1),
(2,	'2016-10-12 12:00 PM', '2016-10-12 12:01 PM', 'Departing', 1, 3, 2),
(3,	'2016-10-14 03:00 PM', '2016-10-20 04:00 AM', 'Delayed', 4,	2, 4),
(4,	'2016-10-12 01:24 PM',	'2016-10-12 4:31 PM', 'Departing', 3, 1, 3),
(5,	'2016-10-12 08:11 AM',	'2016-10-12 11:22 PM',	'Departing', 4,	1, 1),
(6,	'1995-06-21 12:30 PM',	'1995-06-22 08:30 PM',	'Arrived',	2, 	3, 	5),
(7,	'2016-10-12 11:34 PM',	'2016-10-13 03:00 AM',	'Departing', 2,	4, 2),
(8,	'2016-11-11 01:00 PM',	'2016-11-12 10:00 PM',	'Delayed', 4, 3, 1),
(9,	'2015-10-01 12:00 PM',	'2015-12-01 01:00 AM',	'Arrived', 1, 2, 1),
(10, '2016-10-12 07:30 PM', '2016-10-13 12:30 PM', 'Departing', 2, 1,7)
SET IDENTITY_INSERT Flights OFF
SET IDENTITY_INSERT Tickets ON
INSERT INTO Tickets(TicketID, Price, Class, Seat, CustomerID, FlightID)
VALUES(1, 3000.00, 'First', '233-A', 3,	8),
(2,	1799.90, 'Second', '123-D',	1,	1),
(3,	1200.50, 'Second', '12-Z', 2, 5),
(4, 410.68,	'Third', '45-Q', 2, 8),
(5,	560.00,	'Third', '201-R', 4, 6),
(6, 2100.00, 'Second', '13-T', 1, 9),
(7, 5500.00, 'First', '98-O', 2, 7)
--2. Update Arrived Flights
UPDATE Flights
SET AirlineID = 1
WHERE Status = 'Arrived'
--3. Update Tickets
Update Tickets
SET Price += Price/2
WHERE FlightID IN (SELECT FlightID FROM Flights WHERE
AirlineID = (SELECT AirlineID FROM Airlines WHERE Rating = (SELECT MAX(Rating) FROM Airlines)))
--4. Table Creation
CREATE TABLE CustomerReviews(
ReviewID INT PRIMARY KEY,
ReviewContent VARCHAR(255) NOT NULL,
ReviewGrade INT CHECK(ReviewGrade BETWEEN 0 AND 10),
AirlineID INT
CONSTRAINT FK_CustomerReviews_Airlines FOREIGN KEY(AirlineID)
REFERENCES Airlines(AirlineID),
CustomerID iNT
CONSTRAINT FK_CustomerReviews_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)
)
CREATE TABLE CustomerBankAccounts(
AccountID INT PRIMARY KEY,
AccountNumber VARCHAR(10) NOT NULL UNIQUE,
Balance DECIMAL(10,2) NOT NULL,
CustomerID INT
CONSTRAINT FK_CustomerBankAccounts_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)
)
--5. Fill the new Tables With Data
INSERT INTO CustomerReviews(ReviewID, ReviewContent, ReviewGrade, AirlineID, CustomerID)
VALUES(1, 'Me is very happy. Me likey this airline. Me good.', 10, 1, 1),
(2, 'Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!', 10, 1, 4),
(3, 'Meh...', 5, 4,	3),
(4, 'Well Ive seen better, but Ive certainly seen a lot worse...', 7, 3, 5)

INSERT INTO CustomerBankAccounts(AccountID, AccountNumber, Balance, CustomerID)
VALUES(1, '123456790', 2569.23, 1),
(2, '18ABC23672', 14004568.23, 2),
(3, 'F0RG0100N3', 19345.20, 5)
---3. Querying
--1. All Tickets
SELECT TicketID, Price, Class, Seat FROM Tickets
ORDER BY TicketID
--2. All Customers
SELECT CustomerID, FirstName + ' ' + LastName AS [Full Name],
Gender FROM Customers
ORDER BY [Full Name], CustomerID
--3. Delayed Flights
SELECT FlightID, DepartureTime, ArrivalTime FROM Flights
WHERE Status = 'Delayed' ORDER BY FlightID
--4.Extract Top 5 Most Highly Rated Airlines which have any Flights
SELECT TOP 5 AirlineID, AirlineName, Nationality, Rating FROM Airlines
WHERE AirlineID IN (Select AirlineID FROM Flights)
ORDER BY Rating DESC, AirlineID
--5.Extract all Tickets with price below 5000, for First Class
SELECT t.TicketID, a.AirportName AS [Destination], c.FirstName + ' ' + c.LastName AS [Customer Name] FROM Tickets t
JOIN Flights f ON f.FlightID = t.FlightID
JOIN Airports a ON f.DestinationAirportID = a.AirportID
JOIN Customers c ON t.CustomerID = c.CustomerID
WHERE t.Price < 5000 AND t.Class = 'First'
ORDER BY t.TicketID
--6.Extract all Customers which are departing from their Home Town
SELECT c.CustomerID, c.FirstName + ' ' + c.LastName AS FullName, tw.TownName FROM Customers c
JOIN Towns tw ON tw.TownID = c.HomeTownID
JOIN Tickets t ON t.CustomerID = c.CustomerID
JOIN Flights f ON f.FlightID = t.FlightID
JOIN Airports a ON f.OriginAirportID = a.AirportID
WHERE a.TownID = tw.TownID AND f.Status = 'Departing'
ORDER BY c.CustomerID 
--7. Extract all Customers which will fly
SELECT DISTINCT c.CustomerID, c.FirstName + ' ' + c.LastName AS FullName, 2016 - YEAR(c.DateOfBirth) AS Age FROM Customers c
JOIN Tickets t ON t.CustomerID = c.CustomerID
JOIN Flights f ON f.FlightID = t.FlightID
WHERE f.Status = 'Departing'
ORDER BY Age, c.CustomerID
--8. Extract Top 3 Customers which have Delayed Flights
SELECT TOP 3 c.CustomerID, c.FirstName + ' ' + c.LastName AS 
[FullName], t.Price, a.AirportName FROM Customers c
JOIN Tickets t ON t.CustomerID = c.CustomerID
JOIN Flights f ON f.FlightID = t.FlightID
JOIN Airports a ON f.DestinationAirportID = a.AirportID
WHERE f.Status = 'Delayed'
ORDER BY t.Price DESC, c.CustomerID
--9. Extract the Last 5 Flights, which are departing.
SELECT f.FlightID, f.DepartureTime, f.ArrivalTime,
ao.AirportName AS Origin, ad.AirportName AS Destination FROM (SELECT TOP 5 * FROM Flights fl WHERE fl.Status = 'Departing' ORDER BY fl.DepartureTime DESC) AS f
JOIN Airports ao ON ao.AirportID = f.OriginAirportID
JOIN Airports ad ON ad.AirportID = f.DestinationAirportID
ORDER BY f.DepartureTime, f.FlightID
--10.Extract all Customers below 21 years, which have already flew at least once
SELECT DISTINCT cm.CustomerID, cm.FirstName + ' ' + cm.LastName AS 
[FullName],2016 - YEAR(cm.DateOfBirth) AS Age FROM Customers cm
JOIN Tickets t ON t.CustomerID = cm.CustomerID
JOIN Flights f ON f.FlightID = t.FlightID
WHERE f.Status = 'Arrived'  AND 2016 - YEAR(cm.DateOfBirth)< 21 
ORDER BY Age DESC, cm.CustomerID
--11.Extract all Airports and the Count of People departing from them
SELECT a.AirportID, a.AirportName, COUNT(c.CustomerID) AS [Passengers] FROM Airports a
JOIN Flights f ON f.OriginAirportID = a.AirportID
JOIN Tickets t ON t.FlightID = f.FlightID
JOIN Customers c ON c.CustomerID = t.CustomerID
GROUP BY a.AirportID, a.AirportName, f.Status
HAVING COUNT(c.CustomerID) > 0 AND f.Status = 'Departing'
ORDER BY AirportID 
---4. Programmability
--1.
CREATE PROCEDURE usp_SubmitReview(@CustomerID INT, @ReviewContent VARCHAR(255),
	@ReviewGrade INT, @AirlineName VARCHAR(30))
AS
BEGIN
	BEGIN TRAN

	DECLARE @Index INT 
		IF((SELECT COUNT(*) FROM CustomerReviews) = 0)
			SET @Index = 1
		ELSE 
		SET @Index = (SELECT MAX(ReviewID) FROM CustomerReviews) + 1
		
		DECLARE @AirlineId INT  = (SELECT AirlineID FROM Airlines WHERE AirlineName = @AirlineName)
		
		INSERT INTO CustomerReviews
					(ReviewID, ReviewContent, ReviewGrade, 
						 CustomerID, AirlineID)
				VALUES (@Index, @ReviewContent, @ReviewGrade,
						@CustomerID, @AirlineID)

		IF NOT EXISTS(SELECT AirlineName FROM Airlines
					WHERE AirlineName = @AirlineName)
			BEGIN
				RAISERROR('Airline does not exist.', 16, 1)
				ROLLBACK
			END
		ELSE
			BEGIN 
				COMMIT
			END
END 
--2.
CREATE PROCEDURE usp_PurchaseTicket(@CustomerID INT, @FlightID INT, 
	@TicketPrice DECIMAL(8, 2), @Class VARCHAR(5), @Seat VARCHAR(5))
AS
BEGIN
	DECLARE @Index INT 
		IF((SELECT COUNT(*) FROM Tickets) = 0)
			SET @Index = 1
		ELSE SET @Index = (SELECT MAX(TicketID) FROM Tickets) + 1	
	BEGIN TRANSACTION
			DECLARE @CustomerBallance DECIMAL(10, 2) = 
				(SELECT Balance FROM CustomerBankAccounts
				WHERE CustomerID = @CustomerID) 
			IF(@customerBallance IS NULL)
			SET @customerBallance = 0
			IF(@TicketPrice > @customerBallance)
				BEGIN
					RAISERROR('Insufficient bank account balance for ticket purchase.', 16, 1)
					ROLLBACK
				END
	ELSE BEGIN
			INSERT INTO Tickets (TicketID, Price, Class, Seat,
				CustomerID, FlightID)
			VALUES
				(@Index, @TicketPrice, @Class, @Seat,
				@CustomerID, @FlightID)
			UPDATE CustomerBankAccounts 
			SET Balance = Balance - @TicketPrice
			WHERE CustomerID = @CustomerID
			COMMIT
		END
END
---5. Update Trigger
CREATE TRIGGER tr_ArrivedFlights ON Flights FOR UPDATE
AS
INSERT INTO ArrivedFlights ([FlightID], [ArrivalTime],
	[Origin], [Destination], [Passengers])
	SELECT FlightID, ArrivalTime, 
	orig.AirportName AS OriginAirport,
	dest.AirportNAme AS DestinationAirport,
	(SELECT COUNT(*) FROM Tickets WHERE FlightID = i.FlightID)
	As Passengers
	FROM inserted i
	JOIN Airports orig
	ON orig.AirportID = i.OriginAirportID
	JOIN Airports as dest
	ON dest.AirportID = i.DestinationAirportID
	WHERE Status = 'Arrived'

