
module Composite
  module RubygemsExtentions
    module Specification
      
      def self.included(base)
        base.module_eval do
          attribute :rails_dependencies, {}
          
          alias_method :ruby_code_without_composite, :ruby_code
          alias_method :ruby_code, :ruby_code_with_composite
          
          alias_method :to_ruby_without_composite, :to_ruby
          alias_method :to_ruby, :to_ruby_with_composite
        end
      end
      
      def add_rails_dependency(name, options={})
        name = name.to_s
        add_runtime_dependency(name, *[options[:version]].compact)
        @rails_dependencies ||= {}
        @rails_dependencies[name] = options
      end
      
      def ruby_code_with_composite(obj)
        return obj.inspect if Hash === obj
        return ruby_code_without_composite(obj)
      end
      
      def to_ruby_with_composite
        code = to_ruby_without_composite
        code.gsub!(/s\.rails_dependencies\s+[=]([^\n]+)/, 's.instance_variable_set(:@rails_dependencies,\1)')
        code
      end
      
    end
  end
end
