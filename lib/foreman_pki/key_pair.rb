require 'securerandom'

module ForemanPki
  class KeyPair

    KEY_LENGTH = 4096
    EXPIRATION = 2 * 365 * 24 * 60 * 60 # 2 years validity

    def initialize(cert_name, build_env = BuildEnvironment.new)
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

    def create(hostname, ca)
      @hostname = hostname
      @ca = ca

      private_key
      certificate
    end

    def copy(to_copy)
      File.open("#{@build_env.certs_dir}/#{to_copy.cert_name}", 'w', 0444) do |file|
        file.write(to_copy.certificate.to_pem)
      end
      File.open("#{@build_env.keys_dir}/#{to_copy.key_name}", 'w', 0400) do |file|
        file.write(to_copy.private_key.to_pem)
      end
    end

    def private_key
      key_path = "#{@build_env.keys_dir}/#{key_name}"

      return OpenSSL::PKey::RSA.new(File.read(key_path)) if File.exist?(key_path)

      key = OpenSSL::PKey::RSA.new(KEY_LENGTH)
      write_key(key.export)
      key
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

    def keystore
      store = OpenSSL::PKCS12.create(password(@build_env), @service, private_key, certificate, [@ca.certificate])

      File.open("#{@build_env.certs_dir}/keystore", 'w', 0400) do |file|
        file.write(store.to_der)
      end
    end

    def truststore(build_env)
      store = OpenSSL::PKCS12.create(password(build_env), @service, private_key, certificate, [@ca.certificate])

      File.open("#{build_env.certs_dir}/truststore", 'w', 0400) do |file|
        file.write(store.to_der)
      end
    end

    def password(build_env)
      password_path = "#{build_env.keys_dir}/password"
      return File.read(password_path) if File.exist?(password_path)

      password = SecureRandom.base64(15)
      File.open("#{build_env.keys_dir}/password", 'w', 0400) do |file|
        file.write(password)
      end

      password
    end

    def view
      puts certificate.to_text
    end

    def write_certificate(cert)
      File.open("#{@build_env.certs_dir}/#{cert_name}", 'w', 0444) do |file|
        file.write(cert)
      end
    end

    def write_key(key)
      File.open("#{@build_env.keys_dir}/#{key_name}", 'w', 0400) do |file|
        file.write(key)
      end
    end

  end
end
