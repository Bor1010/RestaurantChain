# RestaurantChain Database Setup Guide

## Overview

This database is designed for a multi-location restaurant chain website with full multi-language support (English, Hebrew, Russian) and RTL support for Hebrew.

## Architecture

The database includes:
- **Restaurants**: Multi-location support
- **Multi-language Translations**: All content in English, Hebrew, and Russian
- **Menu Management**: Categories and items with translations
- **User Management**: Customers and staff
- **Order Management**: Complete order tracking
- **Review System**: Customer reviews and ratings

## Directory Structure

```
DataBase/
├── scripts/
│   ├── 001_InitialSchema.sql      - Database initialization
│   ├── 002_CreateTables.sql       - All tables with relationships
│   ├── 003_AddIndexes.sql         - Performance indexes
│   ├── 004_SeedData.sql           - Sample data (3 restaurants, 46 menu items)
│   ├── 005_StoredProcedures.sql   - Common database operations
│   └── README.md                  - This file
├── setup.sql                       - Master script (runs all scripts in order)
└── backups/                        - Backup files location

```

## Quick Start

### Prerequisites
- SQL Server Express (installed locally)
- SQL Server Management Studio (SSMS)

### Installation Steps

1. **Open SQL Server Management Studio**

2. **Enable SQLCMD Mode**
   - Menu: **Query** → **SQLCMD Mode** (enable the checkbox)

3. **Open the master setup script**
   - File: `setup.sql`

4. **Run the script**
   - Press **F5** or **Ctrl+Shift+E**

5. **Verify the database**
   - Right-click **Databases** in Object Explorer
   - Should see **RestaurantChain** database

## Database Schema

### Core Tables

#### 1. **Restaurants**
- RestaurantId (PK)
- Code (unique restaurant code)
- IsActive (status)
- Timestamps

#### 2. **RestaurantTranslations** (Multi-language)
- Stores Name, Description, Address, Contact Info
- Languages: 'en' (English), 'he' (Hebrew), 'ru' (Russian)
- One record per language per restaurant

#### 3. **MenuCategories**
- CategoryId (PK)
- RestaurantId (FK)
- DisplayOrder (for sorting)
- IsActive, Timestamps

#### 4. **MenuCategoryTranslations** (Multi-language)
- CategoryId (FK)
- LanguageCode ('en', 'he', 'ru')
- Name and Description in each language

#### 5. **MenuItems**
- ItemId (PK)
- CategoryId (FK)
- Price (decimal)
- Flags: IsVegetarian, IsSpicy, IsAvailable
- Allergens list

#### 6. **MenuItemTranslations** (Multi-language)
- ItemId (FK)
- LanguageCode ('en', 'he', 'ru')
- Name and Description in each language

#### 7. **Users**
- UserId (PK)
- Email (unique)
- PasswordHash
- UserRole: 'Customer', 'Manager', 'Admin'

#### 8. **Orders**
- OrderId (PK)
- UserId (FK)
- RestaurantId (FK)
- OrderNumber (unique)
- OrderStatus: Pending, Confirmed, Preparing, Ready, Completed, Cancelled
- TotalAmount, Timestamps

#### 9. **OrderItems**
- OrderItemId (PK)
- OrderId (FK)
- ItemId (FK)
- Quantity, UnitPrice, TotalPrice

#### 10. **Reviews**
- ReviewId (PK)
- VisitorId (FK)
- RestaurantId (FK)
- Rating (1-5)
- Comment (free text, any language)
- IsPublished

#### 11. **(Removed)** ReviewTranslations
- Reviews are stored as-is in the parent record.
- Clients can write reviews in any language without per-language duplication.

## Sample Data Included

The `004_SeedData.sql` script creates:

### Restaurants (3 sample restaurants)
1. **Mediterranean Delights** (Tel Aviv)
2. **Kosher Kitchen** (Jerusalem)
3. **Grill Master** (Tel Aviv)

### Menu Items (10 sample items)
- Hummus
- Greek Salad
- Spicy Falafel
- Grilled Salmon
- Sea Bass
- Vegetable Moussaka
- Baklava
- Fruit Salad
- Orange Juice
- Red Wine

All menu items have translations in **English, Hebrew, and Russian**.

### Sample Users (5 users)
- 1 Admin user
- 1 Manager user
- 3 Customer users

## Stored Procedures

### Restaurant Operations
- `sp_GetRestaurantByLanguage` - Get restaurant details
- `sp_GetAllRestaurants` - List all active restaurants

