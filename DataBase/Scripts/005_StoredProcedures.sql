-- Create stored procedures for common database operations
-- Procedures for restaurants, menus, reservations, and translations

USE RestaurantChain
GO

-- ====================================================================
-- RESTAURANT PROCEDURES
-- ====================================================================

-- Get restaurant details with translations for specific language
CREATE OR ALTER PROCEDURE usp_GetRestaurantByLanguage
    @RestaurantId INT,
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        r.RestaurantId,
        r.Code,
        rt.Name,
        rt.Description,
        r.Address,
        r.City,
        r.Country,
        r.ZipCode,
        r.PhoneNumber,
        r.Email,
        r.OpeningTime,
        r.ClosingTime,
        r.Website,
        rt.LanguageCode
    FROM Restaurants r
    INNER JOIN RestaurantTranslations rt ON r.RestaurantId = rt.RestaurantId
    WHERE r.RestaurantId = @RestaurantId 
        AND rt.LanguageCode = @LanguageCode
        AND r.IsActive = 1
END
GO

-- Get all active restaurants
CREATE OR ALTER PROCEDURE usp_GetAllRestaurants
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        r.RestaurantId,
        r.Code,
        rt.Name,
        rt.Description,
        r.Address,
        r.City,
        r.PhoneNumber,
        r.Email,
        r.OpeningTime,
        r.ClosingTime
    FROM Restaurants r
    INNER JOIN RestaurantTranslations rt ON r.RestaurantId = rt.RestaurantId
    WHERE r.IsActive = 1 
        AND rt.LanguageCode = @LanguageCode
    ORDER BY rt.Name
END
GO

-- ====================================================================
-- MENU PROCEDURES
-- ====================================================================

-- Get menu for restaurant with all items translated
CREATE OR ALTER PROCEDURE usp_GetRestaurantMenu
    @RestaurantId INT,
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        mc.CategoryId,
        mct.Name AS CategoryName,
        mct.Description AS CategoryDescription,
        mi.ItemId,
        mit.Name AS ItemName,
        mit.Description AS ItemDescription,
        mi.Price,
        mi.IsVegetarian,
        mi.IsSpicy,
        mi.IsCosher,
        mi.Allergens,
        mc.DisplayOrder AS CategoryOrder,
        mi.DisplayOrder AS ItemOrder
    FROM MenuCategories mc
    INNER JOIN MenuCategoryTranslations mct ON mc.CategoryId = mct.CategoryId
    INNER JOIN MenuItems mi ON mc.CategoryId = mi.CategoryId
    INNER JOIN MenuItemTranslations mit ON mi.ItemId = mit.ItemId
    WHERE mi.RestaurantId = @RestaurantId 
        AND mc.IsActive = 1 
        AND mi.IsAvailable = 1
        AND mct.LanguageCode = @LanguageCode
        AND mit.LanguageCode = @LanguageCode
    ORDER BY mc.DisplayOrder, mi.DisplayOrder
END
GO

-- Get menu categories that have available items in the restaurant
CREATE OR ALTER PROCEDURE usp_GetMenuCategories
    @RestaurantId INT,
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        mc.CategoryId,
        mct.Name,
        mct.Description,
        mc.DisplayOrder
    FROM MenuCategories mc
    INNER JOIN MenuCategoryTranslations mct ON mc.CategoryId = mct.CategoryId
    WHERE mc.IsActive = 1
        AND mct.LanguageCode = @LanguageCode
        AND EXISTS (
            SELECT 1
            FROM MenuItems mi
            WHERE mi.CategoryId = mc.CategoryId
                AND mi.RestaurantId = @RestaurantId
                AND mi.IsAvailable = 1
        )
    ORDER BY mc.DisplayOrder
END
GO

-- Get menu items by category
CREATE OR ALTER PROCEDURE usp_GetMenuItemsByCategory
    @RestaurantId INT,
    @CategoryId INT,
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        mi.ItemId,
        mit.Name,
        mit.Description,
        mi.Price,
        mi.IsVegetarian,
        mi.IsSpicy,
        mi.IsCosher,
        mi.Allergens,
        mi.DisplayOrder
    FROM MenuItems mi
    INNER JOIN MenuItemTranslations mit ON mi.ItemId = mit.ItemId
    WHERE mi.CategoryId = @CategoryId 
        AND mi.RestaurantId = @RestaurantId
        AND mi.IsAvailable = 1
        AND mit.LanguageCode = @LanguageCode
    ORDER BY mi.DisplayOrder
END
GO

