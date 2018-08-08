# Azericard

Ruby interface to AzeriCard online payment processing system.

## Installation

```ruby
gem 'azericard'
# gem 'azericard', github: 'NARKOZ/apluscard'
```

## Configuration

```ruby
Azericard.configure do |config|
  config.endpoint       = Settings.azericard.endpoint
  config.terminal       = Settings.azericard.terminal
  config.secret_key     = Settings.azericard.secret_key

  config.merchant_name  = Settings.azericard.merchant_name
  config.merchant_email = Settings.azericard.merchant_email
  config.merchant_url   = Settings.azericard.merchant_url
  config.country_code   = Settings.azericard.country_code
  config.gmt_offset     = Settings.azericard.gmt_offset
end
```

## Usage

```ruby
# Payment authorization
options = {
  amount: @order.amount,
  currency: @order.currency,
  order: @order.number,
  tr_type: 0,
  desc: @order.description,
  backref: azericard_callback_url
}
request_options = Azericard::Request.options_for_request(options)
p_sign = Azericard::Request.generate_mac(request_options.text_to_sign)

# Checkout transaction
options = {
  amount: @order.amount,
  currency: @order.currency,
  order: @order.number,
  tr_type: 21,
  rrn: @order.payment.rrn,
  intref: @order.payment.intref
}
request_options = Azericard::Request.options_for_request(options)

begin
  Azericard::Request.process request_options
rescue Azericard::Error => e
  e.message
end
```

## Legal

This code is in no way affiliated with, authorised, maintained, sponsored or
endorsed by AzeriCard LLC or any of its affiliates or subsidiaries. This is an
independent and unofficial. Use at your own risk.

## Copyright

Copyright (c) 2013-2023 Nihad Abbasov
