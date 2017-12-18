require 'pry'

class HTTPFormatter

  attr_reader :verb, :path, :protocol, :host, :port,
              :output, :headers

  def request_lines(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def parse_request(request_lines)
    first_line = request_lines[0].split(" ")
    @verb = first_line[0]
    @path = first_line[1]
    @protocol = first_line[2]
    @host = request_lines[1].split(" ")[1].split(":")[0]
    @port = request_lines[1].split(" ")[1].split(":")[1]
  end

  def create_response_footer
    footer = {Verb: @verb, Path: @path, Protocol: @protocol,
              Host: @host, Port: @port, Origin: "127.0.0.1",
              Accept: "text/html,application/xhtml+xml,application/"\
              "xml;q=0.9,image/webp,*/*;q=0.8"}
    printed_footer = footer.map do |key, value|
      "#{key}: #{value}\n"
    end.join.chomp
  end

  def message
    if path == "/"
      body_1 = ""
    elsif path == "/hello"
      body_2 = "Hello World! (#{hello_counter})\n\n"
      hello_counter += 1
    elsif path == "/datetime"
      body_3 = "#{Time.now.strftime('%l:%M%p on %A, %b %e, %Y').lstrip}\n\n"
    elsif path == "/shutdown"
      body_4 =  "Total Requests: #{request_counter}\n\n"
    else
      body_5 = "Request path not supported :(\n\n"
    end
  end

  def response
    response_body = "<pre>" + message + "</pre>"
    @output = "<html><head></head><body>#{response_body}</body></html>"
    @headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def send_response(client)
    client.puts @headers
    client.puts @output
  end

end
