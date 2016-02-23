FactoryGirl.define do
  factory :user do
    name { FFaker::Name.name }
    nickname { FFaker::Name.suffix }
    email { FFaker::Internet.email }

    factory :email_user do
      provider 'email'
      password 'secret123'
      password_confirmation 'secret123'
    end

    # To be used with the sreategy
    # attributes_for only
    trait :success_url do
      confirm_success_url FFaker::Internet.http_url
    end

    trait :invalid_password do
      password_confirmation 'bogus'
    end

    trait :confirmed_email do
      confirmed_at 1.weeks.ago.strftime('%F %T')
      created_at { confirmed_at }
      updated_at { confirmed_at }
    end

    trait :password_reset_token do
      reset_password_token 'foo_bar_baz'
    end
  end

  # To be used with the sreategy
  # attributes_for only
  factory :passwords, class: User do
    password 'secret124'    # New password

    factory :passwords_with_current do
      current_password 'secret123'
    end

    trait :current_invalid do
      current_password 'bogus'
    end

    trait :valid_confirm do
      password_confirmation 'secret124'
    end

    trait :invalid_confirm do
      password_confirmation 'secret125'
    end
  end
end
