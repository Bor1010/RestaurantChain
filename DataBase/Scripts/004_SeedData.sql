-- Seed initial data with multi-language support
-- Sample data for restaurants, tables, reservations in English, Hebrew, and Russian

USE RestaurantChain
GO

-- ====================================================================
-- Insert Sample Restaurants FIRST (before foreign keys reference them)
-- ====================================================================
INSERT INTO Restaurants (Code, Address, City, Country, ZipCode, PhoneNumber, Email, Website, OpeningTime, ClosingTime, IsActive)
VALUES
    ('REST-001', '123 Ben Yehuda St', 'Tel Aviv', 'Israel', '61234', '+972-3-5555555', 'info@meddelights.co.il', 'www.meddelights.co.il', '10:00:00', '23:00:00', 1),
    ('REST-002', '456 King George St', 'Jerusalem', 'Israel', '94226', '+972-2-6666666', 'info@kosherkitchen.co.il', 'www.kosherkitchen.co.il', '11:00:00', '22:00:00', 1),
    ('REST-003', '789 Ibn Gabirol St', 'Tel Aviv', 'Israel', '62765', '+972-3-7777777', 'info@grillmaster.co.il', 'www.grillmaster.co.il', '12:00:00', '23:59:00', 1)
GO

-- ====================================================================
-- Insert Sample Employees (Managers and Admins)
-- ====================================================================
INSERT INTO Employees (Email, PasswordHash, FirstName, LastName, PhoneNumber, EmployeeRole, RestaurantId, IsActive)
VALUES
    ('admin@restaurant.com', 'hashed_password_admin', 'Admin', 'User', '+972-2-1234567', 'Admin', NULL, 1),
    ('manager1@restaurant.com', 'hashed_password_manager1', 'Manager', 'One', '+972-2-1234568', 'Manager', 1, 1),
    ('manager2@restaurant.com', 'hashed_password_manager2', 'Manager', 'Two', '+972-2-1234569', 'Manager', 2, 1),
    ('manager3@restaurant.com', 'hashed_password_manager3', 'Manager', 'Three', '+972-2-1234570', 'Manager', 3, 1)
GO

-- ====================================================================
-- Insert Sample Visitors (Customers making reservations)
-- Email-only, no password
-- ====================================================================
INSERT INTO Visitors (Email, FirstName, LastName, PhoneNumber, PreferredLanguage, IsActive)
VALUES
    ('david.cohen@email.com', 'David', 'Cohen', '+972-50-1234567', 'he', 1),
    ('sarah.levy@email.com', 'Sarah', 'Levy', '+972-50-1234568', 'he', 1),
    ('ivan.petrov@email.com', 'Ivan', 'Petrov', '+972-50-1234569', 'ru', 1),
    ('john.smith@email.com', 'John', 'Smith', '+972-50-1234570', 'en', 1)
GO

-- ====================================================================
-- Insert Restaurant Translations (English, Hebrew, Russian - Name and Description only)
-- ====================================================================
INSERT INTO RestaurantTranslations (RestaurantId, LanguageCode, Name, Description)
VALUES
    -- Restaurant 1 - English
    (1, 'en', 'Mediterranean Delights', 'Authentic Mediterranean cuisine with fresh ingredients'),
    -- Restaurant 1 - Hebrew
    (1, 'he', N'תענוגות ים תיכון', N'מטבח אותנטי תיכוני עם מרכיבים טריים'),
    -- Restaurant 1 - Russian
    (1, 'ru', N'Средиземноморские Радости', N'Аутентичная средиземноморская кухня со свежими ингредиентами'),

    -- Restaurant 2 - English
    (2, 'en', 'Kosher Kitchen', 'Premium kosher restaurant with family traditions'),
    -- Restaurant 2 - Hebrew
    (2, 'he', N'מטבח כשר', N'מסעדה כשרה פרימיום עם מסורות משפחתיות'),
    -- Restaurant 2 - Russian
    (2, 'ru', N'Кошерная Кухня', N'Премиальный кошерный ресторан с семейными традициями'),

    -- Restaurant 3 - English
    (3, 'en', 'Grill Master', 'BBQ and grilled specialties'),
    -- Restaurant 3 - Hebrew
    (3, 'he', N'מאסטר גריל', N'התמחויות BBQ וצלייה'),
    -- Restaurant 3 - Russian
    (3, 'ru', N'Мастер Гриля', N'Барбекю и специальные блюда на гриле')
GO

-- ====================================================================
-- Insert Sample Tables for each Restaurant
-- ====================================================================
INSERT INTO Tables (RestaurantId, TableCode, Capacity, IsActive)
VALUES
    -- Restaurant 1 tables
    (1, 'T1', 2, 1),
    (1, 'T2', 2, 1),
    (1, 'T3', 4, 1),
    (1, 'T4', 4, 1),
    (1, 'T5', 6, 1),
    (1, 'VIP-1', 8, 1),
    -- Restaurant 2 tables
    (2, 'T1', 2, 1),
    (2, 'T2', 4, 1),
    (2, 'T3', 6, 1),
    (2, 'T4', 6, 1),
    (2, 'VIP-1', 10, 1),
    -- Restaurant 3 tables
    (3, 'T1', 4, 1),
    (3, 'T2', 4, 1),
    (3, 'T3', 6, 1),
    (3, 'T4', 8, 1),
    (3, 'T5', 8, 1)
