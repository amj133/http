require './lib/response'
require './lib/word_lookup'
require './lib/request'

class GuessingGame
  attr_reader :secret_number, :guess_count

  def initialize
    @secret_number = rand(1..100)
    @guess_count = 0
  end

  def start(client, guess)
    @guess_count += 1
    if guess == @secret_number
      create_message = "You guessed correctly!!!\n
      #{@guess_count} guesses were made\n\n"
    elsif guess < @secret_number
      create_message = "Your guess is too low!\n
      #{@guess_count} guesses have been made\n\n"
    elsif guess > @secret_number
      create_message = "Your guess is too high
      #{@guess_count} guesses have been made\n\n"
    else
      create_message = "C'mon, make a REAL guess!\n
      #{@guess_count} guesses have been made\n\n"
    end
  end

  # def compare(guess)
  #   @guess_count += 1
  #   @guess = guess
  #   if @guess == @secret_number
  #     "You guessed correctly!!!\n
  #     #{@guess_count} guesses were made\n\n"
  #   elsif @guess < @secret_number
  #     "Your guess is too low!\n
  #     #{@guess_count} guesses have been made\n\n"
  #   elsif @guess > @secret_number
  #     "Your guess is too high
  #     #{@guess_count} guesses have been made\n\n"
  #   else
  #     "C'mon, make a REAL guess!\n
  #     #{@guess_count} guesses have been made\n\n"
  #   end
  # end

end
