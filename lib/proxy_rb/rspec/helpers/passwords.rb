require 'contracts'

module ProxyRb
  module Rspec
    module Helpers
      module Passwords
        include Contracts::Core
        include Contracts::Builtin

        Contract Or[String, Symbol] => Maybe[String]
        def password(user_name)
          ProxyRb.config.password_fetcher.call(user_name.to_s)
        end
      end
    end
  end
end
