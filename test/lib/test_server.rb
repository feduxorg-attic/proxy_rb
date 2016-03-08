# frozen_string_literal: true
require 'json'

# Classes for tests
module Test
  # HTTP Proxy
  class TestServer
    attr_reader :headers, :body, :status_code, :user_database, :config

    def initialize(c)
      @cfg = JSON.parse(c).to_hash.each_with_object({}) { |(k,v),a| a[k.to_sym] = v }

      @headers       = @cfg[:headers]
      @body          = @cfg.fetch(:body, 'Example Domain')
      @status_code   = @cfg[:status_code]
      @user_database = @cfg[:user_database]
    end

    # Start server
    def start
      fail NoMethodError, 'Please implement "#start"-method'
    end
  end
end
