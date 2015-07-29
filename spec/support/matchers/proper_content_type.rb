require 'rspec/expectations'

RSpec::Matchers.define :have_content_type do |expected|
    if !expected.kind_of? Mime::Type
        raise "argument #{expected} is actually a #{expected.class}, not an instance of Mime::Type"
    end

    match do |actual|
        @content = actual.content_type 
        @content == expected
    end

    failure_message do |actual|
        "expected that #{@content} would be #{expected}"
    end

    failure_message_when_negated do |actual|
        "expected that #{@content} would not be #{expected}"
    end
end 
