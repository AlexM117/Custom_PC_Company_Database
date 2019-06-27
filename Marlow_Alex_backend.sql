--Alex Marlow

--Run Instructions: In Order:
--Run create database, then Use, then run all comands EXCEPT for CREATE VIEW at bottom

CREATE DATABASE Marlow_Alex_db
USE Marlow_Alex_db



CREATE TABLE Support_Ticket(
	Ticket_ID      integer        NOT NULL,
	Topic          varchar(128)   NULL,
	MSG            varchar(500)   NOT NULL,
	CONSTRAINT     Support_Ticket_PK PRIMARY KEY (Ticket_ID),


);

CREATE TABLE Customer_Tickets (
	CID            integer        NOT NULL,
	Ticket_ID      integer        NOT NULL,
	CONSTRAINT Costomer_Tickets_PK PRIMARY KEY (CID,Ticket_ID),
	CONSTRAINT 		   Support_Ticket_Relationship FOREIGN KEY (Ticket_ID)
			REFERENCES 	   Support_Ticket (Ticket_ID),
);

CREATE TABLE Customer(
	CID      integer        NOT NULL,
	Email    varchar(128)   NOT NULL,
	Name     varchar(128)   NOT NULL,
	CONSTRAINT Customer_PK PRIMARY KEY (CID),
	CONSTRAINT Email_check CHECK (Email LIKE '%@%.%')

);



CREATE TABLE Supplier (
	Manufacturer   varchar(128)    NOT NULL,
	Email          varchar(128)    NOT NULL,
	CONSTRAINT Supplier_PK PRIMARY KEY (Manufacturer),
	CONSTRAINT Email_check2 CHECK (Email LIKE '%@%.%')

);


CREATE TABLE Inventory (
	Manufacturer   varchar(128)    NOT NULL,
	Model          varchar(128)    NOT NULL,
	In_Stock       int             NOT NULL,
	On_Order       int             NOT NULL,
	Price          int             NOT NULL,
	CONSTRAINT Inventory_PK PRIMARY KEY (Manufacturer, Model),
	--myabe FK here instead of other table idk
	CONSTRAINT Supplier_Relationship FOREIGN KEY (Manufacturer)
			REFERENCES Supplier (Manufacturer),
	CONSTRAINT stock_check CHECK (In_Stock >= 0),
	CONSTRAINT order_check CHECK (On_Order >= 0),
	CONSTRAINT price_check CHECK (Price > 0)

);



CREATE TABLE Item (
	Item_ID        int             NOT NULL,
	Type           varchar(128)    NOT NULL,
	Manufacturer   varchar(128)    NOT NULL,
	Model          varchar(128)    NOT NULL,
	CONSTRAINT Item_PK PRIMARY KEY (Item_ID),
	CONSTRAINT Inventory_R FOREIGN KEY (Manufacturer, Model)
			REFERENCES Inventory (Manufacturer, Model),
	CONSTRAINT Type_check CHECK (Type IN ('GPU','CPU','MOBO','RAM','CASE','STORAGE','Keyboard','Mouse', 'Monitor','Headphones')),
);


CREATE TABLE PC (
	PC_ID       int   NOT NULL,
	CPU_ID      int   NOT NULL,
	GPU_ID      int   NOT NULL,
	MOBO_ID     int   NOT NULL,
	RAM_ID      int   NOT NULL,
	CASE_ID     int   NOT NULL,
	STORAGE_ID  int   NOT NULL,
	Price       int   NOT NULL,
	CONSTRAINT PC_PK PRIMARY KEY (PC_ID),
	CONSTRAINT CPU_R FOREIGN KEY (CPU_ID)
			REFERENCES Item (Item_ID),
	CONSTRAINT GPU_R FOREIGN KEY (GPU_ID)
			REFERENCES Item (Item_ID),
	CONSTRAINT MOBO_R FOREIGN KEY (MOBO_ID)
			REFERENCES Item (Item_ID),
	CONSTRAINT RAM_R FOREIGN KEY (RAM_ID)
			REFERENCES Item (Item_ID),
	CONSTRAINT CASE_R FOREIGN KEY (CASE_ID)
			REFERENCES Item (Item_ID),
	CONSTRAINT STORAGE_R FOREIGN KEY (STORAGE_ID)
			REFERENCES Item (Item_ID),
	CONSTRAINT price_check2 CHECK (Price > 0)

);

CREATE TABLE Sales_Order(
	Order_Num     int     NOT NULL,
	Created       date    NOT NULL,
	Shipped       date    NULL,
	Total_cost    int     NOT NULL,
	PC_ID         int     NOT NULL,
	CONSTRAINT Sales_Order_PK PRIMARY KEY (Order_Num),
	CONSTRAINT PC_Relationship FOREIGN KEY (PC_ID)
			REFERENCES  PC (PC_ID),
	CONSTRAINT CheckDates CHECK (Created < Shipped),
	CONSTRAINT cost_check CHECK (Total_cost >= 0)

);


