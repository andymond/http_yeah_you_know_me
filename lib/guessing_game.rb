class GuessingGame

  attr_accessor :guess
  attr_reader :number_generator

  def initialize(num1 = 0, num2 = 100)
    @guess = nil
    @number_generator = rand(num1..num2)
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
