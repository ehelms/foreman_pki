module ForemanPki
  module Command
    class ImportCaCommand < Clamp::Command
      option "--ca-cert", "CA_CERT", "Absolute path to CA certificate to import", required: true
      option "--ca-key", "CA_KEY", "Absolute path to CA key to import", required: true

      def execute
        config = Config.new

        build_env = ForemanPki::BuildEnvironment.new('ca')
        build_env.create

        ca = ForemanPki::CertificateAuthority.new('ca', build_env)
        ca.import_certificate(ca_cert)
        ca.import_key(ca_key)
      end

    end
  end
end
