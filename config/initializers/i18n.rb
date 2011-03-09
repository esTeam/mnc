
# define suportted  languages

ESTEAM_HEBREW_LANGUAGE = 'עברית'
ESTEAM_ENGLISH_LANGUAGE = 'English'
ESTEAM_DEFAULT_LANGUAGE = ESTEAM_HEBREW_LANGUAGE
ESTEAM_SUPPORTED_LANGUAGES = [ESTEAM_HEBREW_LANGUAGE,ESTEAM_ENGLISH_LANGUAGE]

ESTEAM_SUPPORTED_LOCALES = {
  ESTEAM_HEBREW_LANGUAGE  => 'he' ,
  ESTEAM_ENGLISH_LANGUAGE => 'en'
}

ESTEAM_NO_LANGUAGE_TXT = '---'

# define suportted  locales

I18n.default_locale = 'he'

LOCALES_DIRECTORY = "#{RAILS_ROOT}/config/locales/"