GO

-- ====================================================================
-- Insert Sample Reservations
-- ====================================================================
INSERT INTO Reservations (VisitorId, TableId, RestaurantId, ReservationNumber, ReservationDate, ReservationTime, NumberOfGuests, ReservationEndTime, ReservationStatus, SpecialRequests)
VALUES
    -- Dates are relative to the setup day so seed reservations are always in the future
    -- Reservation 1: David Cohen at Mediterranean Delights for 2 people (table 1, capacity 2)
    (1, 1, 1, 'RES-SEED-001', CAST(DATEADD(DAY, 1, SYSUTCDATETIME()) AS DATE), '19:00:00', 2, '21:00:00', 'Confirmed', NULL),
    -- Reservation 2: Sarah Levy at Kosher Kitchen for 4 people (table 8, capacity 4)
    (2, 8, 2, 'RES-SEED-002', CAST(DATEADD(DAY, 2, SYSUTCDATETIME()) AS DATE), '20:00:00', 4, '22:00:00', 'Confirmed', 'Kosher certified'),
    -- Reservation 3: Ivan Petrov at Grill Master for 6 people (table 14, capacity 6)
    (3, 14, 3, 'RES-SEED-003', CAST(DATEADD(DAY, 3, SYSUTCDATETIME()) AS DATE), '18:30:00', 6, '21:00:00', 'Pending', 'Birthday celebration'),
    -- Reservation 4: John Smith at Mediterranean Delights for 2 people (table 2, capacity 2)
    (4, 2, 1, 'RES-SEED-004', CAST(DATEADD(DAY, 4, SYSUTCDATETIME()) AS DATE), '19:30:00', 2, '21:30:00', 'Confirmed', 'Window seating preferred')
GO

-- ====================================================================
-- Insert Menu Categories (shared by all restaurants)
-- ====================================================================
INSERT INTO MenuCategories (DisplayOrder, IsActive)
VALUES
    (1, 1), -- 1: Appetizers
    (2, 1), -- 2: Main Courses
    (3, 1), -- 3: Sides
    (4, 1), -- 4: Desserts
    (5, 1)  -- 5: Beverages
GO

-- ====================================================================
-- Insert Menu Category Translations
-- ====================================================================
INSERT INTO MenuCategoryTranslations (CategoryId, LanguageCode, Name, Description)
VALUES
    -- Appetizers
    (1, 'en', 'Appetizers', 'Fresh starters to begin your meal'),
    (1, 'he', N'מנות פתיחה', N'מנות פתיחה טריות לתחילת הארוחה'),
    (1, 'ru', N'Закуски', N'Свежие закуски для начала трапезы'),
    
    -- Main Courses
    (2, 'en', 'Main Courses', 'Signature dishes and specialties'),
    (2, 'he', N'מנות עיקריות', N'מנות חתימה והתמחויות'),
    (2, 'ru', N'Основные Блюда', N'Фирменные блюда и специальности'),
    
    -- Sides
    (3, 'en', 'Sides', 'Accompaniments, sauces and more'),
    (3, 'he', N'תוספות', N'תוספות, רטבים ועוד'),
    (3, 'ru', N'Гарниры', N'Гарниры, соусы и другое'),
    
    -- Desserts
    (4, 'en', 'Desserts', 'Sweet treats to complete your meal'),
    (4, 'he', N'קינוחים', N'פינוקים מתוקים לסיום הארוחה'),
    (4, 'ru', N'Десерты', N'Сладкие угощения для завершения трапезы'),
    
    -- Beverages
    (5, 'en', 'Beverages', 'Soft drinks, wines, and cocktails'),
    (5, 'he', N'משקאות', N'משקאות קלים, יינות וקוקטיילים'),
    (5, 'ru', N'Напитки', N'Безалкогольные напитки, вина и коктейли')
    

    

    

    

    

    

GO

-- ====================================================================
-- Insert Menu Items (Restaurant 1)
-- ====================================================================
INSERT INTO MenuItems (CategoryId, RestaurantId, Price, IsAvailable, IsVegetarian, IsSpicy, DisplayOrder)
VALUES
    -- Appetizers (Category 1)
    (1, 1, 45.00, 1, 0, 0, 1),  -- Hummus
    (1, 1, 50.00, 1, 1, 0, 2),  -- Greek Salad
    (1, 1, 55.00, 1, 0, 1, 3),  -- Spicy Falafel
    -- Main Courses (Category 2)
    (2, 1, 120.00, 1, 0, 0, 1), -- Grilled Salmon
    (2, 1, 100.00, 1, 0, 0, 2), -- Sea Bass
    (2, 1, 110.00, 1, 1, 0, 3), -- Vegetable Moussaka
    -- Desserts (Category 4)
    (4, 1, 35.00, 1, 1, 0, 1),  -- Baklava
    (4, 1, 30.00, 1, 1, 0, 2),  -- Fruit Salad
    -- Beverages (Category 5)
    (5, 1, 12.00, 1, 1, 0, 1),  -- Orange Juice
    (5, 1, 25.00, 1, 1, 0, 2)   -- Red Wine
