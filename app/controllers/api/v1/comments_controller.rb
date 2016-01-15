module API
  module V1
    class CommentsController < ApplicationController
      before_action :set_comment, except: [:index, :create]
      before_action :find_task, only: [:index, :create]
      # following hook will prevent an action from been called if having been moved
      # to application.rb (why?); hence assigns(:symbol) will throw an error when 
      # wrong content is requested, because correspnding instance variable will not be set
      before_action :manually_validate_format, only: [:create, :destroy]
      respond_to :json

      # GET /comments
      # GET /comments.json
      def index
        respond_with serialize_models(@task.comments)
      end

      # GET /comments/new
      def show
        respond_with serialize_model(@comment)
      end

      # POST /comments
      # POST /comments.json
      def create
        comment = @task.comments.new(comment_params)

        if comment.save
          respond_with serialize_model(comment), location: [:api, comment] 
        else
          render json: comment.errors, status: :unprocessable_entity 
        end
      end

      # DELETE /comments/1
      # DELETE /comments/1.json
      def destroy
        @comment.destroy
        respond_with(:no_content)
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_comment
          id = params[:id]  
          @comment = Comment.find(id)
        
          rescue ActiveRecord::RecordNotFound
                render json: {errors: "Couldn't find the Comment with id=#{id}"},
                              status: :not_found
        end

        def find_task
          @task = Task.find(params[:task_id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def comment_params
          params.require(:data).permit(:type, :id, {attributes: :content}).fetch(:attributes)
        end
    end
  end
end
