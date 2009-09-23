
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
    
    desc 'install', 'install the milkshake preinitializer'
    def install
      goto_rails do
        
        Milkshake::Template.evaluate('preinitializer.rb'
        ).write_to('config/preinitializer.rb')
        
        unless File.file?('config/milkshake.yml')
          Milkshake::Template.evaluate('milkshake.yml'
          ).write_to('config/milkshake.yml')
        end
        
        shell.say('Milkshake successfully installed!', Thor::Shell::Color::GREEN)
        
      end
    end
    
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
    
    desc 'create PATH', 'create a new rails app.'
    method_option :gemify, :default => false,
      :desc   => 'Also make this a gem',
      :type => :boolean,
      :group  => 'Command'
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
    def create(path)
      
      # owerride app option
      path = File.expand_path(path)
      @options = @options.dup
      @options['app'] = path
      
      if File.exist?(self.options.app)
        shell.say("This path already exists!\n#{self.options.app}", Thor::Shell::Color::RED)
        exit(1)
      end
      
      system(%{rails "#{self.options.app}" > /dev/null})
      shell.say('Rails app successfully created!', Thor::Shell::Color::GREEN)
      
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
      
      shell.say('Rails app successfully cleaned!', Thor::Shell::Color::GREEN)
      
      install
      
      if self.options.gemify
        gemify(File.basename(path))
      end
    end
    
    desc 'gemify NAME', 'make a milkshake plugin'
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
    def gemify(name)
      unless name =~ /^[a-zA-Z0-9_-]+$/
        puts "please specify a valid gem name (/^[a-zA-Z0-9_-]+$/)"
        exit(1)
      end
      
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
      
      shell.say('Jeweler successfully installed!', Thor::Shell::Color::GREEN)
    end
    
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
        shell.say("This is not a rails application!\n#{root_path}", Thor::Shell::Color::RED)
        exit(1)
      end
      
      @rails_root = root_path
    end
    
    def goto_rails(path=nil, &proc)
      Dir.chdir(path || rails_root, &proc)
    end
    
    def environment
      self.options.environment
    end
    
  end
end
