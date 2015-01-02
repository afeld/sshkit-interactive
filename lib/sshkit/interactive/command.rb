module SSHKit
  module Interactive
    class Command
      attr_reader :host

      def initialize(host)
        @host = host
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

      def ssh_options_str
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
        opts.join(' ')
      end

      def to_s
        [
          'ssh',
          ssh_options_str,
          hostname
        ].reject(&:empty?).join(' ')
      end
    end
  end
end
