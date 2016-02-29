# ProxyRb
module ProxyRb
  # User passwords
  module UserPasswords
    # Be a password from environment
    class EnvironmentUserPassword
      include Contracts::Core
      include Contracts::Builtin

      protected

      attr_reader :response

      public

      def initialize(response)
        @response = response
      end

      # Return password
      #
      # @return [String]
      Contract None => String
      def to_s
        response.to_s
      end
    end
  end
end
