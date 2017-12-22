module RequestParser

  def verb(request_lines)
    request_lines[0].split[0]
  end

  def path(request_lines)
    request_lines[0].split[1]
  end

  def protocol(request_lines)
    request_lines[0].split[2]
  end

  def host(request_lines)
    request_lines.find do |line|
      line.include?("Host")
    end.split(":")[1].lstrip
  end

  def port(request_lines)
    request_lines.find do |line|
      line.include?("Host")
    end.split(":")[2]
  end

  def accept(request_lines)
    request_lines.find do |i|
      i.include?("Accept")
    end.split(":")[1].lstrip
  end

  def value(path_line)
      path_line.split("=")[1]
  end

  def diagnostics(request_lines)
    "<pre>" + "\r\n" +
   ["Verb: #{verb(request_lines)}",
    "Path: #{path(request_lines)}",
    "Protocol: #{protocol(request_lines)}",
    "Host: #{host(request_lines)}",
    "Port: #{port(request_lines)}",
    "Origin: #{host(request_lines)}",
    "Accept:#{accept(request_lines)}"].join("\n") + "</pre>"
  end

  def get_content_length(request_lines)
    body = request_lines.find do |line|
      line.include?("Content-Length")
    end
      body.split(":")[1].to_i unless body.nil?
  end

  def get_guess(request_lines, client)
    content_length = get_content_length(request_lines)
    body = client.read(content_length) unless content_length.nil?
    body.split("\r\n")[-2]
  end

end
