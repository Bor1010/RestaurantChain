using Microsoft.AspNetCore.Mvc;
using RestaurantChain.Application;

namespace RestaurantChain.Api.Controllers;

[ApiController]
[Route("api/reservations")]
public sealed class ReservationsController(IReservationService reservationService) : ControllerBase
{
	[HttpPost("visitors")]
	public async Task<ActionResult> GetOrCreateVisitor([FromBody] CreateVisitorRequest request, CancellationToken cancellationToken)
	{
		if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.FirstName) || string.IsNullOrWhiteSpace(request.LastName))
		{
			return BadRequest("Email, FirstName and LastName are required.");
		}

		var visitorId = await reservationService.GetOrCreateVisitorAsync(request, cancellationToken);
		return Ok(new { visitorId });
	}

	[HttpPost("reserve")]
	public async Task<ActionResult> CreateReservation([FromBody] CreateReservationRequest request, CancellationToken cancellationToken)
	{
		if (request.VisitorId <= 0 || request.TableId <= 0 || request.RestaurantId <= 0 || request.NumberOfGuests <= 0)
		{
			return BadRequest("VisitorId, TableId, RestaurantId and NumberOfGuests must be positive.");
		}

		if (request.ReservationEndTime <= request.ReservationTime)
		{
			return BadRequest("ReservationEndTime must be later than ReservationTime.");
		}

		var reservation = await reservationService.CreateReservationAsync(request, cancellationToken);
		return CreatedAtAction(
			nameof(GetReservationDetails),
			new { reservationId = reservation.ReservationId },
			new { reservationId = reservation.ReservationId, reservationNumber = reservation.ReservationNumber });
	}

	[HttpGet("visitor/{visitorId:int}")]
	public async Task<ActionResult> GetVisitorReservations(int visitorId, [FromQuery] string languageCode = "en", CancellationToken cancellationToken = default)
    {
		if (visitorId <= 0 || languageCode.Length is < 2 or > 5)
		{
			return BadRequest("VisitorId must be positive and languageCode must contain between 2 and 5 characters.");
		}

		return Ok(await reservationService.GetVisitorReservationsAsync(visitorId, languageCode, cancellationToken));
	}

	[HttpGet("{reservationId:int}")]
	public async Task<ActionResult> GetReservationDetails(int reservationId, [FromQuery] string languageCode = "en", CancellationToken cancellationToken = default)
	{
		if (reservationId <= 0 || languageCode.Length is < 2 or > 5)
		{
			return BadRequest("ReservationId must be positive and languageCode must contain between 2 and 5 characters.");
		}

		var reservation = await reservationService.GetReservationDetailsAsync(reservationId, languageCode, cancellationToken);
		return reservation is null ? NotFound() : Ok(reservation);
	}

	[HttpPatch("{reservationId:int}/status")]
	public async Task<ActionResult> UpdateStatus(int reservationId, [FromBody] UpdateReservationStatusRequest request, CancellationToken cancellationToken)
	{
		if (reservationId <= 0 || string.IsNullOrWhiteSpace(request.NewStatus))
		{
			return BadRequest("ReservationId must be positive and NewStatus is required.");
		}

		await reservationService.UpdateStatusAsync(reservationId, request, cancellationToken);
		return NoContent();
	}

	[HttpGet("available-tables")]
	public async Task<ActionResult> GetAvailableTables( [FromQuery] int restaurantId,
														[FromQuery] DateOnly reservationDate,
														[FromQuery] TimeOnly reservationTime,
														[FromQuery] int requiredCapacity,
														CancellationToken cancellationToken = default)
	{
		if (restaurantId <= 0 || requiredCapacity <= 0)
		{
			return BadRequest("RestaurantId and RequiredCapacity must be positive.");
		}

        return Ok(await reservationService.GetAvailableTablesAsync(restaurantId, reservationDate, reservationTime, requiredCapacity, cancellationToken));
    }
}