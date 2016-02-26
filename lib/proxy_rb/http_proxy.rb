module ProxyRb
  class HttpProxy
    attr_accessor :credentials

    private

    attr_reader :uri

    public

    def initialize(uri)
      @uri = Addressable::URI.heuristic_parse(uri)

      if hostname?(uri)
        @uri.scheme = 'http'
        @uri.path = '/'
        @uri.host = uri.split.first
        @uri.port = uri.split.last if uri.split.first != uri.split.last
      end
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

    def to_phantom_js
      bind = Shellwords.escape(format('%s:%s', host, port))

      result = []
      result << "--proxy=#{bind}"
      result << "--proxy-auth=#{credentials.to_login}" if credentials

      result
    end

    def to_sym
      Shellwords.escape(*[host, port, credentials].compact.join('_')).to_sym
    end

    private

    def hostname?(name)
      name = name.gsub(%r{^[^:]+://}, '').split(/:/).first

      /
      \A
      (
        (
          [a-zA-Z0-9]
          | [a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]
        )\.
      )*
        (
          [A-Za-z0-9]
      | [A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9]
      )
        \Z
        /x === name
    end
  end
end
