require './lib/server'
require 'Faraday'

class ServerTest < Minitest::Test

  def test_it_exists
    server = Server.new

    assert_instance_of Server, server
  end

  def test_request_lines_stored_and_sent_in_response
    server = Server.new
    request_lines =   ["GET / HTTP/1.1", "User-Agent: Faraday v0.13.1", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]
    response = Faraday.get("http://127.0.0.1:9292")

    response_lines = response.body.split("\n")

    assert_equal 'GET', response_lines[1].split[1]
    assert_equal '/', response_lines[2].split[1]
    assert_equal 'HTTP/1.1', response_lines[3].split[1]
    assert_equal 'Faraday', response_lines[4].split[1]
    assert_equal 'Faraday', response_lines[6].split[1]
  end

  def test_parse_request_returns_diagnostics
    server = Server.new
    request = Request.new
    request_lines =   ["GET / HTTP/1.1", "User-Agent: Faraday v0.13.1", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    server.parse_request(request, request_lines)

    assert_equal 'GET', request.verb
    assert_equal '/', request.path
    assert_equal 'HTTP/1.1', request.protocol
    assert_equal '*/*', request.accept
  end

  def test_prepare_response_creates_response_message
    server = Server.new
    response = Response.new
    request = Request.new
    request_lines =   ["GET /hello HTTP/1.1", "User-Agent: Faraday v0.13.1", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    server.prepare_response(response, request, request_lines)

    assert_equal "Hello World! (2)\n\n", response.create_message(request)
  end

  def test_prepare_response_creates_response_footer
    server = Server.new
    response = Response.new
    request = Request.new
    request_lines =   ["GET /hello HTTP/1.1", "User-Agent: Faraday v0.13.1", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    server.prepare_response(response, request, request_lines)

    assert_equal "\nVerb: GET\nPath: /hello\nProtocol: HTTP/1.1\nHost: Faraday\nPort: \nOrigin: Faraday\nAccept: */*", response.create_response_footer
  end

  def test_prepare_response_creates_response_header
    server = Server.new
    response = Response.new
    request = Request.new
    request_lines =   ["GET /hello HTTP/1.1", "User-Agent: Faraday v0.13.1", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    server.prepare_response(response, request, request_lines)

    assert_equal "http/1.1 200 OK\r\nLocation: \r\ndate: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r\nserver: ruby\r\ncontent-type: text/html; charset=iso-8859-1\r\ncontent-length: 159\r\n\r\n", response.header
  end

  def test_prepare_response_creates_response_body
    server = Server.new
    response = Response.new
    request = Request.new
    request_lines =   ["GET /hello HTTP/1.1", "User-Agent: Faraday v0.13.1", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    server.prepare_response(response, request, request_lines)

    assert_equal "<html><head></head><body><pre>Hello World! (1)\n\n\nVerb: GET\nPath: /hello\nProtocol: HTTP/1.1\nHost: Faraday\nPort: \nOrigin: Faraday\nAccept: */*</pre></body></html>", response.body
  end

  def test_print_request_prints_inspected_lines
    server = Server.new
    request_lines =   ["GET / HTTP/1.1", "User-Agent: Faraday v0.13.1", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"]

    assert_nil server.print_request(request_lines)
  end

end
