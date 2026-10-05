import React from 'react';
import './Hero.css';
import heroSteakImg from './Images/hero-steak.jpg';
import heroFishImg from './Images/hero-fish.jpg';
import { useTranslations } from '../../locales/LanguageContext';

interface HeroProps {
  onBookTable: () => void;
}

export const Hero: React.FC<HeroProps> = ({ onBookTable }) => {
  const t = useTranslations();

  return (
    <section className="hero-section">
      <div className="hero-container">
        {/* Left Food Image - Ribeye Steak on Slate */}
        <div className="hero-image-wrapper hero-image-left">
          <img 
            src={heroSteakImg} 
            alt={t.hero.steakAlt} 
            className="hero-image"
          />
        </div>

        {/* Center Content */}
        <div className="hero-content">
          <h1 className="hero-title">{t.hero.title}</h1>
          <p className="hero-subtitle">
            {t.hero.subtitleLine1}<br />
            {t.hero.subtitleLine2}<br />
            {t.hero.subtitleLine3}
          </p>
          
          <button className="hero-cta-button" onClick={onBookTable}>
            {t.hero.ctaButton}
          </button>
        </div>

        {/* Right Food Image - Grilled Fish on Plate */}
        <div className="hero-image-wrapper hero-image-right">
          <img 
            src={heroFishImg}
            alt={t.hero.fishAlt}
            className="hero-image"
          />
        </div>
      </div>
    </section>
  );
};