CREATE TABLE Customer_Orders (
	CID      integer      NOT NULL,
	Order_Num     int     NOT NULL,
	CONSTRAINT Customer_Orders_PK PRIMARY KEY (CID,Order_Num),
	CONSTRAINT Customer_R FOREIGN KEY (CID)
			REFERENCES Customer(CID),
	CONSTRAINT Sales_Order_R FOREIGN KEY (Order_Num)
			REFERENCES Sales_Order (Order_Num)

);


CREATE TABLE Order_Line_Extra_Item(
	Order_Num       int   NOT NULL,
	Line_Num        int   NOT NULL,
	Item_ID         int   NOT NULL,
	Quantity        int   NOT NULL,
	Extended_Price  int   NOT NULL,
	CONSTRAINT Order_Line_Extra_Item_PK PRIMARY KEY (Order_Num, Line_Num),
	CONSTRAINT Sales_Order_Relationship FOREIGN KEY (Order_Num)
			REFERENCES Sales_Order (Order_Num),
	CONSTRAINT Item_Relationship FOREIGN KEY (Item_ID)
			REFERENCES Item (Item_ID),
	CONSTRAINT price_check3 CHECK (Extended_Price > 0),
	CONSTRAINT Quantity_check CHECK (Quantity > 0)
);



CREATE TABLE Applicant (
	AID       int             NOT NULL,
	Name      varchar(128)    NOT NULL,
	Email     varchar(128)    NOT NULL,
	Phone     varchar(128)    NOT NULL,
	CONSTRAINT Applicant_PK PRIMARY KEY (AID),
	CONSTRAINT Email_check3 CHECK (Email LIKE '%@%.%'),
	CONSTRAINT Phone_check CHECK (Phone LIKE '___-___-____')

);


CREATE TABLE Job_Posting (
	Posting_ID       int           NOT NULL,
	Title            varchar(128)  NOT NULL,
	Description      varchar(500)  NOT NULL,
	Requirements     varchar(500)  NOT NULL,
	CONSTRAINT Job_Posting_PK PRIMARY KEY (Posting_ID)


);


CREATE TABLE Applications (
	Posting_ID       int            NOT NULL,
	AID              int            NOT NULL,
	Resume           varchar(1000)  NOT NULL,
	CONSTRAINT Applications_PK PRIMARY KEY (Posting_ID, AID),
	CONSTRAINT Job_Posting_R FOREIGN KEY (Posting_ID)
			REFERENCES Job_Posting (Posting_ID),
	CONSTRAINT Applicant_R FOREIGN KEY (AID)
			REFERENCES Applicant (AID)

);


CREATE TABLE Employee (
	EID        int           NOT NULL,
	Name       varchar(128)  NOT NULL,
	DOB        date          NOT NULL,
	Address    varchar(128)  NOT NULL,
	Hourly_Pay int           NOT NULL,
	CONSTRAINT Employee_PK PRIMARY KEY (EID),
	CONSTRAINT Pay_check CHECK (Hourly_Pay > 0)

);


CREATE TABLE Task (
	Order_Num       int            NOT NULL,
	EID             int            NOT NULL,
	Task_desc       varchar(500)   NOT NULL,
	CONSTRAINT Task_PK PRIMARY KEY (Order_Num,EID),
	CONSTRAINT Employee_R FOREIGN KEY (EID)
			REFERENCES Employee (EID),
	CONSTRAINT Sales_Order_R2 FOREIGN KEY (Order_Num)
			REFERENCES Sales_Order (Order_Num)

);



CREATE TABLE Complaint (
	Complaint_ID      int            NOT NULL,
	Description       varchar(500)   NOT NULL,
	CONSTRAINT Complaint_PK PRIMARY KEY (Complaint_ID),
);



CREATE TABLE HR (
	EID               int            NOT NULL,
	Complaint_ID      int            NOT NULL,
	CONSTRAINT HR_PK PRIMARY KEY (EID, Complaint_ID),
	CONSTRAINT Employee_R2 FOREIGN KEY (EID)
			REFERENCES Employee (EID),
	CONSTRAINT Complaint_R FOREIGN KEY (Complaint_ID)
			REFERENCES Complaint (Complaint_ID)

);



INSERT INTO Customer VALUES (1, 'JSmith@gmail.com', 'John Smith'
);
INSERT INTO Customer VALUES (2, 'KAlmond@gmail.com', 'Kevin Almond'
);
INSERT INTO Customer VALUES (3, 'MWilson@gmail.com', 'Mike Wilson'
);
INSERT INTO Customer VALUES (4, 'ABond@gmail.com', 'Aric Bond'
);
INSERT INTO Customer VALUES (5, 'RGuy@gmail.com', 'Random Guy'
);



