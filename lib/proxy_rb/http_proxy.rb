module ProxyRb
  class HttpProxy
    private

    attr_reader :uri

    public

    def initialize(uri)
      @uri = Addressable::URI.heuristic_parse(uri)
    end

    def host
      uri.host
    end

    def port
      uri.port
    end

    def to_uri
      uri.to_s
    end
  end
end
