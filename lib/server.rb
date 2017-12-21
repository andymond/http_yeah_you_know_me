require 'socket'
require './lib/word_finder'
require './lib/guessing_game'
require './lib/request_parser'
require './lib/response_body'
require 'pry'

class Server
  include RequestParser
  include ResponseBody

  attr_accessor :client

  def initialize
    @tcp_server = TCPServer.open(9292)
    @count = 0
    @hello_count = 0
    @status_code = nil
  end

  def start
    @count += 1
    puts "Ready for a request"
    @client = @tcp_server.accept
    response_control = response_control(request)
    response = response(response_control)
    client_responder(response)
    start
  end

  def request
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    puts "Got this request:"
    puts request_lines.inspect
    request_lines
  end

  def response_control(request_lines)
    puts "Sending response."
    path = path(request_lines)
    verb = verb(request_lines)
    case
      when path == "/"
        response = diagnostics(request_lines)
        @status_code = "http/1.1 200 ok"
      when path == "/hello"
        response = hello + diagnostics(request_lines)
        @status_code = "http/1.1 200 ok"
      when path == "/datetime"
        response = datetime + diagnostics(request_lines)
        @status_code = "http/1.1 200 ok"
      when path.include?("/word_search")
        word = value(path)
        response = word_search(word)
        @status_code = "http/1.1 200 ok"
      when path == "/start_game" && verb == "POST"
        if @game.nil?
          response = start_game
          @status_code = "http/1.1 200 ok"
        else
          response = html_formatter("Forbidden")
          @status_code = "http/1.1 403 Forbidden"
        end
      when path == "/game" && verb == "GET"
        response = @game.feedback
        @status_code = "http/1.1 200 ok"
      when path == "/game" && verb == "POST"
        guess = get_guess(request_lines, client)
        response = @game.play(guess)
        @status_code = "http/1.1 301 Moved Permanently"
      when path == "/shutdown"
        response = html_formatter("Total count:(#{@count})")
        @status_code = "http/1.1 200 ok"
        response(response)
        client.close
      when path == "/force_error"
        response = html_formatter("ServerError")
        @status_code = "http/1.1 500 Internal Server Error"
      else
        response = html_formatter("404 not found")
        @status_code = "http/1.1 404 Not Found"
    end
    response
  end

  def response(response)
    @formatted_response = html_formatter(response)
    headers = headers(@formatted_response)
    if @status_code == "http/1.1 301 Moved Permanently"
      headers.insert(1, "Location: http://127.0.0.1:9292/game")
    end
    headers
  end

  def client_responder(headers)
    client.puts headers
    client.puts @formatted_response
    puts ["Wrote this response:", headers].join("\n")
  end

  def headers(content)
    [@status_code,
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{content.length}\r\n\r\n"]
  end

end
