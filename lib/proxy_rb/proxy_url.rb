# frozen_string_literal: true
require 'addressable/uri'
require 'delegate'

# ProxyRb
module ProxyRb
  # A ProxyURL
  class ProxyUrl < SimpleDelegator
    #  Build a URL from hash
    #
    #  @param [Hash] hash
    #    An Hash representing the url parts
    #
    # @return [ProxyUrl]
    #   The built url
    def self.build(hash)
      new Addressable::URI.new(hash)
    end

    # Create URL from string
    #
    # @param [String] string
    #   The url
    #
    # @return [ProxyUrl]
    #   The parsed url
    def self.parse(string)
      new Addressable::URI.heuristic_parse(string)
    end

    # Return URL without user name and password
    #
    # @return [ProxyUrl]
    #   The cleaned url
    def without_user_name_and_password
      h = __getobj__.to_hash
      h.delete :user
      h.delete :password

      self.class.build(h)
    end
  end
end
