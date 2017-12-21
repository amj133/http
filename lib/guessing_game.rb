require './lib/response'
require './lib/word_lookup'
require './lib/request'

class GuessingGame
  attr_reader :secret_number, :guess_count

  def initialize
    @secret_number = rand(1..100)
    @guess_count = 0
  end

  def compare(guess)
    @guess_count += 1
    if guess == @secret_number
      "correct!!!\n
      Guesses made: #{@guess_count}\n\n"
    elsif guess < @secret_number
      "too low!\n
      Guesses made: #{@guess_count}\n\n"
    elsif guess > @secret_number
      "too high\n
      Guesses made: #{@guess_count}\n\n"
    else
      "not a real guess :/\n
      Guesses made: #{@guess_count}\n\n"
    end
  end

end
