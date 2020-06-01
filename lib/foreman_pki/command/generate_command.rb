module ForemanPki
  module Command
    class GenerateCommand < Clamp::Command

      class CACommand < Clamp::Command
        def execute
          build_env = ForemanPki::BuildEnvironment.new
          build_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env)
          ca.create
        end
      end

      class ApacheCommand < Clamp::Command
        parameter "HOSTNAME", "Hostname to generate server certificate for"

        def execute
          build_env = ForemanPki::BuildEnvironment.new
          build_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env)
          server = ForemanPki::ApacheCertificate.new(build_env)
          server.create(hostname, 'apache', ca)
        end
      end

      subcommand "ca", "Generate CA certificate", ForemanPki::Command::GenerateCommand::CACommand
      subcommand "apache", "Generate Apache server certificate", ForemanPki::Command::GenerateCommand::ApacheCommand

    end
  end
end
