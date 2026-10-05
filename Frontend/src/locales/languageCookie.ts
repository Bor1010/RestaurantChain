import type { Language } from './types';

const COOKIE_NAME = 'language';
const COOKIE_MAX_AGE_SECONDS = 365 * 24 * 60 * 60;

const isLanguage = (value: string): value is Language =>
  value === 'ru' || value === 'en' || value === 'he';

export function getLanguageCookie(): Language | undefined {
  const match = document.cookie.match(new RegExp(`(?:^|; )${COOKIE_NAME}=([^;]*)`));
  const value = match ? decodeURIComponent(match[1]) : '';
  return isLanguage(value) ? value : undefined;
}

export function setLanguageCookie(language: Language): void {
  document.cookie = `${COOKIE_NAME}=${language}; max-age=${COOKIE_MAX_AGE_SECONDS}; path=/; SameSite=Lax`;
}
