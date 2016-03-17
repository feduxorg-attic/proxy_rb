# frozen_string_literal: true
require 'addressable/uri'
require 'proxy_rb/credentials'

# ProxyRb
module ProxyRb
  # A resource
  class Resource
    attr_accessor :content
    attr_reader :credentials, :url

    def initialize(url)
      @url = Addressable::URI.parse(url)
    end

    # Return credentials from url
    #
    # @return [Credentials]
    #   The credentials from url
    def credentials
      Credentials.new(url.user, url.password)
    end

    # Convert resource to url
    #
    # @return [String] url
    #   The url
    def to_s
      url.to_s
    end
  end
end
