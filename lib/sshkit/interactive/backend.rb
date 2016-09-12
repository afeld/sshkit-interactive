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

      def execute(*args)
        super

        options = args.extract_options!
        cmd     = Command.new(host, command(args, options))

        debug(cmd.to_s)

        cmd.execute
      end
    end
  end
end
