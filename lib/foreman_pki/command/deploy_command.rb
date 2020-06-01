module ForemanPki
  module Command
    class DeployCommand < Clamp::Command
      parameter "certificate", "Certificate to deploy"

      def execute
        build_env = ForemanPki::BuildEnvironment.new

        if @certificate == 'ca'
          deploy_env = ForemanPki::DeployEnvironment.new('foreman')
          deploy_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env, deploy_env)
          ca.deploy
        end

        if @certificate == 'apache'
          deploy_env = ForemanPki::DeployEnvironment.new('apache')
          deploy_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env, deploy_env)

          apache = ForemanPki::ApacheCertificate.new(build_env, deploy_env)
          apache.deploy
        end

        if @certificate == 'foreman-client'
          deploy_env = ForemanPki::DeployEnvironment.new('foreman')
          deploy_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env, deploy_env)

          client = ForemanPki::ForemanClientCertificate.new(build_env, deploy_env)
          client.deploy
        end
      end
    end
  end
end
