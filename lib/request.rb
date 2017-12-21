require 'pry'

class Request
  attr_reader :verb, :path, :parameter, :value, :protocol,
              :host, :port, :origin, :accept, :content_length,
              :guess

  def parse(request_lines)
    first_line = request_lines[0].split(" ") # => ['GET', '/', 'HTTP/1.1']
    @verb = first_line[0]
    @path = first_line[1].split("?")[0]
    @parameter = first_line[1].split("?")[1].split("=")[0] if first_line[1].length > 18
    @value = first_line[1].split("?")[1].split("=")[1] if first_line[1].length > 18
    @protocol = first_line[2]
    @content_length = request_lines[3].split(" ")[1].to_i
    @host = request_lines[1].split(" ")[1].split(":")[0]
    @port = request_lines[1].split(" ")[1].split(":")[1]
    @origin = @host
    accept_line = request_lines.find do |line|
      line.split(" ")[0] == "Accept:"
    end
    @accept = accept_line.split(" ")[1]
  end

  def request_guess(client)
    return nil if self.verb == "GET"
    body = client.read(content_length)
    @guess = body.split[4].to_i
  end

end
