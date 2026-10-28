CREATE DATABASE CafeNetworkDB;
GO

--тексеру1
--істеді

CREATE TABLE Branches
(
    BranchId INT IDENTITY(1,1) PRIMARY KEY,
    BranchName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(20)
);

CREATE TABLE Roles
(
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE Users
(
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Login NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    RoleId INT NOT NULL,
    BranchId INT NULL,

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),

    CONSTRAINT FK_Users_Branches
        FOREIGN KEY (BranchId) REFERENCES Branches(BranchId)
);


CREATE TABLE Categories
(
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);



CREATE TABLE MenuItems
(
    MenuItemId INT IDENTITY(1,1) PRIMARY KEY,
    ItemName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(300),
    Price DECIMAL(10,2) NOT NULL,
    CategoryId INT NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_MenuItems_Categories
        FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId),

    CONSTRAINT CK_MenuItems_Price
        CHECK (Price >= 0)
);



CREATE TABLE Orders
(
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    BranchId INT NOT NULL,
    ClientName NVARCHAR(100),
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(30) NOT NULL DEFAULT N'?абылданды',
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0,

    CONSTRAINT FK_Orders_Branches
        FOREIGN KEY (BranchId) REFERENCES Branches(BranchId),

    CONSTRAINT CK_Orders_TotalAmount
        CHECK (TotalAmount >= 0)
);



CREATE TABLE OrderItems
(
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    MenuItemId INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),

    CONSTRAINT FK_OrderItems_MenuItems
        FOREIGN KEY (MenuItemId) REFERENCES MenuItems(MenuItemId),

    CONSTRAINT CK_OrderItems_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_OrderItems_Price
        CHECK (Price >= 0)
);



CREATE TABLE Payments
(
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod NVARCHAR(30) NOT NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT N'Т?ленді',

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),

    CONSTRAINT CK_Payments_Amount
        CHECK (Amount >= 0)
);


INSERT INTO Roles (RoleName)
VALUES
(N'Клиент'),
(N'Кассир'),
(N'Официант'),
(N'Ас?й ?ызметкері'),
(N'Филиал менеджері'),
(N'Ж?йе ?кімшісі');


INSERT INTO Branches (BranchName, Address, Phone)
VALUES
(N'Орталы? филиал', N'Алматы ?., Абай к?шесі 10', N'+7 700 111 11 11'),
(N'Солт?стік филиал', N'Алматы ?., Досты? к?шесі 25', N'+7 700 222 22 22'),
(N'О?т?стік филиал', N'Алматы ?., ?л-Фараби да??ылы 50', N'+7 700 333 33 33');


INSERT INTO Categories (CategoryName)
VALUES
(N'Ысты? та?амдар'),
(N'Салаттар'),
(N'Сусындар'),
(N'Десерттер');


INSERT INTO MenuItems
    (ItemName, Description, Price, CategoryId, IsAvailable)
VALUES
(N'Палау', N'?аза?ты? д?ст?рлі та?амы', 2500, 1, 1),
(N'Бешбарма?', N'?лтты? та?ам', 3000, 1, 1),
(N'Цезарь', N'Тауы? еті ?осыл?ан салат', 2200, 2, 1),
(N'Кола', N'Газдал?ан сусын', 700, 3, 1),
(N'Шай', N'?ара шай', 500, 3, 1),
(N'Чизкейк', N'Ірімшік ?осыл?ан десерт', 1800, 4, 1);


SELECT * FROM Branches;
SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Categories;
SELECT * FROM MenuItems;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;
SELECT * FROM BranchInventory;


INSERT INTO Users
    (FullName, Login, Password, RoleId, BranchId)
VALUES
(N'Еділ', N'edil', N'12345', 6, 1),
(N'Айдана', N'aidana', N'12345', 2, 1),
(N'Данияр', N'daniyar', N'12345', 3, 1),
(N'Марат', N'marat', N'12345', 4, 1),
(N'Арман', N'arman', N'12345', 5, 1);



