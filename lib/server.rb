require 'pry'
require './lib/request'
require './lib/post_request'

class Server

  def request_lines(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def post_request_body(client, post_request)
    client.read(post_request.content_length)
  end

  # def send_response(client)
  #   client.puts @headers
  #   client.puts @output
  # end

end
