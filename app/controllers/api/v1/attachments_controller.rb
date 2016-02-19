module API
  module V1
    class AttachmentsController < API::V1::BaseController
      before_action :set_attachment, except: [:index, :create]
      before_action :find_comment, only: [:index, :create]
      #before_action :manually_validate_format, except: :index
      respond_to :json

      # GET /attachments
      # GET /attachments.json
      def index
        respond_with serialize_models(@comment.attachments)
      end

      # GET /attachments/1
      # GET /attachments/1.json
      def show
        # Bug in Rails 4.1 - can't properly load  binary data while 
        # pg 0.18 is been used, using base64 encding/decoding as a workaround
        send_data(Base64.decode64(@attachment.data),
                  type: @attachment.mime_type,
                  filename: @attachment.filename)
      end

      # POST /attachments
      # POST /attachments.json
      def create
        # Since 4.1 Rails doesn't properly process ActionDispatch::Http::UploadedFile
        # object it's better to do this manually: create the model instance and
        # define the custom method
        attachment = Attachment.new
        attachment.file_upload=(resource_params.delete(:data))
        # custom validation will also rise native validations  
        if attachment.save(context: :file_upload=)
          respond_with :created, location: [:api, attachment] 
        else
          render json: attachment.errors, status: :unprocessable_entity 
        end
      end

      # DELETE /attachments/1
      # DELETE /attachments/1.json
      def destroy
        @attachment.destroy
        respond_with(:no_content)
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_attachment
          id = params[:id]  
          @attachment = Attachment.find(id)
        end

        def find_comment
          @comment = Comment.find(params[:comment_id])
        end
        # Never trust parameters from the scary internet, only allow the white list through.
        def resource_params
          super :data
        end
    end
  end
end
