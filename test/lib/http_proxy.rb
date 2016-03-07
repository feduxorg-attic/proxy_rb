# frozen_string_literal: true
require 'json'

# Classes for tests
module Test
  # HTTP Proxy
  class HttpProxy
    attr_reader :headers, :body, :status_code, :user_database, :config

    def initialize(c)
      cfg = JSON.parse(c).to_hash.each_with_object({}) { |(k,v),a| a[k.to_sym] = v }

      @headers       = cfg[:headers]
      @body          = cfg[:body]
      @status_code   = cfg[:status_code]
      @user_database = cfg[:user_database]
      @config        = Hash(cfg.delete(:config)).merge(cfg.key?(:Port) ? { Port: cfg.delete(:Port) } : { Port: 8080 }).merge(cfg)
    end

    # Start server
    def start
      require 'webrick'
      require 'webrick/httpproxy'

      if user_database && File.file?(user_database)
        # Apache compatible Password manager
        htpasswd = WEBrick::HTTPAuth::Htpasswd.new File.expand_path('../../config/htpasswd', __FILE__)

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
