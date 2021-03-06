module ForemanPki
  class KeyPair
    KEY_LENGTH = 4096
    EXPIRATION = 2 * 365 * 24 * 60 * 60 # 2 years validity
    KEY_PERMISSIONS = 0o0640
    CERT_PERMISSIONS = 0o644

    attr_reader :ca

    def initialize(cert_name, build_env)
      @build_env = build_env
      @service = build_env.namespace
      @cert_name = cert_name
    end

    def key_name
      "#{@cert_name}.key"
    end

    def cert_name
      "#{@cert_name}.crt"
    end

    def private_key_path
      "#{@build_env.certs_dir}/#{key_name}"
    end

    def certificate_path
      "#{@build_env.certs_dir}/#{cert_name}"
    end

    def create(common_name, ca, force = false)
      @common_name = common_name
      @ca = ca

      private_key(force)
      certificate(force)
    end

    def copy(original)
      copy_certificate(original)
      copy_private_key(original)
    end

    def copy_certificate(original)
      File.open("#{@build_env.certs_dir}/#{original.cert_name}", 'w', CERT_PERMISSIONS) do |file|
        file.write(original.certificate.to_pem)
      end
    end

    def copy_private_key(original)
      File.open("#{@build_env.certs_dir}/#{original.key_name}", 'w', KEY_PERMISSIONS) do |file|
        file.write(original.private_key.to_pem)
      end
    end

    def private_key(force = false)
      password = Password.new(@build_env)
      return OpenSSL::PKey::RSA.new(File.read(private_key_path), password.password) if private_key_exist? && !force

      key = OpenSSL::PKey::RSA.new(KEY_LENGTH)
      write_private_key(key.export)
      key
    end

    def certificate(force = false)
      return OpenSSL::X509::Certificate.new(File.read(certificate_path)) if certificate_exist? && !force

      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = rand(2**128)
      cert.subject = OpenSSL::X509::Name.parse "CN=#{@common_name}"
      cert.issuer = @ca.certificate.subject # root CA is the issuer
      cert.public_key = private_key.public_key
      cert.not_before = Time.now
      cert.not_after = cert.not_before + EXPIRATION

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = @ca.certificate

      cert.add_extension(ef.create_extension("basicConstraints", "CA:FALSE", true))
      cert.add_extension(ef.create_extension("keyUsage", "digitalSignature,keyEncipherment", true))
      cert.add_extension(ef.create_extension("extendedKeyUsage", "serverAuth,clientAuth", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
      cert.sign(@ca.private_key, OpenSSL::Digest.new('SHA256'))

      write_certificate(cert.to_pem)
      cert
    end

    def keystore
      password = Password.new(@build_env)
      store = OpenSSL::PKCS12.create(password.get_or_create, @service, private_key, certificate, [@ca.certificate])

      File.open("#{@build_env.certs_dir}/keystore", 'w', KEY_PERMISSIONS) do |file|
        file.write(store.to_der)
      end
    end

    def certificate_exist?
      File.exist?(certificate_path)
    end

    def private_key_exist?
      File.exist?(private_key_path)
    end

    def view
      puts certificate.to_text
    end

    def write_certificate(cert)
      File.open(certificate_path, 'w', CERT_PERMISSIONS) do |file|
        file.write(cert)
      end
    end

    def write_private_key(key)
      File.open(private_key_path, 'w', KEY_PERMISSIONS) do |file|
        file.write(key)
      end
    end
  end
end
