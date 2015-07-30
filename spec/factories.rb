FactoryGirl.define do
    factory :project do
        name Faker::Lorem.word
    end

    factory :task do
        content Faker::Lorem.sentence
        priority Faker::Number.between(1, 10) 
        deadline Faker::Time.forward(7, :all)
        isdone Faker::Number.between(0, 1) == 1  #type coercion is different 0 is not false
        project
    end 

    factory :comment do
        content Faker::Lorem.sentence
        task
    end

    factory :attachment do
        comment
    end
end
