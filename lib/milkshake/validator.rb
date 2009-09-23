
require 'digest/sha1'

module Milkshake
  class Validator
    
    attr_reader :cache, :link_time
    
    def initialize(cache)
      @cache = cache
      
      @link_time = @cache.key('link.time')
      @cache.reset! if relink?
    end
    
    def current_link_time
      return @current_link_time unless @current_link_time.nil?
      
      path = File.join(RAILS_ROOT, 'tmp', 'relink.txt')
      if File.file?(path)
        @current_link_time = File.mtime(path)
      else
        @current_link_time = Time.now
      end
      
      @current_link_time
    end
    
    def relink?
      (link_time.nil?) or (current_link_time and link_time and current_link_time > link_time)
    end
    
    def persist!
      @cache['link.time'] = Time.now
    end
    
  end
end
