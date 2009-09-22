
module Composite
  class Template
    
    class << self
      attr_accessor :template_dir
      
      def [](name)
        (@templates ||= {})[name] ||= load(name)
      end
      
      def evaluate(name, context={})
        self[name].evaluate(context)
      end
    end
    self.template_dir = File.join(File.dirname(__FILE__), '..', '..', 'templates')
    
    def self.load(name)
      path = File.join(self.template_dir, name)
      if File.exist?(path)
        new IO.read(path)
      else
        raise "Missing template #{name}"
      end
    end
    
    def initialize(template)
      @template = template
    end
    
    def evaluate(context={})
      result = @template.dup
      result.gsub!(/\{\{([a-zA-Z0-9_.-]+)\}\}/) do |m|
        (context[$1] || context[$1.to_sym]).to_s
      end
      result.extend SourceFile
      result
    end
    
    module SourceFile
      def write_to(path)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write self }
        self
      end
    end
    
  end
end