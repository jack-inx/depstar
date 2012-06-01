Trunk::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  Stamps.configure do |config|
	  config.integration_id = '904e44fc-b53f-44ae-bf2a-2d265241e389'
	  # config.username       = 'jacobresnek'
	  # config.password       = 'jake1878'
	  config.username       = 'depstar'
	  config.password       = 'postage1'
		config.log_messages   = true
		# config.endpoint				= 'https://swsim.testing.stamps.com/swsim/SwsimV22.asmx'
		# config.namespace			=	'http://stamps.com/xml/namespace/2012/04/swsim/swsimv22'
		config.endpoint				= 'https://swsim.testing.stamps.com/swsim/swsimv12.asmx'
		config.namespace			=	'http://stamps.com/xml/namespace/2010/11/swsim/swsimv12'
	end
    
end

