import React, { useEffect, useState } from 'react';
import './TableReservations.css';
import { useLanguage, useTranslations } from '../../locales/LanguageContext';
import {
  createReservation,
  getAvailableTables,
  getOrCreateVisitor,
  getRestaurants,
  type Restaurant,
} from '../../services/restaurantsService';

interface TableReservationsProps {
  onBack: () => void;
}

const timeSlots = ['13:00', '14:30', '17:00', '18:30', '20:00', '21:30'];
const reservationDurationMinutes = 90;

function addMinutesToTime(time: string, minutesToAdd: number): string {
  const [hours, minutes] = time.split(':').map(Number);
  const totalMinutes = hours * 60 + minutes + minutesToAdd;
  const endHours = Math.floor(totalMinutes / 60) % 24;
  const endMinutes = totalMinutes % 60;
  return `${String(endHours).padStart(2, '0')}:${String(endMinutes).padStart(2, '0')}`;
}

interface PendingReservation {
  restaurantId: number;
  tableId: number;
  reservationDate: string;
  reservationTime: string;
  numberOfGuests: number;
}

export const TableReservations: React.FC<TableReservationsProps> = ({ onBack }) => {
  const t = useTranslations();
  const { language } = useLanguage();
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [isLoadingRestaurants, setIsLoadingRestaurants] = useState(true);
  const [restaurantsError, setRestaurantsError] = useState(false);
  const [guests, setGuests] = useState(2);
  const [isSearching, setIsSearching] = useState(false);
  const [showContactForm, setShowContactForm] = useState(false);
  const [showNoAvailability, setShowNoAvailability] = useState(false);
  const [isBookingConfirmed, setIsBookingConfirmed] = useState(false);
  const [isBooking, setIsBooking] = useState(false);
  const [bookingError, setBookingError] = useState(false);
  const [reservationNumber, setReservationNumber] = useState<string | null>(null);
  const [pendingReservation, setPendingReservation] = useState<PendingReservation | null>(null);
  const today = new Date().toISOString().split('T')[0];
  const guestLabel = guests === 1 ? t.reservations.guest : t.reservations.guestsMany;


  useEffect(() => {
    let isCurrentRequest = true;

    setIsLoadingRestaurants(true);
    setRestaurantsError(false);

    getRestaurants(language)
      .then((loadedRestaurants) => {
        if (isCurrentRequest) {
          setRestaurants(loadedRestaurants);
        }
      })
      .catch(() => {
        if (isCurrentRequest) {
          setRestaurants([]);
          setRestaurantsError(true);
        }
      })
      .finally(() => {
        if (isCurrentRequest) {
          setIsLoadingRestaurants(false);
        }
      });

    return () => {
      isCurrentRequest = false;
    };
  }, [language]);

  return (
    <section
      className="reservations-page"
      dir={language === 'he' ? 'rtl' : 'ltr'}
    >
      <div className="reservations-overlay" />

      <button
        type="button"
        className="reservations-back-button"
        onClick={onBack}
      >
        <span aria-hidden="true">←</span>
        {t.reservations.backHome}
      </button>

      <div className="reservations-content">
        <header className="reservations-heading">
          <p className="reservations-eyebrow">MEAT &amp; FISH</p>
          <h1>{t.reservations.title}</h1>
          <p>{t.reservations.subtitle}</p>
        </header>

        <form
          className="reservation-form"
          onSubmit={async (event) => {
            event.preventDefault();

            const formData = new FormData(event.currentTarget);

            if (showContactForm) {
              if (!pendingReservation) {
                return;
              }

              setIsBooking(true);
              setBookingError(false);

              try {
                const visitorId = await getOrCreateVisitor({
                  email: String(formData.get('email')),
                  firstName: String(formData.get('firstName')),
                  lastName: String(formData.get('lastName')),
                  phoneNumber: String(formData.get('phone')),
                  preferredLanguage: language,
                });

                const reservation = await createReservation({
                  visitorId,
                  tableId: pendingReservation.tableId,
                  restaurantId: pendingReservation.restaurantId,
                  reservationDate: pendingReservation.reservationDate,
                  reservationTime: pendingReservation.reservationTime,
                  numberOfGuests: pendingReservation.numberOfGuests,
                  reservationEndTime: addMinutesToTime(
                    pendingReservation.reservationTime,
                    reservationDurationMinutes,
                  ),
                  specialRequests: null,
                });

                setReservationNumber(reservation.reservationNumber);
                setIsBookingConfirmed(true);
              } catch {
                setBookingError(true);
              } finally {
                setIsBooking(false);
              }

              return;
            }

            setIsSearching(true);
            setShowNoAvailability(false);

            try {
              const restaurantId = Number(formData.get('restaurantId'));
              const reservationDate = String(formData.get('reservationDate'));
              const reservationTime = String(formData.get('reservationTime'));

              const availableTables = await getAvailableTables(
                restaurantId,
                reservationDate,
                reservationTime,
                guests,
              );

              if (availableTables.length === 0) {
                setShowNoAvailability(true);
              } else {
                setPendingReservation({
                  restaurantId,
                  tableId: availableTables[0].tableId,
                  reservationDate,
                  reservationTime,
                  numberOfGuests: guests,
                });
                setShowContactForm(true);
              }
            } finally {
              setIsSearching(false);
            }
          }}
        >
          {!showContactForm ? (
            <>
          <label>
            <span>{t.reservations.restaurant}</span>
            <div className="reservation-select">
              <select
                name="restaurantId"
                required
                defaultValue=""
                disabled={isLoadingRestaurants || restaurantsError}
              >
                <option value="" disabled>
                  {isLoadingRestaurants
                    ? t.reservations.loadingRestaurants
                    : restaurantsError
                      ? t.reservations.restaurantsError
                      : t.reservations.chooseRestaurant}
                </option>
                {restaurants.map((restaurant) => (
                  <option key={restaurant.restaurantId} value={restaurant.restaurantId}>
                    {restaurant.name} — {restaurant.city}
                  </option>
                ))}
              </select>
            </div>
          </label>

          <div className="reservation-grid">
            <label>
              <span>{t.reservations.date}</span>
              <input name="reservationDate" type="date" min={today} required />
            </label>

            <label>
              <span>{t.reservations.time}</span>
              <div className="reservation-select">
                <select name="reservationTime" required defaultValue="">
                  <option value="" disabled>
                    {t.reservations.chooseTime}
                  </option>
                  {timeSlots.map((time) => (
                    <option key={time} value={time}>
                      {time}
                    </option>
                  ))}
                </select>
              </div>
            </label>
          </div>

          <div className="reservation-field">
            <span>{t.reservations.guests}</span>
            <div className="guest-counter">
              <strong>
                {guests} {guestLabel}
              </strong>
              <div className="guest-controls">
                <button
                  type="button"
                  aria-label="Decrease guests"
                  onClick={() => setGuests(Math.max(1, guests - 1))}
                >
                  −
                </button>
                <span>{guests}</span>
                <button
                  type="button"
                  aria-label="Increase guests"
                  onClick={() => setGuests(Math.min(8, guests + 1))}
                >
                  +
                </button>
              </div>
            </div>
          </div>

          {showNoAvailability && (
            <p className="reservation-message" role="alert">
              {t.reservations.noAvailability}
            </p>
          )}

          <button type="submit" className="reservation-submit" disabled={isSearching}>
            {isSearching ? t.reservations.searching : t.reservations.findTable}
          </button>
            </>
          ) : isBookingConfirmed ? (
            <div className="reservation-confirmation">
              <div className="success-mark" aria-hidden="true">
                ✓
              </div>
              <h2 id="reservation-success-title">{t.reservations.successTitle}</h2>
              {reservationNumber && (
                <p className="reservation-number">
                  {t.reservations.reservationNumber}: {reservationNumber}
                </p>
              )}
              <p>{t.reservations.successMessage}</p>
            </div>
          ) : (
            <>
              <div className="reservation-grid">
                <label>
                  <span>{t.reservations.name}</span>
                  <input name="firstName" placeholder={t.reservations.namePlaceholder} required />
                </label>
                <label>
                  <span>{t.reservations.surname}</span>
                  <input name="lastName" placeholder={t.reservations.surnamePlaceholder} required />
                </label>
              </div>

              <label>
                <span>{t.reservations.phone}</span>
                <input name="phone" type="tel" placeholder={t.reservations.phonePlaceholder} required />
              </label>

              <label>
                <span>{t.reservations.email}</span>
                <input name="email" type="email" placeholder={t.reservations.emailPlaceholder} required />
              </label>

              {bookingError && (
                <p className="reservation-message" role="alert">
                  {t.reservations.bookingError}
                </p>
              )}

              <button type="submit" className="reservation-submit" disabled={isBooking}>
                {isBooking ? t.reservations.booking : t.reservations.bookTable}
              </button>
            </>
          )}
        </form>
      </div>
    </section>
  );
};