-- Search menu items by name
CREATE OR ALTER PROCEDURE usp_SearchMenuItems
    @RestaurantId INT,
    @SearchTerm NVARCHAR(200),
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        mi.ItemId,
        mit.Name,
        mit.Description,
        mi.Price,
        mi.IsVegetarian,
        mi.IsSpicy,
        mi.IsCosher,
        mct.Name AS CategoryName
    FROM MenuItems mi
    INNER JOIN MenuItemTranslations mit ON mi.ItemId = mit.ItemId
    INNER JOIN MenuCategories mc ON mi.CategoryId = mc.CategoryId
    INNER JOIN MenuCategoryTranslations mct ON mc.CategoryId = mct.CategoryId
    WHERE mi.RestaurantId = @RestaurantId 
        AND mi.IsAvailable = 1
        AND mit.LanguageCode = @LanguageCode
        AND mct.LanguageCode = @LanguageCode
        AND mit.Name LIKE '%' + @SearchTerm + '%'
    ORDER BY mit.Name
END
GO

-- ====================================================================
-- VISITOR PROCEDURES
-- ====================================================================

-- Get a visitor by email
CREATE OR ALTER PROCEDURE usp_GetVisitorByEmail
    @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON

    SELECT VisitorId
    FROM Visitors
    WHERE Email = @Email
END
GO

-- Get an existing visitor by email or create a new one
CREATE OR ALTER PROCEDURE rsn.GetOrCreateVisitor
    @Email NVARCHAR(255),
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @PhoneNumber NVARCHAR(20),
    @PreferredLanguage NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    BEGIN TRY
        BEGIN TRANSACTION

        DECLARE @VisitorId INT

        SELECT @VisitorId = VisitorId
        FROM Visitors WITH (UPDLOCK, HOLDLOCK)
        WHERE Email = @Email

        IF @VisitorId IS NULL
        BEGIN
            INSERT INTO Visitors (Email, FirstName, LastName, PhoneNumber, PreferredLanguage)
            VALUES (@Email, @FirstName, @LastName, @PhoneNumber, @PreferredLanguage)

            SET @VisitorId = CONVERT(INT, SCOPE_IDENTITY())
        END

        COMMIT TRANSACTION

        SELECT @VisitorId AS VisitorId
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION
        END

        DECLARE @ErrorMessage NVARCHAR(2048) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

-- ====================================================================
-- RESERVATION PROCEDURES
-- ====================================================================

-- Create new reservation
CREATE OR ALTER PROCEDURE rsn.CreateReservation
    @VisitorId INT,
    @TableId INT,
    @RestaurantId INT,
    @ReservationDate DATE,
    @ReservationTime TIME,
    @NumberOfGuests INT,
    @ReservationEndTime TIME(7),
    @SpecialRequests NVARCHAR(MAX) = NULL,
    @ReservationId INT OUTPUT,
    @ReservationNumber NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        SET @ReservationNumber = 'RES-' + FORMAT(GETUTCDATE(), 'yyyyMMdd-HHmm') + '-' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS NVARCHAR(10))
        
        INSERT INTO Reservations (VisitorId, TableId, RestaurantId, ReservationNumber, ReservationDate, ReservationTime, NumberOfGuests, ReservationEndTime, SpecialRequests, ReservationStatus)
        VALUES (@VisitorId, @TableId, @RestaurantId, @ReservationNumber, @ReservationDate, @ReservationTime, @NumberOfGuests, @ReservationEndTime, @SpecialRequests, 'Pending')
        
        SET @ReservationId = SCOPE_IDENTITY()
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        THROW
    END CATCH
END
GO

-- Get visitor reservations
CREATE OR ALTER PROCEDURE rsn.GetVisitorReservations
    @VisitorId INT,
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        r.ReservationId,
        r.ReservationNumber,
        r.ReservationStatus,
        r.ReservationDate,
        r.ReservationTime,
        r.NumberOfGuests,
        r.ReservationEndTime,
        rt.Name AS RestaurantName,
        t.TableCode
    FROM Reservations r
    INNER JOIN Restaurants res ON r.RestaurantId = res.RestaurantId
    INNER JOIN RestaurantTranslations rt ON res.RestaurantId = rt.RestaurantId
    INNER JOIN Tables t ON r.TableId = t.TableId
    WHERE r.VisitorId = @VisitorId 
        AND rt.LanguageCode = @LanguageCode
    ORDER BY r.ReservationDate DESC, r.ReservationTime DESC
END
GO

