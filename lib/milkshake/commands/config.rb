class Milkshake::Commands::Config
  
  def config(cli, name=nil, *args)
    values = ARGV.dup
    values.shift # remove config
    values.shift # remove the name
  
    unless name
      Milkshake.ui.confirm "Settings are listed in order of priority. The top value will be used.\n"
  
      Milkshake.settings.all.each do |setting|
        Milkshake.ui.confirm "#{setting}"
        cli.with_padding do
          Milkshake.settings.pretty_values_for(setting).each do |line|
            Milkshake.ui.info line
          end
        end
        Milkshake.ui.confirm ""
      end
      return
    end
  
    if values.empty?
      Milkshake.ui.confirm "Settings for `#{name}` in order of priority. The top value will be used"
      cli.with_padding do
        Milkshake.settings.pretty_values_for(name).each { |line| Milkshake.ui.info line }
      end
    else
      locations = Milkshake.settings.locations(name)
  
      if local = locations[:local]
        Milkshake.ui.info "Your application has set #{name} to #{local.inspect}. This will override the " \
          "system value you are currently setting"
      end
  
      if global = locations[:global]
        Milkshake.ui.info "You are replacing the current system value of #{name}, which is currently #{global}"
      end
  
      if env = locations[:env]
        Milkshake.ui.info "You have set a bundler environment variable for #{env}. This will take precedence " \
          "over the system value you are setting"
      end
  
      Milkshake.settings.set_local(name, values.join(" "))
    end
    
  end
  
end