# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#for FU plugin
ENV['INLINEDIR'] = File.join(File.dirname(__FILE__),'../public/uploads/')

#
# esTeam constants
#
ESTEAM_LEVEL_MARK = '◄'
ESTEAM_SITE_NAME ="MNC"

# email setting
ESTEAM_CST_FROM_EMAIL = "moshe.naftaly@mn-consult.com"
ESTEAM_CST_TO_EMAIL = "moshe.naftaly@mn-consult.com"

Rails::Initializer.run do |config|

# setting configuration for the mailer
config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true
config.action_mailer.raise_delivery_errors=true
config.action_mailer.smtp_settings = {
	   :address  => "zeus.site5.com",
	   :port  => 25, 
	   :domain => "mail.mn-consult.com",
	   :user_name => ESTEAM_CST_TO_EMAIL,
	   :password => "mncshalom",
	   :authentication => :login
    }    
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.autoload_paths += %W( #{RAILS_ROOT}/extras )
 # config.autoload_paths += %W( #{RAILS_ROOT}/app/models/ckeditor )
 config.autoload_paths += %W( #{RAILS_ROOT}/app/models/ckeditor )
 
  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :he and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  # See also in config/initializers/i18n.rb
   config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
end