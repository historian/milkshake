require 'thor'

class MilkshakeApp < Thor
  
  require 'pathname'
  require 'fileutils'
  
  require 'milkshake/version'
  require 'milkshake/rails_version'
  
  require 'milkshake_app/helpers'
  require 'milkshake_app/actions'
  require 'milkshake_app/defaults'
  require 'milkshake_app/template'
  
  require 'milkshake_app/create'
  require 'milkshake_app/install'
  require 'milkshake_app/upgrade'
  require 'milkshake_app/data'
  
  include Helpers
  include Actions
  extend  Defaults
  
  namespace :default
  
  def self.banner(task, *args)
    if task.name == 'help'
      "milkshake #{task.formatted_usage(self, false)}"
    else
      "milkshake #{task.formatted_usage(self, true)}"
    end
  end
  
  def help(task=nil, subcommand=false)
    if task && !self.respond_to?(task)
      klass, task = Thor::Util.find_class_and_task_by_namespace(task)
      klass.new.help(task, true)
    else
      super
    end
  end
  
  def method_missing(meth, *args)
    if self.class == MilkshakeApp
      meth = meth.to_s
      klass, task = Thor::Util.find_class_and_task_by_namespace(meth)
      args.unshift(task) if task
      klass.start(args, :shell => self.shell)
    else
      super
    end
  end
  
  class_option :app, :default => '.',
    :desc   => 'Path to the rails application',
    :banner => 'rails_root', :type => :string,
    :group  => 'Global'
  
  class_option :environment, :default => self.default_environment,
    :desc   => 'Rails environment',
    :banner => 'env', :type => :string,
    :group  => 'Global'
  
end
