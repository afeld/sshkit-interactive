# SSHKit::Interactive

An SSHKit backend that allows you to execute interactive commands on your servers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sshkit-interactive'
```

And then execute:

    $ bundle

If you're using Capistrano, add the following to your Capfile:

```ruby
require 'sshkit/interactive'
```

## Usage

From SSHKit, use the interactive backend (which makes a system call to `ssh` under the hood), then execute commands as normal.

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

1. Fork it ( https://github.com/[my-github-username]/sshkit-interactive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
