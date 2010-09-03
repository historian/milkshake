class Milkshake::Hook

  def self.new(*args, &block)
    if self == Milkshake::Hook
      Class.new(self, &block)
    else
      super
    end
  end

  def initialize(name, specs, env)
    @name  = name
    @specs = specs
    @env   = env
  end

  attr_reader :specs, :env, :name

  def run
    raise NotImplemented
  end

  def active_framework
    Milkshake.application.framework.name
  end

  def application_root
    @application_root ||= File.expand_path(env['APP'])
  end

  def bind(source, target, options={})
    case env['BIND_STRATEGY'] || 'link'
    when 'link' then link(source, target, options)
    when 'copy' then copy(source, target, options)
    else            raise "Unknown bind strategy"
    end
  end

  def link(source, target, options={})
    glob(source, options).each do |path|
      new_path = path.transpose_to(File.join(application_root, target))
      new_path.ensure_path
      new_path.make_symlink(path)
    end
  end

  def copy(source, target, options={})
    glob(source, options).each do |path|
      new_path = path.transpose_to(File.join(application_root, target))
      new_path.ensure_path
      new_path.make_copy(path)
    end
  end

  def directory(path)
    path = File.expand_path(path, application_root)
    FileUtils.mkdir_p(path)
  end

  def glob(source, options={})
    pattern  = options[:glob] || '*.*'
    patterns = []

    case source
    when /^gem[:]\/*(.+)$/
      @specs.each do |spec|
        base = File.join(spec.full_gem_path, $1)
        patterns << Path.new(base, pattern)
      end
    when /^app[:]\/*(.+)$/
      base = File.join(application_root, $1)
      patterns << Path.new(base, pattern)
    else
      patterns << Path.new(File.join('/', source), pattern)
    end

    if patterns.empty?
      return []
    end

    if options[:fall_through]
      paths = {}

      patterns.each do |pattern|
        pattern.glob.each do |path|
          paths[path.relative_path.to_s] = path
        end
      end

      paths.values.sort

    else
      return patterns.first.glob

    end
  end

  class Path

    def initialize(base, relative)
      @base_path     = Pathname.new(base)
      @relative_path = Pathname.new(relative)
    end

    attr_reader :base_path, :relative_path

    def to_s(full=true)
      if full
        full_path.to_s
      else
        @relative_path.to_s
      end
    end

    def full_path
      @full_path ||= (@base_path + @relative_path)
    end

    def transpose_to(new_base)
      Path.new(new_base, @relative_path)
    end

    def <=>(other)
      @relative_path <=> other.relative_path
    end

    def glob
      Dir.glob(full_path).collect do |path|
        Path.new(@base_path, Pathname.new(path).relative_path_from(@base_path))
      end
    end

    def ensure_path
      FileUtils.mkdir_p(File.dirname(to_s))
    end

    def make_symlink(old)
      File.unlink(full_path) if File.exist?(full_path)
      full_path.make_symlink(old.full_path)
    end

    def make_copy(old)
      File.unlink(full_path) if File.exist?(full_path)
      FileUtils.cp_r(old, self)
    end

  end

end