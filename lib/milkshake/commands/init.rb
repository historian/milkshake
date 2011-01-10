class Milkshake::Commands::Init
  
  def init(path)
    @path = File.expand_path(path)
    guard_new_host
    generate_host
  end
  
private
  
  def guard_new_host
    if File.exist?(@path)
      ui.error("Host exists: #{@path}")
      exit 1
    end
  end
  
  def generate_host
    FileUtils.mkdir_p(@path)
    FileUtils.mkdir_p(@path + '/data')
    FileUtils.mkdir_p(@path + '/.milkshake')
    FileUtils.mkdir_p(@path + '/tmp')
    FileUtils.cp(File.expand_path('../../templates/config.ru', __FILE__),
                 @path + '/config.ru')
    FileUtils.cp(File.expand_path('../../templates/config.yml', __FILE__),
                 @path + '/.milkshake/config')
  end
  
end