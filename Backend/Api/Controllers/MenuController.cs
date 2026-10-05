using Microsoft.AspNetCore.Mvc;
using RestaurantChain.Application;


namespace RestaurantChain.Api.Controllers
{
    [ApiController]
    [Route("api/menu")]
    public sealed class MenuController(IMenuService menuService) : ControllerBase
    {
        [HttpGet("categories")]
        public async Task<ActionResult> GetMenuCategories([FromQuery] int restaurantId, [FromQuery] string languageCode = "en", CancellationToken cancellationToken = default)
        {
            if (languageCode.Length is < 2 or > 5)
            {
                return BadRequest("languageCode must contain between 2 and 5 characters.");
            }

            var categories = await menuService.GetMenuCategoriesAsync(restaurantId, languageCode, cancellationToken);
            return Ok(categories);
        }

        [HttpGet("menuItems")]
        public async Task<ActionResult> GetMenuItems([FromQuery] int restaurantId, [FromQuery] int categoryId, [FromQuery] string languageCode = "en", CancellationToken cancellationToken = default)
        {
            if (languageCode.Length is < 2 or > 5)
            {
                return BadRequest("languageCode must contain between 2 and 5 characters.");
            }

            var items = await menuService.GetMenuItemsAsync(restaurantId, languageCode, categoryId, cancellationToken);
            return Ok(items);
        }
    }
}
