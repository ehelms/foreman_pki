require 'securerandom'

module ForemanPki
  class Password
    PASSWORD_SIZE = 15

    def initialize(build_env)
      @build_env = build_env
      @path = "#{@build_env.certs_dir}/password"
    end

    def password
      return File.read(@path) if exist?
    end

    def get_or_create(_force = false)
      return password if exist?

      create
    end

    def create
      pass = SecureRandom.base64(PASSWORD_SIZE)
      write(pass)
      pass
    end

    def write(pass)
      File.open("#{@build_env.certs_dir}/password", 'w', 0o400) do |file|
        file.write(pass)
      end
    end

    def exist?
      File.exist?(@path)
    end
  end
end
