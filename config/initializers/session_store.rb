# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_MNC_session',
  :secret      => '147b979ff5ed4461543721026296c491fe7e4720d32bbe5ecab9b82c92c004cef4ba697794721ed89c7d96e4409ce911e2bd6e1a37855562bcd284acaebde9ea'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
