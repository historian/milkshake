# Don't change this file!
# Configure your app in config/environment.rb and config/environments/*.rb

RAILS_ROOT = MILKSHAKE_ROOT

module Rails
  class << self
    def boot!
      unless booted?
        preinitialize
        pick_boot.run
      end
    end

    def booted?
      defined? Rails::Initializer
    end

    def pick_boot
      BundlerBoot.new
    end

    def preinitialize
      load(preinitializer_path) if File.exist?(preinitializer_path)
    end

    def preinitializer_path
      "#{RAILS_ROOT}/config/preinitializer.rb"
    end

    def vendor_rails?
      false
    end
  end

  class BundlerBoot

    def run
      load_initializer

      require File.expand_path('../../rails_ext.rb', __FILE__)

      Rails::Initializer.run(:set_load_path)
    end

    def load_initializer
      require 'initializer'
    end

  end
end

# All that for this:
Rails.boot!
