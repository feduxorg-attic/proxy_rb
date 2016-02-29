module ProxyRb
  module UserPasswords
    class EnvironmentUserPassword
      include Contracts::Core
      include Contracts::Builtin

      protected

      attr_reader :response

      public

      def initialize(response)
        @response = response
      end

      Contract None => String
      def to_s
        response.to_s
      end
    end
  end
end
