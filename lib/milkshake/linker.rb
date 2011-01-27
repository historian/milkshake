
module Milkshake
  class Linker
    
    attr_reader :environment, :validator, :cache
    
    def initialize(environment, validator, cache)
      @environment = environment
      @validator   = validator
      @cache       = cache
    end
    
    def link!
      link_only_once do
        if validator.relink?
          
          run_migrations!
          
          validator.persist!
          cache.persist!
        end
      end
    end
    
  private
    
    def run_migrations!
      ActiveRecord::Migrator.migrate("db/migrate/", nil)
    end
    
    def link_only_once
      lock_path  = Milkshake.cache_file
      FileUtils.touch(lock_path)
      lock_file  = File.new(lock_path)
      acquired   = !!lock_file.flock(File::LOCK_EX | File::LOCK_NB)
      if acquired
        yield
      else
        lock_file.flock(File::LOCK_EX)
      end
    ensure
      lock_file.flock(File::LOCK_UN)
    end
    
  end
end
