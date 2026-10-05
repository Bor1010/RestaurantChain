import React, { useEffect, useState } from 'react';
import '../TableReservations/TableReservations.css';
import './Menu.css';
import { useLanguage, useTranslations } from '../../locales/LanguageContext';
import { getRestaurants, type Restaurant } from '../../services/restaurantsService';
import { getMenuCategories, type MenuCategory } from '../../services/menuService';
import { getRestaurantCookie, setRestaurantCookie } from './restaurantCookie';

interface MenuCategoriesPageProps {
  onBack: () => void;
  onSelectCategory: (restaurantId: number, category: MenuCategory) => void;
}

export const MenuCategoriesPage: React.FC<MenuCategoriesPageProps> = ({ onBack, onSelectCategory }) => {
  const t = useTranslations();
  const { language } = useLanguage();
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [restaurantId, setRestaurantId] = useState<number | null>(null);
  const [isLoadingRestaurants, setIsLoadingRestaurants] = useState(true);
  const [restaurantsError, setRestaurantsError] = useState(false);
  const [categories, setCategories] = useState<MenuCategory[]>([]);
  const [isLoadingCategories, setIsLoadingCategories] = useState(false);
  const [categoriesError, setCategoriesError] = useState(false);

  useEffect(() => {
    let isCurrentRequest = true;

    setIsLoadingRestaurants(true);
    setRestaurantsError(false);

    getRestaurants(language)
      .then((loaded) => {
        if (!isCurrentRequest) {
          return;
        }

        setRestaurants(loaded);
        const savedId = getRestaurantCookie();
        const initial = loaded.find((r) => r.restaurantId === savedId) ?? loaded[0];
        setRestaurantId((current) => current ?? initial?.restaurantId ?? null);
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

  useEffect(() => {
    if (restaurantId === null) {
      return;
    }

    let isCurrentRequest = true;

    setIsLoadingCategories(true);
    setCategoriesError(false);

    getMenuCategories(restaurantId, language)
      .then((loaded) => {
        if (isCurrentRequest) {
          setCategories(loaded);
        }
      })
      .catch(() => {
        if (isCurrentRequest) {
          setCategories([]);
          setCategoriesError(true);
        }
      })
      .finally(() => {
        if (isCurrentRequest) {
          setIsLoadingCategories(false);
        }
      });

    return () => {
      isCurrentRequest = false;
    };
  }, [restaurantId, language]);

  return (
    <section className="reservations-page" dir={language === 'he' ? 'rtl' : 'ltr'}>
      <div className="reservations-overlay" />

      <button type="button" className="reservations-back-button" onClick={onBack}>
        <span aria-hidden="true">←</span>
        {t.menuPage.backHome}
      </button>

      <div className="reservations-content">
        <header className="reservations-heading">
          <p className="reservations-eyebrow">MEAT &amp; FISH</p>
          <h1>{t.menuPage.categoriesTitle}</h1>
        </header>

        <div className="reservation-form">
          <label>
            <span>{t.menuPage.restaurant}</span>
            <div className="reservation-select">
              <select
                value={restaurantId ?? ''}
                disabled={isLoadingRestaurants || restaurantsError || restaurants.length === 0}
                onChange={(event) => {
                  const id = Number(event.target.value);
                  setRestaurantId(id);
                  setRestaurantCookie(id);
                }}
              >
                {restaurantId === null && (
                  <option value="" disabled>
                    {isLoadingRestaurants ? t.menuPage.loadingRestaurants : t.menuPage.restaurantsError}
                  </option>
                )}
                {restaurants.map((restaurant) => (
                  <option key={restaurant.restaurantId} value={restaurant.restaurantId}>
                    {restaurant.name} — {restaurant.city}
                  </option>
                ))}
              </select>
            </div>
          </label>

          {isLoadingCategories ? (
            <p className="menu-empty">{t.menuPage.loading}</p>
          ) : categoriesError ? (
            <p className="reservation-message" role="alert">{t.menuPage.categoriesError}</p>
          ) : categories.length === 0 ? (
            <p className="menu-empty">{t.menuPage.noCategories}</p>
          ) : (
            <ol className="menu-list">
              {categories.map((category, index) => (
                <li key={category.categoryId}>
                  <button
                    type="button"
                    className="menu-list-item"
                    onClick={() => restaurantId !== null && onSelectCategory(restaurantId, category)}
                  >
                    <span className="menu-list-title">{index + 1}. {category.name}</span>
                    {category.description && (
                      <span className="menu-list-description"> - {category.description}</span>
                    )}
                  </button>
                </li>
              ))}
            </ol>
          )}
        </div>
      </div>
    </section>
  );
};
