class Milkshake

  require 'fileutils'
  require 'milkshake/version'
  require 'milkshake/framework'

  class << self
    attr_accessor :application
    
    def application
      @application ||= new
    end
  end

  def initialize

  end

  def framework
    @framework ||= select_framework.new(self)
  end
  
  def boot!
    @is_booted ||= begin
      self.framework.boot
      true
    end
  end
  
  def booted?
    @is_booted || false
  end
  
  def setup!
    @is_setup ||= begin
      self.framework.setup
      true
    end
  end
  
  def setup?
    @is_setup || false
  end
  
  def app
    @app ||= begin
      boot!
      setup!
      self.framework.app
    end
  end
  
  def rake(*args)
    self.framework.rake(*args)
  end
  
  def exec(*args)
    self.framework.exec(*args)
  end
  
  def console(*args)
    self.framework.console(*args)
  end
  
  def call(env)
    self.app.call(env)
  end

private

  def select_framework
    frameworks = File.expand_path('../milkshake/frameworks', __FILE__)
  
    setup_milkshake_root
    setup_bundler
  
    case
    
    when spec = Gem.loaded_specs['rails']
      case spec.version.to_s
      when '2.3.4'
        require File.expand_path('rails_234/framework', frameworks)
      when '3.0.0'
        require File.expand_path('rails_300/framework', frameworks)
      end
    
    end
  
    unless Milkshake::Framework.framework
      raise 'No framework detected'
    end
  
    Milkshake::Framework.framework
  end
  
  def setup_milkshake_root
    unless defined?(::MILKSHAKE_ROOT)
      root = ENV['MILKSHAKE_ROOT'] || '.'
      root = File.expand_path(root)
      Object.const_set('MILKSHAKE_ROOT', root)
    end
  end

  def setup_bundler
    # phusion already deals with bundler
    unless defined? PhusionPassenger

      # don't load bundler if it's already loaded
      unless defined? Bundler
        load_bundler
      end

      setup_load_paths
    end
  end

  def load_bundler
    begin
      require 'bundler'
    rescue LoadError
      raise "Could not load the bundler gem. " +
        "Install it with `gem install bundler`."
    end

    if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
      raise RuntimeError, "Your bundler version is too old. " +
        "Run `gem install bundler` to upgrade."
    end

    true
  end

  def setup_load_paths
    # Set up load paths for all bundled gems
    ENV["BUNDLE_GEMFILE"] = File.expand_path("Gemfile", MILKSHAKE_ROOT)
    Bundler.setup
  rescue Bundler::GemNotFound
    raise RuntimeError, "Bundler couldn't find some gems. " +
      "Did you run `bundle install`?"
  end
  
end
