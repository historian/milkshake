require 'milkshake'

class Milkshake::CLI

  require 'opts'
  require 'pathname'

  require 'milkshake/hook'
  require 'milkshake/cli/defaults'
  require 'milkshake/cli/config'
  require 'milkshake/cli/commands'

  include Opts::DSL
  extend  Defaults

  def initialize
    @config = Milkshake::CLI::Config.new
  end

  class_use Opts::Shell
  class_use Opts::ErrorHandler
  class_use Opts::Environment, 'MILKSHAKE_'
  class_use Opts::ManHelp,
    :path    => File.expand_path('../../man', __FILE__),
    :default => 'milkshake'

  class_option "app",
    :short   => 'a',
    :default => '.',
    :type    => :string

  class_option "environment",
    :short   => 'e',
    :default => self.default_environment,
    :type    => :string


  argument 'NAME'
  def new(env, args)
    app_root = Pathname.new(File.expand_path(env['NAME'], env['APP']))

    if app_root.exist?
      raise "destination already exists!"
    end

    app_root.mkpath
    (app_root + 'log').mkpath
    (app_root + 'private').mkpath
    (app_root + 'public').mkpath
    (app_root + 'tmp').mkpath

    (app_root + 'config.ru').open('w+', 0644) do |file|
      file.write <<-EOC.gsub(/^\s+/m, '')
        require 'milkshake'

        MILKSHAKE_ROOT = File.dirname(__FILE__)
        run Milkshake.application
      EOC
    end

    (app_root + 'config.yml').open('w+', 0644) do |file|
      file.write <<-EOC.gsub(/^\s+/m, '')
        --- {}
      EOC
    end

    (app_root + 'Gemfile').open('w+', 0644) do |file|
      file.write <<-EOC.gsub(/^\s+/m, '')
        source :rubygems

        gem 'rails'
      EOC
    end
  end


  def config(env, args)
    @config.call(env, args)
  end


  def rake(env, args)
    Object.const_set('MILKSHAKE_ROOT', File.expand_path(env['APP']))
    Milkshake.application.rake(*args)
  end


  def exec(env, args)
    Object.const_set('MILKSHAKE_ROOT', File.expand_path(env['APP']))
    Milkshake.application.exec(*args)
  end


  def console(env, args)
    Object.const_set('MILKSHAKE_ROOT', File.expand_path(env['APP']))
    Milkshake.application.console(*args)
  end

  def update(env, args)
    Object.const_set('MILKSHAKE_ROOT', File.expand_path(env['APP']))
    Commands.update(env, args)
  end

  def install(env, args)
    Object.const_set('MILKSHAKE_ROOT', File.expand_path(env['APP']))
    Commands.install(env, args)
  end

end
