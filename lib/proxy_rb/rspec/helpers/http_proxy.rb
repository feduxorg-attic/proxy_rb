# Main Module
module ProxyRb
  # Main Module
  module Rspec
    # Helpers
    module Helpers
      # For http proxy
      module HttpProxy
        def download(r)
          resource = Resource.new(r)
          proxy = ProxyRb::HttpProxy.new(subject)

          downloader = HttpDownloader.new(proxy)
          downloader.process(resource)

          binding.pry

          page.body = resource.content
        end
      end
    end
  end
end
