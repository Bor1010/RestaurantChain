export interface MenuCategory {
  categoryId: number;
  name: string;
  description: string | null;
  displayOrder: number;
}

export interface MenuItem {
  itemId: number;
  name: string;
  description: string | null;
  price: number;
  isVegetarian: boolean;
  isSpicy: boolean;
  isCosher: boolean;
  allergens: string | null;
  displayOrder: number;
}

export async function getMenuCategories(restaurantId: number, languageCode: string): Promise<MenuCategory[]> {
  const query = new URLSearchParams({ restaurantId: String(restaurantId), languageCode });
  const response = await fetch(`/api/menu/categories?${query}`);

  if (!response.ok) {
    throw new Error(`Unable to load menu categories: ${response.status}`);
  }

  return response.json() as Promise<MenuCategory[]>;
}

export async function getMenuItems(restaurantId: number, categoryId: number, languageCode: string): Promise<MenuItem[]> {
  const query = new URLSearchParams({
    restaurantId: String(restaurantId),
    categoryId: String(categoryId),
    languageCode,
  });
  const response = await fetch(`/api/menu/menuItems?${query}`);

  if (!response.ok) {
    throw new Error(`Unable to load menu items: ${response.status}`);
  }

  return response.json() as Promise<MenuItem[]>;
}
