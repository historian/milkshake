require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

class Milkshake
  class Application < Rails::Application
    config.root = Pathname.new(MILKSHAKE_ROOT).expand_path
    config.encoding = "utf-8"
    config.filter_parameters += [:password, :password_confirmation]
    
    config.paths.config.database = "settings/database.yml"
    
    config.paths.config.environment =
      File.expand_path('../environment.rb', __FILE__)
    
    config.paths.config.environments =
      File.expand_path("../environments/#{Rails.env}.rb", __FILE__)

    if File.file?(File.expand_path('settings/session.yml', MILKSHAKE_ROOT))
      require 'erb'
      session_keys = File.expand_path('settings/session.yml', MILKSHAKE_ROOT)
      keys = YAML::load(ERB.new(IO.read(session_keys)).result)
      config.secret_token = keys[Rails.env]['secret']
    end
  end
end
