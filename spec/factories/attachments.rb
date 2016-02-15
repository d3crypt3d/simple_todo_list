FactoryGirl.define do
  factory :attachment do
    comment
    filename 'dummy_file'
    mime_type 'image/jpeg'

    # DRY - lets keep our procs
    transient do
      # lambda must be kept inside a block, otherwise it's nested function
      # (create_dummy_file) will return FactoryGirl::Declaration::Implicit
      # object rather than Rack::Test::UploadedFile; 
      # in other words we will use it as FactoryGirl's lazy attribute;
      # lambda's attributes are swapped, bacause we will apply curring 
      add_rack_upload { ->(size,h) { h[:attributes][:data]= create_dummy_file(size) } }
      #add_stored_rack_upload { ->(size,attach) {attach.file_upload= create_dummy_file(size)} }
    end

    # after(:build) hook will be helpful in both strategies: build and create
    factory :attachment_valid_size do
      # no need to create a file with a maximum valid size, because it will 
      # slow our tests; (2^20)/2 - 512Kb would be pretty enough
      after(:build) { |attach| attach.file_upload= create_dummy_file(524288) } 
    end

    factory :attachment_invalid_size do
      after(:build) { |attach| attach.file_upload= create_dummy_file(5242881) } # 5*2^20+1
    end

    # these factories are used to add data: key's value (Rack::Test::UploadedFile instance)
    # for JSON API object, it's a tricky task - common way will result in 
    # TypeError Exception: wrong argument type (expected String)
    # that's why we will use the custom callback (seems it's the only solution)
    # these factories are intended to use with attributes_for and json_api
    # (it's extended variant) strategies only
    factory :attachment_upload_valid do
      callback(:attachment_file) do |attach, evaluator|
        attach.tap(&evaluator.add_rack_upload.curry[524288])
      end
    end

    factory :attachment_upload_invalid do
      callback(:attachment_file) do |attach, evaluator|
        attach.tap(&evaluator.add_rack_upload.curry[5242881])
      end
    end
  end
end
