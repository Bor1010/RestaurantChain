import React from 'react';
import './Footer.css';
import { useTranslations } from '../../locales/LanguageContext';

export const Footer: React.FC = () => {
  const t = useTranslations();

  return (
    <footer className="site-footer" id="contacts">
      <div className="footer-container">

        <div className="footer-item">
          <span className="footer-icon">📞</span>
          <a href="tel:031234567" className="footer-link">03-123-45-67</a>
        </div>

        <div className="footer-divider">•</div>

        <div className="footer-item">
          <span className="footer-text">{t.footer.hours}</span>
        </div>

        <div className="footer-divider">•</div>

        <div className="footer-item">
          <span className="footer-text">{t.footer.copyright}</span>
        </div>
      </div>
    </footer>
  );
};
