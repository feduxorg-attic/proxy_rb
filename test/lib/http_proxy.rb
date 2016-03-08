# frozen_string_literal: true
require 'json'
require_relative 'test_server'

# Classes for tests
module Test
  # HTTP Proxy
  class HttpProxy < TestServer
    def initialize(*args)
      super(*args)

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

      proxy = WEBrick::HTTPProxyServer.new config

      trap('INT') { proxy.shutdown }
      trap('TERM') { proxy.shutdown }

      proxy.start
    end
  end
end