INSERT INTO Users
    (FullName, Login, Password, RoleId, BranchId)
VALUES
(N'Марат', N'marat', N'12345', 4, 1),
(N'Арман', N'arman', N'12345', 5, 1),
(N'Аружан', N'aruzhan', N'12345', 2, 2),
(N'Н?рлан', N'nurlan', N'12345', 3, 2);


INSERT INTO Orders
    (BranchId, ClientName, OrderDate, Status, TotalAmount)
VALUES
(1, N'Дінм?хаммед', '2026-10-05 10:15:00', N'?абылданды', 3900),
(1, N'Аружан',       '2026-10-05 11:30:00', N'Дайындалуда', 5500),
(2, N'Ермек',        '2026-10-05 12:10:00', N'Дайын', 3700),
(2, N'Айша',         '2026-10-05 12:45:00', N'Т?ленді', 4300);



INSERT INTO OrderItems
    (OrderId, MenuItemId, Quantity, Price)
VALUES
(1, 1, 1, 2500),  
(1, 4, 2, 700),   

(2, 2, 1, 3000),  
(2, 3, 1, 2200),  
(2, 5, 1, 500),   

(3, 1, 1, 2500),  
(3, 6, 1, 1800),  

(4, 3, 1, 2200),  
(4, 6, 1, 1800),  
(4, 5, 1, 500);   



INSERT INTO Payments
    (OrderId, PaymentDate, Amount, PaymentMethod, Status)
VALUES
(1, '2026-10-05 10:20:00', 3900, N'Kaspi', N'Т?ленді'),
(2, '2026-10-05 11:40:00', 5700, N'Карта', N'Т?ленді'),
(3, '2026-10-05 12:20:00', 4300, N'?олма-?ол', N'Т?ленді'),
(4, '2026-10-05 12:55:00', 4500, N'Kaspi', N'Т?ленді');



CREATE TABLE BranchInventory
(
    InventoryId INT IDENTITY(1,1) PRIMARY KEY,

    BranchId INT NOT NULL,
    MenuItemId INT NOT NULL,

    Quantity INT NOT NULL DEFAULT 0,

    CONSTRAINT FK_BranchInventory_Branches
        FOREIGN KEY (BranchId)
        REFERENCES Branches(BranchId),

    CONSTRAINT FK_BranchInventory_MenuItems
        FOREIGN KEY (MenuItemId)
        REFERENCES MenuItems(MenuItemId),

    CONSTRAINT CK_BranchInventory_Quantity
        CHECK (Quantity >= 0),

    CONSTRAINT UQ_BranchInventory
        UNIQUE (BranchId, MenuItemId)
);

INSERT INTO BranchInventory (BranchId, MenuItemId, Quantity)
VALUES
(1, 1, 20),  
(1, 2, 15), 
(1, 3, 10),  
(1, 4, 50),  
(1, 5, 100), 
(1, 6, 12),  

(2, 1, 30),
(2, 2, 20),
(2, 3, 15),
(2, 4, 40),
(2, 5, 80),
(2, 6, 10),

(3, 1, 25),
(3, 2, 18),
(3, 3, 12),
(3, 4, 35),
(3, 5, 70),
(3, 6, 8);

UPDATE Payments
SET PaymentMethod = 'Карта'
WHERE PaymentId= 3;


INSERT INTO Categories (CategoryName)
VALUES
(N'Фастфуд'),
(N'Гарнирлер'),
(N'Таңғы ас');

INSERT INTO MenuItems
    (ItemName, Description, Price, CategoryId, IsAvailable)
VALUES
(N'Қуырдақ', N'Қазақтың дәстүрлі ет тағамы', 2800, 1, 1),
(N'Көкөніс салаты', N'Жаңа піскен көкөністер', 1500, 2, 1),
(N'Апельсин шырыны', N'Табиғи жеміс шырыны', 900, 3, 1),
(N'Балмұздақ', N'Ванильді балмұздақ', 800, 4, 1),
(N'Чизбургер', N'Ірімшік қосылған бургер', 1700, 5, 1),
(N'Картоп фри', N'Қуырылған картоп', 1000, 6, 1),
(N'Омлет', N'Жұмыртқадан дайындалған таңғы ас', 1200, 7, 1);



