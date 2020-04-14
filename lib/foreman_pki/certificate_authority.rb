module ForemanPki
  class CertificateAuthority

    KEY_LENGTH = 2048
    KEY_NAME = 'ca.key'
    CERT_NAME = 'ca.crt'
    EXPIRATION = 2 * 365 * 24 * 60 * 60 # 2 years validity

    def initialize(build_env = BuildEnvironment.new, deploy_env = DeployEnvironment.new('foreman'))
      @build_env = build_env
      @deploy_env = deploy_env
    end

    def create
      key
      cert
    end

    def key
      key_path = "#{@build_env.keys_dir}/#{KEY_NAME}"

      return OpenSSL::PKey::RSA.new(File.read(key_path)) if File.exist?(key_path)

      ca_key = OpenSSL::PKey::RSA.new(KEY_LENGTH)

      File.open("#{@build_env.keys_dir}/#{KEY_NAME}", 'w', 0400) do |file|
        file.write(ca_key.export)
      end

      ca_key
    end

    def cert
      cert_path = "#{@build_env.certs_dir}/#{CERT_NAME}"
      return OpenSSL::X509::Certificate.new(File.read(cert_path)) if File.exist?(cert_path)

      root_key = key

      root_ca = OpenSSL::X509::Certificate.new
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = 1
      root_ca.subject = OpenSSL::X509::Name.parse "/DC=org/DC=Foreman/CN=Certificate Authority"
      root_ca.issuer = root_ca.subject
      root_ca.public_key = root_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = EXPIRATION

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = root_ca
      ef.issuer_certificate = root_ca

      root_ca.add_extension(ef.create_extension("basicConstraints","CA:TRUE",true))
      root_ca.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      root_ca.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      root_ca.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))

      root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)

      File.open("#{@build_env.certs_dir}/#{CERT_NAME}", 'w', 0440) do |file|
        file.write(root_ca.to_pem)
      end
    end

    def view
      puts cert.to_text
    end

    def deploy
      File.open("#{@deploy_env.certs_dir}/#{CERT_NAME}", 'w', 0440) do |file|
        file.write(cert.to_pem)
      end
      File.open("#{@deploy_env.keys_dir}/#{KEY_NAME}", 'w', 0400) do |file|
        file.write(key.to_pem)
      end
    end

  end
end
