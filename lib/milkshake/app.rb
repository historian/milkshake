
begin
  require 'thor'
rescue LoadError
  require 'rubygems'
  retry
end

require 'pathname'

module Milkshake
  class App < Thor
    
    autoload :Helpers,  'milkshake/app/helpers'
    autoload :Actions,  'milkshake/app/actions'
    autoload :Defaults, 'milkshake/app/defaults'
    
    include Helpers
    include Actions
    include Defaults
    
    class_option :app, :default => '.',
      :desc   => 'Path to the rails application',
      :banner => 'rails_root', :type => :string,
      :group  => 'Global'
    
    class_option :environment, :default => self.default_environment,
      :desc   => 'Rails environment',
      :banner => 'env', :type => :string,
      :group  => 'Global'
    
    desc 'info', 'list all loaded gems'
    def info
      goto_rails do
        load_environment!
        
        puts "Loaded gems:"
        data = Milkshake.environment.gemspecs.collect { |gemspec| [gemspec.name, gemspec.version] }
        shell.print_table(data)
      end
    end
    
    desc 'create-app PATH', 'create a new rails app.'
    def create_app(path)
      install_rails! path
      install_app!
    end
    
    desc 'create-gem PATH', 'create a new milkshake gem.'
    method_option :summary, :default => 'FIX_ME_SUMMARY',
      :desc   => 'The gem summary',
      :banner => 'string', :type => :string,
      :group  => 'Gem'
    method_option :description, :default => 'FIX_ME_DESCRIPTION',
      :desc   => 'The gem description',
      :banner => 'string', :type => :string,
      :group  => 'Gem'
    method_option :website, :default => 'FIX_ME_WEBSITE',
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
    def create_gem(path)
      name = File.basename(path)
      assert_valid_gem_name! name
      install_rails! path
      install_app!
      install_gem! name
    end
    
    desc 'create-host PATH', 'create a new milkshake host app.'
    def create_host(path)
      install_rails! path
      install_app!
      install_host!
    end
    
    desc 'install-app', 'install the milkshake preinitializer'
    def install_app
      install_app!
    end
    
    desc 'install-gem NAME', 'make a milkshake plugin'
    method_option :summary, :default => 'FIX_ME_SUMMARY',
      :desc   => 'The gem summary',
      :banner => 'string', :type => :string,
      :group  => 'Command'
    method_option :description, :default => 'FIX_ME_DESCRIPTION',
      :desc   => 'The gem description',
      :banner => 'string', :type => :string,
      :group  => 'Command'
    method_option :website, :default => 'FIX_ME_WEBSITE',
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
    
    desc 'install-host', 'make a milkshake host app'
    def install_host
      install_app!
      install_host!
    end
    
    desc 'extract-data SHARED_DIR', 'extract all data'
    def extract_data(path)
      externalize_data!(path)
    end
    
  end
end
