module ProxyRb
  class Response
    protected

    attr_reader :page

    public

    def initialize(page)
      @page = page
    end

    # def forbidden?
    #   page.status_code == 403
    # end
  end
end