GO

-- ====================================================================
-- Insert Menu Item Translations (Restaurant 1)
-- ====================================================================
INSERT INTO MenuItemTranslations (ItemId, LanguageCode, Name, Description)
VALUES
    -- Hummus
    (1, 'en', 'Hummus', 'Creamy chickpea spread with tahini and olive oil'),
    (1, 'he', N'חומוס', N'משחת חומוס קרימית עם טחינה ושמן זית'),
    (1, 'ru', N'Хумус', N'Кремовый паштет из нута с тахини и оливковым маслом'),
    
    -- Greek Salad
    (2, 'en', 'Greek Salad', 'Fresh tomatoes, cucumbers, feta cheese and olives'),
    (2, 'he', N'סלט יווני', N'עגבניות טריות, מלפפונים, גבינת פטה וזיתים'),
    (2, 'ru', N'Греческий Салат', N'Свежие помидоры, огурцы, сыр фета и оливки'),
    
    -- Spicy Falafel
    (3, 'en', 'Spicy Falafel', 'Deep-fried chickpea balls with warm spices'),
    (3, 'he', N'פלאפל חריף', N'כדורי חומוס מטוגנים עם תבלינים חמים'),
    (3, 'ru', N'Острый Фалафель', N'Жареные шарики из нута с острыми специями'),
    
    -- Grilled Salmon
    (4, 'en', 'Grilled Salmon', 'Atlantic salmon grilled to perfection with lemon butter'),
    (4, 'he', N'סלמון צלוי', N'סלמון אטלנטי צלוי לשלמות עם חמאת לימון'),
    (4, 'ru', N'Филе Лосося на Гриле', N'Атлантический лосось, идеально приготовленный на гриле с лимонным маслом'),
    
    -- Sea Bass
    (5, 'en', 'Sea Bass', 'Fresh sea bass with Mediterranean herbs'),
    (5, 'he', N'דניס', N'דניס טרי עם עשבי תיבול תיכוניים'),
    (5, 'ru', N'Морской Окунь', N'Свежий морской окунь со средиземноморскими травами'),
    
    -- Vegetable Moussaka
    (6, 'en', 'Vegetable Moussaka', 'Layers of aubergine, zucchini and béchamel sauce'),
    (6, 'he', N'מוסקה ירקות', N'שכבות של חציל, קישואים ורוטב בשמל'),
    (6, 'ru', N'Мусака из Овощей', N'Слои баклажанов, цукини и бешамеля'),
    
    -- Baklava
    (7, 'en', 'Baklava', 'Crispy pastry with walnuts and honey syrup'),
    (7, 'he', N'בקלאווה', N'בצק פריך עם אגוזים וסירופ דבש'),
    (7, 'ru', N'Пахлава', N'Хрустящее тесто с грецкими орехами и медовым сиропом'),
    
    -- Fruit Salad
    (8, 'en', 'Fruit Salad', 'Seasonal fresh fruits with honey dressing'),
    (8, 'he', N'סלט פירות', N'פירות טריים עונתיים עם רוטב דבש'),
    (8, 'ru', N'Фруктовый Салат', N'Сезонные свежие фрукты с медовой заправкой'),
    
    -- Orange Juice
    (9, 'en', 'Orange Juice', 'Fresh squeezed orange juice'),
    (9, 'he', N'מיץ תפוז', N'מיץ תפוז טרי לחוץ'),
    (9, 'ru', N'Апельсиновый Сок', N'Свежевыжатый апельсиновый сок'),
    
    -- Red Wine
    (10, 'en', 'Red Wine', 'Premium Israeli red wine selection'),
    (10, 'he', N'יין אדום', N'בחירת יין אדום ישראלי פרימיום'),
    (10, 'ru', N'Красное Вино', N'Премиальный выбор израильского красного вина')
GO

-- ====================================================================
-- Insert Additional Menu Items (Restaurant 1 - Desserts & Beverages)
-- ====================================================================
INSERT INTO MenuItems (CategoryId, RestaurantId, Price, IsAvailable, IsVegetarian, IsSpicy, DisplayOrder)
VALUES
    -- Desserts (Category 4)
    (4, 1, 38.00, 1, 1, 0, 3),  -- Chocolate Souffle
    (4, 1, 36.00, 1, 1, 0, 4),  -- Tiramisu
    (4, 1, 32.00, 1, 1, 0, 5),  -- Ice Cream Trio
    -- Beverages (Category 5)
    (5, 1, 15.00, 1, 1, 0, 3),  -- Lemonade
    (5, 1, 18.00, 1, 1, 0, 4),  -- Cappuccino
    (5, 1, 10.00, 1, 1, 0, 5)   -- Sparkling Water
GO

