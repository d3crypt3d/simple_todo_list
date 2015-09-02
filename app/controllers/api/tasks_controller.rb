module API
    class TasksController < ApplicationController
      before_action :set_task, except: [:index, :create]
      before_action :find_project, only: [:index, :create]
      respond_to :json

      # GET /tasks
      # GET /tasks.json
      def index
        respond_with @project.tasks
      end

      # GET /tasks/1
      # GET /tasks/1.json
      def show
        respond_with @task
      end

      # POST /tasks
      # POST /tasks.json
      def create
        task = @project.tasks.new(task_params)

        if task.save
            respond_with task, location: [:api, task]                 
        else
            render json: task.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /tasks/1
      # PATCH/PUT /tasks/1.json
      def update
          if @task.update(task_params)
            # without json: property has been set no content will be generated
            respond_with @task, json: @task, location: [:api, @task] 
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

          rescue ActiveRecord::RecordNotFound
                render json: {errors: "Couldn't find the Task with id=#{id}"},
                              status: :not_found

        end

        def find_project
            @project = Project.find(params[:project_id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def task_params
          params.require(:task).permit(:id, :content, :priority, :deadline, :isdone)
        end
    end
end
