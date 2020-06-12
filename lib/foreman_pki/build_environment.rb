require 'fileutils'

module ForemanPki
  class BuildEnvironment

    attr_reader :namespace

    def initialize(namespace, config = Config.new)
      @config = config.config
      @namespace = namespace
    end

    def create
      FileUtils.mkdir_p(base_dir)
      FileUtils.mkdir_p(certs_dir)
      FileUtils.mkdir_p(keys_dir)
    end

    def base_dir
      @config.generate.base_dir
    end

    def certs_dir
      "#{base_dir}/#{@namespace}"
    end

    def keys_dir
      "#{base_dir}/#{@namespace}"
    end

  end
end