-- ====================================================================
-- Insert Additional Menu Item Translations (Restaurant 1 - Desserts & Beverages)
-- ====================================================================
INSERT INTO MenuItemTranslations (ItemId, LanguageCode, Name, Description)
VALUES
    -- Chocolate Souffle
    (11, 'en', 'Chocolate Souffle', 'Warm chocolate souffle with a molten center'),
    (11, 'he', N'סופלה שוקולד', N'סופלה שוקולד חם עם מרכז נוזלי'),
    (11, 'ru', N'Шоколадное Суфле', N'Теплое шоколадное суфле с тающей серединкой'),

    -- Tiramisu
    (12, 'en', 'Tiramisu', 'Classic Italian dessert with mascarpone and espresso'),
    (12, 'he', N'טירמיסו', N'קינוח איטלקי קלאסי עם מסקרפונה ואספרסו'),
    (12, 'ru', N'Тирамису', N'Классический итальянский десерт с маскарпоне и эспрессо'),

    -- Ice Cream Trio
    (13, 'en', 'Ice Cream Trio', 'Three scoops of vanilla, chocolate and pistachio ice cream'),
    (13, 'he', N'שלישיית גלידה', N'שלושה כדורי גלידה בטעמי וניל, שוקולד ופיסטוק'),
    (13, 'ru', N'Трио Мороженого', N'Три шарика мороженого: ваниль, шоколад и фисташка'),

    -- Lemonade
    (14, 'en', 'Lemonade', 'Freshly squeezed lemonade with mint'),
    (14, 'he', N'לימונדה', N'לימונדה טרייה סחוטה עם נענע'),
    (14, 'ru', N'Лимонад', N'Свежевыжатый лимонад с мятой'),

    -- Cappuccino
    (15, 'en', 'Cappuccino', 'Espresso with steamed milk foam'),
    (15, 'he', N'קפוצ׳ינו', N'אספרסו עם קצף חלב מוקצף'),
    (15, 'ru', N'Капучино', N'Эспрессо со взбитой молочной пенкой'),

    -- Sparkling Water
    (16, 'en', 'Sparkling Water', 'Chilled sparkling mineral water'),
    (16, 'he', N'מים מוגזים', N'מים מינרליים מוגזים קרים'),
    (16, 'ru', N'Газированная Вода', N'Охлажденная минеральная газированная вода')
GO

-- ====================================================================
-- Insert Menu Items (Restaurant 2 - Starters, Main Courses, Sides)
-- ====================================================================
INSERT INTO MenuItems (CategoryId, RestaurantId, Price, IsAvailable, IsVegetarian, IsSpicy, DisplayOrder)
VALUES
    -- Appetizers (Category 1)
    (1, 2, 42.00, 1, 0, 0, 1),  -- Chopped Liver
    (1, 2, 38.00, 1, 0, 0, 2),  -- Matzo Ball Soup
    (1, 2, 34.00, 1, 1, 0, 3),  -- Eggplant Salad
    (1, 2, 40.00, 1, 1, 0, 4),  -- Stuffed Grape Leaves
    -- Main Courses (Category 2)
    (2, 2, 95.00, 1, 0, 0, 1),  -- Roast Chicken
    (2, 2, 130.00, 1, 0, 0, 2), -- Beef Brisket
    (2, 2, 85.00, 1, 0, 0, 3),  -- Stuffed Cabbage
    (2, 2, 90.00, 1, 0, 0, 4),  -- Turkey Schnitzel
    (2, 2, 88.00, 1, 0, 0, 5),  -- Kosher Meatballs
    -- Sides (Category 3)
    (3, 2, 28.00, 1, 1, 0, 1),  -- Potato Kugel
    (3, 2, 30.00, 1, 1, 0, 2),  -- Roasted Vegetables
    (3, 2, 25.00, 1, 1, 0, 3),  -- Rice Pilaf
    (3, 2, 20.00, 1, 1, 0, 4)   -- Challah Bread
GO

