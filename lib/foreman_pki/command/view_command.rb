module ForemanPki
  module Command
    class ViewCommand < Clamp::Command
      parameter "certificate", "Certificate to view"

      def execute
        build_env = ForemanPki::BuildEnvironment.new

        if @certificate == 'ca'
          ca = ForemanPki::CertificateAuthority.new(build_env)
          ca.view
        end
      end
    end
  end
end
