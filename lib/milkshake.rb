module Milkshake
  
  require 'thor'
  require 'pathname'
  
  require 'milkshake/version'
  
  require 'milkshake/shared_helpers'
  require 'milkshake/cli'
  require 'milkshake/ui'
  require 'milkshake/settings'
  
  class << self
    
    attr_writer :ui
    
    def ui
      @ui ||= UI.new
    end
    
    def root
      default_rackupfile.dirname.expand_path
    end
    
    def app_config_path
      ENV['MILKSHAKE_APP_CONFIG'] ?
        Pathname.new(ENV['MILKSHAKE_APP_CONFIG']).expand_path(root) :
        root.join('.milkshake')
    end
    
    def settings
      @settings ||= Settings.new(app_config_path)
    end
    
    def default_rackupfile
      rackupfile = find_rackupfile
      raise RackupfileNotFound, "Could not locate config.ru" unless rackupfile
      Pathname.new(rackupfile)
    end
    
    def find_rackupfile
      given = ENV['MILKSHAKE_RACKUPFILE']
      return given if given && !given.empty?
    
      previous = nil
      current  = File.expand_path(Dir.pwd)
    
      until !File.directory?(current) || current == previous
        filename = File.join(current, 'config.ru')
        return filename if File.file?(filename)
        current, previous = File.expand_path("..", current), current
      end
    end
    
    def gemspecs
      if defined? ::Bundler
        Bundler.load.specs
      end
    end
    
  end
end
