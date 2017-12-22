require 'pry'

class Request
  attr_reader :verb, :path, :value, :protocol,
              :content_length, :host, :port, :accept,
              :guess

  def parse(request_lines)
    first_line = request_lines[0].split #=> ['GET', '/', HTTP/1.1]
    @verb = first_line[0]
    @path = first_line[1].split("?")[0]
    @value = first_line[1].split("?")[1].split("=")[1] unless first_line[1].split("?")[1].nil?
    @protocol = first_line[2]
    @content_length = request_lines[3].split(" ")[1].to_i
    @host = request_lines[1].split[1].split(":")[0]
    @port = request_lines[1].split[1].split(":")[1]
    # @accept = request_lines[6].split[1] unless request_lines[6].nil?
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
