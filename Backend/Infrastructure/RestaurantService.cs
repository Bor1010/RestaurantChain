using Microsoft.Data.SqlClient;
using RestaurantChain.Application;
using System.Data;

namespace RestaurantChain.Infrastructure
{
    public sealed class RestaurantService(IDbConnectionFactory connectionFactory) : IRestaurantService
    {
        public async Task<IReadOnlyList<Restaurant>> GetAllRestaurantsAsync(string languageCode, CancellationToken cancellationToken)
        {
            await using var connection = connectionFactory.CreateConnection();
            await using var command = new SqlCommand("usp_GetAllRestaurants", connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 5).Value = languageCode;

            await connection.OpenAsync(cancellationToken);
            await using var reader = await command.ExecuteReaderAsync(cancellationToken);
            var restaurants = new List<Restaurant>();

            while (await reader.ReadAsync(cancellationToken))
            {
                restaurants.Add(new Restaurant(
                    reader.GetInt32(reader.GetOrdinal("RestaurantId")),
                    reader.GetString(reader.GetOrdinal("Code")),
                    reader.GetString(reader.GetOrdinal("Name")),
                    reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                    reader.GetString(reader.GetOrdinal("Address")),
                    reader.GetString(reader.GetOrdinal("City")),
                    reader.IsDBNull(reader.GetOrdinal("PhoneNumber")) ? null : reader.GetString(reader.GetOrdinal("PhoneNumber")),
                    reader.IsDBNull(reader.GetOrdinal("Email")) ? null : reader.GetString(reader.GetOrdinal("Email")),
                    reader.IsDBNull(reader.GetOrdinal("OpeningTime")) ? null : reader.GetTimeSpan(reader.GetOrdinal("OpeningTime")),
                    reader.IsDBNull(reader.GetOrdinal("ClosingTime")) ? null : reader.GetTimeSpan(reader.GetOrdinal("ClosingTime"))));
            }

            return restaurants;
        }
    }
}
