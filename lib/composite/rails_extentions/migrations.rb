
module Composite
  module RailsExtentions
    module Migrator
      
      def self.included(base)
        base.module_eval do
          alias_method :migrations_without_composite, :migrations
          alias_method :migrations, :migrations_with_composite
        end
      end
      
      def migrations_with_composite
        return @migrations if @migrations
        all_migrations = []
        
        Composite.environment.gemspecs.each do |gemspec|
          migrations_path_for_gemspec = File.join(gemspec.full_gem_path, 'db', 'migrate')
          if File.directory?(migrations_path_for_gemspec)
            original_migrations_path    = @migrations_path
            @migrations                 = nil
            @migrations_path            = migrations_path_for_gemspec
            all_migrations.concat(migrations_without_composite)
            @migrations_path = original_migrations_path
          end
        end
        
        all_migrations = all_migrations.sort_by(&:version)
        down? ? all_migrations.reverse : all_migrations
        
        @migrations = all_migrations
      end
      
    end
  end
end
