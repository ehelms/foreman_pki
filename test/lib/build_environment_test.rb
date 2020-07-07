require "test_helper"

class BuildEnvironmentTest < Minitest::Test
  def setup
    ENV['FOREMAN_PKI_CONFIG_FILE'] = "#{__dir__}/../../config.yaml.example"
    @build_env = ForemanPki::BuildEnvironment.new('foreman')
  end

  def test_base_dir
    assert_equal "_etc/foreman-pki", @build_env.base_dir
  end

  def test_certs_dir
    assert_equal "_etc/foreman-pki/certs/foreman", @build_env.certs_dir
  end

  def test_export
    @build_env = ForemanPki::BuildEnvironment.new('foreman', 'export_foreman')
    assert_equal "_etc/foreman-pki/exports/export_foreman", @build_env.base_dir
  end
end
