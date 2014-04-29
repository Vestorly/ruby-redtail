require_relative 'helper'

class ClientTest < Test::Unit::TestCase
  def setup
    setup_redtail
    @client = RubyRedtail::Client.new
  end

  should "be able to authenticate with username and password" do
    authentication = @client.authenticate(@redtail_user_name, @redtail_user_password)
    assert_equal("Success", authentication.message)
    assert_equal(41974, authentication.user_id)
    assert_equal(@redtail_user_key, authentication.user_key)
  end

  should "be able to authenticate with user_key" do
    authentication = @client.authenticate(@redtail_user_key)
    assert_equal(41974, authentication.user_id)
    assert_equal(@redtail_user_key, authentication.user_key)
  end
end