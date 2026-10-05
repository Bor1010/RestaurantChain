using Microsoft.Data.SqlClient;
using RestaurantChain.Application;
using System.Data;


namespace RestaurantChain.Infrastructure
{
    public sealed class MenuService(IDbConnectionFactory connectionFactory) : IMenuService
    {
        public async Task<IReadOnlyList<MenuCategory>> GetMenuCategoriesAsync(int restaurantId, string languageCode, CancellationToken cancellationToken)
        {
            await using var connection = connectionFactory.CreateConnection();
            await using var command = new SqlCommand("usp_GetMenuCategories", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.Add("@RestaurantId", SqlDbType.Int).Value = restaurantId;
            command.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 5).Value = languageCode;

            await connection.OpenAsync(cancellationToken);
            await using var reader = await command.ExecuteReaderAsync(cancellationToken);
            var categories = new List<MenuCategory>();

            while (await reader.ReadAsync(cancellationToken))
            {
                categories.Add(new MenuCategory(
                    reader.GetInt32(reader.GetOrdinal("CategoryId")),
                    reader.GetString(reader.GetOrdinal("Name")),
                    reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                    reader.GetInt32(reader.GetOrdinal("DisplayOrder"))));
            }

            return categories;
        }

        public async Task<IReadOnlyList<MenuItem>> GetMenuItemsAsync(int restaurantId, string languageCode, int categoryId, CancellationToken cancellationToken)
        {
            await using var connection = connectionFactory.CreateConnection();
            await using var command = new SqlCommand("usp_GetMenuItemsByCategory", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.Add("@RestaurantId", SqlDbType.Int).Value = restaurantId;
            command.Parameters.Add("@CategoryId", SqlDbType.Int).Value = categoryId;
            command.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 5).Value = languageCode;

            await connection.OpenAsync(cancellationToken);
            await using var reader = await command.ExecuteReaderAsync(cancellationToken);
            var items = new List<MenuItem>();

            while (await reader.ReadAsync(cancellationToken))
            {
                items.Add(new MenuItem(
                    reader.GetInt32(reader.GetOrdinal("ItemId")),
                    reader.GetString(reader.GetOrdinal("Name")),
                    reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                    reader.GetDecimal(reader.GetOrdinal("Price")),
                    reader.GetBoolean(reader.GetOrdinal("IsVegetarian")),
                    reader.GetBoolean(reader.GetOrdinal("IsSpicy")),
                    reader.GetBoolean(reader.GetOrdinal("IsCosher")),
                    reader.IsDBNull(reader.GetOrdinal("Allergens")) ? null : reader.GetString(reader.GetOrdinal("Allergens")),
                    reader.GetInt32(reader.GetOrdinal("DisplayOrder"))));
            }

            return items;
        }
    }
}
