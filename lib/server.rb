require 'socket'
require './lib/word_finder'
require './lib/guessing_game'
require './lib/request_parser'
require 'pry'

class Server

  attr_reader :count, :hello_count

  def initialize
    @tcp_server = TCPServer.open(9292)
    @parser = RequestParser.new
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
    path = @parser.path(request_lines)
    verb = @parser.verb(request_lines)
    case
      when path == "/"
        response = diagnostics(request_lines)
      when path == "/hello"
        response = hello + diagnostics(request_lines)
      when path == "/datetime"
        response = datetime + diagnostics(request_lines)
      when path.include?("/word_search")
        word = @parser.value(path)
        response = word_search(word)
      when path == "/start_game" && verb == "POST"
        if @game.nil?
          response = start_game
        else
          response = html_formatter("Forbidden")
          forbidden_response(response, client)
        end
      when path == "/game" && verb == "GET"
        response = @game.feedback
      when path == "/game" && verb == "POST"
        guess = @parser.get_guess(request_lines, client)
        response = @game.play(guess)
        redirect_response(response, client)
      when path == "/shutdown"
        response = html_formatter("Total count:(#{@count})") + diagnostics(request_lines)
        response(response, client)
        client.close
      when path == "/force_error"
        response = html_formatter("ServerError")
        server_error_response(response, client)
      else
        response = html_formatter("404 not found")
        not_found_response(response, client)
    end
    response
  end

  def response(response, client)
    formatted_response = html_formatter(response)
    headers = headers(formatted_response).join("\r\n")
    client.puts headers
    client.puts formatted_response
    puts ["Wrote this response:", headers].join("\n")
  end

  def html_formatter(content)
    "<html><head></head><body>#{content}</body></html>"
  end

  def headers(response_code = "http/1.1 200 ok", content)
    [response_code,
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{content.length}\r\n\r\n"]
  end

  def redirect(content)
    redirect_headers = headers("http/1.1 301 Moved Permanently", content)
    redirect_headers.insert(1, "Location: http://127.0.0.1:9292/game")
    redirect_headers
  end

  def redirect_response(response, client)
    formatted_response = html_formatter(response)
    redirect = redirect(formatted_response).join("\r\n")
    client.puts redirect
    client.puts formatted_response
    puts ["Wrote this response:", redirect].join("\n")
  end

  def not_found(content)
    not_found_headers = headers("http/1.1 404 Not Found", content)
    not_found_headers
  end

  def not_found_response(response, client)
    formatted_response = html_formatter(response)
    not_found = not_found(formatted_response).join("\r\n")
    client.puts not_found
    client.puts formatted_response
    puts ["Wrote this response:", not_found].join("\n")
  end

  def forbidden(content)
    forbidden_headers = headers("http/1.1 403 Forbidden", content)
    forbidden_headers
  end

  def forbidden_response(response, client)
    formatted_response = html_formatter(response)
    forbidden = forbidden(formatted_response).join("\r\n")
    client.puts forbidden
    client.puts formatted_response
    puts ["Wrote this response:", forbidden].join("\n")
  end

  def server_error(content)
    server_error_headers = headers("http/1.1 500 Internal Server Error", content)
    server_error_headers
  end

  def server_error_response(response, client)
    formatted_response = html_formatter(response)
    server_error = server_error(formatted_response).join("\r\n")
    client.puts server_error
    client.puts formatted_response
    puts ["Wrote this response:", server_error].join("\n")
  end

  def diagnostics(request_lines)
    "<pre>" + "\r\n" +
   ["Verb: #{@parser.verb(request_lines)}",
    "Path: #{@parser.path(request_lines)}",
    "Protocol: #{@parser.protocol(request_lines)}",
    "Host: #{@parser.host(request_lines)}",
    "Port: #{@parser.port(request_lines)}",
    "Origin: #{@parser.host(request_lines)}",
    "Accept:#{@parser.accept(request_lines)}"].join("\n") + "</pre>"
  end

  def hello
    @hello_count += 1
    html_formatter("Hello World! (#{@hello_count})")
  end

  def datetime
    Time.now.ctime
  end

  def word_search(word)
    finder = WordFinder.new
    finder.contains?(word)
  end

  def start_game
    @game = GuessingGame.new
    "Good Luck!"
  end

end
