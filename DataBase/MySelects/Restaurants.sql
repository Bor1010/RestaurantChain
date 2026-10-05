
SELECT TOP (1000) r.[RestaurantId]
      ,rt.[Name]
      ,[Code]
      ,[Address]
      ,[City]
      ,[Country]
      ,[ZipCode]
      ,[PhoneNumber]
      ,[Email]
      ,[Website]
      ,[OpeningTime]
      ,[ClosingTime]
      ,[IsActive]
      ,[CreatedAt]
      ,[UpdatedAt]
  FROM [RestaurantChain].[dbo].[Restaurants] r
  join [RestaurantTranslations] rt on r.RestaurantId = rt.RestaurantId
  where rt.LanguageCode = 'ru'