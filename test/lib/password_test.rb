require "test_helper"

class PasswordTest < Minitest::Test
  def setup
    build_env = setup_build_env
    FakeFS.activate!
    build_env.create
    @password = ForemanPki::Password.new(build_env)
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_password
    @password.create

    assert_equal 20, @password.password.length
  end

  def test_create
    assert_equal 20, @password.create.length
  end

  def test_get_and_not_create
    @password.create

    assert_equal 20, @password.get_or_create.length
  end

  def test_get_and_create
    assert_equal 20, @password.get_or_create.length
  end
end
