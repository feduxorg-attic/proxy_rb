# frozen_string_literal: true
require 'rspec/expectations'

# Aruba
module ProxyRb
  # Matchers
  module Matchers
    include ::RSpec::Matchers

    module_function :include
  end
end
