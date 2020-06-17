module ForemanPki
  module Command
    class ViewCommand < Clamp::Command
      parameter "certificate", "Certificate to view"

      def execute
        config = Config.new

        cert_config = config.certificates.find do |cert|
          cert.cert_name == certificate
        end

        if cert_config.nil?
          fail("No certificate found named #{certificate}")
        end

        build_env = ForemanPki::BuildEnvironment.new(cert_config.service)
        cert = ForemanPki::KeyPair.new(cert_config.cert_name, build_env)
        cert.view
      end
    end
  end
end
