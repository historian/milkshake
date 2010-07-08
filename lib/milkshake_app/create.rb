class MilkshakeApp::Create < MilkshakeApp
  
  extend  Defaults
  namespace :create
  
  desc 'app PATH', 'create a new rails app.'
  method_option :'git-data', :default => false,
    :desc   => 'Initialize git for the shared directory',
    :type => :boolean,
    :group  => 'Command'
  method_option :'shared-data', :default => nil,
    :desc   => 'path for the shared directory',
    :banner => 'path', :type => :string,
    :group  => 'Command'
  def app(path)
    install_rails! path
    install_app!
    if self.options[:'shared-data']
      self.options[:'git'] = self.options[:'git-data']
      ensure_extrernalized_data! self.options[:'shared-data']
    end
  end
  
  desc 'gem PATH', 'create a new milkshake gem.'
  method_option :summary, :default => self.default_summary,
    :desc   => 'The gem summary',
    :banner => 'string', :type => :string,
    :group  => 'Gem'
  method_option :description, :default => self.default_description,
    :desc   => 'The gem description',
    :banner => 'string', :type => :string,
    :group  => 'Gem'
  method_option :website, :default => self.default_website,
    :desc   => 'The gem website',
    :banner => 'string', :type => :string,
    :group  => 'Gem'
  method_option :author, :default => self.default_author,
    :desc   => 'The gem author',
    :banner => 'string', :type => :string,
    :group  => 'Gem'
  method_option :email, :default => self.default_email,
    :desc   => 'The gem author\'s email address',
    :banner => 'string', :type => :string,
    :group  => 'Gem'
  method_option :git, :default => false,
    :desc   => 'Initialize git',
    :type => :boolean,
    :group  => 'Command'
  method_option :'git-data', :default => false,
    :desc   => 'Initialize git for the shared directory',
    :type => :boolean,
    :group  => 'Command'
  method_option :'shared-data', :default => nil,
    :desc   => 'path for the shared directory',
    :banner => 'path', :type => :string,
    :group  => 'Command'
  def gem(path)
    name = File.basename(path)
    assert_valid_gem_name! name
    install_rails! path
    install_app!
    install_gem! name
    if self.options[:'shared-data']
      self.options[:'git'] = self.options[:'git-data']
      ensure_extrernalized_data! self.options[:'shared-data']
    end
  end
  
  desc 'host PATH', 'create a new milkshake host app.'
  method_option :'git-data', :default => false,
    :desc   => 'Initialize git for the shared directory',
    :type => :boolean,
    :group  => 'Command'
  method_option :'shared-data', :default => nil,
    :desc   => 'path for the shared directory',
    :banner => 'path', :type => :string,
    :group  => 'Command'
  def host(path)
    install_rails! path
    install_app!
    install_host!
    if self.options[:'shared-data']
      self.options[:'git'] = self.options[:'git-data']
      ensure_extrernalized_data! self.options[:'shared-data']
    end
  end
  
end