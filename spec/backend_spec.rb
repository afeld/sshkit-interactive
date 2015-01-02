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
  end
end
