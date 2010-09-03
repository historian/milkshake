module Rails
  class Framework < Milkshake::Framework

    self.name = 'rails_234'

    def boot
      require File.expand_path('../config/_boot.rb', __FILE__)
    end

    def setup
      require File.expand_path('../config/_environment.rb', __FILE__)
    end

    def app
      rackup = File.expand_path('../config.ru', __FILE__)
      if ::Rack::Builder.respond_to? :parse_file
        ::Rack::Builder.parse_file(rackup).first
      else
        source = File.read(rackup)
        eval("Rack::Builder.new { (#{source}) }.to_app", TOPLEVEL_BINDING, rackup)
      end
    end

    def rake(*args)
      ARGV.clear and ARGV.concat(args)
      rakefile = File.expand_path('../Rakefile', __FILE__)
      Dir.chdir File.expand_path(MILKSHAKE_ROOT)
      Kernel.exec("rake -f #{rakefile.inspect} #{ARGV.collect(&:inspect).join(' ')}")
    end

    def exec(*args)
      command = args.shift
      if command !~ /^script\//
        raise "Unknown executable"
      end

      ARGV.clear and ARGV.concat(args)

      milkshake.boot!

      require File.expand_path('../'+command, __FILE__)
    end

    def console(*args)
      exec 'script/console', *args
    end

  end
end
