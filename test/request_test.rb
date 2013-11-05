require 'test/unit'
require 'azericard'

class RequestTest < Test::Unit::TestCase
  def setup
    Azericard.endpoint   = 'https://example.com/cgi-bin/cgi_link'
    Azericard.terminal   = '12345678'
    Azericard.secret_key = '1234ABC'
    Azericard.merchant_name  = 'Merchant'
    Azericard.merchant_email = 'merchant@example.com'
    Azericard.merchant_url   = 'https://merchant.example.com'
    Azericard.country_code   = 'AZ'
    Azericard.gmt_offset     = '+4'
  end

  def test_hex2bin
    assert_equal 'example hex data', Azericard::Request.hex2bin('6578616d706c65206865782064617461')
  end

  def test_generate_mac
    assert_equal '115110f072f734a729ebd0e7b65cfd8662fef682', Azericard::Request.generate_mac('text')
  end

  def test_options_for_request
    options = {
      amount: '22.5',
      currency: 'AZN',
      order: '453284023',
      tr_type: 0,
      desc: 'Description',
      backref: 'https://shop.example.com'
    }
    request_options = Azericard::Request.options_for_request(options)
    assert (/422\.53AZN945328402311Description8Merchant28https:\/\/merchant\.example\.com-81234567820merchant@example\.com102AZ2\+4/).match request_options.text_to_sign

    options = {
      amount: '22.5',
      currency: 'AZN',
      order: '453284023',
      tr_type: 21,
      rrn: 'RRN',
      intref: '12345'
    }
    request_options = Azericard::Request.options_for_request(options)
    assert (/9453284023422\.53AZN3RRN512345221812345678/).match request_options.text_to_sign
  end
end
