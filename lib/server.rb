require 'socket'
require './lib/word_finder'
require './lib/guessing_game'
require './lib/request_parser'
require './lib/response_body'
require 'pry'

class Server
  include RequestParser

  attr_accessor :client, :response_body

  def initialize
    @tcp_server = TCPServer.open(9292)
    @response_body = ResponseBody.new
  end

  def start
    response_body.count
    puts "Ready for a request"
    @client = @tcp_server.accept
    response_control = response_control(request)
    response = responder(response_control)
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
      response = response_body.hello + diagnostics(request_lines)
      @status_code = "http/1.1 200 ok"
    when path == "/datetime"
      response = response_body.datetime + diagnostics(request_lines)
      @status_code = "http/1.1 200 ok"
    when path.include?("/word_search")
      word = value(path)
      response = response_body.word_search(word)
      @status_code = "http/1.1 200 ok"
    when path == "/start_game" && verb == "POST"
      if response_body.game.nil?
        response = response_body.start_game
        @status_code = "http/1.1 301 Moved Permanently"
        @location = "Location: http://127.0.0.1:9292/start_game"
      else
        response = response_body.html_formatter("Forbidden")
        @status_code = "http/1.1 403 Forbidden"
      end
    when path == "/start_game" && verb == "GET"
      response = response_body.html_formatter("POST a guess in the body of /game, good luck!")
      @status_code = "http/1.1 200 ok"
    when path == "/game" && verb == "GET"
      response = response_body.game.feedback unless response_body.game.nil?
      @status_code = "http/1.1 200 ok"
    when path == "/game" && verb == "POST"
      guess = get_guess(request_lines, client)
      response = response_body.game.play(guess) unless response_body.game.nil?
      @status_code = "http/1.1 301 Moved Permanently"
      @location = "Location: http://127.0.0.1:9292/game"
    when path == "/shutdown"
      response = response_body.html_formatter("Total count:(#{@count})")
      @status_code = "http/1.1 200 ok"
      responder(response)
      client.close
    when path == "/force_error"
      response = response_body.html_formatter("ServerError")
      @status_code = "http/1.1 500 Internal Server Error"
    else
      response = response_body.html_formatter("404 not found")
      @status_code = "http/1.1 404 Not Found"
    end
    response
  end

  def responder(response)
    @formatted_response = response_body.html_formatter(response)
    headers = headers(@formatted_response)
    if @status_code == "http/1.1 301 Moved Permanently"
      headers.insert(1, @location)
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
