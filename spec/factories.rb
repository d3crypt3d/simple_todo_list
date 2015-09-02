FactoryGirl.define do
    factory :project do
        name { FFaker::Lorem.word }

        factory :invalid_project do
            name nil
        end

        factory :project_with_tasks do
            transient do
                task_count 2
            end

            after(:create) do |project, evaluator|
                create_list(:task, evaluator.task_count, project: project)
            end
        end
    end

    factory :task do
        content { FFaker::Lorem.sentence }
        sequence(:priority) { |n| n } # no need to generate random numbers
        deadline { FFaker::Time.date }
        isdone { FFaker::Boolean.maybe } 
        project

        factory :invalid_task do
            content nil
        end
    end 

    factory :comment do
        content { FFaker::Lorem.sentence }
        task
    end

    factory :attachment do
        comment
    end
end
