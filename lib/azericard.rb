require 'azericard/configuration'
require 'azericard/error'
require 'azericard/request'
require 'azericard/version'
require 'typhoeus'

module Azericard
  extend Configuration

  AzericardOptions = Struct.new(
    :nonce, :timestamp,
    :amount, :currency, :order, :tr_type,
    :desc, :backref,
    :rrn, :intref,
    :text_to_sign
  ).freeze
end
