FactoryGirl.define do
    factory :project do
        name "Test project"
    end

    factory :task do
        content "test content"
        priority 1
        deadline Time.now + 1.hour
        isdone true
        project
    end 

    factory :comment do
        content "test comment"
        task
    end

    factory :attachment do
        comment
    end
end
