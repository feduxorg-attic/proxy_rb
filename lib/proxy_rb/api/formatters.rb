# frozen_string_literal: true
# ProxyRb
module ProxyRb
  # Api
  module Api
    # Formatters for output
    module Formatters
      # Convert Hash to simple table
      #
      # @param [Hash] hash
      #   the hash which should be converted
      #
      # @return [String]
      #   The generated table
      def simple_table(hash)
        SimpleTable.new(hash).to_s
      end
    end
  end
end
