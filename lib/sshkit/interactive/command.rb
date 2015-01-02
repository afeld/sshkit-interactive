module SSHKit
  module Interactive
    class Command
      attr_reader :host, :remote_command

      def initialize(host, remote_command=nil)
        @host = host
        @remote_command = remote_command
      end

      def netssh_options
        self.host.netssh_options
      end

      def user
        self.host.user
      end

      def hostname
        self.host.hostname
      end

      def options
        opts = []
        opts << '-A' if netssh_options[:forward_agent]
        if netssh_options[:keys]
          netssh_options[:keys].each do |k|
            opts << "-i #{k}"
          end
        end
        opts << "-l #{user}" if user
        opts << %{-o "PreferredAuthentications #{netssh_options[:auth_methods].join(',')}"} if netssh_options[:auth_methods]
        opts << %{-o "ProxyCommand #{netssh_options[:proxy].command_line_template}"} if netssh_options[:proxy]
        opts << "-p #{netssh_options[:port]}" if netssh_options[:port]
        opts << '-t' if self.remote_command

        opts
      end

      def options_str
        self.options.join(' ')
      end

      def to_s
        parts = [
          'ssh',
          self.options_str,
          self.hostname
        ]
        if self.remote_command
          parts << %{"#{self.remote_command}"}
        end

        parts.reject(&:empty?).join(' ')
      end

      def execute
        system(self.to_s)
      end
    end
  end
end
