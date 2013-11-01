# Azericard

## Installation

Add this line to your application's Gemfile:

    gem 'azericard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install azericard

## Usage

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
