var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddHealthChecks();
builder.Services.AddScoped<RestaurantChain.Application.IRestaurantService, RestaurantChain.Infrastructure.RestaurantService>();
builder.Services.AddScoped<RestaurantChain.Application.IReservationService, RestaurantChain.Infrastructure.ReservationService>();
builder.Services.AddScoped<RestaurantChain.Application.IMenuService, RestaurantChain.Infrastructure.MenuService>();
builder.Services.AddSingleton<RestaurantChain.Infrastructure.IDbConnectionFactory, RestaurantChain.Infrastructure.SqlConnectionFactory>();

var app = builder.Build();

app.MapHealthChecks("/health");
app.MapControllers();

app.Run();
