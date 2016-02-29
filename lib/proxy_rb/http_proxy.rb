require 'shellwords'

require 'proxy_rb/credentials'
require 'proxy_rb/proxy_url_parser'

module ProxyRb
  class HttpProxy
    protected

    attr_reader :url, :credentials

    public

    def initialize(parser)
      @url         = parser.proxy_url
      @credentials = parser.credentials
    end

    def to_phantom_js
      result = []
      result << "--proxy=#{url.to_s}"
      result << "--proxy-auth=#{credentials.to_s}" unless credentials.empty?

      result
    end

    def to_sym
      Shellwords.escape(*[host, port, credentials.user_name].compact.join('_')).to_sym
    end

    private

    def host
      url.host
    end

    def port
      url.port
    end
  end
end
