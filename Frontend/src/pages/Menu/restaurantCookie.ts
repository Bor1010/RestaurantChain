const COOKIE_NAME = 'restaurantId';
const COOKIE_MAX_AGE_SECONDS = 365 * 24 * 60 * 60;

export function getRestaurantCookie(): number | undefined {
  const match = document.cookie.match(new RegExp(`(?:^|; )${COOKIE_NAME}=([^;]*)`));
  const value = match ? Number(decodeURIComponent(match[1])) : NaN;
  return Number.isInteger(value) ? value : undefined;
}

export function setRestaurantCookie(restaurantId: number): void {
  document.cookie = `${COOKIE_NAME}=${restaurantId}; max-age=${COOKIE_MAX_AGE_SECONDS}; path=/; SameSite=Lax`;
}
