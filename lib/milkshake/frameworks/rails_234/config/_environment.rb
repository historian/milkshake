RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.expand_path('../boot', __FILE__)

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'

  if File.file?(File.expand_path('settings/session.yml', RAILS_ROOT))
    require 'erb'
    session_keys = File.expand_path('settings/session.yml', RAILS_ROOT)
    keys = YAML::load(ERB.new(IO.read(session_keys)).result)
    config.action_controller.session = keys[RAILS_ENV]
  end
end
