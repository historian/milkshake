require 'rubygems/specification'
require 'composite/rubygems_extentions/specification'

unless Gem::Specification.included_modules.include?(Composite::RubygemsExtentions::Specification)
  Gem::Specification.send :include,  Composite::RubygemsExtentions::Specification
end