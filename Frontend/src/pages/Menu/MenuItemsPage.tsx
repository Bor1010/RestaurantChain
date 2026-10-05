import React, { useEffect, useState } from 'react';
import '../TableReservations/TableReservations.css';
import './Menu.css';
import { useLanguage, useTranslations } from '../../locales/LanguageContext';
import { getMenuItems, type MenuCategory, type MenuItem } from '../../services/menuService';

interface MenuItemsPageProps {
  restaurantId: number;
  category: MenuCategory;
  onBack: () => void;
}

export const MenuItemsPage: React.FC<MenuItemsPageProps> = ({ restaurantId, category, onBack }) => {
  const t = useTranslations();
  const { language } = useLanguage();
  const [items, setItems] = useState<MenuItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [hasError, setHasError] = useState(false);

  useEffect(() => {
    let isCurrentRequest = true;

    setIsLoading(true);
    setHasError(false);

    getMenuItems(restaurantId, category.categoryId, language)
      .then((loaded) => {
        if (isCurrentRequest) {
          setItems(loaded);
        }
      })
      .catch(() => {
        if (isCurrentRequest) {
          setItems([]);
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
  }, [restaurantId, category.categoryId, language]);

  return (
    <section className="reservations-page" dir={language === 'he' ? 'rtl' : 'ltr'}>
      <div className="reservations-overlay" />

      <button type="button" className="reservations-back-button" onClick={onBack}>
        <span aria-hidden="true">←</span>
        {t.menuPage.backToCategories}
      </button>

      <div className="reservations-content">
        <header className="reservations-heading">
          <p className="reservations-eyebrow">MEAT &amp; FISH</p>
          <h1>{category.name}</h1>
        </header>

        <div className="reservation-form">
          {isLoading ? (
            <p className="menu-empty">{t.menuPage.loading}</p>
          ) : hasError ? (
            <p className="reservation-message" role="alert">{t.menuPage.itemsError}</p>
          ) : items.length === 0 ? (
            <p className="menu-empty">{t.menuPage.noItems}</p>
          ) : (
            <ul className="menu-list">
              {items.map((item) => (
                <li key={item.itemId} className="menu-list-item">
                  <span className="menu-list-title">
                    {item.name} - <span className="menu-item-price">{item.price.toFixed(2)}</span>
                  </span>
                  {item.description && (
                    <span className="menu-list-description menu-item-description">{item.description}</span>
                  )}
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </section>
  );
};
