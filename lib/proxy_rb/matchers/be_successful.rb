# frozen_string_literal: true
RSpec::Matchers.define :be_successful do
  match do |actual|
    next true if proxy_rb.config.strict == false && (actual.status_code.nil? || actual.status_code == 0)
    sleep 0.5 # handle network latency

    actual.status_code.to_s.start_with?('2', '3')
  end

  failure_message do |actual|
    msg = []

    msg << %(expected that response of "#{resource}" has status code 2xx, but has #{actual.status_code}.)

    msg << if proxy.nil? || proxy.empty?
             %(No proxy was used.)
           else
             %(It was fetched via proxy "#{proxy}".)
           end

    msg.join ' '
  end

  failure_message_when_negated do
    msg = []

    msg << %(expected that response of "#{resource}" does not have status code 2xx.)

    msg << if proxy.nil? || proxy.empty?
             %(No proxy was used.)
           else
             %(It was fetched via proxy "#{proxy}".)
           end

    msg.join ' '
  end
end
