# frozen_string_literal: true
require 'json'

# Classes for tests
module Test
  # Proxy Generator
  class ProxyGenerator
    def render(hashes)
      data = hashes.each_with_object({}) { |e, a| a[e[:option].to_sym] = e[:value] }

      config = {}
      config[:body]          = data.delete(:body)
      config[:config]        = data.delete(:config)
      config[:headers]       = data.delete(:headers)
      config[:status_code]   = data.delete(:status_code)
      config[:user_database] = data.delete(:user_database)

      # Merge the rest
      config.merge! data

      # Compact hash
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
