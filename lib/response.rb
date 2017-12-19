require 'pry'
require './lib/request'
require './lib/word_lookup'

class Response < Request
  attr_reader :header, :body

  def initialize
    @hello_count = 0
    @request_count = 0
  end

  def create_response_footer(request)
    footer = {Verb: request.verb, Path: request.path,
              Protocol: request.protocol,Host: request.host, Port: request.port,
              Origin: request.origin, Accept: request.accept}
    printed_footer = footer.map do |key, value|
      "#{key}: #{value}\n"
    end.join.chomp
  end

  def create_response_header
    @header = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{@body.length}\r\n\r\n"].join("\r\n")
  end

  def create_message(request)
    @request_count += 1
    if request.path == "/"
      message_1 = ""
    elsif request.path == "/hello"
      @hello_count += 1
      message_2 = "Hello World! (#{@hello_count})\n\n"
    elsif request.path == "/datetime"
      message_3 = "#{Time.now.strftime('%l:%M%p on %A, %b %e, %Y').lstrip}\n\n"
    elsif request.path == "/shutdown"
      message_4 =  "Total Requests: #{@request_count}\n\n"
    elsif request.path == "/word_search"
      word_search(request)
    else
      message_5 = "Request path not supported :(\n\n"
    end
  end

  def create_response_body(message)
    @body = "<html><head></head><body><pre>#{message}</pre></body></html>"
  end

  def word_search(request)
    seeker = WordLookup.new(request.value)
    seeker.search_dict
    seeker.search_result
  end

end
