module Rails
  class Framework < Milkshake::Framework

    require 'shellwords'

    self.name = 'rails_300'

    def boot
      # require File.expand_path('../config/boot.rb', __FILE__)
    end

    def setup
      # require File.expand_path('../config/environment.rb', __FILE__)
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
      rakefile = File.expand_path('../Rakefile', __FILE__)
      Dir.chdir File.expand_path(MILKSHAKE_ROOT)
      Kernel.exec(
        Shellwords.shelljoin(['rake', '-f', rakefile] + args))
    end

    def exec(*args)
      ARGV.clear and ARGV.concat(args)

      milkshake.boot!

      require File.expand_path('../script/rails', __FILE__)
    end

    def console(*args)
      exec 'console', *args
    end

  end
end
