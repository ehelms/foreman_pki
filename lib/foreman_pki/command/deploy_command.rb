module ForemanPki
  module Command
    class DeployCommand < Clamp::Command
      parameter "certificate", "Certificate to view"

      def execute
        build_env = ForemanPki::BuildEnvironment.new

        if @certificate == 'ca'
          deploy_env = ForemanPki::DeployEnvironment.new('foreman')
          deploy_env.create

          ca = ForemanPki::CertificateAuthority.new(build_env, deploy_env)
          ca.deploy
        end
      end
    end
  end
end
