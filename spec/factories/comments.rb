FactoryGirl.define do
  factory :comment do
    content { FFaker::Lorem.sentence }
    task

    factory :invalid_comment do
      content nil
    end
  end
end