-- Get reservation details
CREATE OR ALTER PROCEDURE rsn.GetReservationDetails
    @ReservationId INT,
    @LanguageCode NVARCHAR(5) = 'en'
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        r.ReservationId,
        r.ReservationNumber,
        r.ReservationStatus,
        r.ReservationDate,
        r.ReservationTime,
        r.NumberOfGuests,
        r.ReservationEndTime,
        r.SpecialRequests,
        rt.Name AS RestaurantName,
        t.TableCode,
        t.Capacity,
        v.FirstName,
        v.LastName,
        v.Email,
        v.PhoneNumber
    FROM Reservations r
    INNER JOIN Restaurants res ON r.RestaurantId = res.RestaurantId
    INNER JOIN RestaurantTranslations rt ON res.RestaurantId = rt.RestaurantId
    INNER JOIN Tables t ON r.TableId = t.TableId
    INNER JOIN Visitors v ON r.VisitorId = v.VisitorId
    WHERE r.ReservationId = @ReservationId 
        AND rt.LanguageCode = @LanguageCode
END
GO

-- Update reservation status
CREATE OR ALTER PROCEDURE rsn.UpdateReservationStatus
    @ReservationId INT,
    @NewStatus NVARCHAR(50),
    @CancellationReason NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON

    UPDATE Reservations
    SET ReservationStatus = @NewStatus, 
        CancellationReason = @CancellationReason,
        UpdatedAt = SYSUTCDATETIME()
    WHERE ReservationId = @ReservationId
END
GO

-- Get available tables for restaurant and time
CREATE OR ALTER PROCEDURE rsn.GetAvailableTables
    @RestaurantId INT,
    @ReservationDate DATE,
    @ReservationTime TIME,
    @RequiredCapacity INT
AS
BEGIN
    SET NOCOUNT ON

    SELECT DISTINCT
        t.TableId,
        t.TableCode,
        t.Capacity
    FROM Tables t
    WHERE t.RestaurantId = @RestaurantId
        AND t.IsActive = 1
        AND t.Capacity >= @RequiredCapacity
        AND t.TableId NOT IN (
            SELECT r.TableId
            FROM Reservations r
            WHERE r.RestaurantId = @RestaurantId
                AND r.ReservationDate = @ReservationDate
                AND r.ReservationStatus IN ('Confirmed', 'Pending')
                AND r.ReservationTime < DATEADD(MINUTE, 120, @ReservationTime)
                AND r.ReservationEndTime > @ReservationTime
        )
    ORDER BY t.Capacity ASC
END
GO

-- ====================================================================
-- REVIEW PROCEDURES
-- ====================================================================

-- Get restaurant reviews
CREATE OR ALTER PROCEDURE usp_GetRestaurantReviews
    @RestaurantId INT,
    @OnlyPublished BIT = 1
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        r.ReviewId,
        r.Rating,
        r.Comment,
        r.ReviewDate,
        v.FirstName,
        v.LastName
    FROM Reviews r
    INNER JOIN Visitors v ON r.VisitorId = v.VisitorId
    WHERE r.RestaurantId = @RestaurantId
        AND (r.IsPublished = @OnlyPublished OR @OnlyPublished = 0)
    ORDER BY r.ReviewDate DESC
END
GO

-- Get average restaurant rating
CREATE OR ALTER PROCEDURE usp_GetRestaurantAverageRating
    @RestaurantId INT,
    @AverageRating DECIMAL(3,2) OUTPUT,
    @ReviewCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    SELECT 
        @AverageRating = AVG(CAST(Rating AS DECIMAL(3,2))),
        @ReviewCount = COUNT(ReviewId)
    FROM Reviews
    WHERE RestaurantId = @RestaurantId AND IsPublished = 1
END
GO

-- Add review
CREATE OR ALTER PROCEDURE usp_AddReview
    @ReservationId INT,
    @VisitorId INT,
    @RestaurantId INT,
    @Rating INT,
    @Comment NVARCHAR(MAX),
    @ReviewId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Validate rating
        IF @Rating < 1 OR @Rating > 5
        BEGIN
            THROW 50001, 'Rating must be between 1 and 5', 1
        END

        IF LTRIM(RTRIM(@Comment)) = ''
        BEGIN
            THROW 50002, 'Review comment cannot be empty', 1
        END
        
        -- Create review
        INSERT INTO Reviews (ReservationId, VisitorId, RestaurantId, Rating, Comment, IsPublished)
        VALUES (@ReservationId, @VisitorId, @RestaurantId, @Rating, @Comment, 0)
        
        SET @ReviewId = SCOPE_IDENTITY()
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        THROW
    END CATCH
END
GO

-- ====================================================================
-- TRANSLATION PROCEDURES
-- ====================================================================

-- Get available languages
CREATE OR ALTER PROCEDURE usp_GetAvailableLanguages
AS
BEGIN
    SET NOCOUNT ON

    SELECT DISTINCT LanguageCode
    FROM RestaurantTranslations
    UNION
    SELECT DISTINCT LanguageCode
    FROM MenuCategoryTranslations
    ORDER BY LanguageCode
END
GO

PRINT 'All stored procedures created/altered successfully!'
GO
