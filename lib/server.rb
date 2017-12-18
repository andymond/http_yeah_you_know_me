require 'socket'
require 'pry'

class Server

  def initialize
    @tcp_server = TCPServer.open(9292)
    @count = 0
    @hello_count = 0
  end

  def count
    @count += 1
  end

  def start
    puts "Ready for a request"
    client = @tcp_server.accept
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    puts "Got this request:"
    puts request_lines.inspect

    puts "Sending response."
    response = diagnostics(request_lines)
    output = output(response)
    headers = headers(output)
    client.puts headers
    client.puts output
    puts ["Wrote this response:", headers, output].join("\n")
    start
  end

  def output(content)
    "<html><head></head><body>#{content}</body></html>"
  end

  def hello
    @hello_count += 1
    output("Hello World! (#{hello_count})")
  end

  def datetime
    Time.now.ctime
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

  def close
    client.close
    puts "\nResponse complete, exiting."
  end

end
