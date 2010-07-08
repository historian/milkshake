class MilkshakeApp::Upgrade < MilkshakeApp
  
  extend  Defaults
  namespace :upgrade
  
  desc 'app', 'upgrade this milkshake app'
  def app
    upgrade_app!
  end
  
end