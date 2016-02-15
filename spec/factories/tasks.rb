FactoryGirl.define do
  factory :task do
    content { FFaker::Lorem.sentence }
    sequence(:priority) { |n| n } # no need to generate random numbers
    deadline { FFaker::Time.date }
    isdone { FFaker::Boolean.maybe } 
    project

    factory :invalid_task do
      content nil 
    end

    factory :task_with_comments do
      transient { comment_count 2 }
      
      after(:create) do |task, evaluator|
        create_list(:comment, evaluator.comment_count, task: task)
      end
    end
  end 
end
