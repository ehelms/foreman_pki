require 'fileutils'

module ForemanPki
  class BuildEnvironment
    attr_reader :namespace

    def initialize(namespace, export_namespace = nil)
      @config = Config.new.config
      @namespace = namespace
      @export_namespace = export_namespace
    end

    def create
      FileUtils.mkdir_p(base_dir)
      FileUtils.mkdir_p(certs_dir)
      FileUtils.mkdir_p(keys_dir)
    end

    def base_dir
      return @config.base_dir if @export_namespace.nil?

      [@config.base_dir, 'exports', @export_namespace].join('/')
    end

    def certs_dir
      "#{base_dir}/certs/#{@namespace}"
    end

    def keys_dir
      "#{base_dir}/certs/#{@namespace}"
    end
  end
end
