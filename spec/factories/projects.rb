FactoryGirl.define do
  factory :project do
    name { FFaker::Lorem.word }

    factory :invalid_project do
      name nil 
    end

    factory :project_with_tasks do
      transient { task_count 2 }

      after(:create) do |project, evaluator|
        create_list(:task, evaluator.task_count, project: project)
      end
    end
  end
end
