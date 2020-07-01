module ForemanPki
  class Truststore

    def initialize(build_env)
      @build_env = build_env
    end

    def create(key_pair)
      password = Password.new(@build_env)

      File.delete("#{@build_env.certs_dir}/truststore") if File.exist?("#{@build_env.certs_dir}/truststore")
      `ls -la #{@build_env.certs_dir}`

      store = OpenSSL::PKCS12.create(password.get_or_create, @build_env.namespace, key_pair.private_key, key_pair.certificate, [key_pair.ca.certificate])

      File.open("#{@build_env.certs_dir}/truststore", 'w', KeyPair::KEY_PERMISSIONS) do |file|
        file.write(store.to_der)
      end
    end
  end
end
