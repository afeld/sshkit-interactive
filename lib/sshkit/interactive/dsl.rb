module SSHKit
  module Interactive
    module DSL
      def run_interactively(host, &block)
        SSHKit::Interactive::Backend.new(host, &block).run
      end
    end
  end
end

include SSHKit::Interactive::DSL
