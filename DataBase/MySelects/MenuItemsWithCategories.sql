select mi.[ItemId]
      ,[mit].[Name]
      ,[mi].[CategoryId]
      ,[mct].[Name] as Category
      ,[RestaurantId]
      ,[Price]
      ,[IsAvailable]
      ,[IsVegetarian]
      ,[IsSpicy]
      ,[IsCosher]
from [dbo].[MenuItems] mi
join [dbo].[MenuItemTranslations] mit on mit.ItemId = mi.ItemId

join [dbo].[MenuCategories] mc on mc.CategoryId = mi.CategoryId
join [dbo].[MenuCategoryTranslations] mct on mc.CategoryId = mct.CategoryId and mct.LanguageCode = mit.LanguageCode

where mit.LanguageCode = 'en'
and mi.RestaurantId = 2

order by CategoryId

