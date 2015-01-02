describe SSHKit::Interactive::Backend do
  describe '#execute' do
    it "does a system call with the SSH command" do
      host = SSHKit::Host.new('example.com')
      backend = SSHKit::Interactive::Backend.new(host)
      expect(backend).to receive(:system).with('ssh -A -t example.com "/usr/bin/env ls"')
      backend.execute('ls')
    end
  end
end
