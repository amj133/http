require 'minitest/autorun'
require 'minitest/pride'
require './lib/http_formatter'
require 'socket'
require 'Faraday'
require 'pry'

class HTTPFormatterTest < Minitest::Test
  @@tcp_server = TCPServer.new(9292)
  # @@headers = ["http/1.1 200 ok",
  #               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
  #               "server: ruby",
  #               "content-type: text/html; charset=iso-8859-1",
  #               "content-length: #{"Monkeys are awesome".chars.count}\r\n\r\n"].join("\r\n")

  def test_it_exists
    request = HTTPFormatter.new

    assert_instance_of HTTPFormatter, request
  end

  def test_request_lines_stores_request_in_array
    request = HTTPFormatter.new

    client = @@tcp_server.accept
    # client.puts @@headers
    # client.puts "Monkeys are awesome"
    # Faraday.get "http://127.0.0.1:9292"

    assert_equal ["GET / HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                   "Upgrade-Insecure-Requests: 1",
                   "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                   "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5",
                   "Accept-Language: en-us",
                   "Accept-Encoding: gzip, deflate",
                   "Connection: keep-alive"], request.request_lines(client)

    client.close
  end

  def test_parse_request_returns_proper_values
    request = HTTPFormatter.new

    client = @@tcp_server.accept
    # client.puts @@headers
    # client.puts "Monkeys are awesome"
    # Faraday.get "http://127.0.0.1:9292"

    lines = request.request_lines(client)
    request.parse_request(lines)

    assert_equal "GET", request.verb
    assert_equal "/", request.path
    assert_equal "HTTP/1.1", request.protocol
    assert_equal "127.0.0.1", request.host
    assert_equal "9292", request.port

    client.close
  end

  def test_create_response_footer_contains_parsed_request
    request = HTTPFormatter.new

    client = @@tcp_server.accept
    lines = request.request_lines(client)
    request.parse_request(lines)

    assert_equal "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      request.create_response_footer
    # assert_equal "Verb: GET\n"
    #              "Path: /\n"
    #              "Protocol: HTTP/1.1\n"
    #              "Host: 127.0.0.1\n"
    #              "Port: 9292\n"
    #              "Origin: 127.0.0.1\n"
    #              "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    #                 request.create_response_footer

    client.close
  end

  def test_response_creates_header_and_output
    request = HTTPFormatter.new

    client = @@tcp_server.accept
    lines = request.request_lines(client)
    request.parse_request(lines)
    footer = request.create_response_footer
    request.response(footer)

    assert_equal "<html><head></head><body><pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8</pre></body></html>",
      request.output

    client.close
  end

  def test_response_body_creates_header_and_output
    request = HTTPFormatter.new

    client = @@tcp_server.accept
    lines = request.request_lines(client)
    request.parse_request(lines)
    footer = request.create_response_footer
    request.response(footer)

    assert_equal "<html><head></head><body><pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8</pre></body></html>",
      request.output

    client.close
  end

  def test_send_response_sends_correct_header_output_data
    skip
    request = HTTPFormatter.new

    client = @@tcp_server.accept
    lines = request.request_lines(client)
    request.parse_request(lines)
    footer = request.create_response_footer
    response = request.response(footer)
    request.send_response(client)
    binding.pry
    var = Faraday.get('http://127.0.0.1:9292')


    assert_equal "<html><head></head><body><pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8</pre></body></html>",
      request.output

    client.close
  end

end