-- ====================================================================
-- Insert Menu Item Translations (Restaurant 2 - Starters, Main Courses, Sides)
-- ====================================================================
INSERT INTO MenuItemTranslations (ItemId, LanguageCode, Name, Description)
VALUES
    -- Chopped Liver
    (17, 'en', 'Chopped Liver', 'Traditional kosher chopped liver with caramelized onions'),
    (17, 'he', N'כבד קצוץ', N'כבד קצוץ מסורתי כשר עם בצל מקורמל'),
    (17, 'ru', N'Рубленая Печень', N'Традиционная кошерная рубленая печень с карамелизированным луком'),

    -- Matzo Ball Soup
    (18, 'en', 'Matzo Ball Soup', 'Chicken broth with fluffy matzo balls'),
    (18, 'he', N'מרק כדורי מצה', N'ציר עוף עם כדורי מצה תפוחים'),
    (18, 'ru', N'Суп с Шариками из Мацы', N'Куриный бульон с пышными шариками из мацы'),

    -- Eggplant Salad
    (19, 'en', 'Eggplant Salad', 'Smoky roasted eggplant with tahini and garlic'),
    (19, 'he', N'סלט חצילים', N'חציל קלוי מעושן עם טחינה ושום'),
    (19, 'ru', N'Салат из Баклажанов', N'Дымный печеный баклажан с тахини и чесноком'),

    -- Stuffed Grape Leaves
    (20, 'en', 'Stuffed Grape Leaves', 'Grape leaves filled with rice, herbs and pine nuts'),
    (20, 'he', N'עלי גפן ממולאים', N'עלי גפן ממולאים באורז, עשבי תיבול וצנוברים'),
    (20, 'ru', N'Долма', N'Виноградные листья, фаршированные рисом, зеленью и кедровыми орешками'),

    -- Roast Chicken
    (21, 'en', 'Roast Chicken', 'Slow-roasted whole chicken with garlic and herbs'),
    (21, 'he', N'עוף צלוי', N'עוף שלם צלוי לאט עם שום ועשבי תיבול'),
    (21, 'ru', N'Жареная Курица', N'Медленно запеченная целая курица с чесноком и травами'),

    -- Beef Brisket
    (22, 'en', 'Beef Brisket', 'Slow-braised beef brisket in rich gravy'),
    (22, 'he', N'חזה בקר', N'חזה בקר מבושל לאט ברוטב עשיר'),
    (22, 'ru', N'Говяжья Грудинка', N'Медленно тушеная говяжья грудинка в насыщенной подливе'),

    -- Stuffed Cabbage
    (23, 'en', 'Stuffed Cabbage', 'Cabbage rolls filled with beef and rice in tomato sauce'),
    (23, 'he', N'כרוב ממולא', N'גלילי כרוב ממולאים בבקר ואורז ברוטב עגבניות'),
    (23, 'ru', N'Голубцы', N'Капустные рулеты с говядиной и рисом в томатном соусе'),

    -- Turkey Schnitzel
    (24, 'en', 'Turkey Schnitzel', 'Breaded turkey schnitzel served with lemon'),
    (24, 'he', N'שניצל הודו', N'שניצל הודו מצופה פירורי לחם מוגש עם לימון'),
    (24, 'ru', N'Шницель из Индейки', N'Панированный шницель из индейки, подается с лимоном'),

    -- Kosher Meatballs
    (25, 'en', 'Kosher Meatballs', 'Beef meatballs simmered in tomato sauce'),
    (25, 'he', N'קציצות בשר', N'קציצות בקר מבושלות ברוטב עגבניות'),
    (25, 'ru', N'Кошерные Фрикадельки', N'Говяжьи фрикадельки, тушенные в томатном соусе'),

    -- Potato Kugel
    (26, 'en', 'Potato Kugel', 'Baked potato and onion casserole'),
    (26, 'he', N'קוגל תפוחי אדמה', N'תבשיל אפוי של תפוחי אדמה ובצל'),
    (26, 'ru', N'Картофельный Кугель', N'Запеченная запеканка из картофеля и лука'),

    -- Roasted Vegetables
    (27, 'en', 'Roasted Vegetables', 'Seasonal vegetables roasted with olive oil'),
    (27, 'he', N'ירקות קלויים', N'ירקות עונתיים קלויים בשמן זית'),
    (27, 'ru', N'Печеные Овощи', N'Сезонные овощи, запеченные с оливковым маслом'),

    -- Rice Pilaf
    (28, 'en', 'Rice Pilaf', 'Fluffy rice cooked with vermicelli and spices'),
    (28, 'he', N'אורז פילאף', N'אורז תפוח מבושל עם אטריות דקות ותבלינים'),
    (28, 'ru', N'Плов', N'Рассыпчатый рис с вермишелью и специями'),

    -- Challah Bread
    (29, 'en', 'Challah Bread', 'Traditional braided egg bread'),
    (29, 'he', N'חלה', N'לחם ביצים קלוע מסורתי'),
    (29, 'ru', N'Хала', N'Традиционный плетеный яичный хлеб')
GO

-- ====================================================================
-- Insert Menu Items (Restaurant 3 - Grilled Meats, Vegetables, Sides, Sauces)
-- ====================================================================
INSERT INTO MenuItems (CategoryId, RestaurantId, Price, IsAvailable, IsVegetarian, IsSpicy, DisplayOrder)
VALUES
    -- Grilled vegetables as Appetizers (Category 1)
    (1, 3, 32.00, 1, 1, 0, 1),  -- Grilled Eggplant
    (1, 3, 30.00, 1, 1, 0, 2),  -- Grilled Peppers
    (1, 3, 26.00, 1, 1, 0, 3),  -- Grilled Corn
    (1, 3, 34.00, 1, 1, 0, 4),  -- Grilled Mushrooms
    -- Grilled meats as Main Courses (Category 2)
    (2, 3, 95.00, 1, 0, 1, 1),  -- Beef Kebab
    (2, 3, 145.00, 1, 0, 0, 2), -- Lamb Chops
    (2, 3, 85.00, 1, 0, 0, 3),  -- Chicken Skewers
    (2, 3, 78.00, 1, 0, 1, 4),  -- Merguez Sausage
    (2, 3, 160.00, 1, 0, 0, 5), -- Entrecote Steak
    -- Sides and sauces (Category 3)
    (3, 3, 28.00, 1, 1, 0, 1),  -- Grilled Potatoes
    (3, 3, 24.00, 1, 1, 0, 2),  -- Rice with Herbs
    (3, 3, 22.00, 1, 1, 0, 3),  -- Coleslaw
    (3, 3, 12.00, 1, 1, 0, 4),  -- Pita Bread
    (3, 3, 14.00, 1, 1, 0, 5),  -- Chimichurri
    (3, 3, 12.00, 1, 1, 0, 6),  -- Tahini Sauce
    (3, 3, 12.00, 1, 1, 0, 7),  -- Garlic Aioli
    (3, 3, 14.00, 1, 1, 1, 8)   -- Spicy Harissa
