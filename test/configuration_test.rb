require 'minitest/autorun'
require 'azericard'

class ConfigurationTest < Minitest::Test
  def teardown
    Azericard.reset
  end

  def test_config_options
    Azericard.endpoint   = 'https://example.com/cgi-bin/cgi_link'
    Azericard.terminal   = '12345678'
    Azericard.secret_key = '00112233445566778899AABBCCDDEEFF'
    Azericard.merchant_name  = 'Merchant'
    Azericard.merchant_email = 'merchant@example.com'
    Azericard.merchant_url   = 'https://merchant.example.com'
    Azericard.country_code   = 'AZ'
    Azericard.gmt_offset     = '+4'
    Azericard.debug          = true

    assert_equal 'https://example.com/cgi-bin/cgi_link', Azericard.endpoint
    assert_equal '12345678', Azericard.terminal
    assert_equal '00112233445566778899AABBCCDDEEFF', Azericard.secret_key
    assert_equal 'Merchant', Azericard.merchant_name
    assert_equal 'merchant@example.com', Azericard.merchant_email
    assert_equal 'https://merchant.example.com', Azericard.merchant_url
    assert_equal 'AZ', Azericard.country_code
    assert_equal '+4', Azericard.gmt_offset
    assert Azericard.debug
  end

  def test_user_agent
    assert_equal "Azericard Ruby Gem #{Azericard::VERSION}", Azericard.user_agent

    Azericard.user_agent = 'Custom User Agent'
    assert_equal 'Custom User Agent', Azericard.user_agent
  end

  def test_config_block
    Azericard::Configuration::VALID_OPTIONS_KEYS.each do |key|
      Azericard.configure do |config|
        config.send("#{key}=", key)
        assert_equal key, Azericard.send(key)
      end
    end
  end
end
