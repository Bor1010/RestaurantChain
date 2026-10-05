import { english } from './english';

// Widens the literal string values inferred from english.ts to plain `string`, keeping the nested shape.
type Strings<T> = { 
    [K in keyof T]: T[K] extends string ? string : Strings<T[K]> 
};

// english.ts is the source of truth for which keys must exist; other languages are checked against this shape.
export type Translations = Strings<typeof english>;

export type Language = 'ru' | 'en' | 'he';
