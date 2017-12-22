require 'socket'
require './lib/server'
require './lib/request'
require './lib/response'

server = Server.new
server.start_server
request = Request.new
response = Response.new

until request.path == "/shutdown"
  client = server.listen
  request_lines = server.get_request_lines
  server.parse_request(request, request_lines)
  server.prepare_response(response, request, request_lines)
  server.print_request(request_lines)
  server.send_response(response)
  client.close
end

puts "\nResponse complete, exiting."
