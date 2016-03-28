# frozen_string_literal: true
require 'json'
require_relative 'test_server'

# Classes for tests
module Test
  # HTTP Proxy
  class HttpProxy < TestServer
    attr_reader :expected_response_body

    def initialize(*args)
      super(*args)

      @expected_response_body = @cfg.delete(:expected_response_body)

      @config = Hash(
        @cfg.delete(:config)
      ).merge(
        @cfg.key?(:Port) ? {} : { Port: 8080 }
      ).merge(@cfg)
    end

    # Start server
    def start
      require 'webrick'
      require 'webrick/httpproxy'

      if user_database && File.file?(user_database)
        # Apache compatible Password manager
        htpasswd = WEBrick::HTTPAuth::Htpasswd.new user_database

        # Authenticator
        authenticator = WEBrick::HTTPAuth::ProxyBasicAuth.new(
          Realm: 'Proxy Realm',
          UserDB: htpasswd
        )

        config[:ProxyAuthProc] = authenticator.method(:authenticate).to_proc
      end

      body_has_content = proc do |body|
        return true unless expected_response_body

        expected_response_body == body
      end

      config[:ProxyContentHandler] = proc do |_req, res|
        Array(headers).each { |k, v| res.header[k] = v }
        res.body   = body        if body && body_has_content
        res.status = status_code if status_code && body_has_content
      end

      proxy = WEBrick::HTTPProxyServer.new config

      trap('INT') { proxy.shutdown }
      trap('TERM') { proxy.shutdown }

      proxy.start
    end
  end
end
