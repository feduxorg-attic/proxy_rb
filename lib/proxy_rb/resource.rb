# frozen_string_literal: true
require 'addressable/uri'

# ProxyRb
module ProxyRb
  # A resource
  class Resource
    attr_accessor :content

    private

    attr_reader :url

    public

    def initialize(url)
      @url = Addressable::URI(url)
    end

    # Convert resource to url
    #
    # @return [String] url
    #   The url
    def to_url
      url.to_s
    end
  end
end