INSERT INTO Support_Ticket VALUES (1,'PSU Blew up', 'My PSU blew up on my recent order, I need a replacement,
you guys realy need to allow us to pick our own PSUs, that dont come with the case'
);


INSERT INTO Customer_Tickets VALUES (2,1
);

INSERT INTO Supplier VALUES('ASUS', 'ASUS@gmail.com'
);
INSERT INTO Supplier VALUES('EVGA', 'EVGA@gmail.com'
);
INSERT INTO Supplier VALUES('GIGABYTE', 'GIGABYTE@gmail.com'
);
INSERT INTO Supplier VALUES('COOLERMASTER', 'COOLERMASTER@gmail.com'
);
INSERT INTO Supplier VALUES('INTEL', 'INTEL@gmail.com'
);
INSERT INTO Supplier VALUES('AMD', 'AMD@gmail.com'
);
INSERT INTO Supplier VALUES('SAMSUNG', 'SAMSUNG@gmail.com'
);
INSERT INTO Supplier VALUES('CORSAIR', 'CORSAIR@gmail.com'
);
INSERT INTO Supplier VALUES('SENNHEISER', 'SENNHEISER@gmail.com'
);



INSERT INTO Inventory VALUES('INTEL', 'I7-7300', 5, 5, 200
);
INSERT INTO Inventory VALUES('INTEL', 'I5-7600', 5, 0, 150
);
INSERT INTO Inventory VALUES('ASUS', 'R9-270x', 5, 5, 160
);
INSERT INTO Inventory VALUES('GIGABYTE', 'XYZ300', 3, 4, 150
);
INSERT INTO Inventory VALUES('CORSAIR', 'DOMINATOR', 5, 5, 100
);
INSERT INTO Inventory VALUES('COOLERMASTER', 'P300', 5, 0, 100
);
INSERT INTO Inventory VALUES('SAMSUNG', '840-EVO', 5, 0, 70
);
INSERT INTO Inventory VALUES('CORSAIR', 'K70', 5, 0, 120
);
INSERT INTO Inventory VALUES('CORSAIR', 'M300', 0, 10, 50
);
INSERT INTO Inventory VALUES('ASUS', 'PQ100', 0, 10, 200
);
INSERT INTO Inventory VALUES('SENNHEISER', 'HD-598', 5, 0, 80
);


INSERT INTO Item VALUES (1000, 'CPU', 'INTEL', 'I7-7300'
);
INSERT INTO Item VALUES (1001, 'CPU', 'INTEL', 'I7-7300'
);
INSERT INTO Item VALUES (1002, 'CPU', 'INTEL', 'I7-7300'
);
INSERT INTO Item VALUES (1003, 'CPU', 'INTEL', 'I7-7300'
);
INSERT INTO Item VALUES (1004, 'CPU', 'INTEL', 'I7-7300'
);
INSERT INTO Item VALUES (1005, 'CPU', 'INTEL', 'I7-7300'
);

INSERT INTO Item VALUES(1101, 'CPU', 'INTEL', 'I5-7600'
);
INSERT INTO Item VALUES(1102, 'CPU', 'INTEL', 'I5-7600'
);
INSERT INTO Item VALUES(1103, 'CPU', 'INTEL', 'I5-7600'
);
INSERT INTO Item VALUES(1104, 'CPU', 'INTEL', 'I5-7600'
);
INSERT INTO Item VALUES(1105, 'CPU', 'INTEL', 'I5-7600'
);

INSERT INTO Item VALUES(2000, 'GPU', 'ASUS', 'R9-270x'
);
INSERT INTO Item VALUES(2001, 'GPU', 'ASUS', 'R9-270x'
);
INSERT INTO Item VALUES(2002, 'GPU', 'ASUS', 'R9-270x'
);
INSERT INTO Item VALUES(2003, 'GPU', 'ASUS', 'R9-270x'
);
INSERT INTO Item VALUES(2004, 'GPU', 'ASUS', 'R9-270x'
);
INSERT INTO Item VALUES(2005, 'GPU', 'ASUS', 'R9-270x'
);

INSERT INTO Item VALUES(3000, 'MOBO', 'GIGABYTE', 'XYZ300'
);
INSERT INTO Item VALUES(3001, 'MOBO', 'GIGABYTE', 'XYZ300'
);
INSERT INTO Item VALUES(3002, 'MOBO', 'GIGABYTE', 'XYZ300'
);
INSERT INTO Item VALUES(3003, 'MOBO', 'GIGABYTE', 'XYZ300'
);

