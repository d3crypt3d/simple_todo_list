module API
  module V1
    class ProjectsController < API::V1::BaseController
      before_action :set_project, only: [:show, :update, :destroy]
      #before_action :manually_validate_format, only: [:create, :update, :destroy]
      respond_to :json

      # GET /projects
      # GET /projects.json
      def index
        respond_with serialize_models(Project.all, include: 'tasks')
      end

      # GET /projects/1
      # GET /projects/1.json
      def show
        respond_with serialize_model(@project)
      end

      # POST /projects
      # POST /projects.json
      def create
        project = Project.new(resource_params)

        if project.save
          # refer to rake routes for location options                 
          respond_with serialize_model(project), location: [:api, project] 
        else
          render json: project.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /projects/1
      # PATCH/PUT /projects/1.json
      def update
        if @project.update(resource_params)
          # without json: property has been set no content will be generated
          respond_with @project, json: serialize_model(@project), location: [:api, @project]
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      # DELETE /projects/1
      # DELETE /projects/1.json
      def destroy
        @project.destroy
        respond_with(:no_content)
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_project
          id = params[:id]
          @project = Project.find(id)
        end
        # Never trust parameters from the scary internet, only allow the white list through.
        def resource_params
          super :name
        end
    end
  end
end
