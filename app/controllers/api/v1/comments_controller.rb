module API
  module V1
    class CommentsController < API::V1::BaseController
      before_action :set_comment, except: [:index, :create]
      before_action :find_task, only: [:index, :create]
      #before_action :manually_validate_format, only: [:create, :destroy]
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
        comment = @task.comments.new(resource_params)

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
        end

        def find_task
          @task = Task.find(params[:task_id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def resource_params
          super :content
        end
    end
  end
end
