
require 'snapshots'

module Composite
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
          Snapshots.dump
          
          link_public_directories!
          
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
    
    def link_public_directories!
      public_vendor_path = File.join(Rails.public_path, 'vendor')
      FileUtils.rm_rf(public_vendor_path)
      FileUtils.mkdir_p(public_vendor_path)
      
      self.environment.gemspecs.each do |gemspec|
        begin
          public_path = File.join(gemspec.full_gem_path, 'public')
          if File.directory?(public_path)
            FileUtils.ln_s(public_path, File.join(public_vendor_path, gemspec.name))
          end
        rescue
        end
      end
    end
    
    def link_only_once
      lock_path  = Composite.cache_file
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
