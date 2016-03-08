# frozen_string_literal: true
# ProxyRb
module ProxyRb
  # A response
  class Response
    protected

    attr_reader :page

    public

    def initialize(page)
      @page = page
    end

    def mime_type
      page.driver.response_headers['Content-Type']
    end
  end
end
