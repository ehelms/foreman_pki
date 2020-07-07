require "test_helper"

class PasswordTest < Minitest::Test
  def setup
    ENV['FOREMAN_PKI_CONFIG_FILE'] = "#{__dir__}/../../config.yaml.example"
    build_env = ForemanPki::BuildEnvironment.new('foreman')
    @password = ForemanPki::Password.new(build_env)
  end

  def test_password
    File.stubs(:exist?).returns(true)
    File.expects(:read).returns(SecureRandom.base64(15))

    assert_equal 20, @password.password.length
  end

  def test_create
    File.expects(:open).with("_etc/foreman-pki/certs/foreman/password", 'w', 0o400)
    File.stubs(:exist?).returns(true)

    assert_equal 20, @password.create.length
  end

  def test_get_and_not_create
    File.stubs(:exist?).returns(true)
    File.expects(:read).returns(SecureRandom.base64(15))

    assert_equal 20, @password.get_or_create.length
  end

  def test_get_and_create
    File.expects(:open).with("_etc/foreman-pki/certs/foreman/password", 'w', 0o400)
    File.stubs(:exist?).returns(false)

    assert_equal 20, @password.get_or_create.length
  end
end
