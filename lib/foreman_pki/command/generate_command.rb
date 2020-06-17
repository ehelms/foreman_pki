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
        ca = ForemanPki::CertificateAuthority.new('ca', build_env)

        config.certificates.each do |certificate|
          build_env = ForemanPki::BuildEnvironment.new(certificate.service)
          build_env.create

          key_pair = ForemanPki::KeyPair.new(certificate.cert_name, build_env)

          if certificate.ca
            key_pair.copy(ca)
          else
            key_pair.create(certificate.common_name || common_name, ca)

            if certificate.keystore
              key_pair.keystore
            end

            if certificate.truststore
              truststore_build_env = ForemanPki::BuildEnvironment.new(certificate.truststore.service)
              truststore_build_env.create

              key_pair.truststore(truststore_build_env)
            end
          end
        end
      end
    end
  end
end
