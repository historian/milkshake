
begin
  require 'thor'
rescue LoadError
  require 'rubygems'
  retry
end

module Milkshake
  class App < Thor
    
    def self.default_author
      @default_author ||= begin
        name = %x[git config --get user.name].chomp
        name = '[AUTHOR]' if name.nil? or name.empty?
        name
      end
    end
    
    def self.default_email
      @default_email ||= begin
        email = %x[git config --get user.email].chomp
        email = '[EMAIL]' if email.nil? or email.empty?
        email
      end
    end
    
    def self.default_environment
      @default_environment ||= begin
        ENV['RAILS_ENV'] || 'development'
      end
    end
    
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
        Milkshake.environment.gemspecs.each do |gemspec|
          puts "#{gemspec.name} (#{gemspec.version})"
        end
      end
    end
    
    desc 'create-app PATH', 'create a new rails app.'
    def create_app(path)
      install_rails! path
      install_app!
    end
    
    desc 'create-gem PATH', 'create a new milkshake gem.'
    method_option :summary, :default => '[SUMMARY]',
      :desc   => 'The gem summary',
      :banner => 'string', :type => :string,
      :group  => 'Gem'
    method_option :description, :default => '[DESCRIPTION]',
      :desc   => 'The gem description',
      :banner => 'string', :type => :string,
      :group  => 'Gem'
    method_option :website, :default => '[WEBSITE]',
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
    method_option :summary, :default => '[SUMMARY]',
      :desc   => 'The gem summary',
      :banner => 'string', :type => :string,
      :group  => 'Command'
    method_option :description, :default => '[DESCRIPTION]',
      :desc   => 'The gem description',
      :banner => 'string', :type => :string,
      :group  => 'Command'
    method_option :website, :default => '[WEBSITE]',
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
    
    module Helpers
    private
      
      def load_environment!
        Object.const_set('RAILS_ROOT', rails_root)  rescue nil
        ENV['RAILS_ENV'] = environment
        $rails_rake_task = true
        require(File.join(RAILS_ROOT, 'config', 'environment'))
      end
      
      def rails_root
        return @rails_root if @rails_root
        
        root_path = self.options.app
        root_path = File.expand_path(root_path)
        
        unless File.directory?(root_path) and File.file?(File.join(root_path, 'config', 'environment.rb'))
          bad_say("This is not a rails application!\n#{root_path}")
        end
        
        @rails_root = root_path
      end
      
      def goto_rails(path=nil, &proc)
        Dir.chdir(path || rails_root, &proc)
      end
      
      def environment
        self.options.environment
      end
      
      def good_say(msg)
        shell.say(msg, Thor::Shell::Color::GREEN)
      end
      
      def bad_say(msg, exit=true)
        shell.say(msg, Thor::Shell::Color::RED)
        exit(1) if exit
      end
      
    end
    
    module Actions
    private
      
      def assert_valid_gem_name!(name)
        unless name =~ /^[a-zA-Z0-9_-]+$/
          bad_say "please specify a valid gem name (/^[a-zA-Z0-9_-]+$/)"
        end
      end
      
      def assert_new_app_path!
        if File.exist?(self.options.app)
          bad_say("This path already exists!\n#{self.options.app}")
        end
      end
      
      def override_app_path!(path)
        path = File.expand_path(path)
        @options = @options.dup
        @options['app'] = path
      end
      
      def install_rails!(path)
        override_app_path! path
        assert_new_app_path!
        
        system(%{rails "#{self.options.app}" > /dev/null})
        good_say('Rails app successfully created!')
        
        goto_rails do
          if File.file?('config/locales/en.yml')
            File.unlink('config/locales/en.yml')
          end
          if File.file?('public/index.html')
            File.unlink('public/index.html')
          end
          if File.file?('public/images/rails.png')
            File.unlink('public/images/rails.png')
          end
          if File.file?('public/javascripts/controls.js')
            File.unlink('public/javascripts/controls.js')
          end
          if File.file?('public/javascripts/dragdrop.js')
            File.unlink('public/javascripts/dragdrop.js')
          end
          if File.file?('public/javascripts/effects.js')
            File.unlink('public/javascripts/effects.js')
          end
          if File.file?('public/javascripts/prototype.js')
            File.unlink('public/javascripts/prototype.js')
          end
          
          Milkshake::Template.evaluate('routes.rb'
          ).write_to('config/routes.rb')
        end
        
        good_say('Rails app successfully cleaned!')
      end
      
      def install_app!
        goto_rails do
          
          Milkshake::Template.evaluate('preinitializer.rb'
          ).write_to('config/preinitializer.rb')
          
          unless File.file?('config/milkshake.yml')
            Milkshake::Template.evaluate('milkshake.yml'
            ).write_to('config/milkshake.yml')
          end
          
        end
        
        good_say('Milkshake successfully installed!')
      end
      
      def install_gem!(name)
        assert_valid_gem_name! name
        
        goto_rails do
          Milkshake::Template.evaluate('jeweler.rake',
            :name        => name,
            :author      => self.options.author,
            :email       => self.options.email,
            :summary     => self.options.summary,
            :description => self.options.description,
            :website     => self.options.website
          ).write_to('lib/tasks/jeweler.rake')
          
          FileUtils.mkdir_p('rails/initializers')
          FileUtils.touch('rails/init.rb')
        end
        
        good_say('Jeweler successfully installed!')
      end
      
      def install_host!
        goto_rails do
          FileUtils.rm_rf('README')             rescue nil
          FileUtils.rm_rf('Rakefile')           rescue nil
          FileUtils.rm_rf('app')                rescue nil
          FileUtils.rm_rf('config/locales')     rescue nil
          FileUtils.rm_rf('db/seeds.rb')        rescue nil
          FileUtils.rm_rf('doc')                rescue nil
          FileUtils.rm_rf('lib')                rescue nil
          FileUtils.rm_rf('public/images')      rescue nil
          FileUtils.rm_rf('public/javascripts') rescue nil
          FileUtils.rm_rf('public/stylesheets') rescue nil
          FileUtils.rm_rf('test')               rescue nil
          FileUtils.rm_rf('vendor')             rescue nil
        end
        
        good_say('Rails app successfully stripped!')
      end
      
    end
    
    include Helpers
    include Actions
    
  end
end
