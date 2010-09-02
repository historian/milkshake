class Rails::Configuration

  def environment_path
    File.expand_path("../../config/environments/#{environment}.rb", __FILE__)
  end

  def default_database_configuration_file
    [
      "#{root_path}/settings/database.yml",
      "#{root_path}/config/database.yml"
    ].detect { |path| File.exist?(path) }
  end
  
  def default_controller_paths
    paths = [
      File.join(root_path, 'app', 'controllers'),
      File.expand_path("../../app/controllers", __FILE__)
    ]
    paths.concat builtin_directories
    paths
  end
  
  def default_routes_configuration_file
    local = File.join(root_path, 'config', 'routes.rb')
    if File.file?(local)
      local
    else
      File.expand_path("../../config/routes.rb", __FILE__)
    end
  end

  alias \
    default_load_paths_without_milkshake \
    default_load_paths
  def default_load_paths
    paths = default_load_paths_without_milkshake
    paths.push File.expand_path("../../app/controllers", __FILE__)
    paths.push File.expand_path("../../app", __FILE__)
    paths
  end
  
  alias \
    default_eager_load_paths_without_milkshake \
    default_eager_load_paths
  def default_eager_load_paths
    paths = default_eager_load_paths_without_milkshake
    paths.push File.expand_path("../../app/controllers", __FILE__)
    paths.push File.expand_path("../../app", __FILE__)
    paths
  end
  
  def default_gems
    nil
  end
  
  def gems
    @gems ||= Bundler.definition.specs.collect do |spec|
      dep = Rails::GemDependency.new(spec.name)
      dep.specification = spec
      dep
    end.compact
  end
  
  def default_plugin_locators
    [Rails::Plugin::MilkshakeLocator]
  end

end

module Rails
  class GemDependency

    def dependencies
      return [] unless installed?
      specification.dependencies.reject do |dependency|
        dependency.type == :development
      end.map do |dependency|
        GemDependency.new(dependency.name, :requirement => dependency.version_requirements)
      end
    end
    
  end
end


module Rails
  class Plugin
    
    class Loader
      def plugins
        @plugins ||= all_plugins.select { |plugin| should_load?(plugin) }
      end
  
      def add_plugin_load_paths
        plugins.each do |plugin|
          plugin.load_paths.each do |path|
            $LOAD_PATH.insert(application_lib_index + 1, path)
      
            ActiveSupport::Dependencies.load_paths.unshift path
      
            unless configuration.reload_plugins?
              ActiveSupport::Dependencies.load_once_paths.unshift path
            end
          end
        end
      
        $LOAD_PATH.uniq!
      end
    end
    
    class MilkshakeLocator < Locator
      def plugins
        gem_index = initializer.configuration.gems.inject({}) { |memo, gem| memo.update gem.specification => gem }
        
        Bundler.definition.specs.collect do |spec|
          is_plugin = (
            spec.loaded_from and (
              File.exist?(File.join(spec.full_gem_path, "rails", "init.rb")) or
              File.exist?(File.join(spec.full_gem_path, "rails", "initializers"))
            )
          )
          
          if is_plugin
            Rails::GemPlugin.new(spec, gem_index[spec])
          end
        end.compact
      end
    end
    
  end
end