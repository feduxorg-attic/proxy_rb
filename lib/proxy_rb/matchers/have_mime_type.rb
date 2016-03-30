# frozen_string_literal: true
RSpec::Matchers.define :have_mime_type do |expected|
  match do |actual|
    @actual = actual.mime_type
    values_match?(expected, @actual)
  end

  failure_message do |actual|
    msg = []

    msg << %(expected that response of "#{resource}" has mime type "#{expected}", but has "#{actual}".)

    if proxy.nil? || proxy.empty?
      msg << %(No proxy was used.)
    else
      msg << %(It was fetched via proxy "#{proxy.to_s}".)
    end

    msg.join ' '
  end

  failure_message_when_negated do
    msg = []

    msg << %(expected that response of "#{resource}" does not have mime type "#{expected}".)

    if proxy.nil? || proxy.empty?
      msg << %(No proxy was used.)
    else
      msg << %(It was fetched via proxy "#{proxy.to_s}".)
    end

    msg.join ' '
  end
end

RSpec::Matchers.alias_matcher :be_of_mime_type, :have_mime_type
