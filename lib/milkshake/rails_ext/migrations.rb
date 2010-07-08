module Milkshake::RailsExt::Migrator

  def self.included(base)
    base.class_eval do

      old_m = :migrations_without_milkshake
      new_m = :migrations_with_milkshake
      unless instance_methods.include?(old_m.to_s)
        alias_method old_m, :migrations
        alias_method :migrations, new_m
      end

    end
  end

  def migrations_with_milkshake
    return @migrations if @migrations
    all_migrations = []

    all_migrations.concat(migrations_without_milkshake)

    Bundler::SPECS.each do |gemspec|
      migrations_path_for_gemspec = File.expand_path('db/migrate',
        gemspec.full_gem_path)

      if File.directory?(migrations_path_for_gemspec)
        original_migrations_path    = @migrations_path
        @migrations                 = nil
        @migrations_path            = migrations_path_for_gemspec
        all_migrations.concat(migrations_without_milkshake)
        @migrations_path = original_migrations_path
      end
    end

    all_migrations = all_migrations.sort_by(&:version)
    down? ? all_migrations.reverse : all_migrations

    @migrations = all_migrations
  end

end