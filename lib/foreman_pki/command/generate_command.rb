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

      class ServerCommand < Clamp::Command
        parameter "HOSTNAME", "Hostname to generate server certificate for"

        def execute
          build_env = ForemanPki::BuildEnvironment.new
          build_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env)
          server = ForemanPki::ServerCertificate.new(build_env)
          server.create(hostname, ca)
        end
      end

      subcommand "ca", "Generate CA certificate", ForemanPki::Command::GenerateCommand::CACommand
      subcommand "server", "Generate server certificate", ForemanPki::Command::GenerateCommand::ServerCommand

    end
  end
end
