FactoryGirl.define do  factory :fake do
    
  end

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

    factory :comment do
        content { FFaker::Lorem.sentence }
        task

        factory :invalid_comment do
            content nil
        end
    end

    factory :attachment do
        comment
        # after(:build) hook will be helpful in both strategies: build and create
        factory :attachment_valid_size do
            # no need to create a file with a maximum valid size, as it will slow our
            # tests; (2^20)/2 - 512Kb would be pretty enough
            after(:build) { |attach| attach.file_upload= create_dummy_file(524288) } 
        end
        factory :attachment_invalid_size do
            after(:build) { |attach| attach.file_upload= create_dummy_file(5242881) } # 5*2^20+1
        end
    end
end
