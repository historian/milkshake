
module Milkshake
  class App
    module Defaults
      
      def default_author
        @default_author ||= begin
          name = %x[git config --get user.name].chomp
          name = 'FIX_ME_AUTHOR' if name.nil? or name.empty?
          name
        end
      end
      
      def default_email
        @default_email ||= begin
          email = %x[git config --get user.email].chomp
          email = 'FIX_ME_EMAIL' if email.nil? or email.empty?
          email
        end
      end
      
      def default_environment
        @default_environment ||= begin
          ENV['RAILS_ENV'] || 'development'
        end
      end
      
      def default_summary
        'FIX_ME_SUMMARY'
      end
      
      def default_description
        'FIX_ME_DESCRIPTION'
      end
      
      def default_website
        'FIX_ME_WEBSITE'
      end
      
      def rename_task(names={})
        names.each do |old_name, new_name|
          self.tasks[new_name.to_s] = self.tasks.delete(old_name.to_s)
        end
      end
      
    end
  end
end
