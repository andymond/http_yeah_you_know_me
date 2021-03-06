require 'socket'
require 'pry'

class Server


    tcp_server = TCPServer.new(9292)
    count = 0


loop do
  client = tcp_server.accept
  count += 1
binding.pry
  puts "Ready for a request"
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect

  puts "Sending response."
  response = "<pre>" + request_lines.join("\n") + "</pre>" +
             "\r\n" +
             ["Verb: #{}",
               "Path: #{}",
               "Protocol: #{}",
               "Host: #{}",
               "Port: #{}",
               "Origin: #{}",
               "Accept:#{}"].join("\n")

  output = "<html><head></head><body>Hello World! (#{count})#{response}</body></html>"
  headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  client.puts headers
  client.puts output

  puts ["Wrote this response:", headers, output].join("\n")

end

client.close
puts "\nResponse complete, exiting."

end
