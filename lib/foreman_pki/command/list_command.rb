module ForemanPki
  module Command
    class ListCommand < Clamp::Command
      def execute
        config = Config.new

        config.certificates.each do |cert|
          puts cert.cert_name
        end
      end
    end
  end
end
