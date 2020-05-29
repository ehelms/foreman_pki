require 'json'
require 'yaml'

module ForemanPki
  class Config

    CONFIG_FILE = ENV['FOREMAN_PKI_CONFIG_FILE'] || "#{File.expand_path(File.dirname(__FILE__))}/../../config.yaml"

    def config
      @config ||= JSON.parse(YAML.load_file(CONFIG_FILE).to_json, object_class: OpenStruct)
    end

  end
end
