using Microsoft.AspNetCore.Mvc;
using RestaurantChain.Application;

namespace RestaurantChain.Api.Controllers;

[ApiController]
[Route("api/restaurants")]
public sealed class RestaurantsController(IRestaurantService restaurantService) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult> GetAllRestaurants([FromQuery] string languageCode = "en", CancellationToken cancellationToken = default)
    {
        if (languageCode.Length is < 2 or > 5)
        {
            return BadRequest("languageCode must contain between 2 and 5 characters.");
        }

        var restaurants = await restaurantService.GetAllRestaurantsAsync(languageCode, cancellationToken);
        return Ok(restaurants);
    }
}