

class GuessingGame
  attr_reader :guess, :secret_number

  def initialize(guess)
    @guess = guess
    @secret_number = rand(1..100)
  end

  def compare
    if @guess == @secret_number
      "You guessed correctly!!!"
    elsif @guess < @secret_number
      "Your guess is too low!"
    elsif @guess > @secret_number
      "Your guess is too high"
    else
      "C'mon, make a REAL guess!"
    end
  end

end
