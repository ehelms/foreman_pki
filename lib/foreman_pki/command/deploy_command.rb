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

        if @certificate == 'foreman'
          deploy_env = ForemanPki::DeployEnvironment.new('foreman')
          deploy_env.create

          foreman = ForemanPki::ServerCertificate.new(build_env, deploy_env)
          foreman.deploy
        end
      end
    end
  end
end
