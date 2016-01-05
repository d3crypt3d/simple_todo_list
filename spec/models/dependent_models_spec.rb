require 'rails_helper'

describe "nested models test" do
  # Since building an attachment is expensive operation
  # we will use before :all hook - to create resources
  # once for all transactions
  before :all do
    @attachment = FactoryGirl.build(:attachment)
    @comment = @attachment.comment
    @task = @comment.task
    @project = @task.project
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

  # And delete them after all transactions
  after :all do
    Project.destroy_all
  end
end
