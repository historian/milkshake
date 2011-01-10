module Milkshake::SharedHelpers
  
  def setup_bundler
    # Set up gems listed in the Gemfile.
    begin
      ENV['BUNDLE_GEMFILE'] = gemfile_path
      require 'bundler'
      Bundler.setup
    rescue Bundler::GemNotFound => e
      STDERR.puts e.message
      STDERR.puts "Try running `milkshake update`."
      exit!
    end if File.exist?(gemfile_path)
  end
  
  def load_plugins
    Milkshake.gemspecs.each do |spec|
      plugin_path = File.expand_path('lib/milkshake_plugin.rb', spec.full_gem_path)
      
      if File.file?(plugin_path)
        load plugin_path
      end
    end
  end
  
  def run_hooks(type)
    
  end
  
  def bundler_path
    @bundler_path ||= File.expand_path('tmp/bundler', Milkshake.root)
  end
  
  def gemfile_path
    @gemfile_path ||= File.expand_path('Gemfile', bundler_path)
  end
  
end