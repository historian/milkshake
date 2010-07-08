class Milkshake::Linker

  def link!
    link_only_once do
      if needs_relink?

        run_migrations!
        dump_relinked_at!

      end
    end
  end

private

  def run_migrations!
    ActiveRecord::Migrator.class_eval do
      include Milkshake::RailsExt::Migrator
    end

    ActiveRecord::Migrator.migrate("db/migrate/", nil)
  end

  def link_only_once
    lock_path  = relink_lck_path
    FileUtils.mkdir_p(File.dirname(lock_path))
    FileUtils.touch(lock_path)

    lock_file  = File.new(lock_path)
    acquired   = !!lock_file.flock(File::LOCK_EX | File::LOCK_NB)
    if acquired
      yield
    else
      lock_file.flock(File::LOCK_EX)
    end
  ensure
    lock_file.flock(File::LOCK_UN)
  end

  def needs_relink?
    time = (YAML.load_file(relink_txt_path) rescue nil)
    ((!time) or (time < File.mtime(relink_txt_path)))
  end

  def dump_relinked_at!
    File.open(relink_txt_path, 'w+') { |f| f.write YAML.dump(Time.now) }
  end

  def relink_txt_path
    @relink_txt_path ||= File.join(Rails.root, 'tmp/relink.txt')
  end

  def relink_lck_path
    @relink_lck_path ||= File.join(Rails.root, 'tmp/relink.lck')
  end

end
