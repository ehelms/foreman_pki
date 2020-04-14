require 'fileutils'

module ForemanPki
  class DeployEnvironment

    def initialize(service)
      @service = service
    end

    def create
      FileUtils.mkdir_p(base_dir)
      FileUtils.mkdir_p(certs_dir)
      FileUtils.mkdir_p(keys_dir)
      FileUtils.mkdir_p(requests_dir)
    end

    def base_dir
      "etc/#{@service}/pki"
    end

    def certs_dir
      "#{base_dir}/certs"
    end

    def keys_dir
      "#{base_dir}/private"
    end

    def requests_dir
      "#{base_dir}/requests"
    end

  end
end
