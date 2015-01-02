module SSHKit

  module Backend

    class SshCommand < Printer

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
        host_url = String(host.hostname)
        host_url = '%s@%s' % [host.username, host_url] if host.username
        result = 'ssh %s -t "%s"' % [host_url, command(*args).to_command]
        output << Command.new(result)
        system(result)
      end

    end
  end
end
