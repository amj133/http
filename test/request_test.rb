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

  def test_parse_request_finds_and_assigns_accept
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

end
