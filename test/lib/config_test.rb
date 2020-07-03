require "test_helper"

class ConfigTest < Minitest::Test
  def setup
    ENV['FOREMAN_PKI_CONFIG_FILE'] = "#{File.expand_path(File.dirname(__FILE__))}/fixtures/config.yaml"
    @config = ForemanPki::Config.new
  end

  def test_config
    assert_equal "/etc/foreman-pki", @config.config.base_dir
  end

  def test_certificates
    expected_certs = ['apache', 'smart-proxy', 'foreman-to-smart-proxy', 'tomcat', 'ca', 'foreman-to-candlepin', 'foreman-to-pulp'].sort
    certs = @config.certificates.map(&:cert_name).sort
    assert_equal expected_certs, certs
  end

  def test_bundle
    bundle = ['apache', 'foreman-to-smart-proxy', 'smart-proxy']
    certs = @config.bundle('foreman').map(&:cert_name)
    assert_equal bundle, certs
  end
end
