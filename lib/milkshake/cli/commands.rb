module Milkshake::CLI::Commands

  require 'shellwords'

  def update(env, args)
    in_app_root(env) do
      Kernel.system(Shellwords.shelljoin(['bundle', 'update'] + args))
      run_hooks(env)
    end
  end

  def install(env, args)
    in_app_root(env) do
      Kernel.system(Shellwords.shelljoin(['bundle', 'install'] + args))
      run_hooks(env)
    end
  end

  def run_hooks(env)
    Milkshake.application.setup!

  end

  def in_app_root(env)
    app_root = File.expand_path(env['APP'])
    Dir.chdir(app_root) do
      yield
    end
  end

  extend self

end