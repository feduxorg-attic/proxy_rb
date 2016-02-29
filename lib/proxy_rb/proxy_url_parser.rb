require 'uri'
require 'proxy_rb/proxy_url'

module ProxyRb
  class ProxyUrlParser
    protected

    attr_reader :raw_url

    public

    attr_reader :proxy_url, :credentials

    def initialize(url)
      @raw_url = url

      if hostname?(@raw_url)
        @proxy_url = ProxyUrl.build(url_hash_for_hostname_port)
      else
        @proxy_url = ProxyUrl.build(url_hash_for_url)
      end

      @credentials = Credentials.new(proxy_url.user, proxy_url.password)
    end

    private

    def hostname?(name)
      name = name.to_s.gsub(%r{^[^:]+://}, '').split(/:/).first

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

    def url_hash_for_hostname_port
      splitted_url = raw_url.to_s.split(/:/)

      url_hash = {}
      url_hash[:host] = splitted_url.first
      url_hash[:path] = '/'
      url_hash[:port] = splitted_url.last unless splitted_url.first == splitted_url.last

      url_hash
    end

    def url_hash_for_url
      URI(raw_url).hash
    end
  end
end
