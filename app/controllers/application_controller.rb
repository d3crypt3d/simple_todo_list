class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
  # DRY - move the construction into superclass, because attributes
  # is the only thing that varies
  def resource_params(*attributes)
    params.require(:data).permit(:type, :id, {attributes: attributes}).fetch(:attributes)
  end
end
