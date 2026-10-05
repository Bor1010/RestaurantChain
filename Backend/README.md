# RestaurantChain Backend

ASP.NET Core Web API on .NET 10 using a Clean Architecture layout.

## Projects

- `Domain` contains business models.
- `Application` contains use-case contracts and application services.
- `Infrastructure` contains SQL Server access and stored procedure implementations.
- `Api` contains controllers and HTTP configuration.

## Run

1. Run `DataBase/setup.sql` in SQL Server Management Studio with SQLCMD mode enabled.
2. Check `ConnectionStrings:RestaurantChain` in `Backend/Api/appsettings.json`.
3. Start the API from the repository root:

```powershell
dotnet run --project Backend/Api
```

Endpoints:

- `GET /health`
- `GET /api/restaurants?languageCode=en`

Use user secrets or environment variables for production connection strings.