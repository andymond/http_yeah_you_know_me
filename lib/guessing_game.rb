class GuessingGame

  attr_accessor :guess
  attr_reader :number_generator, :guess_count

  def initialize(num1 = 0, num2 = 100)
    @guess = nil
    @number_generator = rand(num1..num2)
    @guess_count = 0
  end

  def play(guess)
    @guess_count += 1
    @guess = guess.to_i
    guess_validator(guess)
  end

  def number?(input)
    input.to_s =~ /[0-9]/ ? true : false
  end

  def guess_validator(guess)
    if number?(guess)
      guess.to_i
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

  def feedback
    "Number of guesses: (#{@guess_count}) Last guess #{guess}, #{guess_match}"
  end

end
