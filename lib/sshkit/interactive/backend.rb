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

      def execute(*args, &block)
        remote_command = command(*args)
        output << remote_command
        Command.new(host, remote_command).execute
      end

      def _unsupported_operation(*args)
        raise ::SSHKit::Backend::MethodUnavailableError, 'SSHKit::Interactive does not support this operation.'
      end

      alias :upload! :_unsupported_operation
      alias :download! :_unsupported_operation
      alias :test :_unsupported_operation
      alias :capture :_unsupported_operation
    end
  end
end
