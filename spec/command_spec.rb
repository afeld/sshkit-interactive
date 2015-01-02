describe SSHKit::Interactive::Command do
  describe '#to_s' do
    it "handles a simple hostname" do
      host = SSHKit::Host.new('example.com')
      command = SSHKit::Interactive::Command.new(host)
      expect(command.to_s).to eq('ssh -A example.com')
    end
  end
end
