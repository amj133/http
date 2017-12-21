require 'socket'
require 'pry'
require './lib/server'
require './lib/response'
require './lib/guessing_game'
require './lib/request'
require './lib/word_lookup'

tcp_server = TCPServer.new(9292)
server = Server.new
request = Request.new
response = Response.new

until request.path == "/shutdown" && request.verb == "GET"
  puts "Ready for a request"
  client = tcp_server.accept
  # binding.pry
  request_lines = server.request_lines(client)
  # binding.pry
  request.parse(request_lines)
  response.parse(request_lines)
  #-----------------------------------------
  guess = request.request_guess(client)
  # binding.pry
  #-----------------------------------------

  response_message = response.create_message(request)
  response_footer = response.create_response_footer
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
