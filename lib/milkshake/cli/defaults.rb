module Milkshake::CLI::Defaults
  
  def default_environment
    @default_environment ||= begin
      ENV['MILKSHAKE_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end
  end
  
  def default_framework
    @default_framework ||= begin
      'rails-234'
    end
  end
  
  def available_frameworks
    @available_frameworks ||= begin
      %w( rails-234 rails-300 )
    end
  end
  
end