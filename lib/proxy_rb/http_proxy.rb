require 'uri'
require 'shellwords'

require 'proxy_rb/credentials'

module ProxyRb
  class HttpProxy
    protected

    attr_reader :uri, :credentials

    public

    def initialize(uri)
      @uri         = URI(uri)

      if hostname?(uri)
        splitted_uri = uri.split(/:/)

        @uri.scheme   = 'http'
        @uri.path     = '/'
        @uri.host     = splitted_uri.first
        @uri.port     = splitted_uri.last unless splitted_uri.first == splitted_uri.last
      end

      @credentials = Credentials.new(@uri.user, @uri.password)
    end

    def to_uri
      uri.to_s
    end

    def to_phantom_js
      result = []
      result << "--proxy=#{to_uri}"
      result << "--proxy-auth=#{credentials.to_login}" if uri.user

      result
    end

    def to_sym
      Shellwords.escape(*[host, port, credentials.user_name].compact.join('_')).to_sym
    end

    private

    def host
      uri.host
    end

    def port
      uri.port
    end

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
