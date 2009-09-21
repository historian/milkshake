
require 'digest/sha1'

module Composite
  class Validator
    
    attr_reader :environment, :validation_file, :version, :link_time
    
    def initialize(environment, validation_file)
      @environment     = environment
      @validation_file = validation_file
      
      if File.file?(self.validation_file)
        begin
          yaml = YAML.load_file(self.validation_file)
          @version   = yaml['version']
          @link_time = yaml['link_time']
        rescue
          @version   = nil
          @link_time = nil
        end
      end
    end
    
    def migrate?
      (current_version != version) or relink?
    end
    
    def link_vendor_public?
      (current_version != version) or relink?
    end
    
    def current_version
      return @current_version if @current_version
      
      base = self.environment.gems.keys.sort.inject([]) do |m, name|
        m << [name, self.environment.gems[name]]
      end
      
      @current_version = Digest::SHA1.hexdigest(base.inspect)
    end
    
    def current_link_time
      return @current_link_time unless @current_link_time.nil?
      
      path = File.join(RAILS_ROOT, 'tmp', 'relink.txt')
      if File.file?(path)
        @current_link_time = File.mtime(path)
      else
        @current_link_time = false
      end
      
      @current_link_time
    end
    
    def relink?
      (link_time.nil?) or (current_link_time and link_time and current_link_time >= link_time)
    end
    
    def make_snapshot?
      migrate? or link_vendor_public?
    end
    
    def persist!
      File.open(self.validation_file, 'w+') do |f|
        f.write YAML.dump({ 'version' => current_version, 'link_time' => Time.now })
      end
    end
    
  end
end
