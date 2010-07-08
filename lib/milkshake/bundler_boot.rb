class Milkshake::BundlerBoot

  def run
    load_initializer

    Rails::Initializer.class_eval do
      include Milkshake::RailsExt::Initializer
    end

    Rails::Configuration.class_eval do
      include Milkshake::RailsExt::Configuration
    end

    Rails::Initializer.run(:set_load_path)
  end

  def load_initializer
    # phusion already deals with bundler
    unless defined? PhusionPassenger
      
      # don't load bundler if it's already loaded
      unless defined? Bundler
        load_bundler
      end
      
      setup_load_paths
    end

    require 'initializer'
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
    ENV["BUNDLE_GEMFILE"] = File.expand_path("Gemfile", RAILS_ROOT)
    Bundler.setup
  rescue Bundler::GemNotFound
    raise RuntimeError, "Bundler couldn't find some gems. " +
      "Did you run `bundle install`?"
  end

end