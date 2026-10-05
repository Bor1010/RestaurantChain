import React from 'react';
import './Header.css';
import { useLanguage, useTranslations } from '../../locales/LanguageContext';
import type { Language } from '../../locales/types';

const LANGUAGE_OPTIONS: { code: Language; label: string }[] = [
  { code: 'ru', label: 'RU' },
  { code: 'en', label: 'EN' },
  { code: 'he', label: 'HE' },
];

interface HeaderProps {
  onContactsClick?: () => void;
}

export const Header: React.FC<HeaderProps> = ({ onContactsClick }) => {
  const t = useTranslations();
  const { language, setLanguage } = useLanguage();

  return (
    <header className="site-header">
      {/* Top Header Bar */}
      <div className="header-top">
        <div className="header-top-container">
          {/* Language Switcher */}
          <div className="header-language-switcher">
            <select
              className="header-language-select"
              value={language}
              onChange={(event) => setLanguage(event.target.value as Language)}
              aria-label="Language"
            >
              {LANGUAGE_OPTIONS.map((option) => (
                <option key={option.code} value={option.code}>
                  {option.label}
                </option>
              ))}
            </select>
          </div>

          {/* Logo Section */}
          <div className="logo-container">
            <span className="logo-text">{t.header.logoLeft}</span>
            <div className="logo-icon">
              {/* Custom Cutlery SVG Icon (Fork, Knife, Spoon in Gold) */}
              <svg width="24" height="28" viewBox="0 0 24 28" fill="none" xmlns="http://www.w3.org/2000/svg">
                {/* Fork */}
                <path d="M5 2V10C5 11.1 5.9 12 7 12V26H9V12C10.1 12 11 11.1 11 10V2H9.5V7H8.5V2H6.5V7H5.5V2H5Z" fill="url(#gold-grad)" />
                {/* Knife */}
                <path d="M13 2V13C13 14 13.8 14.8 14.8 14.8H15V26H17V2C13 2 13 2 13 2Z" fill="url(#gold-grad)" />
                {/* Spoon */}
                <path d="M19 2C17.3 2 16 4 16 6.5C16 9 17.3 11 19 11V26H21V11C22.7 11 24 9 24 6.5C24 4 22.7 2 19 2Z" fill="url(#gold-grad)" />
                <defs>
                  <linearGradient id="gold-grad" x1="0" y1="0" x2="0" y2="26" gradientUnits="userSpaceOnUse">
                    <stop stopColor="#f3e098" />
                    <stop offset="0.5" stopColor="#cfa358" />
                    <stop offset="1" stopColor="#9e7b39" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            <span className="logo-text">{t.header.logoRight}</span>
          </div>

          {/* Phone Number */}
          <div className="header-phone">
            <a href="tel:031234567">03-123-45-67</a>
          </div>
        </div>
      </div>

      {/* Navigation Bar with Gold Background */}
      <nav className="header-nav">
        <ul className="nav-list">
          <li className="nav-item"><a href="#about" className="nav-link">{t.header.navAbout}</a></li>
          <li className="nav-item"><a href="#menu" className="nav-link">{t.header.navMenu}</a></li>
          <li className="nav-item"><a href="#gallery" className="nav-link">{t.header.navGallery}</a></li>
          <li className="nav-item">
            <a
              href="#contacts"
              className="nav-link"
              onClick={(event) => {
                if (onContactsClick) {
                  event.preventDefault();
                  onContactsClick();
                }
              }}
            >
              {t.header.navContacts}
            </a>
          </li>
        </ul>
      </nav>
    </header>
  );
};
