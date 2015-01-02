describe SSHKit::Interactive::Backend do
  describe '#execute' do
    let(:host) { SSHKit::Host.new('example.com') }
    let(:backend) { SSHKit::Interactive::Backend.new(host) }

    def expect_system_call(command)
      expect_any_instance_of(SSHKit::Interactive::Command).to receive(:system).with(command)
    end

    it "does a system call with the SSH command" do
      expect_system_call('ssh -A -t example.com "/usr/bin/env ls"')
      backend.execute('ls')
    end

    it "respects the specified directory" do
      backend.within('/var/log') do
        expect_system_call('ssh -A -t example.com "cd /var/log && /usr/bin/env ls"')
        backend.execute('ls')
      end
    end

    it "respects the specified user" do
      backend.as('deployer') do
        expect_system_call('ssh -A -t example.com "sudo -u deployer && /usr/bin/env ls"')
        backend.execute('ls')
      end
    end

    it "respects the specified group"

    it "respects the specified env"

    it "respects the specified user"
  end
end
