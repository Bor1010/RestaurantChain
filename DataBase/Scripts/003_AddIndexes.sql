-- Create indexes for performance optimization
-- Indexes on frequently searched and joined columns

USE RestaurantChain
GO

-- ====================================================================
-- EMPLOYEES Indexes (Email is already covered by its UNIQUE constraint)
-- ====================================================================
CREATE INDEX IX_Employees_IsActive ON Employees(IsActive)
GO

CREATE INDEX IX_Employees_RestaurantId ON Employees(RestaurantId)
GO

-- ====================================================================
-- VISITORS Indexes (Email is already covered by its UNIQUE constraint)
-- ====================================================================
CREATE INDEX IX_Visitors_IsActive ON Visitors(IsActive)
GO

CREATE INDEX IX_Visitors_PhoneNumber ON Visitors(PhoneNumber)
GO

-- ====================================================================
-- RESTAURANTS Indexes (Code is already covered by its UNIQUE constraint)
-- ====================================================================
CREATE INDEX IX_Restaurants_IsActive ON Restaurants(IsActive)
GO

CREATE INDEX IX_Restaurants_City ON Restaurants(City)
GO

-- ====================================================================
-- RESTAURANT TRANSLATIONS Indexes
-- ====================================================================
CREATE INDEX IX_RestaurantTranslations_RestaurantId ON RestaurantTranslations(RestaurantId)
GO

CREATE INDEX IX_RestaurantTranslations_LanguageCode ON RestaurantTranslations(LanguageCode)
GO

-- ====================================================================
-- MENU CATEGORIES Indexes
-- ====================================================================
CREATE INDEX IX_MenuCategories_IsActive ON MenuCategories(IsActive)
GO

CREATE INDEX IX_MenuCategories_DisplayOrder ON MenuCategories(DisplayOrder)
GO

-- ====================================================================
-- MENU CATEGORY TRANSLATIONS Indexes
-- ====================================================================
CREATE INDEX IX_MenuCategoryTranslations_CategoryId ON MenuCategoryTranslations(CategoryId)
GO

CREATE INDEX IX_MenuCategoryTranslations_LanguageCode ON MenuCategoryTranslations(LanguageCode)
GO

-- ====================================================================
-- MENU ITEMS Indexes
-- ====================================================================
CREATE INDEX IX_MenuItems_CategoryId ON MenuItems(CategoryId)
GO

CREATE INDEX IX_MenuItems_RestaurantId ON MenuItems(RestaurantId)
GO

CREATE INDEX IX_MenuItems_IsAvailable ON MenuItems(IsAvailable)
GO

CREATE INDEX IX_MenuItems_DisplayOrder ON MenuItems(DisplayOrder)
GO

-- Composite index for restaurant menu search
CREATE INDEX IX_MenuItems_Restaurant_Available ON MenuItems(RestaurantId, IsAvailable)
GO

-- ====================================================================
-- MENU ITEM TRANSLATIONS Indexes
-- ====================================================================
CREATE INDEX IX_MenuItemTranslations_ItemId ON MenuItemTranslations(ItemId)
GO

CREATE INDEX IX_MenuItemTranslations_LanguageCode ON MenuItemTranslations(LanguageCode)
GO

-- ====================================================================
-- TABLES Indexes
-- ====================================================================
CREATE INDEX IX_Tables_RestaurantId ON Tables(RestaurantId)
GO

CREATE INDEX IX_Tables_IsActive ON Tables(IsActive)
GO

-- Composite index for restaurant tables and availability
CREATE INDEX IX_Tables_Restaurant_Active ON Tables(RestaurantId, IsActive)
GO

-- ====================================================================
-- RESERVATIONS Indexes
-- ====================================================================
CREATE INDEX IX_Reservations_VisitorId ON Reservations(VisitorId)
GO

CREATE INDEX IX_Reservations_RestaurantId ON Reservations(RestaurantId)
GO

CREATE INDEX IX_Reservations_ReservationDate ON Reservations(ReservationDate)
GO

CREATE INDEX IX_Reservations_ReservationStatus ON Reservations(ReservationStatus)
GO

-- Composite index for finding available tables
CREATE INDEX IX_Reservations_Restaurant_Date_Status ON Reservations(RestaurantId, ReservationDate, ReservationStatus)
GO

-- Composite index for visitor reservations
CREATE INDEX IX_Reservations_Visitor_Date ON Reservations(VisitorId, ReservationDate)
GO

-- ====================================================================
-- REVIEWS Indexes
-- ====================================================================
CREATE INDEX IX_Reviews_VisitorId ON Reviews(VisitorId)
GO

CREATE INDEX IX_Reviews_RestaurantId ON Reviews(RestaurantId)
GO

CREATE INDEX IX_Reviews_Rating ON Reviews(Rating)
GO

CREATE INDEX IX_Reviews_IsPublished ON Reviews(IsPublished)
GO

-- Composite index for restaurant reviews
CREATE INDEX IX_Reviews_Restaurant_Published ON Reviews(RestaurantId, IsPublished)
GO

PRINT 'All indexes created successfully!'
GO
