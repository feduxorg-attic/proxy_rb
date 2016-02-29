module ProxyRb
  class Request
    protected

    attr_reader :page

    public

    def initialize(page)
      @page = page
    end

    def successful?
      page.status_code.to_s.start_with?('2')  || page.status_code.to_s.start_with?('3')
    end

    # def forbidden?
    #   page.status_code == 403
    # end

    # def invalid?
    #   page.status_code == 401
    # end

    # def redirected?
    #   page.status_code.to_s.start_with? '3'
    # end
  end
end
