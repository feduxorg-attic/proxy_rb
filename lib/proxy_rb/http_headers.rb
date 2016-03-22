module ProxyRb
  class HttpHeaders
    protected

    attr_reader :capybara_headers

    public

    def initialize(capybara_headers)
      @capybara_headers = Hash(capybara_headers)
    end

    def to_h
      capybara_headers.select { |k, _| k.to_s.start_with?('HTTP_') }.each_with_object({}) { |(k, v), a| a[k.to_s.sub(/HTTP_/, '')] = v }
    end
  end
end
