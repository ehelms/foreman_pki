module ForemanPki
  class CertificateAuthority < KeyPair

    def create
      private_key
      certificate
    end

    def import_certificate(import_path)
      write_certificate(File.read(import_path))
    end

    def import_key(import_path)
      write_key(File.read(import_path))
    end

    def certificate
      cert_path = "#{@build_env.certs_dir}/#{cert_name}"
      return OpenSSL::X509::Certificate.new(File.read(cert_path)) if File.exist?(cert_path)

      root_ca = OpenSSL::X509::Certificate.new
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = rand(2**128)
      root_ca.subject = OpenSSL::X509::Name.parse "CN=Foreman CA"
      root_ca.issuer = root_ca.subject
      root_ca.public_key = private_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = root_ca.not_before + EXPIRATION

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = root_ca
      ef.issuer_certificate = root_ca

      root_ca.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
      root_ca.add_extension(ef.create_extension("keyUsage", "keyCertSign, cRLSign", true))
      root_ca.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
      root_ca.add_extension(ef.create_extension("authorityKeyIdentifier", "keyid:always", false))

      root_ca.sign(private_key, OpenSSL::Digest::SHA256.new)
      write_certificate(root_ca.to_pem)

      root_ca
    end

  end
end
