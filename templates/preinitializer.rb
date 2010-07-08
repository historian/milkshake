# this is the milkshake initializer

unless defined?(Bundler)
  environment = File.expand_path('.bundle/environment.rb', RAILS_ROOT)
  if File.file?(environment)
    require environment
  else
    require 'rubygems'
    require 'bundler'
  end
end

require 'milkshake/automagic'