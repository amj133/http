require 'socket'
require 'pry'
require './lib/server'
require './lib/response'
require './lib/request'

tcp_server = TCPServer.new(9292)
server = Server.new
request = Request.new
response = Response.new
post = PostRequest.new

until request.path == "/shutdown"
  puts "Ready for a request"
  client = tcp_server.accept

  request_lines = server.request_lines(client)
  #-----------------------------------------
  # post.read_content_length(request_lines)
  # post_body = server.post_request_body(client, post)
  # guess = post_body.split[4].to_i
  # binding.pry
  #-----------------------------------------
  request.parse(request_lines)

  response_message = response.create_message(request)
  response_footer = response.create_response_footer(request)
  response_body = response.create_response_body(response_message + response_footer)
  response_header = response.create_response_header

  puts "Got this request:"
  puts request_lines.inspect

  client.puts response.header
  client.puts response.body

  puts "Sending response."
  puts ["Wrote this response:", response.header, response.body].join("\n")
  client.close
end

puts "\nResponse complete, exiting."
