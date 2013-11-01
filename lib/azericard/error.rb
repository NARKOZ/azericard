module Azericard
  class Error < StandardError; end
  class HTTPResponseError < Error; end
  class AzericardResponseError < Error; end
end
