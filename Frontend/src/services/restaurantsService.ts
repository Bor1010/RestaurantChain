export interface Restaurant {
  restaurantId: number;
  code: string;
  name: string;
  description: string | null;
  address: string;
  city: string;
  phoneNumber: string | null;
  email: string | null;
  openingTime: string | null;
  closingTime: string | null;
}

export interface AvailableTable {
  tableId: number;
  tableCode: string;
  capacity: number;
}

export async function getAvailableTables(
  restaurantId: number,
  reservationDate: string,
  reservationTime: string,
  requiredCapacity: number,
): Promise<AvailableTable[]> {
  const query = new URLSearchParams({
    restaurantId: String(restaurantId),
    reservationDate,
    reservationTime,
    requiredCapacity: String(requiredCapacity),
  });

  const response = await fetch(`/api/reservations/available-tables?${query}`);

  if (!response.ok) {
    throw new Error(`Unable to load available tables: ${response.status}`);
  }

  return response.json() as Promise<AvailableTable[]>;
}

export async function getRestaurants(languageCode: string): Promise<Restaurant[]> {
  
  const response = await fetch(
    `/api/restaurants?languageCode=${encodeURIComponent(languageCode)}`,
  );

  if (!response.ok) {
    throw new Error(`Unable to load restaurants: ${response.status}`);
  }

  return response.json() as Promise<Restaurant[]>;
}

export interface CreateVisitorRequest {
  email: string;
  firstName: string;
  lastName: string;
  phoneNumber: string | null;
  preferredLanguage: string;
}

export async function getOrCreateVisitor(request: CreateVisitorRequest): Promise<number> {
  const response = await fetch('/api/reservations/visitors', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(request),
  });

  if (!response.ok) {
    throw new Error(`Unable to create visitor: ${response.status}`);
  }

  const data = (await response.json()) as { visitorId: number };
  return data.visitorId;
}

export interface CreateReservationRequest {
  visitorId: number;
  tableId: number;
  restaurantId: number;
  reservationDate: string;
  reservationTime: string;
  numberOfGuests: number;
  reservationEndTime: string;
  specialRequests: string | null;
}

export interface CreatedReservation {
  reservationId: number;
  reservationNumber: string;
}

export async function createReservation(request: CreateReservationRequest): Promise<CreatedReservation> {
  
  const response = await fetch('/api/reservations/reserve', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(request),
  });

  if (!response.ok) {
    throw new Error(`Unable to create reservation: ${response.status}`);
  }

  return response.json() as Promise<CreatedReservation>;
}
