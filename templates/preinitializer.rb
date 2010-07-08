# this is the milkshake initializer

environment = File.expand_path('.bundle/environment.rb', RAILS_ROOT)
if File.file?(environment)
  require environment
else
  require 'rubygems'
end

require 'milkshake/automagic'