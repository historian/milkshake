class MilkshakeApp::Install < MilkshakeApp
  
  namespace :install
  
  desc 'app', 'install the milkshake preinitializer'
  def app
    install_app!
  end
  
  desc 'gem NAME', 'make a milkshake plugin'
  method_option :summary, :default => self.default_summary,
    :desc   => 'The gem summary',
    :banner => 'string', :type => :string,
    :group  => 'Command'
  method_option :description, :default => self.default_description,
    :desc   => 'The gem description',
    :banner => 'string', :type => :string,
    :group  => 'Command'
  method_option :website, :default => self.default_website,
    :desc   => 'The gem website',
    :banner => 'string', :type => :string,
    :group  => 'Command'
  method_option :author, :default => self.default_author,
    :desc   => 'The gem author',
    :banner => 'string', :type => :string,
    :group  => 'Command'
  method_option :email, :default => self.default_email,
    :desc   => 'The gem author\'s email address',
    :banner => 'string', :type => :string,
    :group  => 'Command'
  method_option :git, :default => false,
    :desc   => 'Initialize git',
    :type => :boolean,
    :group  => 'Command'
  def gem(name)
    assert_valid_gem_name! name
    install_app!
    install_gem! name
  end
  
  desc 'host', 'make a milkshake host app'
  def host
    install_app!
    install_host!
  end
  
end