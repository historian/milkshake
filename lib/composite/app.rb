
require 'thor'

module Composite
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
    
    desc 'install', 'install the composite preinitializer'
    def install
      goto_rails do
        
        Composite::Template.evaluate('preinitializer.rb'
        ).write_to('config/preinitializer.rb')
        
        unless File.file?('config/composite.yml')
          Composite::Template.evaluate('composite.yml'
          ).write_to('config/composite.yml')
        end
        
      end
    end
    
    desc 'info', 'list all loaded gems'
    def info
      goto_rails do
        load_environment!
        
        puts "Loaded gems:"
        Composite.environment.gemspecs.each do |gemspec|
          puts "#{gemspec.name} (#{gemspec.version})"
        end
      end
    end
    
    desc 'gemify NAME', 'make a composite plugin'
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
        Composite::Template.evaluate('jeweler.rake',
          :name        => name,
          :author      => self.options.author,
          :email       => self.options.email,
          :summary     => self.options.summary,
          :description => self.options.description,
          :website     => self.options.website
        ).write_to('lib/tasks/jeweler.rake')
      end
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
        $stderr.puts "This is not a rails application!"
        exit(1)
      end
      
      @rails_root = root_path
    end
    
    def goto_rails(&proc)
      Dir.chdir(rails_root, &proc)
    end
    
    def environment
      self.options.environment
    end
    
  end
end
