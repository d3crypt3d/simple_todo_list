class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActionController::UnknownFormat, with: :unacceptable

  def unacceptable
    render json: {errors: "Unsupported format is requested"}, status: :not_acceptable 
  end
  # Using respond_to in pair with respond_with has a caveat:
  # since some of the operations (create/update/delete) are 
  # performed prior the respond_with method, one having requested
  # the wrong format, still can delete/update/create the reource
  # (though, recieve 406 error message). Following workaround 
  # uses ActionController::Responder private methods - ones 
  # that work under the hood and are available at controller level 
  def manually_validate_format
    retrieve_collector_from_mimes
  end
end
