# frozen_string_literal: true
# ProxyRb
module ProxyRb
  # An HTTP request
  class Request
    protected

    attr_reader :page

    public

    def initialize(page)
      @page = page
    end

    # Was the request successful
    #
    # @return [TrueClass, FalseClass]
    #   The result
    def successful?
      page.status_code.to_s.start_with?('2', '3')
    end

    # The request is forbidden
    #
    # @return [TrueClass, FalseClass]
    #   The result
    def forbidden?
      page.status_code == 403
    end

    # def invalid?
    #   page.status_code == 401
    # end

    # def redirected?
    #   page.status_code.to_s.start_with? '3'
    # end
  end
end