### Menu Operations
- `sp_GetRestaurantMenu` - Get full menu for a restaurant
- `sp_GetMenuItemsByCategory` - Get items in a category
- `sp_SearchMenuItems` - Search items by name

### Visitor Operations
- `sp_GetVisitorByEmail` - Find a visitor by email
- `sp_GetOrCreateVisitor` - Return an existing visitor ID or create a visitor and return its ID

### Order Operations
- `sp_CreateOrder` - Create new order
- `sp_GetUserOrders` - Get user's order history
- `sp_GetOrderDetails` - Get order line items
- `sp_UpdateOrderStatus` - Update order status

### Review Operations
- `sp_GetRestaurantReviews` - Get restaurant reviews
- `sp_GetRestaurantAverageRating` - Calculate average rating
- `sp_AddReview` - Add a new review with a single comment field

### Utility
- `sp_GetAvailableLanguages` - List available languages

## Multi-Language Support

### Language Codes
- `'en'` - English
- `'he'` - Hebrew (RTL)
- `'ru'` - Russian

### Implementation
- All user-facing content (names, descriptions) stored in separate translation tables
- Each restaurant, menu category, and menu item has one record per language
- Stored procedures accept `@LanguageCode` parameter for filtering

### Frontend Integration
For React/VITE frontend:
```javascript
// Example API call
fetch(`/api/restaurant/1?language=he`)
  .then(res => res.json())
  .then(data => {
    // Hebrew data with RTL support
    document.documentElement.lang = 'he';
    document.documentElement.dir = 'rtl';
  })
```

## Indexes for Performance

The database includes optimized indexes on:
- User search fields (Email)
- Restaurant filtering (Code, IsActive)
- Menu searches (Category, IsAvailable)
- Order lookups (UserId, RestaurantId, OrderDate)
- Review filtering (RestaurantId, Rating, IsPublished)

## Database Backups

Create regular backups:

```sql
-- Backup database
BACKUP DATABASE RestaurantChain
TO DISK = 'C:\path\to\DataBase\backups\RestaurantChain_YYYYMMDD.bak'
WITH INIT, COMPRESSION
GO

-- Restore database
RESTORE DATABASE RestaurantChain
FROM DISK = 'C:\path\to\DataBase\backups\RestaurantChain_YYYYMMDD.bak'
WITH REPLACE
GO
```

## Common Tasks

### Get all menu items for a restaurant in Hebrew
```sql
EXEC sp_GetRestaurantMenu @RestaurantId = 1, @LanguageCode = 'he'
```

### Search menu items
```sql
EXEC sp_SearchMenuItems @RestaurantId = 1, @SearchTerm = 'Fish', @LanguageCode = 'en'
```

### Add a customer review
```sql
EXEC sp_AddReview 
    @VisitorId = 3,
    @RestaurantId = 1,
    @Rating = 5,
    @Comment = N'Отличная еда и обслуживание!'
```

### Get restaurant average rating
```sql
DECLARE @Avg DECIMAL(3,2), @Count INT
EXEC sp_GetRestaurantAverageRating @RestaurantId = 1, @AverageRating = @Avg OUTPUT, @ReviewCount = @Count OUTPUT
SELECT @Avg AS AverageRating, @Count AS TotalReviews
```

## Connection String (ASP.NET Core)

For your C# backend:

```csharp
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=RestaurantChain;Trusted_Connection=true;Encrypt=false;"
}
```

Or with SQL authentication:
```csharp
"DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=RestaurantChain;User Id=sa;Password=YourPassword;Encrypt=false;"
```

## Troubleshooting

### "Cannot find directory" error
- Ensure SQLCMD Mode is enabled (Query → SQLCMD Mode)
- Verify the scripts folder path is correct

### "Database already exists" error
- The script will drop existing database on first run
- This is intentional for development setup

### Connection failed
- Verify SQL Server is running
- Check instance name: `localhost\SQLEXPRESS`
- Ensure database name: `RestaurantChain`

## Next Steps

1. ✅ Database created and populated with sample data
2. 📝 Create Entity Framework Core DbContext (C# backend)
3. 🌐 Set up ASP.NET Core Web API controllers
4. ⚛️ Build React frontend with multi-language support
5. 🔐 Implement authentication and authorization

## Contact & Support

For questions about the database structure or stored procedures, refer to the SQL comments in each script file.

---

**Last Updated**: 2026-08-18
**Language Codes**: English (en), Hebrew (he), Russian (ru)
**SQL Server Version**: SQL Server Express
