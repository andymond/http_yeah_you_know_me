class ResponseBody

  attr_reader :game, :finder
  attr_accessor :count, :hello_count

  def initialize
    @count = 0
    @hello_count = 0
  end

  def count
    @count += 1
  end

  def html_formatter(content)
    "<html><head></head><body>#{content}</body></html>"
  end

  def hello
    @hello_count += 1
    html_formatter("Hello World! (#{@hello_count})")
  end

  def datetime
    Time.now.ctime
  end

  def word_search(word)
    @finder = WordFinder.new
    finder.contains?(word)
  end

  def start_game
    @game = GuessingGame.new
    "Good Luck!"
  end
end
