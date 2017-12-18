require 'socket'
require 'pry'
require './lib/http_formatter.rb'

tcp_server = TCPServer.new(9292) # establish server port
formatter = HTTPFormatter.new
hello_counter = 0
request_counter = 0
exit_server = false

until formatter.path == "/shutdown"
# until exit_server == true
  puts "Ready for a request"
  client = tcp_server.accept # establish client port
  request_counter += 1
  #----------------------------Stores & Parses request
  request = formatter.request_lines(client)
  formatter.parse_request(request)
  footer = formatter.create_response_footer
  #----------------------------Potential responses
  # body1 = ""
  # body2 = "Hello World! (#{hello_counter})\n\n"
  # body3 = "#{Time.now.strftime('%l:%M%p on %A, %b %e, %Y').lstrip}\n\n"
  # body4 =  "Total Requests: #{request_counter}\n\n"
  # body5 = "Request path not supported :(\n\n"
  #----------------------------Print the request to server screen
  puts "Got this request:"
  puts request.inspect
  #----------------------------Create our response depending on path
  # if formatter.path == "/"
  #   response = body1 + footer
  #   formatter.response(response)
  # elsif formatter.path == "/hello"
  #   response = body2 + footer
  #   formatter.response(response)
  #   hello_counter += 1
  # elsif formatter.path == "/datetime"
  #   response = body3 + footer
  #   formatter.response(response)
  # elsif formatter.path == "/shutdown"
  #   response = body4 + footer
  #   formatter.response(response)
  #   exit_server = true
  # else
  #   response = body5 + footer
  #   formatter.response(response)
  # end
  #----------------------------Send the response (w/ body) to the client
  client.puts formatter.headers
  client.puts formatter.output
  #-----------------------------Prints response to client on the server screen
  puts "Sending response."
  puts ["Wrote this response:", formatter.headers, formatter.output].join("\n")
  puts"\n\nRequest Counter: #{request_counter}\n\n" #this is just a check
  client.close
end

puts "\nResponse complete, exiting."
