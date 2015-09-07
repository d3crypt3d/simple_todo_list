if defined? FactoryGirl
    require "#{Rails.root}/spec/support/factory_helpers.rb"
    FactoryGirl::SyntaxRunner.send(:include, FactoryHelpers)
end
