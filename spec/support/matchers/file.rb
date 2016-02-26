RSpec::Matchers.define :be_existing_file do |_|
  match { |actual| File.file?(actual) }

  failure_message do |actual|
    format('expected that file "%s" exists', actual)
  end

  failure_message_when_negated do |actual|
    format('expected that file "%s" does not exist', actual)
  end
end

RSpec::Matchers.define :have_content do |expected|
  match { |actual| File.read(actual).chomp == expected.chomp }

  failure_message do |actual|
    format("expected that file \"%s\" contains:\n%s", actual, expected)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" does not contain:\n%s", actual, expected)
  end
end
