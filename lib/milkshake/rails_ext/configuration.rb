module Milkshake::RailsExt::Configuration

  def self.included(base)
    base.class_eval do

      old_m = :default_gems_without_milkshake
      new_m = :default_gems_with_milkshake
      unless instance_methods.include?(old_m.to_s)
        alias_method old_m, :default_gems
        alias_method :default_gems, new_m
      end

    end
  end

  def default_gems_with_milkshake
    Bundler::SPECS.inject([]) do |memo, gemspec|
      next(memo) if %w( rails actionmailer actionpack activerecord activeresource activesupport ).include? gemspec.name
      
      memo << Rails::GemDependency.new(gemspec.name, {})
    end
  end
  
end
