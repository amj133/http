require 'pry'

class Request
  attr_reader :verb, :path, :protocol, :host,
              :port, :origin, :accept

  def parse(request_lines)
    first_line = request_lines[0].split(" ")
    @verb = first_line[0]
    @path = first_line[1]
    @protocol = first_line[2]
    @host = request_lines[1].split(" ")[1].split(":")[0]
    @port = request_lines[1].split(" ")[1].split(":")[1]
    @origin = @host
    accept_line = request_lines.find do |line|
      line.split(" ")[0] == "Accept:"
    end
    @accept = accept_line.split(" ")[1]
  end

end
