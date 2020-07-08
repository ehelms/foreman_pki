$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "foreman_pki"

require "minitest/autorun"
require 'mocha/minitest'
require 'fakefs/safe'

def setup_build_env
  ENV['FOREMAN_PKI_CONFIG_FILE'] = "#{__dir__}/../config.yaml.example"
  build_env = ForemanPki::BuildEnvironment.new('foreman')
end
