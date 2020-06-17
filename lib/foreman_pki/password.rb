require 'securerandom'

module ForemanPki
  class Password

    PASSWORD_SIZE = 15

    def initialize(build_env)
      @build_env = build_env
      @path = "#{@build_env.keys_dir}/password"
    end

    def password
      return File.read(@path) if exist?
    end

    def get_or_create(force = false)
      return password if exist?
      create
      password
    end

    def create
      write(SecureRandom.base64(PASSWORD_SIZE))
    end

    def write(pass)
      File.open("#{@build_env.keys_dir}/password", 'w', 0400) do |file|
        file.write(pass)
      end
    end

    def exist?
      File.exist?(@path)
    end

  end
end
