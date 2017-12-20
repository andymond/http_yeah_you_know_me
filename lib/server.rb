require 'socket'
require './lib/word_finder'
require './lib/guessing_game'
require './lib/request_parser'
require 'pry'

class Server

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
        response = start_game
      when path == "/game" && verb == "GET"
        response = @game.feedback
      when path == "/game" && verb == "POST"
        guess = @parser.get_guess
        response = @game.play(guess)
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
    puts ["Wrote this response:", headers].join("\n")
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
    output("Hello World! (#{@hello_count})")
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
