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

        if @certificate == 'apache'
          apache = ForemanPki::ApacheCertificate.new(build_env)
          apache.view
        end

        if @certificate == 'foreman-client'
          client = ForemanPki::ForemanClientCertificate.new(build_env)
          client.view
        end
      end
    end
  end
end
