require "test_helper"

class TruststoreTest < Minitest::Test
  def setup
    build_env = setup_build_env

    FakeFS.activate!
    build_env.create

    ca = ForemanPki::CertificateAuthority.new('foreman', build_env)
    ca.create

    @key_pair = ForemanPki::KeyPair.new('foreman', build_env)
    @key_pair.create('foreman.example.com', ca)

    @truststore = ForemanPki::Truststore.new(build_env)
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_create
    @truststore.create(@key_pair)

    assert File.exist?('_etc/foreman-pki/certs/foreman/truststore')
  end
end
