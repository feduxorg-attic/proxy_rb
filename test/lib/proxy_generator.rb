# frozen_string_literal: true
require 'json'

# Classes for tests
module Test
  # Proxy Generator
  class ProxyGenerator
    def render(hashes)
      data = hashes.each_with_object({}) { |e, a| a[e[:option].to_sym] = e[:value] }

      config = {}
      config[:body]                   = data.delete(:body)
      config[:config]                 = data.key?(:config) ? JSON.parse(data.delete(:config).to_s) : nil
      config[:headers]                = data.key?(:headers) ? JSON.parse(data.delete(:headers).to_s) : nil
      config[:status_code]            = data.delete(:status_code)
      config[:user_database]          = data.delete(:user_database)
      config[:expected_response_body] = data.delete(:expected_response_body)

      # Merge the rest
      config.merge! data

      # Compact hash
      config.delete_if { |_k, v| v.nil? }

      <<~EOS
      #!/usr/bin/env ruby

      $LOAD_PATH << '#{File.expand_path('../', __FILE__)}'
      require 'http_proxy'

      config = %#
      #{JSON.generate(config)}
      #

      Test::HttpProxy.new(config).start
      EOS
    end
  end
end
