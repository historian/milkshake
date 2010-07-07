require 'thor'

class MilkshakeApp < Thor
  
  require 'pathname'
  require 'fileutils'
  require 'milkshake/version'
  require 'milkshake/rails_version'
  require 'milkshake_app/helpers'
  require 'milkshake_app/actions'
  require 'milkshake_app/defaults'
  require 'milkshake_app/template'
  
  include Helpers
  include Actions
  extend  Defaults
  
  namespace :default
  
  class_option :app, :default => '.',
    :desc   => 'Path to the rails application',
    :banner => 'rails_root', :type => :string,
    :group  => 'Global'
  
  class_option :environment, :default => self.default_environment,
    :desc   => 'Rails environment',
    :banner => 'env', :type => :string,
    :group  => 'Global'
  
  desc 'create.app PATH', 'create a new rails app.'
  method_option :'git-data', :default => false,
    :desc   => 'Initialize git for the shared directory',
    :type => :boolean,
    :group  => 'Command'
  method_option :'shared-data', :default => nil,
    :desc   => 'path for the shared directory',
    :banner => 'path', :type => :string,
    :group  => 'Command'
  def create_app(path)
    install_rails! path
    install_app!
    if self.options[:'shared-data']
      self.options[:'git'] = self.options[:'git-data']
      ensure_extrernalized_data! self.options[:'shared-data']
    end
  end
  
  desc 'create.gem PATH', 'create a new milkshake gem.'
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
  def create_gem(path)
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
  
  desc 'create.host PATH', 'create a new milkshake host app.'
  method_option :'git-data', :default => false,
    :desc   => 'Initialize git for the shared directory',
    :type => :boolean,
    :group  => 'Command'
  method_option :'shared-data', :default => nil,
    :desc   => 'path for the shared directory',
    :banner => 'path', :type => :string,
    :group  => 'Command'
  def create_host(path)
    install_rails! path
    install_app!
    install_host!
    if self.options[:'shared-data']
      self.options[:'git'] = self.options[:'git-data']
      ensure_extrernalized_data! self.options[:'shared-data']
    end
  end
  rename_task 'create_host' => 'create.host',
              'create_app'  => 'create.app',
              'create_gem'  => 'create.gem'
  
  desc 'install.app', 'install the milkshake preinitializer'
  def install_app
    install_app!
  end
  
  desc 'install.gem NAME', 'make a milkshake plugin'
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
  def install_gem(name)
    assert_valid_gem_name! name
    install_app!
    install_gem! name
  end
  
  desc 'install.host', 'make a milkshake host app'
  def install_host
    install_app!
    install_host!
  end
  rename_task 'install_host' => 'install.host',
              'install_app'  => 'install.app',
              'install_gem'  => 'install.gem'
  
  desc 'extract.data SHARED_DIR', 'extract all data'
  method_option :git, :default => false,
    :desc   => 'Initialize git',
    :type => :boolean,
    :group  => 'Command'
  def extract_data(path)
    externalize_data! path
  end
  rename_task 'extract_data' => 'extract.data'
  
  desc 'link.data SHARED_DIR', 'link all data to an existing shared directory'
  def link_data(path)
    link_externalized_data! path
  end
  rename_task 'link_data' => 'link.data'
  
end
