module ForemanPki
  module Command
    class GenerateCommand < Clamp::Command
      option "--common-name", "COMMON_NAME", "Specify the common name (CN) for certificate (defaults to current hostname)"
      option "--force", :flag, "Forces generation of certificates even if they already exist. Should be used if changing CA's but must be used with extreme cauation."

      def default_common_name
        `hostname`
      end

      def execute
        config = Config.new

        build_env = ForemanPki::BuildEnvironment.new('ca')
        build_env.create

        ca = ForemanPki::CertificateAuthority.new('ca', build_env)
        puts "Generating CA" if !ca.certificate_exist?
        ca.create

        config.certificates.each do |certificate|
          build_env = ForemanPki::BuildEnvironment.new(certificate.service)
          build_env.create

          key_pair = KeyPair.new(certificate.cert_name, build_env)

          puts "Generating #{certificate.cert_name}" if !force? && !key_pair.certificate_exist?
          puts "Skipping #{certificate.cert_name}. Certificate already exists." if !force? && key_pair.certificate_exist?
          puts "Force regenerating #{certificate.cert_name}" if force?

          if certificate.ca
            key_pair.copy(ca)
          else
            key_pair.create(certificate.common_name || common_name, ca, force?)

            key_pair.keystore if certificate.keystore

            if certificate.truststore
              truststore_build_env = BuildEnvironment.new(certificate.truststore.service)
              truststore_build_env.create

              truststore = Truststore.new(truststore_build_env)
              truststore.create(key_pair)
            end
          end
        end
      end
    end
  end
end
