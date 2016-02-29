require 'uri'
require 'addressable/uri'
require 'proxy_rb/proxy_url'

# ProxyRb
module ProxyRb
  # Parse urls for proxies
  class ProxyUrlParser
    protected

    attr_reader :raw_url

    public

    attr_reader :proxy_url, :credentials

    # @param [String] url
    #   The url for the proxy configuration
    def initialize(url)
      temporary_url = ProxyUrl.parse(url)

      @proxy_url   = temporary_url.without_user_name_and_password
      @credentials = Credentials.new(temporary_url.user, temporary_url.password)
    end

    private

    def url_hash_for_hostname_port
      splitted_url = raw_url.to_s.split(/:/)

      url_hash = {}
      url_hash[:host] = splitted_url.first
      url_hash[:path] = '/'
      url_hash[:port] = splitted_url.last unless splitted_url.first == splitted_url.last

      url_hash
    end

    def url_hash_for_url
      Addressable::URI.parse(raw_url).to_hash
    end

    def url?(u)
      url = Addressable::URI.parse(u)

      return false if url.nil?
      return false unless /\A[[:alnum:]]+\Z/ === url.scheme
      return true if url && url.host

      false
    rescue Addressable::URI::InvalidURIError
      false
    end
  end
end
