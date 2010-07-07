module MilkshakeApp::Helpers
private
  
  def load_environment!
    Object.const_set('RAILS_ROOT', rails_root)  rescue nil
    ENV['RAILS_ENV'] = environment
    $rails_rake_task = true
    require(File.join(RAILS_ROOT, 'config', 'environment'))
  end
  
  def rails_root
    return @rails_root if @rails_root
    
    root_path = self.options.app
    root_path = File.expand_path(root_path)
    
    unless File.directory?(root_path) and File.file?(File.join(root_path, 'config', 'environment.rb'))
      bad_say("This is not a rails application!\n#{root_path}")
    end
    
    @rails_root = root_path
  end
  
  def goto_rails(path=nil)
    Dir.chdir(path || rails_root) do
      yield(Pathname.pwd)
    end
  end
  
  def environment
    self.options.environment
  end
  
  def good_say(msg)
    shell.say(msg, Thor::Shell::Color::GREEN)
  end
  
  def bad_say(msg, exit=true)
    shell.say(msg, Thor::Shell::Color::RED)
    exit(1) if exit
  end
  
  def ask_with_default(statement, default=nil, color=nil)
    if default
      answer = shell.ask(statement+" [#{default}]:", color)
      answer = default if answer.nil? or answer.strip.empty?
      answer.strip
    else
      shell.ask(statement, color)
    end
  end
  
  def ask_unless_given(statement, value=nil, default=nil, color=nil)
    if !value.nil? and value != default
      value
    else
      ask_with_default(statement, default, color)
    end
  end
  
  def assert_valid_gem_name!(name)
    unless name =~ /^[a-zA-Z0-9_-]+$/
      bad_say "please specify a valid gem name (/^[a-zA-Z0-9_-]+$/)"
    end
  end
  
  def assert_new_app_path!
    if File.exist?(self.options.app)
      bad_say("This path already exists!\n#{self.options.app}")
    end
  end
  
  def assert_new_shared_path!(path)
    if path.exist?
      bad_say("This path already exists!\n#{path}")
    end
  end
  
  def assert_shared_path!(path)
    unless path.exist?
      bad_say("This path already exists!\n#{path}")
    end
  end
  
  def pathname_for(path, expand=true)
    path = Pathname.new(path) unless Pathname === path
    path = path.expand_path
    path
  end
  
  def override_app_path!(path)
    path = File.expand_path(path)
    @options = @options.dup
    @options['app'] = path
  end
  
  def make_symlink!(old_path, new_path)
    Dir.chdir(old_path.dirname.to_s) do
      old_path.basename.make_symlink(new_path.relative_path_from(old_path.dirname))
    end
  end
  
  def swap_and_make_symlink!(old_path, new_path)
    old_path.rename(new_path)
    make_symlink! old_path, new_path
  end
  
  def safe_rm(path)
    path = Pathname.new(path) unless Pathname === path
    if path.file? or path.symlink?
      path.unlink
    elsif path.directory?
      path.rmtree
    end
  end
  
end