require 'pry'
require './lib/request'

class Response < Request
  attr_reader :output, :header

  def initialize
    @hello_count = 0
    @request_count = 0
  end

  def create_response_footer
    footer = {Verb: @verb, Path: @path, Protocol: @protocol,
              Host: @host, Port: @port, Origin: @origin,
              Accept: @accept}
    printed_footer = footer.map do |key, value|
      "#{key}: #{value}\n"
    end.join.chomp
  end

  def create_response_header
    @headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{@body.length}\r\n\r\n"].join("\r\n")
  end

  def create_response_body(message)
    @body = "<html><head></head><body><pre>#{message}</pre></body></html>"
  end

  def create_message
    if path == "/"
      message_1 = ""
    elsif path == "/hello"
      @hello_count += 1
      message_2 = "Hello World! (#{hello_count})\n\n"
    elsif path == "/datetime"
      message_3 = "#{Time.now.strftime('%l:%M%p on %A, %b %e, %Y').lstrip}\n\n"
    elsif path == "/shutdown"
      message_4 =  "Total Requests: #{request_counter}\n\n"
    else
      message_5 = "Request path not supported :(\n\n"
    end
  end

end
