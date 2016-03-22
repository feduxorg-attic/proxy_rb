module ProxyRb
  module Api
    module Formatters
      def simple_table(hash)
        SimpleTable.new(hash).to_s
      end
    end
  end
end
