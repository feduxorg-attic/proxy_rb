# frozen_string_literal: true
require 'delegate'

# ProxyRb
module ProxyRb
  # An HTTP request
  class Request < SimpleDelegator
    # Was the request successful
    #
    # @return [TrueClass, FalseClass]
    #   The result
    def successful?
      __getobj__.status_code.to_s.start_with?('2', '3')
    end

    # The request is forbidden
    #
    # @return [TrueClass, FalseClass]
    #   The result
    def forbidden?
      __getobj__.status_code == 403
    end
  end
end
