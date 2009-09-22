
require 'thor'

module Composite
  class App < Thor
    
    class_option :app, :default => '.', :type => :string,
      :desc   => 'Path to the rails application',
      :banner => 'rails_root',
      :group  => 'Global'
    
    desc 'install', 'install the composite preinitializer'
    def install
      goto_rails do
        
        FileUtils.touch('config/preinitializer.rb')
        unless IO.read('config/preinitializer.rb').include?('this is the composite initializer')
          File.open('config/preinitializer.rb', 'a+') do |f|
            f.write <<-EOC

# this is the composite initializer
require 'rubygems'
require 'composite/automagic'
EOC
          end
        end
        
        unless File.file?('config/composite.yml')
          File.open('config/composite.yml', 'w+') do |f|
            f.write <<-EOC
gems:
  lalala_more:
    version: 0.2.38
EOC
          end
        end
        
      end
    end
    
  private
    
    def rails_root
      return @rails_root if @rails_root
      
      root_path = self.options.app
      root_path = File.expand_path(root_path)
      
      unless File.directory?(root_path) and File.file?(File.join(root_path, 'config', 'environment.rb'))
        $stderr.puts "This is not a rails application!"
        exit(1)
      end
      
      @rails_root = root_path
    end
    
    def goto_rails(&proc)
      Dir.chdir(rails_root, &proc)
    end
    
  end
end
