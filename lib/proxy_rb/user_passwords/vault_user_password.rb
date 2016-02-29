module ProxyRb
  module UserPasswords
    class VaultUserPassword
      include Contracts::Core
      include Contracts::Builtin

      protected

      attr_reader :response

      public

      def initialize(response)
        @response = response.data
      end


      Contract None => String
      def to_s
        response[:password].to_s
      end
    end
  end
end
