class Milkshake::Commands::Update
  include Milkshake::SharedHelpers
  
  def update
    write_gemfile
    update_bundler
    
    setup_bundler
    load_plugins
    run_hooks(:post_update)
  end
  
private

  def write_gemfile
    sources = bundler_sources.map do |name, options|
      options = options.dup
      type = options.delete('type')
      path = options.delete('path')
      "#{type}(#{path.inspect}, #{options.inspect}) # #{name}"
    end
    
    gems = bundler_gems.map do |g, options|
      if options == "true"
        "gem(#{g.inspect})"
      else
        "gem(#{g.inspect}, #{options.inspect})"
      end
    end
    
    gemfile = <<-EOF
    
      source :rubygems
      
      #{sources.join("\n")}
      
      #{gems.join("\n")}
    
    EOF
    
    gemfile = gemfile.gsub(/^\s+/m, '').strip
    
    FileUtils.mkdir_p(bundler_path)
    File.open(gemfile_path, 'w+') { |f| f.write gemfile }
  end

  def update_bundler
    ENV['BUNDLE_GEMFILE'] = gemfile_path
    Dir.chdir(Milkshake.root) do
      exit 1 unless system("bundle install")
    end
  end
  
  def bundler_sources
    sources = {}
    Milkshake.settings.all.each do |key|
      key =~ /^bundler\.sources\.([^\.]+)\.([^\.]+)(?:\.(.+))?$/
      if key =~ /^bundler\.sources\.([^\.]+)\.([^\.]+)(?:\.(.+))?$/
        raise "Only path sources are currently supported" unless $1 == 'path'
        unless $3
          (sources[$2] ||= {})['path'] = Milkshake.settings[key]
          (sources[$2] ||= {})['type'] = 'path'
        else
          (sources[$2] ||= {})[$3] = Milkshake.settings[key]
        end
      end
    end
    sources
  end
  
  def bundler_gems
    deps = {}
    Milkshake.settings.all.each do |key|
      if key =~ /^bundler\.gems\.([^\.]+)(?:\.(.+))?$/
        if $2
          (deps[$1] ||= {})[$2] = Milkshake.settings[key]
        else
          deps[$1] = Milkshake.settings[key]
        end
      end
    end
    deps
  end
  
end