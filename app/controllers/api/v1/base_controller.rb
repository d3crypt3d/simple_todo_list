class API::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  # APIs on HTTP are stateless, sessions are exactly the
  # opposite of that, hence we must disable the CSRF
  # token and cookies
  protect_from_forgery with: :null_session
  before_action :authenticate_api_user!

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

  # Convenience methods for serializing models:
  def serialize_model(model, options = {})
    options[:is_collection] = false
    JSONAPI::Serializer.serialize(model, options)
  end
  
  def serialize_models(models, options = {})
    options[:is_collection] = true
    JSONAPI::Serializer.serialize(models, options)
  end

  private
  def destroy_session
    request.session_options[:skip] = true
  end

  # DRY - move the construction into superclass, because 
  # attributes are the only things that varies
  def resource_params(*attributes)
    params.require(:data).permit(:type, :id, {attributes: attributes}).fetch(:attributes)
  end
end
