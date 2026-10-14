CREATE DATABASE CafeNetworkDB;
GO

--тексеру1

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

USE CafeNetworkDB;
GO


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
-- Тапсырыс №1
(1, 1, 1, 2500),  -- Палау
(1, 4, 2, 700),   -- Кола x2

-- Тапсырыс №2
(2, 2, 1, 3000),  -- Бешбарма?
(2, 3, 1, 2200),  -- Цезарь
(2, 5, 1, 500),   -- Шай

-- Тапсырыс №3
(3, 1, 1, 2500),  -- Палау
(3, 6, 1, 1800),  -- Чизкейк

-- Тапсырыс №4
(4, 3, 1, 2200),  -- Цезарь
(4, 6, 1, 1800),  -- Чизкейк
(4, 5, 1, 500);   -- Шай



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
-- Орталық филиал
(1, 1, 20),  -- Палау
(1, 2, 15),  -- Бешбармақ
(1, 3, 10),  -- Цезарь
(1, 4, 50),  -- Кола
(1, 5, 100), -- Шай
(1, 6, 12),  -- Чизкейк

-- Солтүстік филиал
(2, 1, 30),
(2, 2, 20),
(2, 3, 15),
(2, 4, 40),
(2, 5, 80),
(2, 6, 10),

-- Оңтүстік филиал
(3, 1, 25),
(3, 2, 18),
(3, 3, 12),
(3, 4, 35),
(3, 5, 70),
(3, 6, 8);

UPDATE Payments
SET PaymentMethod = 'Карта'
WHERE PaymentId= 3;
