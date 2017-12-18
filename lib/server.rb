require 'socket'
require 'pry'

#---------------------------Establish server port and accept client port (communication now open)
tcp_server = TCPServer.new(9292) # establish server port

counter = 1

loop do
  puts "Ready for a request"
  client = tcp_server.accept

  #----------------------------Stores received request in array
  request_lines = []

  # line = client.gets and
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  #----------------------------Print the request to server screen
  puts "Got this request:"
  puts request_lines.inspect


  #----------------------------Create our response, much of it based on request
  response_body = "<pre>" + "Hello World! (#{counter})" + "</pre>"
  # response_footer = "<pre>Verb: POST\nPath: /\nProtocol: HTTP/1.1\n
  # Host: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept:
  # text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
  # </pre>"
  output = "<html><head></head><body>#{response_body}</body></html>"
  headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")

  #----------------------------Send the response (w/ body) to the client
  client.puts headers  # this is the formal response stuff
  client.puts output  # this is the RESPONSE body


  #-----------------------------Prints response to client on the server screen
  puts "Sending response."
  puts ["Wrote this response:", headers, output].join("\n")


  #----------------------------Close the client port (path of communication)
  counter += 1
  client.close
  puts "\nResponse complete, exiting."

end
