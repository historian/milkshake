# Milkshake

Milkshake allows you to compose rails apps from several other rails apps specially packed as gems.

## Creating a host application

To create a new host application you must use the <tt>create.host</tt> command.

    $ milkshake create.host my_host_applications
    Rails app successfully created!
    Rails app successfully cleaned!
    Milkshake successfully installed!
    Rails app successfully stripped!
    $ ls my_host_applications
    config db log public script tmp

## Creating a gem application

Gem applications can be packaged as gems and can be linked back into host applications.

    $ milkshake create.gem my_gem_applications
    #   anwser the questions milkshake asks you

## Installation

    $ gem install milkshake

## Wish list

* link rake tasks from [gem path]/lib/tasks (is this needed?)
* migrate down when removing (or downgrading) a gem.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
  bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Simon Menke. See LICENSE for details.