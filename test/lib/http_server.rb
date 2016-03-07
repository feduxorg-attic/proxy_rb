# frozen_string_literal: true
require 'json'

# Classes for tests
module Test
  # HTTP Server
  class HttpServer
    attr_reader :headers, :body, :status_code, :user_database, :config

    def initialize(c)
      cfg = JSON.parse(c).to_hash.each_with_object({}) { |(k,v),a| a[k.to_sym] = v }

      @headers       = cfg.delete(:headers)
      @body          = cfg.delete(:body)
      @status_code   = cfg.delete(:status_code)
      @user_database = cfg.delete(:user_database)
      @config        = Hash(cfg.delete(:config)).merge(cfg.key?(:Port) ? { Port: cfg.delete(:Port) } : { Port: 8000 }).merge(cfg)
    end

    # Start server
    def start
      require 'webrick'

      if user_database && File.file?(user_database)
        # Apache compatible Password manager
        htpasswd = WEBrick::HTTPAuth::Htpasswd.new File.expand_path('../../config/htpasswd', __FILE__)

        config[:Realm]  = 'Web Server Realm'
        config[:UserDB] = htpasswd
      end

      server = WEBrick::HTTPServer.new config

      server.mount_proc '/' do |req, res|
        Array(headers).each { |k,v| res.headers[k] = v }

        res.body = body if body
        res.status = status_code if status_code
      end

      server.start
    end
  end
end
