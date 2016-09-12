# based on https://github.com/jetthoughts/j-cap-recipes/blob/be9dffe279b7bee816c9bafcb3633109096b20d5/lib/sshkit/backends/ssh_command.rb
module SSHKit
  module Interactive
    class Backend < SSHKit::Backend::Printer
      def run
        instance_exec(host, &@block)
      end

      def within(directory, &_block)
        (@pwd ||= []).push(directory.to_s)
        yield
      ensure
        @pwd.pop
      end

      def as(who, &_block)
        if who.is_a?(Hash)
          @user  = who[:user]  || who["user"]
          @group = who[:group] || who["group"]
        else
          @user  = who
          @group = nil
        end

        yield
      ensure
        remove_instance_variable(:@user)
        remove_instance_variable(:@group)
      end

      def execute(*args, &block)
        options        = args.extract_options!
        remote_command = command(args, options)

        output.log_command_start(remote_command)

        Command.new(host, remote_command).execute
      end
    end
  end
end
