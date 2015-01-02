describe SSHKit::Interactive::Command do
  describe '#to_s' do
    def command_to_s(host)
      command = SSHKit::Interactive::Command.new(host)
      command.to_s
    end

    it "handles a simple hostname" do
      host = SSHKit::Host.new('example.com')
      expect(command_to_s(host)).to eq('ssh -A example.com')
    end

    it "handles a username and port" do
      host = SSHKit::Host.new('someuser@example.com:2222')
      expect(command_to_s(host)).to eq('ssh -A -l someuser -p 2222 example.com')
    end

    it "handles a proxy" do
      host = SSHKit::Host.new('someuser@example.com:2222')
      host.ssh_options = {
        proxy: Net::SSH::Proxy::Command.new('ssh mygateway.com -W %h:%p')
      }

      expect(command_to_s(host)).to eq('ssh -A -l someuser -o "ProxyCommand ssh mygateway.com -W %h:%p" -p 2222 example.com')
    end

    it "handles keys option" do
      host = SSHKit::Host.new('example.com')
      host.ssh_options = { keys: %w(/home/user/.ssh/id_rsa) }

      expect(command_to_s(host)).to eq('ssh -A -i /home/user/.ssh/id_rsa example.com')
    end

    it "handles extra options" do
      host = SSHKit::Host.new('someuser@example.com:2222')
      host.keys     = ["~/.ssh/some_key_here"]
      host.ssh_options = {
        port: 3232,
        keys: %w(/home/user/.ssh/id_rsa),
        forward_agent: false,
        auth_methods: %w(publickey password)
      }

      expect(command_to_s(host)).to eq('ssh -i /home/user/.ssh/id_rsa -l someuser -o "PreferredAuthentications publickey,password" -p 3232 example.com')
    end

    it "handles a password"
  end
end
