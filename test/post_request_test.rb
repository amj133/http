require 'minitest/autorun'
require 'minitest/pride'
require './lib/request'
require './lib/response'
require './lib/post_request'
require 'pry'

class ResponseTest < Minitest::Test

  def test_it_exists
    post = PostRequest.new

    assert_instance_of PostRequest, post
  end

  def test_read_content_length_gets_content_length_from_request
    post = PostRequest.new
    request_1 = (["POST /start_game HTTP/1.1",
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

    request_2 = (["POST /start_game HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36",
                  "Cache-Control: no-cache",
                  "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                  "Postman-Token: 80993bd5-276d-becf-e51b-4ad1ec930d98",
                  "Content-Length: 35",
                  "Content-Type: text/plain;charset=UTF-8",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"])

    assert_equal 22, post.read_content_length(request_1)
    assert_equal 35, post.read_content_length(request_2)
  end

end
