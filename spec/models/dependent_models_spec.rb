require 'rails_helper'

describe "nested models test" do
    
    before :all do
        @attachment = FactoryGirl.build(:attachment)
        @comment = @attachment.comment
        @task = @comment.task
        @project = @task.project
        #@task = FactoryGirl.build(:task)
    end

    it "should create parent model" do
        expect(Comment.all).to include @comment
        expect(Task.all).to include @task
        expect(Project.all).to include @project
    end

    it "should destroy dependent model" do        
        @project.destroy
        expect(Task.all).not_to include @task
        expect(Comment.all).not_to include @comment
        expect(Attachment.all).not_to include @attachment
    end

end
