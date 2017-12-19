class GuessingGame

  attr_reader :guess, :number_generator

  def initialize(guess)
    @guess = guess
    @number_generator = rand(0..100)
  end

  def number?(input)
    input.to_s =~ /[0-9]/ ? true : false
  end

  def guess_validator
    if number?(guess)
      guess_match
    else
      "That's not a number! Try again."
    end
  end

  def guess_match
    if guess == number_generator
      "You guessed it!"
    elsif guess < number_generator
      "Too low! Guess again!"
    elsif guess > number_generator
      "Too high! Guess again!"
    end
  end

end
