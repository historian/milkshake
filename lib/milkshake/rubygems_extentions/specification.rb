
module Milkshake
  module RubygemsExtentions
    module Specification
      
      def rails_dependencies
        path = File.join(self.full_gem_path, 'config', 'milkshake.yml')
        return YAML.load_file(path)['gems']
      rescue
        return(@engine_dependencies || {})
      end
      
      def store_persistent_load_information!
        @persistent_loaded      = @loaded
        @persistent_loaded_from = @loaded_from
      end
      
      def use_persistent_load_information!
        @loaded      = @persistent_loaded
        @loaded_from = @persistent_loaded_from
      end
      
    end
  end
end
