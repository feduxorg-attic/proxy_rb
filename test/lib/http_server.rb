# frozen_string_literal: true
require 'json'
require_relative 'test_server'

# Classes for tests
module Test
  # HTTP Server
  class HttpServer < TestServer
    def initialize(*args)
      super(*args)

      @config = Hash(
        @cfg.delete(:config)
      ).merge(
        @cfg.key?(:Port) ? {} : { Port: 8000 }
      ).merge(@cfg)
    end

    # Start server
    def start
      require 'webrick'

      if user_database && File.file?(user_database)
        # Apache compatible Password manager
        htpasswd = WEBrick::HTTPAuth::Htpasswd.new user_database

        config[:Realm]  = 'Web Server Realm'
        config[:UserDB] = htpasswd
      end

      server = WEBrick::HTTPServer.new config

      server.mount_proc '/' do |_req, res|
        Array(headers).each { |k, v| res.header[k] = v }

        res.body = body if body
        res.status = status_code if status_code
      end

      server.start
    end
  end
end
