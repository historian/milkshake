class MilkshakeApp::Data < MilkshakeApp
  
  extend  Defaults
  namespace :data
  
  desc 'extract SHARED_DIR', 'extract all data'
  method_option :git, :default => false,
    :desc   => 'Initialize git',
    :type => :boolean,
    :group  => 'Command'
  def extract(path)
    externalize_data! path
  end
  
  desc 'link SHARED_DIR', 'link all data to an existing shared directory'
  def link(path)
    link_externalized_data! path
  end
  
end