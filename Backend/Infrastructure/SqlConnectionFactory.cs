using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace RestaurantChain.Infrastructure;

public interface IDbConnectionFactory
{
	SqlConnection CreateConnection();
}

public sealed class SqlConnectionFactory(IConfiguration configuration) : IDbConnectionFactory
{
	public SqlConnection CreateConnection()
	{
		var connectionString = configuration.GetConnectionString("RestaurantChain");

		if (string.IsNullOrWhiteSpace(connectionString))
		{
			throw new InvalidOperationException("ConnectionStrings:RestaurantChain is not configured.");
		}

		return new SqlConnection(connectionString);
	}
}
