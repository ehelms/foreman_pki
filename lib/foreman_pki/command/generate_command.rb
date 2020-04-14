module ForemanPki
  module Command
    class GenerateCommand < Clamp::Command
      def execute
        build_env = ForemanPki::BuildEnvironment.new
        build_env.create

        ca = ForemanPki::CertificateAuthority.new(build_env)
        ca.create
      end
    end
  end
end
