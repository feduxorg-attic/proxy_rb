require 'addressable/uri'

module ProxyRb
  class Resource
    attr_accessor :content

    private

    attr_reader :uri

    public

    def initialize(uri)
      @uri = Addressable::URI.parse(uri)
    end

    def to_uri
      uri.to_s
    end
  end
end