GO

-- ====================================================================
-- Insert Menu Item Translations (Restaurant 3 - Grilled Meats, Vegetables, Sides, Sauces)
-- ====================================================================
INSERT INTO MenuItemTranslations (ItemId, LanguageCode, Name, Description)
VALUES
    -- Beef Kebab
    (30, 'en', 'Beef Kebab', 'Grilled minced beef skewers with spices'),
    (30, 'he', N'קבב בקר', N'שיפודי בקר טחון צלויים עם תבלינים'),
    (30, 'ru', N'Кебаб из Говядины', N'Шашлык из рубленой говядины на гриле со специями'),

    -- Lamb Chops
    (31, 'en', 'Lamb Chops', 'Grilled lamb chops marinated in herbs'),
    (31, 'he', N'צלעות כבש', N'צלעות כבש צלויות מושרות בעשבי תיבול'),
    (31, 'ru', N'Бараньи Отбивные', N'Жареные бараньи отбивные, маринованные в травах'),

    -- Chicken Skewers
    (32, 'en', 'Chicken Skewers', 'Grilled chicken breast skewers with garlic marinade'),
    (32, 'he', N'שיפודי עוף', N'שיפודי חזה עוף צלויים במרינדת שום'),
    (32, 'ru', N'Куриные Шашлычки', N'Шашлычки из куриной грудки на гриле в чесночном маринаде'),

    -- Merguez Sausage
    (33, 'en', 'Merguez Sausage', 'Spicy grilled lamb sausage'),
    (33, 'he', N'נקניקיית מרגז', N'נקניקיית כבש חריפה צלויה'),
    (33, 'ru', N'Колбаски Мергез', N'Острые бараньи колбаски на гриле'),

    -- Entrecote Steak
    (34, 'en', 'Entrecote Steak', 'Prime grilled entrecote steak cooked to preference'),
    (34, 'he', N'סטייק אנטריקוט', N'סטייק אנטריקוט איכותי צלוי לפי בחירה'),
    (34, 'ru', N'Стейк Антрекот', N'Отборный стейк антрекот на гриле по вашему выбору прожарки'),

    -- Grilled Eggplant
    (35, 'en', 'Grilled Eggplant', 'Charred eggplant slices with olive oil'),
    (35, 'he', N'חציל צלוי', N'פרוסות חציל צלויות עם שמן זית'),
    (35, 'ru', N'Жареный Баклажан', N'Обжаренные ломтики баклажана с оливковым маслом'),

    -- Grilled Peppers
    (36, 'en', 'Grilled Peppers', 'Sweet bell peppers grilled to perfection'),
    (36, 'he', N'פלפלים צלויים', N'פלפלים מתוקים צלויים לשלמות'),
    (36, 'ru', N'Жареный Перец', N'Сладкий перец, идеально приготовленный на гриле'),

    -- Grilled Corn
    (37, 'en', 'Grilled Corn', 'Sweet corn grilled with butter'),
    (37, 'he', N'תירס צלוי', N'תירס מתוק צלוי עם חמאה'),
    (37, 'ru', N'Жареная Кукуруза', N'Сладкая кукуруза на гриле со сливочным маслом'),

    -- Grilled Mushrooms
    (38, 'en', 'Grilled Mushrooms', 'Portobello mushrooms grilled with garlic butter'),
    (38, 'he', N'פטריות צלויות', N'פטריות פורטבלו צלויות בחמאת שום'),
    (38, 'ru', N'Жареные Грибы', N'Грибы портобелло на гриле с чесночным маслом'),

    -- Grilled Potatoes
    (39, 'en', 'Grilled Potatoes', 'Baby potatoes grilled with rosemary'),
    (39, 'he', N'תפוחי אדמה צלויים', N'תפוחי אדמה קטנים צלויים עם רוזמרין'),
    (39, 'ru', N'Жареный Картофель', N'Молодой картофель на гриле с розмарином'),

    -- Rice with Herbs
    (40, 'en', 'Rice with Herbs', 'White rice cooked with fresh herbs'),
    (40, 'he', N'אורז עם עשבי תיבול', N'אורז לבן מבושל עם עשבי תיבול טריים'),
    (40, 'ru', N'Рис с Зеленью', N'Белый рис, приготовленный со свежей зеленью'),

    -- Coleslaw
    (41, 'en', 'Coleslaw', 'Fresh cabbage salad with creamy dressing'),
    (41, 'he', N'קולסלו', N'סלט כרוב טרי ברוטב קרמי'),
    (41, 'ru', N'Коулслоу', N'Свежий капустный салат со сливочной заправкой'),

    -- Pita Bread
    (42, 'en', 'Pita Bread', 'Warm freshly baked pita bread'),
    (42, 'he', N'פיתה', N'פיתה טרייה אפויה וחמה'),
    (42, 'ru', N'Пита', N'Тёплая свежеиспечённая пита'),

    -- Chimichurri
    (43, 'en', 'Chimichurri', 'Fresh herb sauce with parsley, garlic and vinegar'),
    (43, 'he', N'צ׳ימיצ׳ורי', N'רוטב עשבי תיבול טרי עם פטרוזיליה, שום וחומץ'),
    (43, 'ru', N'Чимичурри', N'Свежий соус из зелени с петрушкой, чесноком и уксусом'),

    -- Tahini Sauce
    (44, 'en', 'Tahini Sauce', 'Creamy sesame paste sauce with lemon'),
    (44, 'he', N'רוטב טחינה', N'רוטב טחינה קרמי עם לימון'),
    (44, 'ru', N'Соус Тахини', N'Кремовый соус из кунжутной пасты с лимоном'),

    -- Garlic Aioli
    (45, 'en', 'Garlic Aioli', 'Creamy garlic and olive oil emulsion'),
    (45, 'he', N'איולי שום', N'תחליב קרמי של שום ושמן זית'),
    (45, 'ru', N'Чесночный Айоли', N'Кремовая эмульсия из чеснока и оливкового масла'),

    -- Spicy Harissa
    (46, 'en', 'Spicy Harissa', 'North African hot chili paste'),
    (46, 'he', N'הריסה חריפה', N'משחת צ׳ילי חריפה צפון אפריקאית'),
    (46, 'ru', N'Острая Харисса', N'Острая паста чили из Северной Африки')
