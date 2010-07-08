require 'fileutils'

module Milkshake

  require 'milkshake/version'
  require 'milkshake/rails_version'

  require 'milkshake/bundler_boot'
  require 'milkshake/linker'

  module RailsExt
    require 'milkshake/rails_ext/configuration'
    require 'milkshake/rails_ext/initializer'
    require 'milkshake/rails_ext/migrations'
  end
end