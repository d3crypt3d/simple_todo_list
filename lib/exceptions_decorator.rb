# We will override the behaviour of the original method a bit.
# Actually what needs to be done - is adding/replcaing keys:
# "title" and "detail" instead of "error". Unfortunately
# we can't process the json object after the superclass method
# has performed (with super), because the object turnes into
# the string.
class ExceptionsDecorator < ActionDispatch::PublicExceptions
  def call(env)
    controller_known_mimes = env['action_controller.instance'].mimes_for_respond_to if env['action_controller.instance']
    exception_instance     = env['action_dispatch.exception']

    request      = ActionDispatch::Request.new(env)
    content_type = begin
                     request.formats.first
                   rescue ActionController::BadRequest
                     Mime::HTML
                   end
    status       = env["PATH_INFO"][1..-1]
    # According to JSON API spec, title - a short, human-readable
    # summary of the problem that SHOULD NOT change from occurrence
    # to occurrence of the problem, except for purposes of localization.
    body         = {status: status,  title: Rack::Utils::HTTP_STATUS_CODES.fetch(status.to_i, Rack::Utils::HTTP_STATUS_CODES[500])}
    
    body["detail"] = case exception_instance
                      # When unknown format exception is raised
                      # we still need to turn the object format
                      # into the one, 'known' by the controller
                      # (not JSON only)
                       when ActionController::UnknownFormat
                         content_type = controller_known_mimes.keys.first
                         # Unfortunately, error object of this
                         # type doesn't containt any description
                         'unsupported format is requested'
                       else
                         exception_instance.to_s
                     end

    render(status, content_type, body)
  end
end
