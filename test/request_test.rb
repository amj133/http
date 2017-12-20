require 'minitest/autorun'
require 'minitest/pride'
require './lib/request'
require 'pry'

class RequestTest < Minitest::Test

  def test_it_exists
    request = Request.new

    assert_instance_of Request, request
  end

  def test_parse_request_returns_correct_values
    request = Request.new

    request.parse(["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "Accept: */*", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])

    assert_equal "GET", request.verb
    assert_equal "/", request.path
    assert_equal "HTTP/1.1", request.protocol
    assert_equal "127.0.0.1", request.host
    assert_equal "9292", request.port
    assert_equal "127.0.0.1", request.origin
    assert_equal "*/*", request.accept
  end

  def test_parse_finds_and_returns_accept
    request = Request.new

    request.parse(["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept: */*", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])

    assert_equal "GET", request.verb
    assert_equal "/", request.path
    assert_equal "HTTP/1.1", request.protocol
    assert_equal "127.0.0.1", request.host
    assert_equal "9292", request.port
    assert_equal "127.0.0.1", request.origin
    assert_equal "*/*", request.accept
  end

  def test_parse_returns_path_paramater_values_when_specified
    request = Request.new

    request.parse(["GET /word_search?word=monkey HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept: */*", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])
    assert_equal "/word_search", request.path
    assert_equal "word", request.parameter
    assert_equal "monkey", request.value
  end

  def test_content_length_returns_correct_integer_value
    request = Request.new
    request_lines = (["POST /start_game HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Content-Length: 22",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36",
                  "Cache-Control: no-cache",
                  "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                  "Postman-Token: 80993bd5-276d-becf-e51b-4ad1ec930d98",
                  "Content-Type: text/plain;charset=UTF-8",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"])

    request.parse(request_lines)

    assert_equal 22, request.content_length
  end


end
