# frozen_string_literal: true
require 'shellwords'

require 'proxy_rb/credentials'
require 'proxy_rb/proxy_url_parser'

# ProxyRb
module ProxyRb
  # Represent proxy
  class HttpProxy
    protected

    attr_reader :url, :credentials

    public

    def initialize(parser)
      @url         = parser.proxy_url
      @credentials = parser.credentials
    end

    # Convert to parameters for PhantomJS
    #
    # @return [Array]
    #   An array of parameters for PhantomJS
    def to_phantom_js
      result = []
      result << "--proxy=#{url}"
      result << "--proxy-auth=#{credentials}" unless credentials.empty?

      result
    end

    # Convert to symbol to reference the proxy
    #
    # @return [Symbol]
    #   <host>_<port>_<credentials>
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
