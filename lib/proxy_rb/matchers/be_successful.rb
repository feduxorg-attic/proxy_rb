# frozen_string_literal: true
RSpec::Matchers.define :be_successful do
  match do |actual|
    next true if proxy_rb.config.strict == false && (actual.status_code.nil? || actual.status_code == 0)

    sleep 0.5
    actual.status_code.to_s.start_with?('2', '3')
  end

  failure_message do |actual|
    %(expected that response has status code 2xx, but has #{actual.status_code})
  end

  failure_message_when_negated do
    %(expected that response does not have status code 2xx)
  end
end
