require 'pry'
require './lib/request'
require './lib/word_lookup'
require './lib/guessing_game'

class Response < Request
  attr_reader :header, :body

  def initialize
    @hello_count = 0
    @request_count = 0
  end

  def create_response_footer
    footer = {Verb: verb, Path: path, Protocol: protocol, Host: host,
              Port: port, Origin: origin, Accept: accept}
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
    if path == "/"
      ""
    elsif path == "/hello" && verb == "GET"
      @hello_count += 1
      "Hello World! (#{@hello_count})\n\n"
    elsif path == "/datetime" && verb == "GET"
      "#{Time.now.strftime('%l:%M%p on %A, %b %e, %Y').lstrip}\n\n"
    elsif path == "/shutdown" && verb == "GET"
      "Total Requests: #{@request_count}\n\n"
    elsif path == "/word_search" && verb == "GET"
      word_search
    elsif path == "/start_game" && verb == "POST"
      start_game
      "Good luck!\n\n"
    elsif path == "/game" && verb == "GET"
      compare_guess(request)
    elsif path == "/game" && verb == "POST"
      compare_guess(request)
    else
      "Request path not supported :(\n\n"
    end
  end

  def start_game
    @game = GuessingGame.new
  end

  def compare_guess(request)
    @game.compare(request.guess)
  end

  def create_response_body(message)
    @body = "<html><head></head><body><pre>#{message}</pre></body></html>"
  end

  def word_search
    seeker = WordLookup.new(value)
    seeker.search_dict
    seeker.search_result
  end

end
