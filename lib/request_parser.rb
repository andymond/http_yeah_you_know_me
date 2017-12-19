class RequestParser

  attr_reader :request_lines

  def initialize(request_lines)
    @request_lines = request_lines
  end

end
