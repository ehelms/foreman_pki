require 'json'
require 'yaml'

module ForemanPki
  class Config

    CONFIG_FILE = ENV['FOREMAN_PKI_CONFIG_FILE'] || "#{File.expand_path(File.dirname(__FILE__))}/../../config.yaml"

    def config
      if File.exist?(CONFIG_FILE)
        @config ||= to_openstruct(YAML.load_file(CONFIG_FILE))
      else
        @config = default_config
      end
    end

    def default_config
      to_openstruct({
        generate: {
          base_dir: '_etc/foreman_pki',
        },
        deploy: {
          base_dir: '_etc'
        }
      })
    end

    def to_openstruct(config_hash)
      JSON.parse(config_hash.to_json, object_class: OpenStruct)
    end

  end
end
