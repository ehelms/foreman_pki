module ForemanPki
  class ServerCertificate < KeyPair

    def initialize(build_env = BuildEnvironment.new, deploy_env = DeployEnvironment.new('foreman'))
      @build_env = build_env
      @deploy_env = deploy_env
    end

    def key_name
      "#{@hostname}.key"
    end

    def cert_name
      "#{@hostname}.crt"
    end

    def create(hostname, ca)
      @hostname = hostname
      @ca = ca

      private_key
      certificate
    end

    def certificate
      cert_path = "#{@build_env.certs_dir}/#{cert_name}"
      return OpenSSL::X509::Certificate.new(File.read(cert_path)) if File.exist?(cert_path)

      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.subject = OpenSSL::X509::Name.parse "/DC=org/DC=Foreman/CN=#{@hostname}"
      cert.issuer = @ca.certificate.subject # root CA is the issuer
      cert.public_key = private_key.public_key
      cert.not_before = Time.now
      cert.not_after = EXPIRATION

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = @ca.certificate

      cert.add_extension(ef.create_extension("keyUsage","digitalSignature", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
      cert.sign(private_key, OpenSSL::Digest::SHA256.new)

      File.open("#{@build_env.certs_dir}/#{cert_name}", 'w', 0440) do |file|
        file.write(cert.to_pem)
      end

      cert
    end

  end
end
