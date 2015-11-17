# based on https://github.com/jetthoughts/j-cap-recipes/blob/be9dffe279b7bee816c9bafcb3633109096b20d5/lib/sshkit/backends/ssh_command.rb
module SSHKit
  module Interactive
    class Backend < SSHKit::Backend::Printer
      def run
        instance_exec(host, &@block)
      end

      def within(directory, &block)
        (@pwd ||= []).push directory.to_s
        yield
      ensure
        @pwd.pop
      end

      def execute(*args)
        super

        cmd = Command.new(host, command(*args))

        debug(cmd.to_s)

        cmd.execute
      end
    end
  end
end
