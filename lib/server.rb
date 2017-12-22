
class Server

  def start_server
    @port = TCPServer.new(9292)
  end

  def listen
    puts "Ready for a request"
    @client = @port.accept
  end

  def get_request_lines
    request_lines = []
    while line = @client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def print_request(request_lines)
    puts "Got this request:"
    puts request_lines.inspect
  end

  def parse_request(request, request_lines)
    request.parse(request_lines)
    request.request_guess(@client)
  end

  def prepare_response(response, request, request_lines)
    response.parse(request_lines)
    message = response.create_message(request)
    footer = response.create_response_footer
    body = response.create_response_body(message + footer)
    header = response.create_response_header
  end

  def send_response(response)
    puts "Sending response."
    @client.puts response.header
    @client.puts response.body
    puts ["Wrote this response:", response.header, response.body].join("\n")
  end

end
