
module Milkshake
  class Cache
    
    attr_accessor :path, :entries, :history
    
    def initialize(path)
      @path = path
      begin
        File.open(@path, 'r') { |file| @entries = Marshal.load(file.read) }
        raise 'wrong type' unless Hash === @entries
      rescue
        @entries = {}
      end
      @history = []
    end
    
    def key(name)
      if @entries.key?(name.to_s)
        @entries[name.to_s]
      elsif block_given?
        @entries[name.to_s] = yield
      else
        nil
      end
    end
    
    def [](name)
      @entries[name.to_s]
    end
    
    def []=(name, value)
      @entries[name.to_s] = value
    end
    
    def reset!
      @history << @entries
      @entries = {}
    end
    
    def restore!
      @entries = @history.pop || {}
    end
    
    def persist!
      File.open(@path, 'w+') { |file| file.write Marshal.dump(@entries) }
    end
    
  end
end
