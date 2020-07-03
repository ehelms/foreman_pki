module ForemanPki
  module Command
    class ImportCommand < Clamp::Command
      parameter "bundle", "Specify the certificate bundle to import"

      def execute
        build_env = ForemanPki::BuildEnvironment.new('ca')

        Dir.chdir(build_env.base_dir) do
          `/usr/bin/tar -xzf #{bundle}`
        end
      end
    end
  end
end
