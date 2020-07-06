module ForemanPki
  module Command
    class ExportCommand < Clamp::Command
      option "--common-name",
             "COMMON_NAME",
             "Specify the common name (CN) for exported certificates to have",
             required: true
      option "--bundle",
             "BUNDLE",
             "Specify the certificate bundle to export",
             required: true
      option "--force",
             :flag,
             [
               "Forces generation of certificates even if they already exist.",
               "Should be used if changing CA's but must be used with caution."
             ].join(' ')

      def execute
        config = Config.new

        certificates = config.bundle(bundle)
        build_env = ForemanPki::BuildEnvironment.new('ca')
        ca = ForemanPki::CertificateAuthority.new('ca', build_env)

        certificates.each do |certificate|
          build_env = ForemanPki::BuildEnvironment.new(certificate.service, common_name)
          build_env.create

          puts "Generating #{certificate.cert_name} for export" unless force?
          puts "Force regenerating #{certificate.cert_name} for export" if force?
          key_pair = KeyPair.new(certificate.cert_name, build_env)

          key_pair.create(certificate.common_name || common_name, ca, force?)
        end

        build_env = ForemanPki::BuildEnvironment.new('ca', common_name)
        build_env.create

        puts "Copying CA certificate for export"
        ca_copy = ForemanPki::CertificateAuthority.new('ca', build_env)
        ca_copy.copy_certificate(ca)

        Dir.chdir(build_env.base_dir) do
          `/usr/bin/tar -czf foreman-pki-#{common_name}.tar.gz ./`
        end
      end
    end
  end
end
