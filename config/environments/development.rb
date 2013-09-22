Yava::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

	# http://railsapps.github.io/rails-environment-variables.html
	config.before_configuration do
		env_file = File.join(Rails.root, 'config', 'local_env.yml')
		YAML.load(File.open(env_file)).each do |key, value|
			ENV[key.to_s] = value
		end if File.exists?(env_file)
	end

  # http://railsapps.github.io/rails-send-email.html
  # ActionMailer Config
  config.action_mailer.logger = Rails.logger
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  config.action_mailer.smtp_settings = {
	address: "example.org",
	port: 123,
	domain: "yava.example.org",
	authentication: "plain",
	enable_starttls_auto: true,
	user_name: ENV["INQUIRY_USERNAME"],
	password: ENV["INQUIRY_PASSWORD"]
  }
end