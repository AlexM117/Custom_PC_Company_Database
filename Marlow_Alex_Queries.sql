--Alex  Marlow

--The following is a list of queries that get data from the database
USE Marlow_Alex_db    --As the Databse was allowed to change since proposal all the proposed quaries may not be completed


--Get all support tickets for Customer 2

SELECT Topic, MSG
FROM Support_Ticket JOIN Customer_Tickets ON Support_Ticket.Ticket_ID = Customer_Tickets.Ticket_ID
WHERE CID = 2;

--Show how many items are in stock from each manufacturer

SELECT Manufacturer, SUM(In_Stock)
FROM Inventory
GROUP BY Manufacturer;

--Show components that are out of stock and are not on order

SELECT *
FROM Inventory
WHERE In_Stock = 0 AND On_Order = 0;

-- Find Number of Intell CPUs used in PCs

SELECT Count(*) as Intel_CPUs_Used
FROM PC JOIN Item ON PC.CPU_ID = Item_ID
WHERE Manufacturer = 'INTEL';

--Show all extra items for order 1

SELECT *
FROM Order_Line_Extra_Item
WHERE Order_Num = 1;

--Show all complaints of Employee 1

SELECT Description
FROM HR JOIN Complaint ON HR.Complaint_ID = Complaint.Complaint_ID
WHERE EID = 1;

--Show all resumes for job posting 1

SELECT Resume
FROM Job_Posting JOIN Applications ON Job_Posting.Posting_ID = Applications.Posting_ID
WHERE Job_Posting.Posting_ID = 1;


--Show what percent of tasks have been given to employee 1

SELECT (100*Count(*)/(SELECT Count(*) FROM Task)) as Percent_1
FROM Task
WHERE EID = 1;


