module ForemanPki
  module Certificate
    class Apache < KeyPair

      def create(hostname, service, ca)
        @hostname = hostname
        @service = service
        @ca = ca

        private_key
        certificate
      end

      def certificate
        cert_path = "#{@build_env.certs_dir}/#{cert_name}"
        return OpenSSL::X509::Certificate.new(File.read(cert_path)) if File.exist?(cert_path)

        cert = OpenSSL::X509::Certificate.new
        cert.version = 2
        cert.serial = rand(2**128)
        cert.subject = OpenSSL::X509::Name.parse "CN=#{@hostname}"
        cert.issuer = @ca.certificate.subject # root CA is the issuer
        cert.public_key = private_key.public_key
        cert.not_before = Time.now
        cert.not_after = cert.not_before + EXPIRATION

        ef = OpenSSL::X509::ExtensionFactory.new
        ef.subject_certificate = cert
        ef.issuer_certificate = @ca.certificate

        cert.add_extension(ef.create_extension("basicConstraints","CA:FALSE", true))
        cert.add_extension(ef.create_extension("keyUsage","digitalSignature,keyEncipherment", true))
        cert.add_extension(ef.create_extension("extendedKeyUsage","serverAuth,clientAuth", true))
        cert.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
        cert.sign(@ca.private_key, OpenSSL::Digest::SHA256.new)

        File.open("#{@build_env.certs_dir}/#{cert_name}", 'w', 0444) do |file|
          file.write(cert.to_pem)
        end

        cert
      end

    end
  end
end
