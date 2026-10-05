-- Create all database tables with multi-language support (English, Hebrew, Russian)
-- Restaurant Reservation System (Table Booking)

USE RestaurantChain
GO

-- ====================================================================
-- EMPLOYEES Table (Managers and Admins)
-- ====================================================================
CREATE TABLE Employees (
    EmployeeId INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20),
    EmployeeRole NVARCHAR(50) NOT NULL, -- Manager, Admin
    RestaurantId INT, -- NULL for Admin, specific restaurant for Manager
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_EmployeeRole CHECK (EmployeeRole IN ('Manager', 'Admin'))
)
GO

-- ====================================================================
-- VISITORS Table (Customers making table reservations)
-- Email-only authentication (Magic Link or OTP)
-- ====================================================================
CREATE TABLE Visitors (
    VisitorId INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(255) NOT NULL UNIQUE,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    PreferredLanguage NVARCHAR(5) DEFAULT 'en', -- 'en', 'he', 'ru'
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME()
)
GO

-- ====================================================================
-- RESTAURANTS Table
-- ====================================================================
CREATE TABLE Restaurants (
    RestaurantId INT PRIMARY KEY IDENTITY(1,1),
    Code NVARCHAR(50) NOT NULL UNIQUE,
    Address NVARCHAR(500) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    ZipCode NVARCHAR(20),
    PhoneNumber NVARCHAR(20) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Website NVARCHAR(500),
    OpeningTime TIME NOT NULL, -- e.g., 10:00
    ClosingTime TIME NOT NULL, -- e.g., 23:00
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME()
)
GO

-- Add Foreign Key for Employees to Restaurants
ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId) ON DELETE SET NULL
GO

-- ====================================================================
-- TABLES Table (Physical tables in restaurant)
-- ====================================================================
CREATE TABLE Tables (
    TableId INT PRIMARY KEY IDENTITY(1,1),
    RestaurantId INT NOT NULL,
    TableCode NVARCHAR(50) NOT NULL, -- T1, T2, VIP-1, etc.
    Capacity INT NOT NULL, -- Maximum number of guests
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Tables_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId) ON DELETE CASCADE,
    CONSTRAINT UQ_Table_Number UNIQUE (RestaurantId, TableCode)
)
GO

-- ====================================================================
-- RESERVATIONS Table (Table Bookings)
-- ====================================================================
CREATE TABLE Reservations (
    ReservationId INT PRIMARY KEY IDENTITY(1,1),
    VisitorId INT NOT NULL,
    TableId INT NOT NULL,
    RestaurantId INT NOT NULL,
    ReservationNumber NVARCHAR(50) NOT NULL UNIQUE,
    ReservationDate DATE NOT NULL, -- Date of reservation
    ReservationTime TIME(0) NOT NULL, -- Time of reservation
    ReservationEndTime TIME(0) NOT NULL, -- Time the reservation ends
    NumberOfGuests INT NOT NULL, -- How many people
    ReservationStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending, Confirmed, Cancelled, Completed
    SpecialRequests NVARCHAR(MAX), -- High chair, wheelchair access, etc.
    CancellationReason NVARCHAR(MAX),
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Reservations_Visitors FOREIGN KEY (VisitorId) REFERENCES Visitors(VisitorId),
    CONSTRAINT FK_Reservations_Tables FOREIGN KEY (TableId) REFERENCES Tables(TableId),
    CONSTRAINT FK_Reservations_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId),
    CONSTRAINT CHK_ReservationStatuses CHECK (ReservationStatus IN ('Pending', 'Confirmed', 'Cancelled', 'Completed'))
)
GO



-- ====================================================================
-- RESTAURANT TRANSLATIONS (Multi-language support - Name and Description only)
-- ====================================================================
CREATE TABLE RestaurantTranslations (
    RestaurantTranslationId INT PRIMARY KEY IDENTITY(1,1),
    RestaurantId INT NOT NULL,
    LanguageCode NVARCHAR(5) NOT NULL, -- 'en', 'he', 'ru'
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    CONSTRAINT FK_RestaurantTranslations_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId) ON DELETE CASCADE,
    CONSTRAINT UQ_Restaurant_Language UNIQUE (RestaurantId, LanguageCode)
)
GO

-- ====================================================================
-- MENU CATEGORIES Table (shared by all restaurants)
-- ====================================================================
CREATE TABLE MenuCategories (
    CategoryId INT PRIMARY KEY IDENTITY(1,1),
    DisplayOrder INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME()
)
GO

-- ====================================================================
-- MENU CATEGORY TRANSLATIONS (Multi-language support)
-- ====================================================================
CREATE TABLE MenuCategoryTranslations (
    CategoryTranslationId INT PRIMARY KEY IDENTITY(1,1),
    CategoryId INT NOT NULL,
    LanguageCode NVARCHAR(5) NOT NULL, -- 'en', 'he', 'ru'
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    CONSTRAINT FK_MenuCategoryTranslations_Categories FOREIGN KEY (CategoryId) REFERENCES MenuCategories(CategoryId) ON DELETE CASCADE,
    CONSTRAINT UQ_Category_Language UNIQUE (CategoryId, LanguageCode)
)
GO

-- ====================================================================
-- MENU ITEMS Table
-- ====================================================================
CREATE TABLE MenuItems (
    ItemId INT PRIMARY KEY IDENTITY(1,1),
    CategoryId INT NOT NULL,
    RestaurantId INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT 1,
    IsVegetarian BIT NOT NULL DEFAULT 0,
    IsSpicy BIT NOT NULL DEFAULT 0,
    IsCosher BIT NOT NULL DEFAULT 1,
    Allergens NVARCHAR(500),
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_MenuItems_Categories FOREIGN KEY (CategoryId) REFERENCES MenuCategories(CategoryId) ON DELETE CASCADE,
    CONSTRAINT FK_MenuItems_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId) ON DELETE NO ACTION
)
GO

-- ====================================================================
-- MENU ITEM TRANSLATIONS (Multi-language support)
-- ====================================================================
CREATE TABLE MenuItemTranslations (
    ItemTranslationId INT PRIMARY KEY IDENTITY(1,1),
    ItemId INT NOT NULL,
    LanguageCode NVARCHAR(5) NOT NULL, -- 'en', 'he', 'ru'
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    CONSTRAINT FK_MenuItemTranslations_Items FOREIGN KEY (ItemId) REFERENCES MenuItems(ItemId) ON DELETE CASCADE,
    CONSTRAINT UQ_MenuItem_Language UNIQUE (ItemId, LanguageCode)
)
GO

-- ====================================================================
-- REVIEWS Table
-- ====================================================================
CREATE TABLE Reviews (
    ReviewId INT PRIMARY KEY IDENTITY(1,1),
    ReservationId INT NOT NULL UNIQUE,
    VisitorId INT NOT NULL,
    RestaurantId INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(MAX) NOT NULL,
    ReviewDate DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    IsPublished BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2(2) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Reviews_Reservations FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId) ON DELETE CASCADE,
    CONSTRAINT FK_Reviews_Visitors FOREIGN KEY (VisitorId) REFERENCES Visitors(VisitorId),
    CONSTRAINT FK_Reviews_Restaurants FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId) ON DELETE CASCADE
)
GO

PRINT 'All tables created successfully!'
GO
