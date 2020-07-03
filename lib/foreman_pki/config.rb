require 'json'
require 'yaml'

module ForemanPki
  class Config

    CONFIG_FILE = ENV['FOREMAN_PKI_CONFIG_FILE'] || "#{File.expand_path(File.dirname(__FILE__))}/../../config.yaml"
    BUNDLE_DIR = "#{File.expand_path(File.dirname(__FILE__))}/../../bundles"

    def initialize
      @certificates = []
    end

    def config
      if File.exist?(CONFIG_FILE)
        @config ||= to_openstruct(YAML.load_file(CONFIG_FILE))
      else
        @config ||= default_config
      end
    end

    def certificates
      return @certificates unless @certificates.empty?

      @certificates = config.bundles.collect do |bundle|
        YAML.load_file("#{BUNDLE_DIR}/#{bundle}.yaml")
      end

      @certificates = sort(@certificates)
      to_openstruct(@certificates)
    end

    def bundle(name)
      certs = YAML.load_file("#{BUNDLE_DIR}/#{name}.yaml")
      certs = sort(certs)
      to_openstruct(certs)
    end

    private

    def default_config
      to_openstruct({
        base_dir: '_etc/foreman-pki',
      })
    end

    def to_openstruct(config_hash)
      JSON.parse(config_hash.to_json, object_class: OpenStruct)
    end

    def sort(certificates)
      certificates = certificates.flatten.sort { |a, b| a['cert_name'] <=> b['cert_name'] }
    end

  end
end
