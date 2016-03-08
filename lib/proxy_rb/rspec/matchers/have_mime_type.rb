# frozen_string_literal: true
RSpec::Matchers.define :have_mime_type do |expected|
  match do |actual|
    @actual = actual.mime_type
    values_match?(expected, @actual)
  end
end

RSpec::Matchers.alias_matcher :be_of_mime_type, :have_mime_type
