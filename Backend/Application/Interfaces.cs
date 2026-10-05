namespace RestaurantChain.Application;

public interface IRestaurantService
{
    Task<IReadOnlyList<Restaurant>> GetAllRestaurantsAsync(string languageCode, CancellationToken cancellationToken);
}

public interface IReservationService
{
    Task<int> GetOrCreateVisitorAsync(CreateVisitorRequest request, CancellationToken cancellationToken);
    Task<CreatedReservation> CreateReservationAsync(CreateReservationRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<Reservation>> GetVisitorReservationsAsync(int visitorId, string languageCode, CancellationToken cancellationToken);
    Task<ReservationDetails?> GetReservationDetailsAsync(int reservationId, string languageCode, CancellationToken cancellationToken);
    Task UpdateStatusAsync(int reservationId, UpdateReservationStatusRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<AvailableTable>> GetAvailableTablesAsync(int restaurantId, DateOnly reservationDate, TimeOnly reservationTime, int requiredCapacity, CancellationToken cancellationToken);
}

public interface IMenuService
{
    Task<IReadOnlyList<MenuCategory>> GetMenuCategoriesAsync(int restaurantId, string languageCode, CancellationToken cancellationToken);
    Task<IReadOnlyList<MenuItem>> GetMenuItemsAsync(int restaurantId, string languageCode, int categoryId, CancellationToken cancellationToken);
}