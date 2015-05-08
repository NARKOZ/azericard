module Azericard
  module Request
    # @param [Azericard::AzericardOptions] request_options
    # @return [true]
    # @raise [Azericard::HTTPResponseError]
    # @raise [Azericard::AzericardResponseError]
    def self.process(request_options)
      p_sign = generate_mac(request_options.text_to_sign)

      request = Typhoeus::Request.new(
        Azericard.endpoint,
        method: :post,
        followlocation: true,
        ssl_verifypeer: false,
        ssl_verifyhost: 2,
        sslversion: :tlsv1,
        ssl_cipher_list: 'RC4-SHA',
        headers: {
          "User-Agent" => Azericard.user_agent
        },
        body: {
          "AMOUNT"    => request_options.amount,
          "CURRENCY"  => request_options.currency,
          "ORDER"     => request_options.order,
          "RRN"       => request_options.rrn,
          "INT_REF"   => request_options.intref,
          "TERMINAL"  => Azericard.terminal,
          "TRTYPE"    => request_options.tr_type,
          "TIMESTAMP" => request_options.timestamp,
          "NONCE"     => request_options.nonce,
          "P_SIGN"    => p_sign
        }
      )

      response = request.run

      if response.success?
        if response.body == '0'
          true
        else
          raise AzericardResponseError, "Azericard responded with: #{response.body[0..4]}"
        end
      else
        raise HTTPResponseError, "Azericard request failed: #{response.code}"
      end
    end

    # @param [Hash] options
    # @return [Azericard::AzericardOptions]
    def self.options_for_request(options={})
      nonce      = options.fetch :nonce      , SecureRandom.hex(8)
      timestamp  = options.fetch :timestamp  , Time.now.utc.strftime('%Y%m%d%H%M%S')
      merch_name = options.fetch :merch_name , Azericard.merchant_name
      merch_url  = options.fetch :merch_url  , Azericard.merchant_url
      terminal   = options.fetch :terminal   , Azericard.terminal.to_s
      email      = options.fetch :email      , Azericard.merchant_email
      country    = options.fetch :country    , Azericard.country_code
      merch_gmt  = options.fetch :merch_gmt  , Azericard.gmt_offset

      desc = backref = rrn = intref = nil

      # Order total amount in float format with decimal point separator
      amount = options.fetch(:amount).to_f.to_s

      # Order currency: 3-character currency code
      currency = options.fetch(:currency)

      # Merchant order ID
      order = options.fetch(:order).to_s

      # Operation type
      #
      # 0 - auth
      # 21 - checkout
      # 24 - reversal
      tr_type = options.fetch(:tr_type).to_s

      if tr_type == '0'
        # Order description
        desc = options.fetch(:desc).to_s

        # Merchant URL for posting authorization result
        backref = options.fetch(:backref)

        text_to_sign = "#{amount.size}#{amount}#{currency.size}#{currency}#{order.size}#{order}" \
          "#{desc.size}#{desc}#{merch_name.size}#{merch_name}#{merch_url.size}#{merch_url}-" \
          "#{terminal.size}#{terminal}#{email.size}#{email}#{tr_type.size}#{tr_type}#{country.size}#{country}" \
          "#{merch_gmt.size}#{merch_gmt}#{timestamp.size}#{timestamp}#{nonce.size}#{nonce}#{backref.size}#{backref}"
      elsif tr_type == '21' || tr_type == '24'
        # Merchant bank's retrieval reference number
        rrn = options.fetch(:rrn).to_s

        # E-Commerce gateway internal reference number
        intref = options.fetch(:intref)

        text_to_sign = "#{order.size}#{order}#{amount.size}#{amount}#{currency.size}#{currency}" \
          "#{rrn.size}#{rrn}#{intref.size}#{intref}#{tr_type.size}#{tr_type}#{terminal.size}#{terminal}" \
          "#{timestamp.size}#{timestamp}#{nonce.size}#{nonce}"
      end

      AzericardOptions.new(nonce, timestamp, amount, currency, order, tr_type, desc, backref, rrn, intref, text_to_sign)
    rescue KeyError => e
      e.message
    end

    # Generates MAC – Message Authentication Code
    def self.generate_mac(text_to_sign)
      OpenSSL::HMAC.hexdigest('sha1', hex2bin(Azericard.secret_key), text_to_sign)
    end

    # Decodes a hexadecimally encoded binary string
    def self.hex2bin(str)
      str.scan(/../).map { |x| x.to_i(16).chr }.join
    end
  end
end
