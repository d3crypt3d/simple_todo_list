module API
    class ProjectsController < ApplicationController
      before_action :set_project, only: [:show, :update, :destroy]
      before_action :manually_validate_format, only: [:create, :update, :destroy]
      respond_to :json

      # GET /projects
      # GET /projects.json
      def index
        respond_with Project.all
      end

      # GET /projects/1
      # GET /projects/1.json
      def show
          respond_with @project
      end

      # POST /projects
      # POST /projects.json
      def create
          project = Project.new(project_params)

          if project.save
            # in this case json object can be returned without setting json: property, strange
            respond_with project, location: [:api, project]                 
          else
            render json: project.errors, status: :unprocessable_entity
          end
      end

      # PATCH/PUT /projects/1
      # PATCH/PUT /projects/1.json
      def update
          if @project.update(project_params)
            # without json: property has been set no content will be generated
            respond_with @project, json: @project, location: [:api, @project] 
          else
            render json: @project.errors, status: :unprocessable_entity
          end
      end

      # DELETE /projects/1
      # DELETE /projects/1.json
      def destroy
            @project.delete
            respond_with(:no_content)
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_project
            id = params[:id]
            @project = Project.find(id)

            rescue ActiveRecord::RecordNotFound
                render json: {errors: "Couldn't find the Project with id=#{id}"},
                              status: :not_found
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def project_params
            params.require(:project).permit(:name,:id)
        end
    end
end