GO

-- ====================================================================
-- Insert Desserts and Beverages (Restaurants 2 and 3)
-- Item IDs 47-66 follow the previous inserts
-- ====================================================================
INSERT INTO MenuItems (CategoryId, RestaurantId, Price, IsAvailable, IsVegetarian, IsSpicy, DisplayOrder)
VALUES
    -- Restaurant 2 Desserts (Category 4): 47-51
    (4, 2, 32.00, 1, 1, 0, 1),  -- Honey Cake
    (4, 2, 30.00, 1, 1, 0, 2),  -- Rugelach
    (4, 2, 34.00, 1, 1, 0, 3),  -- Apple Strudel
    (4, 2, 36.00, 1, 1, 0, 4),  -- Chocolate Babka
    (4, 2, 28.00, 1, 1, 0, 5),  -- Sorbet Trio
    -- Restaurant 2 Beverages (Category 5): 52-56
    (5, 2, 28.00, 1, 1, 0, 1),  -- Kosher Red Wine
    (5, 2, 14.00, 1, 1, 0, 2),  -- Grape Juice
    (5, 2, 12.00, 1, 1, 0, 3),  -- Mint Tea
    (5, 2, 15.00, 1, 1, 0, 4),  -- Lemonade
    (5, 2, 14.00, 1, 1, 0, 5),  -- Turkish Coffee
    -- Restaurant 3 Desserts (Category 4): 57-61
    (4, 3, 32.00, 1, 1, 0, 1),  -- Grilled Pineapple
    (4, 3, 38.00, 1, 1, 0, 2),  -- Chocolate Lava Cake
    (4, 3, 36.00, 1, 1, 0, 3),  -- Cheesecake
    (4, 3, 34.00, 1, 1, 0, 4),  -- Ice Cream Sundae
    (4, 3, 26.00, 1, 1, 0, 5),  -- Malabi
    -- Restaurant 3 Beverages (Category 5): 62-66
    (5, 3, 24.00, 1, 1, 0, 1),  -- Craft Beer
    (5, 3, 12.00, 1, 1, 0, 2),  -- Cola
    (5, 3, 14.00, 1, 1, 0, 3),  -- Iced Tea
    (5, 3, 16.00, 1, 1, 0, 4),  -- Limonana
    (5, 3, 12.00, 1, 1, 0, 5)   -- Espresso
GO