INSERT INTO Item VALUES(4000, 'RAM', 'CORSAIR', 'DOMINATOR'
);
INSERT INTO Item VALUES(4001, 'RAM', 'CORSAIR', 'DOMINATOR'
);
INSERT INTO Item VALUES(4002, 'RAM', 'CORSAIR', 'DOMINATOR'
);
INSERT INTO Item VALUES(4003, 'RAM', 'CORSAIR', 'DOMINATOR'
);
INSERT INTO Item VALUES(4004, 'RAM', 'CORSAIR', 'DOMINATOR'
);
INSERT INTO Item VALUES(4005, 'RAM', 'CORSAIR', 'DOMINATOR'
);


INSERT INTO Item VALUES(5000, 'CASE', 'COOLERMASTER', 'P300'
);
INSERT INTO Item VALUES(5001, 'CASE', 'COOLERMASTER', 'P300'
);
INSERT INTO Item VALUES(5002, 'CASE', 'COOLERMASTER', 'P300'
);
INSERT INTO Item VALUES(5003, 'CASE', 'COOLERMASTER', 'P300'
);
INSERT INTO Item VALUES(5004, 'CASE', 'COOLERMASTER', 'P300'
);
INSERT INTO Item VALUES(5005, 'CASE', 'COOLERMASTER', 'P300'
);

INSERT INTO Item VALUES(6000, 'STORAGE', 'SAMSUNG', '840-EVO'
);
INSERT INTO Item VALUES(6001, 'STORAGE', 'SAMSUNG', '840-EVO'
);
INSERT INTO Item VALUES(6002, 'STORAGE', 'SAMSUNG', '840-EVO'
);
INSERT INTO Item VALUES(6003, 'STORAGE', 'SAMSUNG', '840-EVO'
);
INSERT INTO Item VALUES(6004, 'STORAGE', 'SAMSUNG', '840-EVO'
);
INSERT INTO Item VALUES(6005, 'STORAGE', 'SAMSUNG', '840-EVO'
);

INSERT INTO Item VALUES(7000, 'Keyboard', 'CORSAIR', 'K70'
);
INSERT INTO Item VALUES(7001, 'Keyboard', 'CORSAIR', 'K70'
);
INSERT INTO Item VALUES(7002, 'Keyboard', 'CORSAIR', 'K70'
);
INSERT INTO Item VALUES(7003, 'Keyboard', 'CORSAIR', 'K70'
);
INSERT INTO Item VALUES(7004, 'Keyboard', 'CORSAIR', 'K70'
);
INSERT INTO Item VALUES(7005, 'Keyboard', 'CORSAIR', 'K70'
);

INSERT INTO Item VALUES(10001, 'Headphones', 'SENNHEISER', 'HD-598'
);
INSERT INTO Item VALUES(10002, 'Headphones', 'SENNHEISER', 'HD-598'
);
INSERT INTO Item VALUES(10003, 'Headphones', 'SENNHEISER', 'HD-598'
);
INSERT INTO Item VALUES(10004, 'Headphones', 'SENNHEISER', 'HD-598'
);
INSERT INTO Item VALUES(10005, 'Headphones', 'SENNHEISER', 'HD-598'
);


INSERT INTO PC VALUES(100, 1000, 2000, 3000, 4000, 5000, 6000, 900
);

INSERT INTO Sales_Order VALUES(1, '12-20-2006', '12-30-2006', 1020, 100
);


INSERT INTO Customer_Orders VALUES(2, 1
);

INSERT INTO Order_Line_Extra_Item VALUES(1, 1, 7000, 1, 120
);

INSERT INTO Applicant VALUES(1, 'John Johnson', 'JJ@gmail.com', '360-222-2222'
);
INSERT INTO Applicant VALUES(2, 'Ron Swanson', 'RS@gmail.com', '360-333-2222'
);


INSERT INTO Job_Posting VALUES(1, 'PC_Builder', 'Build computers.....idk', 'high school deploma'
);

INSERT INTO Applications VALUES(1,1,'Hire me plz Im doomed'
);
INSERT INTO Applications VALUES(1,2,'Masters degree in Truffle Gathering'
);


INSERT INTO Employee VALUES(1, 'Billy Bob', '11-11-1991', 'Random road', '16'
);
INSERT INTO Employee VALUES(2, 'Hes A MANAGER', '10-10-1990', 'Another Road', '20'
);
INSERT INTO Employee VALUES(3, 'U WOT M8?', '10-01-1990', 'South by East-West LN', '100'
);


INSERT INTO Task VALUES(1, 1, 'Build PC'
);
INSERT INTO Task VALUES(1, 2, 'Ship PC'
);
INSERT INTO Task VALUES(1, 3, 'Observe'
);

INSERT INTO Complaint VALUES(1, 'Hes A MANAGER is a manager'
);
INSERT INTO Complaint VALUES(2, 'Hes A MANAGER is still a manager!?'
);

INSERT INTO HR VALUES(1, 1
);
INSERT INTO HR VALUES(1, 2
);
