require 'uri'

module ProxyRb
  class Resource
    attr_accessor :content

    private

    attr_reader :url

    public

    def initialize(url)
      @url = URI(url)
    end

    def to_url
      url.to_s
    end
  end
end
