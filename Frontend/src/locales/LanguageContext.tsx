import React, { createContext, useContext, useMemo, useState } from 'react';
import type { Language, Translations } from './types';
import { russian } from './russian';
import { english } from './english';
import { hebrew } from './hebrew';
import { getLanguageCookie, setLanguageCookie } from './languageCookie';

const translationsByLanguage: Record<Language, Translations> = {
  ru: russian,
  en: english,
  he: hebrew,
};

interface LanguageContextValue {
  language: Language;
  setLanguage: (language: Language) => void;
  t: Translations;
}

const LanguageContext = createContext<LanguageContextValue | undefined>(undefined);


export const LanguageProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {

  const [language, setLanguageState] = useState<Language>(() => getLanguageCookie() ?? 'ru');

  const setLanguage = (nextLanguage: Language) => {
    setLanguageState(nextLanguage);
    setLanguageCookie(nextLanguage);
  };

  const value = useMemo<LanguageContextValue>(
    () => ({ language, setLanguage, t: translationsByLanguage[language] }),
    [language]
  );

  return <LanguageContext.Provider value={value}>{children}</LanguageContext.Provider>;
};

export const useTranslations = (): Translations => {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useTranslations must be used within a LanguageProvider');
  }
  return context.t;
};

export const useLanguage = (): LanguageContextValue => {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
};
