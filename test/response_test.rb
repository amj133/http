require './lib/response'

class ResponseTest < Minitest::Test

  def test_it_exists
    response = Response.new

    assert_instance_of Response, response
  end

  def test_create_response_footer_contains_request_information
    response = Response.new
    requested_lines = ["GET / HTTP/1.1",
                       "Host: 127.0.0.1:9292",
                       "Upgrade-Insecure-Requests: 1",
                       "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5",
                       "Accept-Language: en-us",
                       "Accept-Encoding: gzip, deflate",
                       "Accept: */*",
                       "Connection: keep-alive"]

    response.parse(requested_lines)

    assert_equal "\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*",
      response.create_response_footer
  end

  def test_create_response_body_creates_formatted_body
    response = Response.new

    assert_equal "<html><head></head><body><pre>Hello World!</pre></body></html>",
      response.create_response_body("Hello World!")
  end

  def test_create_message_output_depends_on_request_path
    response_1 = Response.new
    response_2 = Response.new
    response_3 = Response.new
    response_4 = Response.new
    response_5 = Response.new
    request_1 = Request.new
    request_2 = Request.new
    request_3 = Request.new
    request_4 = Request.new
    request_5 = Request.new

    response_1.parse(["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "Accept: */*", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])
    response_2.parse(["GET /hello HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "Accept: */*", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])
    response_3.parse(["GET /datetime HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "Accept: */*", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])
    response_4.parse(["GET /shutdown HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "Accept: */*", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])
    response_5.parse(["GET /monkey HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "Accept: */*", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])

    assert_equal "", response_1.create_message(request_1)
    assert_equal "Hello World! (1)\n\n", response_2.create_message(request_2)
    assert_equal "#{Time.now.strftime('%l:%M%p on %A, %b %e, %Y').lstrip}\n\n", response_3.create_message(request_3)
    assert_equal "Total Requests: 1\n\n", response_4.create_message(request_4)
    assert_equal "404 Not Found", response_5.create_message(request_5)
  end

  def test_path_word_search_returns_whether_word_is_known_or_not
    response = Response.new
    request = Request.new
    requested_lines = ["GET /word_search?word=baboon HTTP/1.1",
                       "Host: 127.0.0.1:9292",
                       "Upgrade-Insecure-Requests: 1",
                       "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5",
                       "Accept-Language: en-us",
                       "Accept-Encoding: gzip, deflate",
                       "Accept: */*",
                       "Connection: keep-alive"]

    response.parse(requested_lines)

    assert_equal "Baboon is a known word\n\n", response.create_message(request)
  end

  def test_path_start_game_instantiates_guessing_game_and_returns_message
    response = Response.new
    request = Request.new
    requested_lines = ["GET /start_game HTTP/1.1",
                       "Host: 127.0.0.1:9292",
                       "Upgrade-Insecure-Requests: 1",
                       "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5",
                       "Accept-Language: en-us",
                       "Accept-Encoding: gzip, deflate",
                       "Accept: */*",
                       "Connection: keep-alive"]

    response.parse(requested_lines)

    assert_equal "Good luck!\n\n", response.create_message(request)
    assert_instance_of GuessingGame, response.game
  end

  def test_path_game_will_check_guess
    response = Response.new
    request = Request.new
    requested_lines = ["GET /game HTTP/1.1",
                       "Host: 127.0.0.1:9292",
                       "Upgrade-Insecure-Requests: 1",
                       "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5",
                       "Accept-Language: en-us",
                       "Accept-Encoding: gzip, deflate",
                       "Accept: */*",
                       "Connection: keep-alive"]

    response.parse(requested_lines)

    assert_equal "You have to make a guess first!", response.create_message(request)
  end

  def test_path_force_error_response_will_return_error_message
    response = Response.new
    request = Request.new
    requested_lines = ["GET /force_error HTTP/1.1",
                       "Host: 127.0.0.1:9292",
                       "Upgrade-Insecure-Requests: 1",
                       "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5",
                       "Accept-Language: en-us",
                       "Accept-Encoding: gzip, deflate",
                       "Accept: */*",
                       "Connection: keep-alive"]

    response.parse(requested_lines)

    assert_equal "500 Internal Server Error", response.create_message(request)
  end

  def test_create_response_header_creates_formatted_header
    response = Response.new
    request = Request.new
    requested_lines = ["GET / HTTP/1.1",
                       "Host: 127.0.0.1:9292",
                       "Upgrade-Insecure-Requests: 1",
                       "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5",
                       "Accept-Language: en-us",
                       "Accept-Encoding: gzip, deflate",
                       "Accept: */*",
                       "Connection: keep-alive"]

    response.parse(requested_lines)
    message = response.create_message(request)
    response.create_response_body(message)

    assert_equal "http/1.1 200 OK\r\nLocation: \r\ndate: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r\nserver: ruby\r\ncontent-type: text/html; charset=iso-8859-1\r\ncontent-length: 50\r\n\r\n",
      response.create_response_header
  end

end
