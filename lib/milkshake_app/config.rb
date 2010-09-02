class MilkshakeApp::Config
  
  require 'yaml'
  
  include Opts::DSL
  
  def list(env, args)
    config_file = File.expand_path('config.yml', env['APP'])
    @config = YAML.load_file(config_file) if File.file?(config_file)
    @config ||= {}
    
    env['opts.shell'].say(YAML.dump(@config))
  end
  
  argument 'KEY'
  def get(env, args)
    config_file = File.expand_path('config.yml', env['APP'])
    config = YAML.load_file(config_file) if File.file?(config_file)
    config ||= {}
    config_root = config
    
    key_path = env['KEY'].split('.')
    
    while key = key_path.shift
      if key_path.empty?
        case config
        when Hash
          unless config[key]
            raise "not a valid key: #{env['KEY']}"
          end
          
          env['opts.shell'].say(
            "#{env['KEY']}: #{config[key]}")
          
        when Array
          unless config[key.to_i]
            raise "not a valid key: #{env['KEY']}"
          end
          
          env['opts.shell'].say(
            "#{env['KEY']}: #{config[key.to_i]}")
          
        else
          raise "not a valid key: #{env['KEY']}"
        end
      else
        case config
        when Hash
          config = config[key]
          next if config
          raise "not a valid key: #{env['KEY']}"
          
        when Array
          config = config[key.to_i]
          next if config
          
        end
        
        raise "not a valid key: #{env['KEY']}"
      end
    end
  end
  
  argument 'KEY'
  argument 'VALUE'
  def set(env, args)
    config_file = File.expand_path('config.yml', env['APP'])
    config = YAML.load_file(config_file) if File.file?(config_file)
    config ||= {}
    config_root = config
    
    key_path = env['KEY'].split('.')
    
    while key = key_path.shift
      if key_path.empty?
        case config
        when Hash
          config[key] = env['VALUE']
          
        when Array
          config[key.to_i] = env['VALUE']
          
        else
          raise "not a valid key: #{env['KEY']}"
        end
      else
        case config
        when Hash
          if config[key]
            config = config[key]
          else
            config = (config[key] = {})
          end
          next if config
          
        when Array
          config = config[key.to_i]
          next if config
          
        end
        
        raise "not a valid key: #{env['KEY']}"
      end
    end
    
    File.open(config_file, 'w+', 0644) do |fd|
      fd.write YAML.dump(config_root)
    end
  end
  
  argument 'KEY'
  def remove(env, args)
    config_file = File.expand_path('config.yml', env['APP'])
    config = YAML.load_file(config_file) if File.file?(config_file)
    config ||= {}
    config_root = config
    
    key_path = env['KEY'].split('.')
    
    while key = key_path.shift
      if key_path.empty?
        case config
        when Hash
          config.delete(key)
          
        when Array
          config.delete_at(key.to_i)
          
        else
          raise "not a valid key: #{env['KEY']}"
        end
      else
        case config
        when Hash
          config = config[key]
          next if config
          raise "not a valid key: #{env['KEY']}"
          
        when Array
          config = config[key.to_i]
          next if config
          
        end
        
        raise "not a valid key: #{env['KEY']}"
      end
    end
    
    File.open(config_file, 'w+', 0644) do |fd|
      fd.write YAML.dump(config_root)
    end
  end
  
end