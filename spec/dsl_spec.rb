describe SSHKit::Interactive::DSL do
  describe '#run_interactively' do
    include SSHKit::Interactive::DSL

    let(:host) { SSHKit::Host.new('example.com') }

    it "initialize a new command" do
      expect_system_call('ssh -A -t example.com "/usr/bin/env ls"')

      run_interactively host do
        execute(:ls)
      end
    end
  end
end
