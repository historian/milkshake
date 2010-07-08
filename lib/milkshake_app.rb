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
  require 'milkshake_app/data'
  
  include Helpers
  include Actions
  extend  Defaults
  
  namespace :default
  
  # def self.start(given_args = ARGV, config = {})
  #   if self == MilkshakeApp
  #     case given_args[0]
  #     when 'deploy'
  #       given_args[0] = 'deploy:version'
  #     when 'build'
  #       given_args[0] = 'build:current'
  #     end
  #   end
  #   super(given_args, config)
  # end
  
  def self.banner(task)
    "#{banner_base} #{task.formatted_usage(self, true)}"
  end
  
  def help(meth=nil)
    if meth && !self.respond_to?(meth)
      klass, task = Thor::Util.find_class_and_task_by_namespace(meth)
      klass.start(["-h", task].compact, :shell => self.shell)
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
