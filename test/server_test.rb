require 'minitest/autorun'
require 'minitest/pride'
require './lib/server'
require './lib/request'
require 'socket'
require 'Faraday'
require 'pry'

class ServerTest < Minitest::Test
  @@tcp_server = TCPServer.new(9292)

  def test_it_exists
    server = Server.new

    assert_instance_of Server, server
  end

  def test_request_lines_stores_client_request
    # get request with no path must be sent with Postman for assertions to pass
    server = Server.new
    request = Request.new
    client = @@tcp_server.accept

    request_lines = server.request_lines(client)
    request.parse(request_lines)

    assert_equal "GET", request.verb
    assert_equal "/", request.path
    assert_equal "HTTP/1.1", request.protocol
    assert_equal "127.0.0.1", request.host
    assert_equal "9292", request.port
    assert_equal "127.0.0.1", request.origin
    assert_equal "*/*", request.accept
    client.close
  end

end
