require 'rails_helper'

describe "nested models test" do
    
    before do
        @task = FactoryGirl.build(:task)
    end

    it "should create parent model" do
        expect(Project.all).to include @task.project
    end

    it "should destroy dependent model" do        
        @task.project.destroy
        expect(Task.all).not_to include @task
    end

end
