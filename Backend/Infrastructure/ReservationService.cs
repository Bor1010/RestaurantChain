using Microsoft.Data.SqlClient;
using RestaurantChain.Application;
using System.Data;

namespace RestaurantChain.Infrastructure;

public sealed class ReservationService (IDbConnectionFactory connectionFactory) : IReservationService
{
    public async Task<int> GetOrCreateVisitorAsync(CreateVisitorRequest request, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await using var command = CreateCommand(connection, "rsn.GetOrCreateVisitor");
        command.Parameters.Add("@Email", SqlDbType.NVarChar, 255).Value = request.Email;
        command.Parameters.Add("@FirstName", SqlDbType.NVarChar, 100).Value = request.FirstName;
        command.Parameters.Add("@LastName", SqlDbType.NVarChar, 100).Value = request.LastName;
        command.Parameters.Add("@PhoneNumber", SqlDbType.NVarChar, 20).Value = (object?)request.PhoneNumber ?? DBNull.Value;
        command.Parameters.Add("@PreferredLanguage", SqlDbType.NVarChar, 5).Value = request.PreferredLanguage;

        await connection.OpenAsync(cancellationToken);
        var visitorId = await command.ExecuteScalarAsync(cancellationToken);

        return (int)(visitorId ?? throw new InvalidOperationException("Visitor ID was not returned."));
    }

    public async Task<CreatedReservation> CreateReservationAsync(CreateReservationRequest request, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await using var command = CreateCommand(connection, "rsn.CreateReservation");

        AddCreateParameters(command, request); //from "CreateReservationRequest" record

        var reservationId = new SqlParameter("@ReservationId", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
        command.Parameters.Add(reservationId);

        var reservationNumber = new SqlParameter("@ReservationNumber", SqlDbType.NVarChar, 50)
        {
            Direction = ParameterDirection.Output
        };
        command.Parameters.Add(reservationNumber);

        await connection.OpenAsync(cancellationToken);
        await command.ExecuteNonQueryAsync(cancellationToken);

        return new CreatedReservation(
            (int)(reservationId.Value ?? throw new InvalidOperationException("Reservation ID was not returned.")),
            (string)(reservationNumber.Value ?? throw new InvalidOperationException("Reservation number was not returned.")));
    }

    public async Task<IReadOnlyList<Reservation>> GetVisitorReservationsAsync(int visitorId, string languageCode, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await using var command = CreateCommand(connection, "rsn.GetVisitorReservations");
        command.Parameters.Add("@VisitorId", SqlDbType.Int).Value = visitorId;
        command.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 5).Value = languageCode;

        await connection.OpenAsync(cancellationToken);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var reservations = new List<Reservation>();

        while (await reader.ReadAsync(cancellationToken))
        {
            reservations.Add(new Reservation(
                reader.GetInt32(reader.GetOrdinal("ReservationId")),
                reader.GetString(reader.GetOrdinal("ReservationNumber")),
                reader.GetString(reader.GetOrdinal("ReservationStatus")),
                DateOnly.FromDateTime(reader.GetDateTime(reader.GetOrdinal("ReservationDate"))),
                TimeOnly.FromTimeSpan(reader.GetTimeSpan(reader.GetOrdinal("ReservationTime"))),
                reader.GetInt32(reader.GetOrdinal("NumberOfGuests")),
                TimeOnly.FromTimeSpan(reader.GetTimeSpan(reader.GetOrdinal("ReservationEndTime"))),
                reader.GetString(reader.GetOrdinal("RestaurantName")),
                reader.GetInt32(reader.GetOrdinal("TableNumber"))));
        }

        return reservations;
    }

