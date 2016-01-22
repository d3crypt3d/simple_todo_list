module API
  module V1
    class TasksController < API::V1::BaseController
      before_action :set_task, except: [:index, :create]
      before_action :find_project, only: [:index, :create]
      # following hook will prevent an action from been called if having been moved
      # to application.rb (why?); hence assigns(:symbol) will throw an error when 
      # wrong content is requested, because correspnding instance variable will not be set
      before_action :manually_validate_format, only: [:create, :update, :destroy]
      respond_to :json

      # GET /tasks
      # GET /tasks.json
      def index
        respond_with serialize_models(@project.tasks)
      end

      # GET /tasks/1
      # GET /tasks/1.json
      def show
        respond_with serialize_model(@task)
      end

      # POST /tasks
      # POST /tasks.json
      def create
        task = @project.tasks.new(resource_params)

        if task.save
          respond_with serialize_model(task), location: [:api, task]                 
        else
          render json: task.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /tasks/1
      # PATCH/PUT /tasks/1.json
      def update
        if @task.update(resource_params)
          # without json: property has been set no content will be generated
          respond_with @task, json: serialize_model(@task), location: [:api, @task] 
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # DELETE /tasks/1
      # DELETE /tasks/1.json
      def destroy
        @task.destroy
        respond_with(:no_content)
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_task
          id = params[:id] 
          @task = Task.find(id)
        end

        def find_project
          @project = Project.find(params[:project_id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def resource_params
          super :content, :priority, :deadline, :isdone
        end
    end
  end
end
