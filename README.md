# SSHKit::Interactive

An [SSHKit](https://github.com/capistrano/sshkit) [backend](https://github.com/capistrano/sshkit/tree/master/test/unit/backends) that allows you to execute interactive commands on your servers. Remote commands that you might want to use this for:

* A Rails console
* A text editor
* `less`
* *etc.*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sshkit-interactive'
```

And then execute:

    $ bundle

If you're using [Capistrano](http://capistranorb.com/), add the following to your Capfile:

```ruby
require 'sshkit/interactive'
```

## Usage

From SSHKit, use the [interactive backend](lib/sshkit/interactive/backend.rb) (which makes a system call to `ssh` under the hood), then execute commands as normal.

```ruby
SSHKit.config.backend = SSHKit::Interactive::Backend
hosts = %w{my.server.com}
on hosts do |host|
  execute(:vim)
end
```

Note that you will probably only want to execute on a single host. In Capistrano, it might look something like this:

```ruby
namespace :rails do
  desc "Run Rails console"
  task :console do
    SSHKit.config.backend = SSHKit::Interactive::Backend
    on primary(:app) do |host|
      execute(:rails, :console)
    end
  end
end
```

## Contributing

1. [Fork it](https://github.com/afeld/sshkit-interactive/fork)
1. Clone it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
