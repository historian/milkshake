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

    app_root = File.expand_path(env['APP'])
    FileUtils.rm_rf(File.expand_path('public', app_root))
    FileUtils.rm_rf(File.expand_path('tmp',    app_root))
    FileUtils.mkdir_p(File.expand_path('public', app_root))
    FileUtils.mkdir_p(File.expand_path('tmp',    app_root))

    available_hooks(env).each do |hook|
      env['opts.shell'].say "Running hook: #{hook.name}", :green
      hook.run
    end
  end

  def in_app_root(env)
    app_root = File.expand_path(env['APP'])
    Dir.chdir(app_root) do
      yield
    end
  end

  def available_hooks(env)
    @hooks ||= begin
      specs = Bundler.definition.specs
      hook_paths.collect do |(hook_path, name)|
        source = File.read(hook_path)
        hook = eval("Milkshake::Hook.new { #{source} }", TOPLEVEL_BINDING, hook_path)
        hook.new(name, specs, env)
      end
    end
  end

  def hook_paths
    @hook_paths ||= begin
      paths = []
      Bundler.definition.specs.each do |spec|
        hook_path = File.expand_path(
          'milkshake/hook.rb', spec.full_gem_path)

        if File.file?(hook_path)
          paths << [hook_path, spec.full_name]
        end
      end
      paths
    end
  end

  extend self

end