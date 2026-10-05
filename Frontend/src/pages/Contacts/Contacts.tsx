import React, { useEffect, useState } from 'react';
import './Contacts.css';
import { useLanguage, useTranslations } from '../../locales/LanguageContext';
import { getRestaurants, type Restaurant } from '../../services/restaurantsService';

interface ContactsProps {
  onBack: () => void;
}

function formatTime(time: string | null): string {
  return time ? time.slice(0, 5) : '—';
}

function groupByCity(restaurants: Restaurant[]): [string, Restaurant[]][] {
  const groups = new Map<string, Restaurant[]>();

  for (const restaurant of restaurants) {
    const cityRestaurants = groups.get(restaurant.city) ?? [];
    cityRestaurants.push(restaurant);
    groups.set(restaurant.city, cityRestaurants);
  }

  return [...groups.entries()];
}

export const Contacts: React.FC<ContactsProps> = ({ onBack }) => {
  const t = useTranslations();
  const { language } = useLanguage();
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [hasError, setHasError] = useState(false);

  useEffect(() => {
    let isCurrentRequest = true;

    setIsLoading(true);
    setHasError(false);

    getRestaurants(language)
      .then((loadedRestaurants) => {
        if (isCurrentRequest) {
          setRestaurants(loadedRestaurants);
        }
      })
      .catch(() => {
        if (isCurrentRequest) {
          setRestaurants([]);
          setHasError(true);
        }
      })
      .finally(() => {
        if (isCurrentRequest) {
          setIsLoading(false);
        }
      });

    return () => {
      isCurrentRequest = false;
    };
  }, [language]);

  return (
    <section className="contacts-page" dir={language === 'he' ? 'rtl' : 'ltr'}>
      <div className="contacts-overlay" />

      <button type="button" className="contacts-back-button" onClick={onBack}>
        <span aria-hidden="true">←</span>
        {t.contacts.backHome}
      </button>

      <div className="contacts-content">
        <header className="contacts-heading">
          <p className="contacts-eyebrow">MEAT &amp; FISH</p>
          <h1>{t.contacts.title}</h1>
          <p>{t.contacts.subtitle}</p>
        </header>

        {isLoading ? (
          <p className="contacts-message">{t.contacts.loading}</p>
        ) : hasError ? (
          <p className="contacts-message" role="alert">
            {t.contacts.error}
          </p>
        ) : (
          groupByCity(restaurants).map(([city, cityRestaurants]) => (
            
            <div className="contacts-city-group" key={city}>
              <h2 className="contacts-city-title">{city}</h2>
              <div className="contacts-cards">
                {cityRestaurants.map((restaurant) => (
                  <dl className="contacts-card" key={restaurant.restaurantId}>
                    <div className="contacts-card-row">
                      <dt>{t.contacts.name}</dt>
                      <dd>{restaurant.name}</dd>
                    </div>
                    <div className="contacts-card-row">
                      <dt>{t.contacts.address}</dt>
                      <dd>{restaurant.address}</dd>
                    </div>
                    <div className="contacts-card-row">
                      <dt>{t.contacts.phone}</dt>
                      <dd>{restaurant.phoneNumber ?? '—'}</dd>
                    </div>
                    <div className="contacts-card-row">
                      <dt>{t.contacts.email}</dt>
                      <dd>{restaurant.email ?? '—'}</dd>
                    </div>
                    <div className="contacts-card-row">
                      <dt>{t.contacts.hours}</dt>
                      <dd>
                        {formatTime(restaurant.openingTime)} - {formatTime(restaurant.closingTime)}
                      </dd>
                    </div>
                  </dl>
                ))}
              </div>
            </div>
          ))
        )}
      </div>
    </section>
  );
};
