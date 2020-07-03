module ForemanPki
  module Command
    class ImportCaCommand < Clamp::Command
      option "--ca-cert", "CA_CERT", "Absolute path to CA certificate to import", required: true
      option "--ca-key", "CA_KEY", "Absolute path to CA key to import", required: true
      option "--password", "PASSWORD", "Password protecting the CA key being imported. Only required if the CA key being imported is password protected"

      def execute
        build_env = ForemanPki::BuildEnvironment.new('ca')
        build_env.create

        ca = ForemanPki::CertificateAuthority.new('ca', build_env)
        ca.import_certificate(ca_cert)
        ca.import_private_key(ca_key)
        ca.import_password(password) if password
      end

    end
  end
end
