require 'fileutils'

module ForemanPki
  class BuildEnvironment

    def initialize
    end

    def create
      FileUtils.mkdir_p(base_dir)
      FileUtils.mkdir_p(certs_dir)
      FileUtils.mkdir_p(keys_dir)
      FileUtils.mkdir_p(requests_dir)
    end

    def base_dir
      "pki-build"
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
