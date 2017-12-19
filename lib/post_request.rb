require 'pry'
require './lib/request'

class PostRequest < Request
  attr_reader :content_length

  def read_content_length(request_lines)
    content_length_line = request_lines.find do |line|
      line.split(" ")[0] == "Content-Length:"
    end
    @content_length = content_length_line.split(" ")[1].to_i
  end

end
