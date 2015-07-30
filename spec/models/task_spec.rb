require 'rails_helper'

describe Task do
  
  before do
      @task = FactoryGirl.build(:task)
  end

  subject { @task }

  it { should be_valid }                # valid with valid attributes
  it { should respond_to(:content) }
  it { should respond_to(:priority) }
  it { should respond_to(:deadline) }
  it { should respond_to(:isdone) }
  it { should respond_to(:project_id) }
    
  context "when content is not present" do
      before { @task.content = " " }
      it { should_not be_valid }
  end

  context "when priority is not present" do
      before { @task.priority = nil }
      it { should_not be_valid }
  end

  context "when priority is not numerical" do
      before { @task.priority = 'not integer' }
      it { should_not be_valid }
  end

  context "when priority is eq to 0" do
      before { @task.priority = 0 }
      it { should_not be_valid }
  end

  context "when priority is less than 0" do
      before { @task.priority = -1 }
      it { should_not be_valid }
  end

  context "when a task with the same priority 
                is already exist inside this project" do
      before { @task.save }             #since we used Factory's build method
      subject { @task.dup }
      it { should_not be_valid }
  end

  context "when a task with the same priority 
                    exists inside another project" do
       before do
           @task.project_id += 1
           @task.save
       end 

       it { should be_valid }
  end

  context "when deadline is not present" do
      before { @task.deadline = nil }
      it { should_not be_valid }
  end

  context "when project_id is not present" do
      before { @task.project_id = nil }
      it { should_not be_valid }
  end
  #pending "add some examples to (or delete) #{__FILE__}"
end
