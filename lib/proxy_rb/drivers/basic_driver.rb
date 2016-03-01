module ProxyRb
  module Drivers
    class BasicDriver
      def register(_proxy)
        fail NoMethodError, 'You need to implement this in your driver'
      end
    end
  end
end
