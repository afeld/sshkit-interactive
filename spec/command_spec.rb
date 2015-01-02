describe SSHKit::Interactive::Command do
  describe '#options_str' do
    def command_options_str(host)
      command = SSHKit::Interactive::Command.new(host)
      command.options_str
    end

    it "handles a simple hostname" do
      host = SSHKit::Host.new('example.com')
      expect(command_options_str(host)).to eq('-A')
    end

    it "handles a username and port" do
      host = SSHKit::Host.new('someuser@example.com:2222')
      expect(command_options_str(host)).to eq('-A -l someuser -p 2222')
    end

    it "handles a proxy" do
      host = SSHKit::Host.new('someuser@example.com:2222')
      host.ssh_options = {
        proxy: Net::SSH::Proxy::Command.new('ssh mygateway.com -W %h:%p')
      }

      expect(command_options_str(host)).to eq('-A -l someuser -o "ProxyCommand ssh mygateway.com -W %h:%p" -p 2222')
    end

    it "handles keys option" do
      host = SSHKit::Host.new('example.com')
      host.ssh_options = { keys: %w(/home/user/.ssh/id_rsa) }

      expect(command_options_str(host)).to eq('-A -i /home/user/.ssh/id_rsa')
    end

    # TODO split into separate tests
    it "handles extra options" do
      host = SSHKit::Host.new('someuser@example.com:2222')
      host.keys     = ["~/.ssh/some_key_here"]
      host.ssh_options = {
        port: 3232,
        keys: %w(/home/user/.ssh/id_rsa),
        forward_agent: false,
        auth_methods: %w(publickey password)
      }

      expect(command_options_str(host)).to eq('-i /home/user/.ssh/id_rsa -l someuser -o "PreferredAuthentications publickey,password" -p 3232')
    end

    it "handles a password"

    it "handles all option overrides"
    # see SSHKit::Host#netssh_options
    # https://github.com/capistrano/sshkit/blob/master/lib/sshkit/host.rb
  end

  describe '#to_s' do
    let(:host) { SSHKit::Host.new('example.com') }

    it "includes options" do
      command = SSHKit::Interactive::Command.new(host)
      expect(command).to receive(:options_str).and_return('-A -B -C')
      expect(command.to_s).to eq('ssh -A -B -C example.com')
    end

    it "excludes options if they're blank" do
      command = SSHKit::Interactive::Command.new(host)
      expect(command).to receive(:options_str).and_return('')
      expect(command.to_s).to eq('ssh example.com')
    end

    it "accepts a remote command" do
      command = SSHKit::Interactive::Command.new(host, 'ls')
      expect(command.to_s).to eq('ssh -A -t example.com "ls"')
    end
  end
end
