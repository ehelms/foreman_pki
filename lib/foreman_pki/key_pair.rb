module ForemanPki
  class KeyPair

    KEY_LENGTH = 2048
    EXPIRATION = 2 * 365 * 24 * 60 * 60 # 2 years validity

    def initialize(build_env = BuildEnvironment.new, deploy_env = DeployEnvironment.new('foreman'))
      @build_env = build_env
      @deploy_env = deploy_env
      @service = deploy_env.service
    end

    def key_name
      "#{@service}.key"
    end

    def cert_name
      "#{@service}.crt"
    end

    def create
      private_key
      certificate
    end

    def private_key
      key_path = "#{@build_env.keys_dir}/#{key_name}"

      return OpenSSL::PKey::RSA.new(File.read(key_path)) if File.exist?(key_path)

      key = OpenSSL::PKey::RSA.new(KEY_LENGTH)

      File.open("#{@build_env.keys_dir}/#{key_name}", 'w', 0400) do |file|
        file.write(key.export)
      end

      key
    end

    def certificate
      fail NotImplementedError
    end

    def view
      puts certificate.to_text
    end

  end
end
