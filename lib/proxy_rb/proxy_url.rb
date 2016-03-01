# frozen_string_literal: true
require 'addressable/uri'

# ProxyRb
module ProxyRb
  # A ProxyURL
  class ProxyUrl
    #  Build a URL from hash
    #
    #  @param [Hash] hash
    #    An Hash representing the url parts
    #
    # @return [ProxyUrl]
    #   The built url
    def self.build(hash)
      new(Addressable::URI.new(hash))
    end

    # Create URL from string
    #
    # @param [String] string
    #   The url
    #
    # @return [ProxyUrl]
    #   The parsed url
    def self.parse(string)
      string = string.to_s
      string = if string.empty?
                 string
               elsif string.start_with?('http://') 
                 string
               else
                 'http://' + string
               end

      new(Addressable::URI.heuristic_parse(string))
    end

    protected

    attr_reader :url

    public

    def initialize(url)
      @url = url
    end

    %i(host user password port).each do |m|
      define_method m do
        return nil if empty?

        url.public_send m
      end
    end

    def to_s
      return "" if empty?

      url.to_s
    end

    # Check if url is empty
    def empty?
      url.nil? || url.empty?
    end

    # Return URL without user name and password
    #
    # @return [ProxyUrl]
    #   The cleaned url
    def without_user_name_and_password
      return self.class.new(nil) if empty?

      h = url.to_hash
      h.delete :user
      h.delete :password

      self.class.build(h)
    end
  end
end
