# frozen_string_literal: true
require 'json'

# Classes for tests
module Test
  # Proxy Generator
  class ProxyGenerator
    def render(hashes)
      data = hashes.each_with_object({}) { |e, a| a[e[:option].to_sym] = e[:value] }

      config = {}
      config[:headers]       = data[:headers]
      config[:body]          = data.fetch(:body, 'Example Domain')
      config[:status_code]   = data[:status_code]
      config[:config]        = data[:config]
      config[:user_database] = data[:user_database]

      config.delete_if { |k,v| v.nil? }

      <<~EOS
      #!/usr/bin/env ruby

      $LOAD_PATH << '#{File.expand_path('../', __FILE__)}'
      require 'http_proxy'

      config = %(
      #{JSON.dump(config)}
      )

      Test::HttpProxy.new(config).start
      EOS
    end
  end
end