ALTER TABLE Orders
DROP CONSTRAINT FK_Orders_Users;
GO

ALTER TABLE Orders
DROP COLUMN EmployeeId;
GO

INSERT INTO BranchInventory (BranchId, MenuItemId, Quantity)
VALUES
(1, 7, 15),
(1, 8, 20),
(1, 9, 40),
(1, 10, 15),
(1, 11, 25),
(1, 12, 30),
(1, 13, 20),

(2, 7, 20),
(2, 8, 15),
(2, 9, 30),
(2, 10, 10),
(2, 11, 20),
(2, 12, 25),
(2, 13, 15),

(3, 7, 12),
(3, 8, 18),
(3, 9, 25),
(3, 10, 12),
(3, 11, 15),
(3, 12, 20),
(3, 13, 10);


INSERT INTO Orders
    (BranchId, ClientName, Status, TotalAmount)
VALUES
    (1, N'Әлихан', N'Қабылданды', 4600);


UPDATE Orders
SET TotalAmount = 3700
WHERE OrderId = 5;



SELECT Orders.ClientName ,Orders.TotalAmount as taps
FROM Orders JOIN Branches
ON Orders.BranchId = Branches.BranchId
ON Categories.Category

GROUP BY Orders.ClientName , Orders.TotalAmount, Branches.BranchId
HAVING Orders.TotalAmount > 3800 AND Branches.BranchId=1;




SELECT * FROM Branches;
SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Categories;
SELECT * FROM MenuItems;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;
SELECT * FROM BranchInventory;


SELECT ItemName,Price from MenuItems
WHERE Price > 2000;

SELECT DISTINCT Status
FROM Orders;

SELECT DISTINCT PaymentMethod
FROM Payments;

SELECT ItemName, Price
FROM MenuItems
ORDER BY Price ASC;


SELECT Categories.CategoryName , COUNT(MenuItems.MenuItemId) AS sany
FROM Categories JOIN MenuItems
ON Categories.CategoryId = MenuItems.CategoryId 
GROUP BY Categories.CategoryId , Categories.CategoryName 

SELECT MAX(Price), MIN(Price), SUM(Price) FROM MenuItems

SELECT c.CategoryName, COUNT(m.MenuItemId) AS aaa
FROM Categories c
JOIN MenuItems m
ON c.CategoryId = m.CategoryId
GROUP BY c.CategoryId, c.CategoryName
HAVING COUNT(m.MenuItemId) >= 2;


SELECT Orders.OrderId AS [Тапсырыс нөмірі],
Orders.ClientName AS [Клиент],
Orders.OrderDate AS [Тапсырыс уақыты],
Users.FullName AS [Кассир],
Roles.RoleName AS [Рөлі]
FROM Orders
INNER JOIN Users ON Orders.CashierId = Users.UserId
INNER JOIN Roles ON Users.RoleId = Roles.RoleId
WHERE Roles.RoleId = 2;




SELECT * FROM Branches;
SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Categories;
SELECT * FROM MenuItems;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Payments;
SELECT * FROM BranchInventory;


SELECT
OrderId AS [Тапсырыс],
ClientName AS [Клиент],
Status AS [Бастапқы мәртебе],
CASE
  WHEN Status = N'Қабылданды'
     THEN N'Кезекте'
  WHEN Status = N'Дайындалуда'
     THEN N'Асүйде дайындалып жатыр'
  WHEN Status = N'Дайын'
     THEN N'Беруге дайын'
  WHEN Status = N'Төленді'
     THEN N'Төлем жасалған'
  ELSE N'Басқа мәртебе'
END AS [Түсіндірме]
FROM Orders;

