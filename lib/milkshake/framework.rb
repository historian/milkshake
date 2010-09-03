class Milkshake::Framework

  class << self
    attr_accessor :framework

    def inherited(base)
      unless base.superclass == Milkshake::Framework
        raise LoadError, "Only direct subclasses are supported"
      end

      Milkshake::Framework.framework = base
    end

    attr_accessor :name
  end

  attr_reader :milkshake

  def initialize(milkshake)
    @milkshake = milkshake
  end

  def name
    self.class.name
  end

  def boot
    raise NotImplementedError
  end

  def setup
    raise NotImplementedError
  end

  def app
    raise NotImplementedError
  end

  def rake(*args)
    raise NotImplementedError
  end

  def exec(*args)
    raise NotImplementedError
  end

  def console(*args)
    raise NotImplementedError
  end

end
