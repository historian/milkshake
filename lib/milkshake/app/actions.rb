
module Milkshake
  class App
    module Actions
    private
      
      def install_rails!(path)
        override_app_path! path
        assert_new_app_path!
        
        system(%{rails "#{self.options.app}" > /dev/null})
        good_say('Rails app successfully created!')
        
        goto_rails do
          if File.file?('config/locales/en.yml')
            File.unlink('config/locales/en.yml')
          end
          if File.file?('public/index.html')
            File.unlink('public/index.html')
          end
          if File.file?('public/images/rails.png')
            File.unlink('public/images/rails.png')
          end
          if File.file?('public/javascripts/controls.js')
            File.unlink('public/javascripts/controls.js')
          end
          if File.file?('public/javascripts/dragdrop.js')
            File.unlink('public/javascripts/dragdrop.js')
          end
          if File.file?('public/javascripts/effects.js')
            File.unlink('public/javascripts/effects.js')
          end
          if File.file?('public/javascripts/prototype.js')
            File.unlink('public/javascripts/prototype.js')
          end
          
          Milkshake::Template.evaluate('routes.rb'
          ).write_to('config/routes.rb')
        end
        
        good_say('Rails app successfully cleaned!')
      end
      
      def install_app!
        goto_rails do
          
          Milkshake::Template.evaluate('preinitializer.rb'
          ).write_to('config/preinitializer.rb')
          
          unless File.file?('config/milkshake.yml')
            Milkshake::Template.evaluate('milkshake.yml'
            ).write_to('config/milkshake.yml')
          end
          
        end
        
        good_say('Milkshake successfully installed!')
      end
      
      def install_gem!(name)
        assert_valid_gem_name! name
        
        goto_rails do
          
          Milkshake::Template.evaluate('jeweler.rake',
            :name        => name,
            :author      => ask_unless_given(
              'Author',      self.options.author,      self.class.default_author),
            :email       => ask_unless_given(
              'Email',       self.options.email,       self.class.default_email),
            :summary     => ask_unless_given(
              'Summary',     self.options.summary,     'FIX_ME_SUMMARY'),
            :description => ask_unless_given(
              'Description', self.options.description, 'FIX_ME_DESCRIPTION'),
            :website     => ask_unless_given(
              'Website',     self.options.website,     'FIX_ME_WEBSITE')
          ).write_to('lib/tasks/jeweler.rake')
          
          FileUtils.mkdir_p('rails/initializers')
          FileUtils.touch('rails/init.rb')
          FileUtils.rm_rf('app/controllers/application_controller.rb') rescue nil
          FileUtils.rm_rf('app/helpers/application_helper.rb')         rescue nil
          
          if self.options.git shell.yes?('Initialize git? [yN]:')
            system(%{ git init > /dev/null })
            
            Milkshake::Template.evaluate('gitignore'
            ).write_to('.gitignore')
            
            system(%{ git add . > /dev/null })
            system(%{ git commit -m "First import" > /dev/null })
          end
        end
        
        good_say('Jeweler successfully installed!')
      end
      
      def install_host!
        goto_rails do |rails_root|
          (rails_root + 'README').unlink             rescue nil
          (rails_root + 'Rakefile').unlink           rescue nil
          (rails_root + 'app').rmtree                rescue nil
          (rails_root + 'config/locales').rmtree     rescue nil
          (rails_root + 'db/seeds.rb').unlink        rescue nil
          (rails_root + 'doc').rmtree                rescue nil
          (rails_root + 'lib').rmtree                rescue nil
          (rails_root + 'public/images').rmtree      rescue nil
          (rails_root + 'public/javascripts').rmtree rescue nil
          (rails_root + 'public/stylesheets').rmtree rescue nil
          (rails_root + 'test').rmtree               rescue nil
          (rails_root + 'vendor').rmtree             rescue nil
        end
        
        good_say('Rails app successfully stripped!')
      end
      
      def externalize_data!(shared_path)
        shared_path = pathname_for(shared_path)
        
        assert_new_shared_path! shared_path
        shared_path.mkpath
        
        goto_rails do |rails_path|
          
          (rails_path + 'public/system').mkpath
          (rails_path + 'config/settings').mkpath
          
          make_symlink!(
            rails_path  + 'db',
            shared_path + 'private')
          
          make_symlink!(
            rails_path  + 'log',
            shared_path + 'log')
          
          make_symlink!(
            rails_path  + 'public/system',
            shared_path + 'public')
          
          make_symlink!(
            rails_path  + 'config/settings',
            shared_path + 'settings')
          
          make_symlink!(
            rails_path  + 'config/milkshake.yml',
            shared_path + 'settings/milkshake.yml')
          
          make_symlink!(
            rails_path  + 'config/database.yml',
            shared_path + 'settings/database.yml')
          
        end
        
        good_say('Data files successfully externalized!')
      end
      
    end
  end
end
