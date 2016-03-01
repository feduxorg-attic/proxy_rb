# frozen_string_literal: true
# Proxy Generator
class ProxyGenerator
  # Authentication Proxy
  class AuthenticationProxyGenerator
    def match?(m)
      m == :authentication
    end

    def render(table)
      config_db = table.hashes.each_with_object(
        Port: 8080
      ) do |e, a|
        a[e[:option].to_sym] = e[:value]
      end

      users = Array(config_db.delete(:users)).map do |k, v|
        format("htpasswd.set_passwd 'Proxy Realm', %s, %s", k, v)
      end.join("\n")

      config = (config_db.map { |k, v| format('%s: %s', k, v) } + ['ProxyAuthProc: authenticator.method(:authenticate).to_proc']).join(', ')

      <<~EOS
      #!/usr/bin/env ruby

      require 'webrick'
      require 'webrick/httpproxy'

      # Apache compatible Password manager
      htpasswd = WEBrick::HTTPAuth::Htpasswd.new File.expand_path('../../config/htpasswd', __FILE__)
      # Create entry with username and password, the password is "crypt" encrypted
      #{users}
      # Write file to disk
      htpasswd.flush

      # Authenticator
      authenticator = WEBrick::HTTPAuth::ProxyBasicAuth.new(
        Realm: 'Proxy Realm',
        UserDB: htpasswd
      )

      proxy = WEBrick::HTTPProxyServer.new #{config}

      trap('INT') { proxy.shutdown }
      trap('TERM') { proxy.shutdown }

      proxy.start
      EOS
    end
  end

  # Simple Proxy
  class SimpleProxyGenerator
    def match?(m)
      m == :simple
    end

    def render(table)
      config_db = table.hashes.each_with_object(
        Port: 8080
      ) do |e, a|
        a[e[:option]] = e[:value]
      end

      config = config_db.map { |k, v| format('%s: %s', k, v) }.join(', ')

      <<~EOS
      #!/usr/bin/env ruby

      require 'webrick'
      require 'webrick/httpproxy'

      proxy = WEBrick::HTTPProxyServer.new #{config}

      trap('INT') { proxy.shutdown }
      trap('TERM') { proxy.shutdown }

      proxy.start
      EOS
    end
  end
end

class ProxyGenerator
  protected

  attr_reader :type

  public

  def initialize(type:)
    @generators = []
    @generators << AuthenticationProxyGenerator.new
    @generators << SimpleProxyGenerator.new

    @type = type
  end

  def render(table)
    @generators.find { |g| g.match? type }.render(table)
  end
end
