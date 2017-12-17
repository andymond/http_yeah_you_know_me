require 'socket'
require 'pry'

class Server

  attr_reader :count

  def initialize
    @tcp_server = TCPServer.new(9292)
    @count = 0
    start
  end

  def start
    client = @tcp_server.accept
    @count += 1

    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    puts "Got this request:"
    puts request_lines.inspect

    puts "Sending response."
    response = "<pre>" + "\r\n" +
               ["Verb: #{request_lines[0].split[0]}",
                "Path: #{request_lines[0].split[1]}",
                "Protocol: #{request_lines[0].split[2]}",
                "Host: #{request_lines[1].split(":")[1].lstrip}",
                "Port: #{request_lines[1].split(":")[2]}",
                "Origin: #{request_lines[1].split(":")[1].lstrip}",
                "Accept:#{request_lines.find do |i|
                    i.include?("Accept")
                 end.split(":")[1]}"].join("\n") + "</pre>"

    output = "<html><head></head><body>Hello World! (#{count})#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output

    puts ["Wrote this response:", headers, output].join("\n")

    start
  end

  def close
    client.close
    puts "\nResponse complete, exiting."
  end

  def verb

  end

  def path

  end

  def protocol

  end

  def host
  end

  def port
  end

  def accept
  end

end