INSERT INTO MenuItemTranslations (ItemId, LanguageCode, Name, Description)
VALUES
    -- Honey Cake
    (47, 'en', 'Honey Cake', 'Traditional spiced honey cake'),
    (47, 'he', N'עוגת דבש', N'עוגת דבש מסורתית מתובלת'),
    (47, 'ru', N'Медовый Торт', N'Традиционный пряный медовый торт'),

    -- Rugelach
    (48, 'en', 'Rugelach', 'Crescent pastries filled with chocolate and cinnamon'),
    (48, 'he', N'רוגלך', N'מאפה חצי סהר במילוי שוקולד וקינמון'),
    (48, 'ru', N'Ругелах', N'Рогалики с шоколадом и корицей'),

    -- Apple Strudel
    (49, 'en', 'Apple Strudel', 'Flaky pastry with apples, raisins and cinnamon'),
    (49, 'he', N'שטרודל תפוחים', N'בצק פריך עם תפוחים, צימוקים וקינמון'),
    (49, 'ru', N'Яблочный Штрудель', N'Слоеное тесто с яблоками, изюмом и корицей'),

    -- Chocolate Babka
    (50, 'en', 'Chocolate Babka', 'Sweet braided bread with chocolate swirls'),
    (50, 'he', N'בבקה שוקולד', N'לחם מתוק קלוע עם שכבות שוקולד'),
    (50, 'ru', N'Шоколадная Бабка', N'Сладкий плетеный хлеб с шоколадными прослойками'),

    -- Sorbet Trio
    (51, 'en', 'Sorbet Trio', 'Three scoops of dairy-free fruit sorbet'),
    (51, 'he', N'שלישיית סורבה', N'שלושה כדורי סורבה פירות פרווה'),
    (51, 'ru', N'Трио Сорбета', N'Три шарика фруктового сорбета без молока'),

    -- Kosher Red Wine
    (52, 'en', 'Kosher Red Wine', 'Mevushal red wine from the Judean Hills'),
    (52, 'he', N'יין אדום כשר', N'יין אדום מבושל מהרי יהודה'),
    (52, 'ru', N'Кошерное Красное Вино', N'Красное вино мевушаль из Иудейских гор'),

    -- Grape Juice
    (53, 'en', 'Grape Juice', 'Natural pressed grape juice'),
    (53, 'he', N'מיץ ענבים', N'מיץ ענבים טבעי סחוט'),
    (53, 'ru', N'Виноградный Сок', N'Натуральный виноградный сок прямого отжима'),

    -- Mint Tea
    (54, 'en', 'Mint Tea', 'Hot tea with fresh mint leaves'),
    (54, 'he', N'תה נענע', N'תה חם עם עלי נענע טריים'),
    (54, 'ru', N'Мятный Чай', N'Горячий чай со свежими листьями мяты'),

    -- Lemonade
    (55, 'en', 'Lemonade', 'Chilled homemade lemonade'),
    (55, 'he', N'לימונדה', N'לימונדה ביתית קרה'),
    (55, 'ru', N'Лимонад', N'Охлажденный домашний лимонад'),

    -- Turkish Coffee
    (56, 'en', 'Turkish Coffee', 'Traditional coffee with cardamom'),
    (56, 'he', N'קפה טורקי', N'קפה מסורתי עם הל'),
    (56, 'ru', N'Кофе по-Турецки', N'Традиционный кофе с кардамоном'),

    -- Grilled Pineapple
    (57, 'en', 'Grilled Pineapple', 'Caramelized pineapple with cinnamon'),
    (57, 'he', N'אננס צלוי', N'אננס מקורמל עם קינמון'),
    (57, 'ru', N'Ананас на Гриле', N'Карамелизированный ананас с корицей'),

    -- Chocolate Lava Cake
    (58, 'en', 'Chocolate Lava Cake', 'Warm chocolate cake with a liquid center'),
    (58, 'he', N'עוגת לבה שוקולד', N'עוגת שוקולד חמה עם מרכז נוזלי'),
    (58, 'ru', N'Шоколадный Фондан', N'Теплый шоколадный кекс с жидкой серединой'),

    -- Cheesecake
    (59, 'en', 'Cheesecake', 'Creamy baked cheesecake with berry sauce'),
    (59, 'he', N'עוגת גבינה', N'עוגת גבינה אפויה וקרמית עם רוטב פירות יער'),
    (59, 'ru', N'Чизкейк', N'Нежный запеченный чизкейк с ягодным соусом'),

    -- Ice Cream Sundae
    (60, 'en', 'Ice Cream Sundae', 'Vanilla ice cream with chocolate sauce and nuts'),
    (60, 'he', N'סאנדיי גלידה', N'גלידת וניל עם רוטב שוקולד ואגוזים'),
    (60, 'ru', N'Мороженое Санди', N'Ванильное мороженое с шоколадным соусом и орехами'),

    -- Malabi
    (61, 'en', 'Malabi', 'Milk pudding with rose water syrup and pistachios'),
    (61, 'he', N'מלבי', N'פודינג חלב עם סירופ ורדים ופיסטוק'),
    (61, 'ru', N'Малаби', N'Молочный пудинг с розовым сиропом и фисташками'),

    -- Craft Beer
    (62, 'en', 'Craft Beer', 'Local craft beer on tap'),
    (62, 'he', N'בירה בוטיק', N'בירה בוטיק מקומית מהחבית'),
    (62, 'ru', N'Крафтовое Пиво', N'Местное крафтовое пиво разливное'),

    -- Cola
    (63, 'en', 'Cola', 'Chilled cola'),
    (63, 'he', N'קולה', N'קולה קרה'),
    (63, 'ru', N'Кола', N'Охлажденная кола'),

    -- Iced Tea
    (64, 'en', 'Iced Tea', 'Homemade peach iced tea'),
    (64, 'he', N'תה קר', N'תה קר ביתי בטעם אפרסק'),
    (64, 'ru', N'Холодный Чай', N'Домашний холодный чай со вкусом персика'),

    -- Limonana
    (65, 'en', 'Limonana', 'Frozen lemon and mint drink'),
    (65, 'he', N'לימונענע', N'משקה לימון ונענע קפוא'),
    (65, 'ru', N'Лимонана', N'Замороженный напиток из лимона и мяты'),

    -- Espresso
    (66, 'en', 'Espresso', 'Strong single-shot espresso'),
    (66, 'he', N'אספרסו', N'אספרסו חזק בשוט בודד'),
    (66, 'ru', N'Эспрессо', N'Крепкий эспрессо одинарной порции')
GO

PRINT 'Seed data inserted successfully!'
GO
