require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load


module RailsBootstrap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
    end


    config.to_prepare do
      Devise::Mailer.layout "mailer" # simple.haml or simple.erb
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.secret_key_base = ENV['SECRET_KEY_BASE']

    config.active_job.queue_adapter = :delayed_job

    Rails.application.routes.default_url_options[:host]= ENV['HOST']

    config.action_mailer.smtp_settings = {
      :address => "email-smtp.us-west-1.amazonaws.com",
      :domain => "caremountain.com",
      :port => 587,
      :user_name => ENV["SES_SMTP_USERNAME"],
      :password => ENV["SES_SMTP_PASSWORD"],
      :authentication => :login,
      :enable_starttls_auto => true
    }

  end
end
