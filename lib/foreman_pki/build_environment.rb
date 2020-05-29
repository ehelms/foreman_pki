require 'fileutils'

module ForemanPki
  class BuildEnvironment

    def initialize(config = Config.new)
      @config = config.config
    end

    def create
      FileUtils.mkdir_p(base_dir)
      FileUtils.mkdir_p(certs_dir)
      FileUtils.mkdir_p(keys_dir)
    end

    def base_dir
      @config.generate.directory
    end

    def certs_dir
      "#{base_dir}/certs"
    end

    def keys_dir
      "#{base_dir}/private"
    end

  end
end
