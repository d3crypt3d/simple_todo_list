FactoryGirl.define do
    factory :project do
        name { FFaker::Lorem.word }

        factory :invalid_project do
            name nil
        end
    end

    factory :task do
        content { FFaker::Lorem.sentence }
        priority { FFaker::Number.between(1, 10) } 
        deadline { FFaker::Time.forward(7, :all) }
        isdone { FFaker::Number.between(0, 1) == 1 } #type coercion is different: 0 is not false
        project
    end 

    factory :comment do
        content { FFaker::Lorem.sentence }
        task
    end

    factory :attachment do
        comment
    end
end
