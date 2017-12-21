require './lib/request'
require './lib/word_lookup'
require './lib/guessing_game'

class Response < Request
  attr_reader :header, :body, :game

  def initialize
    @hello_count = 0
    @request_count = 0
    @location = ""
  end

  def create_response_footer
    footer = {Verb: verb, Path: path, Protocol: protocol, Host: host,
              Port: port, Origin: host, Accept: accept}
    printed_footer = footer.map do |key, value|
      "\n#{key}: #{value}"
    end.join.chomp
  end

  def create_response_header
      @header = ["http/1.1 #{@status_code}", # 200 ok",
                 "Location: #{@location}", # not present
                 "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                 "server: ruby",
                 "content-type: text/html; charset=iso-8859-1",
                 "content-length: #{@body.length}\r\n\r\n"].join("\r\n")
  end

  def create_message(request)
    @status_code =  "200 OK"
    @request_count += 1
    case path
      when '/' then ""
      when '/hello' then hello_response
      when '/datetime' then datetime_response
      when '/shutdown' then shutdown_response
      when '/word_search' then word_search
      when '/start_game' then begin_guessing_response
      when '/game' then check_guess_response(request)
      when '/force_error' then error_response
      else
        @status_code = "404 Not Found"
    end
  end

  def hello_response
    @hello_count += 1
    "Hello World! (#{@hello_count})\n\n"
  end

  def datetime_response
    "#{Time.now.strftime('%l:%M%p on %A, %b %e, %Y').lstrip}\n\n"
  end

  def shutdown_response
    "Total Requests: #{@request_count}\n\n"
  end

  def begin_guessing_response
    if game.nil?
      start_game
    else
      @status_code = "403 Forbidden"
    end
  end

  def check_guess_response(request)
    case verb
    when 'GET'
      "Your most recent guess #{request.guess} is " + compare_guess(request)
    when 'POST'
      @status_code = "301 Moved Permanently"
      @location = "http://127.0.0.1:9292/game"
    end
  end

  def error_response
    @status_code = "500 Internal Server Errror"
  end

  def start_game
    @game = GuessingGame.new
    "Good luck!\n\n"
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
