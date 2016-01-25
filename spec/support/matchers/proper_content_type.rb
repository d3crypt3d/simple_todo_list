require 'rspec/expectations'

RSpec::Matchers.define :have_content_type do |expected|
  unless expected.kind_of? Symbol
    raise "argument #{expected} is actually a #{expected.class}, not a symbol"
  end
  
  match do |actual|
    @expected_content = Mime::Type.lookup_by_extension(expected)
    raise "mime type #{expected} is not registered" unless @expected_content
    @actual_content = actual.content_type 
    @actual_content == @expected_content
  end

  failure_message do 
    "expected that #{@actual_content} would be #{@expected_content}"
  end

  failure_message_when_negated do
    "expected that #{@actual_content} would not be #{@expected_content}"
  end
end 
