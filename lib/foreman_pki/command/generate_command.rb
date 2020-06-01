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
        option "--hostname", "HOSTNAME", "Specify the hostname for certificate (defaults to current hostname)"

        def default_hostname
          `hostname`
        end

        def execute
          build_env = ForemanPki::BuildEnvironment.new
          build_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env)
          apache = ForemanPki::ApacheCertificate.new(build_env)
          apache.create(hostname, 'apache', ca)
        end
      end

      class ForemanClientCommand < Clamp::Command
        option "--hostname", "HOSTNAME", "Specify the hostname for certificate (defaults to current hostname)"

        def default_hostname
          `hostname`
        end

        def execute
          build_env = ForemanPki::BuildEnvironment.new
          build_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env)
          client = ForemanPki::ForemanClientCertificate.new(build_env)
          client.create(hostname, 'foreman', ca)
        end
      end

      subcommand "ca", "Generate CA certificate", ForemanPki::Command::GenerateCommand::CACommand
      subcommand "apache", "Generate Apache server certificate", ForemanPki::Command::GenerateCommand::ApacheCommand
      subcommand "foreman-client", "Generate Foreman client certificate", ForemanPki::Command::GenerateCommand::ForemanClientCommand

    end
  end
end
