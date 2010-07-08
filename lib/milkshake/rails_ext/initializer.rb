module Milkshake::RailsExt::Initializer

  def self.included(base)
    base.class_eval do

      old_m = :load_application_initializers_without_milkshake
      new_m = :load_application_initializers_with_milkshake
      unless instance_methods.include?(old_m.to_s)
        alias_method old_m, :load_application_initializers
        alias_method :load_application_initializers, new_m
      end

    end
  end

  def load_gems
    @bundler_loaded ||= Bundler.require :default, Rails.env
  end

  def load_application_initializers_with_milkshake
    Milkshake::Linker.new.link!

    paths = []

    Bundler::SPECS.each do |gemspec|
      paths.concat Dir.glob(File.expand_path(
        'rails/initializers/**/*.rb',
        gemspec.full_gem_path))
    end

    paths.concat Dir.glob(File.expand_path(
      'rails/initializers/**/*.rb',
      Rails.root))

    paths.concat Dir.glob(File.expand_path(
      'rails/init.rb',
      Rails.root))

    paths.each do |path|
      load(path)
    end

    load_application_initializers_without_milkshake
  end

end
