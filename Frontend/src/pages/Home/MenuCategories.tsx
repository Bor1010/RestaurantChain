import React from 'react';
import './MenuCategories.css';

import grillMeatImg from './Images/grill-meat.jpg';
import seafoodImg from './Images/seafood.jpg';
import dessertsImg from './Images/desserts.jpg';
import exclusiveImg from './Images/exclusive.jpg';
import { useTranslations } from '../../locales/LanguageContext';

interface MenuCategory {
  id: string;
  title: string;
  image: string;
  alt: string;
}

interface MenuCategoriesProps {
  onOpenMenu: () => void;
}

export const MenuCategories: React.FC<MenuCategoriesProps> = ({ onOpenMenu }) => {
  const t = useTranslations();

  const categories: MenuCategory[] = [
    {
      id: 'grill-meat',
      title: t.menu.grillMeat,
      image: grillMeatImg,
      alt: t.menu.grillMeatAlt
    },
    {
      id: 'seafood',
      title: t.menu.seafood,
      image: seafoodImg,
      alt: t.menu.seafoodAlt
    },
    {
      id: 'desserts',
      title: t.menu.desserts,
      image: dessertsImg,
      alt: t.menu.dessertsAlt
    },
    {
      id: 'exclusive',
      title: t.menu.exclusive,
      image: exclusiveImg,
      alt: t.menu.exclusiveAlt
    }
  ];

  return (
    <section className="menu-categories-section" id="menu">
      <div className="menu-categories-container">
        <button className="menu-categories-button" onClick={onOpenMenu}>{t.menu.sectionTitle}</button>

        <div className="categories-grid">
          {categories.map((category) => (
            <div key={category.id} className="category-card">
              {/* Card Title */}
              <div className="category-card-header">
                <h3 className="category-title">{category.title}</h3>
              </div>

              {/* Card Image Container with White Background Box */}
              <div className="category-image-box">
                <img 
                  src={category.image} 
                  alt={category.alt} 
                  className="category-image"
                />
              </div>

              {/* Card Action Button */}
              <div className="category-card-footer">
                <button className="category-button">
                  {t.menu.viewMenuButton}
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};
