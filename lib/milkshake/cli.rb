module Milkshake::Commands
  require 'milkshake/commands/init'
  require 'milkshake/commands/config'
  require 'milkshake/commands/update'
end

class Milkshake::CLI < Thor
  
  def initialize(*)
    super
    the_shell = (options["no-color"] ? Thor::Shell::Basic.new : shell)
    Milkshake.ui = Milkshake::UI::Shell.new(the_shell)
    Milkshake.ui.debug! if options["verbose"]
  end
  

  class_option "no-color", :type => :boolean, :banner => "Disable colorization in output"
  class_option "verbose",  :type => :boolean, :banner => "Enable verbose output mode", :aliases => "-V"
  

  desc "init [PATH]", 'Initialize a new host'
  def init(path)
    Milkshake::Commands::Init.new.init(path)
  end

  
  desc "update", 'Update the host'
  def update
    Milkshake::Commands::Update.new.update
  end


  desc "config NAME [VALUE]", "retrieve or set a configuration value"
  long_desc <<-D
    Retrieves or sets a configuration value. If only parameter is provided, retrieve the value. If two parameters are provided, replace the
    existing value with the newly provided one.
  
    By default, setting a configuration value sets it for all projects
    on the machine.
  
    If a global setting is superceded by local configuration, this command
    will show the current value, as well as any superceded values and
    where they were specified.
  D
  def config(name = nil, *args)
    Milkshake::Commands::Config.new.config(self, name, *args)
  end
  
end