
require 'snapshots'

module Composite
  class Linker
    
    attr_reader :environment, :validator
    
    def initialize(environment, validator)
      @environment = environment
      @validator   = validator
    end
    
    def link!
      link_only_once do
        if validator.make_snapshot?
          Snapshots.dump
        end
        
        if validator.link_vendor_public?
          link_public_directories!
        end
        
        if validator.migrate?
          run_migrations!
        end
        
        validator.persist!
      end
    end
    
  private
    
    def run_migrations!
      ActiveRecord::Migrator.migrate("db/migrate/", nil)
    end
    
    def link_public_directories!
      public_vendor_path = File.join(RAILS_ROOT, 'public', 'vendor')
      FileUtils.rm_rf(public_vendor_path)
      FileUtils.mkdir_p(public_vendor_path)
      
      self.environment.gemspecs.each do |gemspec|
        public_path = File.join(gemspec.full_gem_path, 'public')
        if File.directory?(public_path)
          FileUtils.ln_s(public_path, File.join(public_vendor_path, gemspec.name))
        end
      end
    end
    
    def link_only_once
      lock_path  = File.join(RAILS_ROOT, 'tmp', 'composite_version.yml')
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
