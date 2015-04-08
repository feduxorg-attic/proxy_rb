module ProxyRb
  class HttpDownloader
    private

    attr_reader :downloader, :proxy

    public

    def initialize(proxy)
      @downloader = Excon
      @proxy      = proxy
    end

    def process(resource)
      resource.content = downloader.get(resource.to_uri, proxy: proxy.to_uri)
    end
  end
end
