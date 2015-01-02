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
        ssh_command = Command.new(host).to_s
        local_command = command(*args).to_command
        result = %[#{ssh_command} -t "#{local_command}"]
        output << SSHKit::Command.new(result, host: host)
        system(result)
      end
    end
  end
end
