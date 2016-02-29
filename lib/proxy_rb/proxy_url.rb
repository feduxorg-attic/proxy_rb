require 'addressable/uri'
require 'delegate'

module ProxyRb
  class ProxyUrl < SimpleDelegator
    def self.build(hash)
      new Addressable::URI.new(hash)
    end

    def self.parse(string)
      new Addressable::URI.heuristic_parse(string)
    end

    def without_user_name_and_password
      h = __getobj__.to_hash
      h.delete :user
      h.delete :password

      self.class.build(h)
    end
  end
end
