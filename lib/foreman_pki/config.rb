require 'json'
require 'yaml'

module ForemanPki
  class Config

    BUNDLE_DIR = "#{File.expand_path(File.dirname(__FILE__))}/../../bundles"

    def initialize
      @certificates = []
    end

    def config
      root_path = "#{File.expand_path(File.dirname(__FILE__))}/../../"

      config_file = "#{root_path}/config.yaml.example"
      config_file = "#{root_path}/../../config.yaml" if File.exist?("#{root_path}/../../config.yaml")
      config_file = '/etc/foreman-pki/config.yaml' if File.exist?('/etc/foreman-pki/config.yaml')
      config_file = ENV['FOREMAN_PKI_CONFIG_FILE'] if ENV['FOREMAN_PKI_CONFIG_FILE']

      @config ||= to_openstruct(YAML.load_file(config_file))
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

    def to_openstruct(config_hash)
      JSON.parse(config_hash.to_json, object_class: OpenStruct)
    end

    def sort(certificates)
      certificates = certificates.flatten.sort { |a, b| a['cert_name'] <=> b['cert_name'] }
    end

  end
end
