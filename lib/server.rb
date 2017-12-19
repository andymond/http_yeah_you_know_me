require 'socket'
require_relative 'word_finder'
require 'pry'

class Server

  def initialize
    @tcp_server = TCPServer.open(9292)
    @count = 0
    @hello_count = 0
  end

  def start
    @count += 1
    puts "Ready for a request"
    client = @tcp_server.accept
    request = request(client)
    response_control = response_control(request, client)
    response(response_control, client)
    start
  end

  def request(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    puts "Got this request:"
    puts request_lines.inspect
    request_lines
  end

  def response_control(request_lines, client)
    puts "Sending response."
    path = path(request_lines)
    verb = verb(request_lines)
    case
      when path == "/"
        response = diagnostics(request_lines)
      when path == "/hello"
        response = hello + diagnostics(request_lines)
      when path == "/datetime"
        response = datetime + diagnostics(request_lines)
      when path.include?("/word_search")
        response = word_search(value(path))
      when path == "/start_game" && verb == "POST"
        response = "Good luck!" #game init
      when path == "/game" && verb == "GET"
        response = "how many guesses + if so, 2 hi or 2 lo"
      when path == "/game" && verb == "POST"
        response == "sends guess & redirects to gets + /game"
      when path == "/shutdown"
        response = output("Total count:(#{@count})") + diagnostics(request_lines)
        response(response, client)
        client.close
    end
    response
  end

  def response(response, client)
    output = output(response)
    headers = headers(output)
    client.puts headers
    client.puts output
    puts ["Wrote this response:", headers, output].join("\n")
  end

  def output(content)
    "<html><head></head><body>#{content}</body></html>"
  end

  def headers(content)
    ["http/1.1 200 ok",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{content.length}\r\n\r\n"].join("\r\n")
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

  def hello
    @hello_count += 1
    output("Hello World! (#{@hello_count})")
  end

  def datetime
    Time.now.ctime
  end

  def verb(request_lines)
    request_lines[0].split[0]
  end

  def path(request_lines)
    request_lines[0].split[1]
  end

  def value(path_line)
    path_line.split("=")[1]
  end

  def word_search(word)
    finder = WordFinder.new
    finder.contains?(word)
  end

  def protocol(request_lines)
    request_lines[0].split[2]
  end

  def host(request_lines)
    request_lines[1].split(":")[1].lstrip
  end

  def port(request_lines)
    request_lines[1].split(":")[2]
  end

  def accept(request_lines)
    request_lines.find do |i|
      i.include?("Accept")
    end.split(":")[1]
  end

end
