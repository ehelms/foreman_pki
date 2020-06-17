module ForemanPki
  module Command
    class VerifyCommand < Clamp::Command

      def execute
        config = Config.new

        build_env = ForemanPki::BuildEnvironment.new('ca')
        ca = ForemanPki::CertificateAuthority.new(build_env)

        store = OpenSSL::X509::Store.new
        store.add_cert(ca.certificate)

        config.certificates.each do |certificate|
          build_env = ForemanPki::BuildEnvironment.new(certificate.service)
          key_pair = ForemanPki::KeyPair.new(certificate.cert_name, build_env)

          store.verify(key_pair.certificate)

          puts "#{certificate.cert_name}: #{store.error_string}"
        end
      end

    end
  end
end
