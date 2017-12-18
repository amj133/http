require 'minitest/autorun'
require 'minitest/pride'
require './lib/request'
require './lib/response'
require 'pry'

class ResponseTest < Minitest::Test

  def test_it_exists
    response = Response.new

    assert_instance_of Response, response
  end

  def test_create_response_footer_contains_request_information
    response = Response.new

    response.parse(["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Upgrade-Insecure-Requests: 1", "Accept: */*", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5", "Accept-Language: en-us", "Accept-Encoding: gzip, deflate", "Connection: keep-alive"])

    assert_equal "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*",
      response.create_response_footer
  end

  def test_create_response_header_creates_formatted_header
    response = Response.new

    response.create_response_body("Hello World!")

    assert_equal "http/1.1 200 ok\r\ndate: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r\nserver: ruby\r\ncontent-type: text/html; charset=iso-8859-1\r\ncontent-length: 62\r\n\r\n",
      response.create_response_header
  end

  def test_create_response_body_creates_formatted_body
    response = Response.new

    assert_equal "<html><head></head><body><pre>Hello World!</pre></body></html>",
      response.create_response_body("Hello World!")
  end
end
