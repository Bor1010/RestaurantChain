import React from 'react';
import { Header } from './pages/Home/Header';
import { Hero } from './pages/Home/Hero';
import { MenuCategories } from './pages/Home/MenuCategories';
import { Footer } from './pages/Home/Footer';
import { TableReservations } from './pages/TableReservations/TableReservations';
import { Contacts } from './pages/Contacts/Contacts';
import { MenuCategoriesPage } from './pages/Menu/MenuCategoriesPage';
import { MenuItemsPage } from './pages/Menu/MenuItemsPage';
import type { MenuCategory } from './services/menuService';
import { LanguageProvider } from './locales/LanguageContext';

interface SelectedMenuCategory {
  restaurantId: number;
  category: MenuCategory;
}

export const App: React.FC = () => {
  const [currentPage, setCurrentPage] = React.useState<'home' | 'reservations' | 'contacts' | 'menuCategories' | 'menuItems'>('home');
  const [selectedCategory, setSelectedCategory] = React.useState<SelectedMenuCategory | null>(null);

  return (
    <LanguageProvider>
      <div className="page-container">
        <main className="main-content">
          {currentPage === 'home' ? (
            <>
              <Header onContactsClick={() => setCurrentPage('contacts')} />
              <Hero onBookTable={() => setCurrentPage('reservations')} />
              <MenuCategories onOpenMenu={() => setCurrentPage('menuCategories')} />
              <Footer />
            </>
          ) : currentPage === 'reservations' ? (
            <TableReservations onBack={() => setCurrentPage('home')} />
          ) : currentPage === 'menuCategories' ? (
            <MenuCategoriesPage
              onBack={() => setCurrentPage('home')}
              onSelectCategory={(restaurantId, category) => {
                setSelectedCategory({ restaurantId, category });
                setCurrentPage('menuItems');
              }}
            />
          ) : currentPage === 'menuItems' && selectedCategory ? (
            <MenuItemsPage
              restaurantId={selectedCategory.restaurantId}
              category={selectedCategory.category}
              onBack={() => setCurrentPage('menuCategories')}
            />
          ) : (
            <Contacts onBack={() => setCurrentPage('home')} />
          )}
        </main>
      </div>
    </LanguageProvider>
  );
};

export default App;
