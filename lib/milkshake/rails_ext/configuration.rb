module Milkshake::RailsExt::Configuration

  def self.included(base)
    base.class_eval do

      old_m = :default_i18n_without_milkshake
      new_m = :default_i18n_with_milkshake
      unless instance_methods.include?(old_m.to_s)
        alias_method old_m, :default_i18n
        alias_method :default_i18n, new_m
      end

    end
  end

  # inject locales from gem dependecies
  def default_i18n_with_milkshake
    i18n = default_i18n_without_milkshake

    paths = []

    Bundler::SPECS.each do |gemspec|
      locale_dir = File.expand_path(
        'config/locales',
        gemspec.full_gem_path)

      if File.directory?(locale_dir)
        paths.concat Dir[File.join(locale_dir, '*.{rb,yml}')]
      end
    end

    i18n.load_path.concat(paths)
    i18n.load_path.uniq!

    i18n
  end

end
