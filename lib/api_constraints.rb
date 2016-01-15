class ApiConstraints
  def initialize(version, default: true)
    @version, @default = version, default
  end

  def matches?(req)
    @default || check_header(req.headers)
  end

  private
  def check_headers(headers)
    accept = headers['Accept']
    accept && accept.include?("application/vnd.api.#{@version}+json")
  end
end
