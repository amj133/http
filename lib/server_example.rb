require 'socket'
require 'pry'

# The browser issues an HTTP request by opening a TCP socket connection to
# example.com on port 80. The server accepts the connection, opening a socket
# for bi-directional communication. (clients perspective)
# accepts incoming connection by returning a
# TCPsocket object (represents a TCP/IP CLIENTTTTTTT socket)
# the client variable is now the returned TCPsocket (client socket)


#---------------------------Establish server port and accept client port (communication now open)
tcp_server = TCPServer.new(9292) # establish server port
puts "Ready for a request"
client = tcp_server.accept

#----------------------------Receive request and store it in array
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

#----------------------------Print to server screen the request
puts "Got this request:"
puts request_lines.inspect


#----------------------------Create our response, much of it based on request
response = "<pre>" + request_lines.join("\n") + "</pre>"
output = "<html><head></head><body>#{response}</body></html>"
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
puts "\nResponse complete, exiting."


#----------------------------Close the client port (path of communication)
client.close
