
module Composite
  class Cache
    
    attr_accessor :path, :entries
    
    def initialize(path)
      @path = path
      begin
        File.open(@path, 'r') { |f| @entries = Marshal.load(f.read) }
        raise 'wrong type' unless Hash === @entries
      rescue
        @entries = {}
      end
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
      @entries = {}
    end
    
    def persist!
      File.open(@path, 'w+') { |f| f.write Marshal.dump(@entries) }
    end
    
  end
end
