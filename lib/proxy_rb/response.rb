# frozen_string_literal: true
require 'delegate'

# ProxyRb
module ProxyRb
  # A response
  class Response < SimpleDelegator
    def mime_type
      __getobj__.driver.response_headers['Content-Type']
    end
  end
end
