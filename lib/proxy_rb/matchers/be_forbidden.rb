# frozen_string_literal: true
RSpec::Matchers.define :be_forbidden do
  match do |actual|
    values_match?(403, actual.status_code)
  end

  failure_message do |actual|
    %(expected that response has status code 403, but has #{actual.status_code})
  end

  failure_message_when_negated do
    %(expected that response does not have status code 403)
  end
end