    public async Task<ReservationDetails?> GetReservationDetailsAsync(int reservationId, string languageCode, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await using var command = CreateCommand(connection, "rsn.GetReservationDetails");
        command.Parameters.Add("@ReservationId", SqlDbType.Int).Value = reservationId;
        command.Parameters.Add("@LanguageCode", SqlDbType.NVarChar, 5).Value = languageCode;

        await connection.OpenAsync(cancellationToken);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new ReservationDetails(
            reader.GetInt32(reader.GetOrdinal("ReservationId")),
            reader.GetString(reader.GetOrdinal("ReservationNumber")),
            reader.GetString(reader.GetOrdinal("ReservationStatus")),
            DateOnly.FromDateTime(reader.GetDateTime(reader.GetOrdinal("ReservationDate"))),
            TimeOnly.FromTimeSpan(reader.GetTimeSpan(reader.GetOrdinal("ReservationTime"))),
            reader.GetInt32(reader.GetOrdinal("NumberOfGuests")),
            TimeOnly.FromTimeSpan(reader.GetTimeSpan(reader.GetOrdinal("ReservationEndTime"))),
            reader.IsDBNull(reader.GetOrdinal("SpecialRequests")) ? null : reader.GetString(reader.GetOrdinal("SpecialRequests")),
            reader.GetString(reader.GetOrdinal("RestaurantName")),
            reader.GetString(reader.GetOrdinal("TableCode")),
            reader.GetInt32(reader.GetOrdinal("Capacity")),
            reader.GetString(reader.GetOrdinal("FirstName")),
            reader.GetString(reader.GetOrdinal("LastName")),
            reader.GetString(reader.GetOrdinal("Email")),
            reader.IsDBNull(reader.GetOrdinal("PhoneNumber")) ? null : reader.GetString(reader.GetOrdinal("PhoneNumber")));
    }

    public async Task UpdateStatusAsync(int reservationId, UpdateReservationStatusRequest request, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await using var command = CreateCommand(connection, "rsn.UpdateReservationStatus");
        command.Parameters.Add("@ReservationId", SqlDbType.Int).Value = reservationId;
        command.Parameters.Add("@NewStatus", SqlDbType.NVarChar, 50).Value = request.NewStatus;
        command.Parameters.Add("@CancellationReason", SqlDbType.NVarChar).Value = (object?)request.CancellationReason ?? DBNull.Value;

        await connection.OpenAsync(cancellationToken);
        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<AvailableTable>> GetAvailableTablesAsync(
                            int restaurantId, DateOnly reservationDate, TimeOnly reservationTime, int requiredCapacity, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        await using var command = CreateCommand(connection, "rsn.GetAvailableTables");
        command.Parameters.Add("@RestaurantId", SqlDbType.Int).Value = restaurantId;
        command.Parameters.Add("@ReservationDate", SqlDbType.Date).Value = reservationDate.ToDateTime(TimeOnly.MinValue);
        command.Parameters.Add("@ReservationTime", SqlDbType.Time).Value = reservationTime.ToTimeSpan();
        command.Parameters.Add("@RequiredCapacity", SqlDbType.Int).Value = requiredCapacity;

        await connection.OpenAsync(cancellationToken);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var tables = new List<AvailableTable>();

        int minPlaces = 0;
        while (await reader.ReadAsync(cancellationToken))
        {
            int capacity = reader.GetInt32(reader.GetOrdinal("Capacity"));

            if (minPlaces == 0)
                minPlaces = capacity;
            else if (capacity > minPlaces) //only nessery capacity tables
                break;

            tables.Add(new AvailableTable(
                reader.GetInt32(reader.GetOrdinal("TableId")),
                reader.GetString(reader.GetOrdinal("TableCode")),
                capacity));
        }

        return tables;
    }

    private static SqlCommand CreateCommand(SqlConnection connection, string procedureName) => new(procedureName, connection)
    {
        CommandType = CommandType.StoredProcedure
    };

    private static void AddCreateParameters(SqlCommand command, CreateReservationRequest request)
    {
        command.Parameters.Add("@VisitorId", SqlDbType.Int).Value = request.VisitorId;
        command.Parameters.Add("@TableId", SqlDbType.Int).Value = request.TableId;
        command.Parameters.Add("@RestaurantId", SqlDbType.Int).Value = request.RestaurantId;
        command.Parameters.Add("@ReservationDate", SqlDbType.Date).Value = request.ReservationDate.ToDateTime(TimeOnly.MinValue);
        command.Parameters.Add("@ReservationTime", SqlDbType.Time).Value = request.ReservationTime.ToTimeSpan();
        command.Parameters.Add("@NumberOfGuests", SqlDbType.Int).Value = request.NumberOfGuests;
        command.Parameters.Add("@ReservationEndTime", SqlDbType.Time).Value = request.ReservationEndTime.ToTimeSpan();
        command.Parameters.Add("@SpecialRequests", SqlDbType.NVarChar).Value = (object?)request.SpecialRequests ?? DBNull.Value;
    }
}

