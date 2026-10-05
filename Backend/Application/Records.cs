namespace RestaurantChain.Application;

public sealed record CreateReservationRequest(
    int VisitorId,
    int TableId,
    int RestaurantId,
    DateOnly ReservationDate,
    TimeOnly ReservationTime,
    int NumberOfGuests,
    TimeOnly ReservationEndTime,
    string? SpecialRequests);

public sealed record UpdateReservationStatusRequest(string NewStatus, string? CancellationReason);

public sealed record CreatedReservation(int ReservationId, string ReservationNumber);

public sealed record CreateVisitorRequest(
    string Email,
    string FirstName,
    string LastName,
    string? PhoneNumber,
    string PreferredLanguage);

public sealed record Restaurant(
    int RestaurantId,
    string Code,
    string Name,
    string? Description,
    string Address,
    string City,
    string? PhoneNumber,
    string? Email,
    TimeSpan? OpeningTime,
    TimeSpan? ClosingTime);

public sealed record Reservation(
    int ReservationId,
    string ReservationNumber,
    string ReservationStatus,
    DateOnly ReservationDate,
    TimeOnly ReservationTime,
    int NumberOfGuests,
    TimeOnly ReservationEndTime,
    string RestaurantName,
    int TableNumber);

public sealed record ReservationDetails(
    int ReservationId,
    string ReservationNumber,
    string ReservationStatus,
    DateOnly ReservationDate,
    TimeOnly ReservationTime,
    int NumberOfGuests,
    TimeOnly ReservationEndTime,
    string? SpecialRequests,
    string RestaurantName,
    string TableCode,
    int Capacity,
    string FirstName,
    string LastName,
    string Email,
    string? PhoneNumber);

public sealed record AvailableTable(int TableId, string TableCode, int Capacity);

public sealed record MenuCategory(int CategoryId, string Name, string? Description, int DisplayOrder);

public sealed record MenuItem(
    int ItemId,
    string Name,
    string? Description,
    decimal Price,
    bool IsVegetarian,
    bool IsSpicy,
    bool IsCosher,
    string? Allergens,
    int DisplayOrder);