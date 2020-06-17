module ForemanPki
  module Command
    class GenerateCommand < Clamp::Command
      option "--common-name", "COMMON_NAME", "Specify the common name (CN) for certificate (defaults to current hostname)"

      def default_common_name
        `hostname`
      end

      def execute
        config = Config.new

        build_env = ForemanPki::BuildEnvironment.new('ca')
        build_env.create
        ca = ForemanPki::CertificateAuthority.new(build_env)

        config.certificates.each do |cert|
          build_env = ForemanPki::BuildEnvironment.new(cert.service)
          build_env.create

          cert_name = cert.cert || cert.service

          key_pair = ForemanPki::KeyPair.new(cert_name, build_env)

          if cert.ca
            key_pair.copy(ca)
          else
            key_pair.create(cert.common_name || common_name, ca)

            if cert.keystore
              key_pair.keystore
            end

            if cert.truststore
              truststore_build_env = ForemanPki::BuildEnvironment.new(cert.truststore.service || cert.service)
              truststore_build_env.create

              key_pair.truststore(truststore_build_env)
            end
          end
        end
      end
    end
  end
end
