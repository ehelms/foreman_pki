require 'fileutils'

module ForemanPki
  class DeployEnvironment

    attr_reader :service

    def initialize(service, config = Config.new)
      @service = service
      @config = config.config
    end

    def create
      FileUtils.mkdir_p(base_dir)
      FileUtils.mkdir_p(certs_dir)
      FileUtils.mkdir_p(keys_dir)
    end

    def base_dir
      "#{@config.deploy.base_dir}/#{@service}/pki"
    end

    def certs_dir
      "#{base_dir}/certs"
    end

    def keys_dir
      "#{base_dir}/private"
    end

  end
end
