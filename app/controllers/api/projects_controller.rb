module API
    class ProjectsController < ApplicationController
      before_action :set_project, only: [:show, :edit, :update, :destroy]

      # GET /projects
      # GET /projects.json
      def index
        #render json: Project.where(archived: false), status: 200
        render json: Project.all, status: 200
      end

      # GET /projects/1
      # GET /projects/1.json
      def show
          render json: Project.find(params[:id]), status: 200
      end

      # GET /projects/new
      def new
        @project = Project.new
      end

      # GET /projects/1/edit
      def edit
      end

      # POST /projects
      # POST /projects.json
      def create
          project = Project.new(project_params)

          if project.save
            render json: project, status: :created, location: [:api, project]
          else
            render json: project.errors, status: :unprocessable_entity
          end

      end

      # PATCH/PUT /projects/1
      # PATCH/PUT /projects/1.json
      def update
          if @project.update(project_params)
            render json: @project, status: :ok, location: [:api, @project] 
          else
            render json: @project.errors, status: :unprocessable_entity
          end
      end

      # DELETE /projects/1
      # DELETE /projects/1.json
      def destroy
            #@project.find_unarchived(params[:id])
            #@project.archive
            @project.delete
            head :no_content
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_project
          @project = Project.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def project_params
          params.require(:project).permit(:name)
        end
    end
end
