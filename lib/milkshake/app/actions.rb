
module Milkshake
  class App
    module Actions
    private
      
      def install_rails!(path)
        override_app_path! path
        assert_new_app_path!
        
        system(%{rails _#{Milkshake::RAILS_VERSION}_ "#{self.options.app}" > /dev/null})
        good_say('Rails app successfully created!')
        
        goto_rails do |rails_root|
          safe_rm(rails_root + 'config/locales/en.yml')
          safe_rm(rails_root + 'public/index.html')
          safe_rm(rails_root + 'public/images/rails.png')
          safe_rm(rails_root + 'public/javascripts/controls.js')
          safe_rm(rails_root + 'public/javascripts/dragdrop.js')
          safe_rm(rails_root + 'public/javascripts/effects.js')
          safe_rm(rails_root + 'public/javascripts/prototype.js')
          
          Milkshake::Template.evaluate('routes.rb'
          ).write_to('config/routes.rb')
          
          Milkshake::Template.evaluate('staging.rb'
          ).write_to('config/environments/staging.rb')
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
        
        goto_rails do |rails_root|
          
          options = gem_options(name)
          
          Milkshake::Template.evaluate('jeweler.rake',
            options
          ).write_to('lib/tasks/jeweler.rake')
          
          Milkshake::Template.evaluate('root_module.rb',
            options
          ).write_to("lib/#{options[:name]}.rb")
          
          FileUtils.mkdir_p('rails/initializers')
          FileUtils.touch('rails/init.rb')
          safe_rm(rails_root + 'app/controllers/application_controller.rb')
          safe_rm(rails_root + 'app/helpers/application_helper.rb')
          
          if self.options.git or shell.yes?('Initialize git? [yN]:')
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
          safe_rm(rails_root + 'README')
          safe_rm(rails_root + 'Rakefile')
          safe_rm(rails_root + 'app')
          safe_rm(rails_root + 'config/locales')
          safe_rm(rails_root + 'db/seeds.rb')
          safe_rm(rails_root + 'doc')
          safe_rm(rails_root + 'lib')
          safe_rm(rails_root + 'public/images')
          safe_rm(rails_root + 'public/javascripts')
          safe_rm(rails_root + 'public/stylesheets')
          safe_rm(rails_root + 'test')
          safe_rm(rails_root + 'vendor')
        end
        
        good_say('Rails app successfully stripped!')
      end
      
      def ensure_extrernalized_data!(shared_path)
        shared_path = pathname_for(shared_path)
        if shared_path.exist?
          link_externalized_data! shared_path
        else
          externalize_data! shared_path
        end
      end
      
      def externalize_data!(shared_path)
        shared_path = pathname_for(shared_path)
        
        goto_rails do |rails_path|
          
          if (rails_path + 'config/settings').symlink?
            bad_say("The data of this rails app seems to be already extracted!")
          end
          
          assert_new_shared_path! shared_path
          shared_path.mkpath
          
          (rails_path + 'public/system').mkpath
          (rails_path + 'config/settings').mkpath
          
          swap_and_make_symlink!(
            rails_path  + 'db',
            shared_path + 'private')
          
          swap_and_make_symlink!(
            rails_path  + 'log',
            shared_path + 'log')
          
          swap_and_make_symlink!(
            rails_path  + 'public/system',
            shared_path + 'public')
          
          swap_and_make_symlink!(
            rails_path  + 'config/settings',
            shared_path + 'settings')
          
          swap_and_make_symlink!(
            rails_path  + 'config/milkshake.yml',
            shared_path + 'settings/milkshake.yml')
          
          swap_and_make_symlink!(
            rails_path  + 'config/database.yml',
            shared_path + 'settings/database.yml')
          
        end
        
        if self.options.git or shell.yes?('Initialize git? [yN]:')
          Dir.chdir(shared_path.to_s) do
            system(%{ git init > /dev/null })
            
            Milkshake::Template.evaluate('gitignore_for_data'
            ).write_to('.gitignore')
            
            system(%{ git add . > /dev/null })
            system(%{ git commit -m "First snapshot" > /dev/null })
          end
        end
        
        good_say('Data files successfully externalized!')
      end
      
      def link_externalized_data!(shared_path)
        shared_path = pathname_for(shared_path)
        assert_shared_path! shared_path
        
        goto_rails do |rails_path|
          
          safe_rm(rails_path + 'db')
          make_symlink!(
            rails_path  + 'db',
            shared_path + 'private')
          
          safe_rm(rails_path + 'log')
          make_symlink!(
            rails_path  + 'log',
            shared_path + 'log')
          
          safe_rm(rails_path + 'public/system')
          make_symlink!(
            rails_path  + 'public/system',
            shared_path + 'public')
          
          safe_rm(rails_path + 'config/settings')
          make_symlink!(
            rails_path  + 'config/settings',
            shared_path + 'settings')
          
          safe_rm(rails_path + 'config/milkshake.yml')
          make_symlink!(
            rails_path  + 'config/milkshake.yml',
            shared_path + 'settings/milkshake.yml')
          
          safe_rm(rails_path + 'config/database.yml')
          make_symlink!(
            rails_path  + 'config/database.yml',
            shared_path + 'settings/database.yml')
          
        end
      end
      
    private
      
      def gem_options(name)
        {
        :name =>
          name,
          
        :module_name =>
          name.classify,
        
        :author =>
          ask_unless_given('Author',      self.options.author,      self.class.default_author),
        
        :email =>
          ask_unless_given('Email',       self.options.email,       self.class.default_email),
        
        :summary =>
          ask_unless_given('Summary',     self.options.summary,     'FIX_ME_SUMMARY'),
        
        :description =>
          ask_unless_given('Description', self.options.description, 'FIX_ME_DESCRIPTION'),
        
        :website =>
          ask_unless_given('Website',     self.options.website,     'FIX_ME_WEBSITE')
        }
      end
      
    end
  end
end
