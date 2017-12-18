class WordFinder

  attr_reader :content

  def initialize
    @content = File.read('/usr/share/dict/words')
  end

  def contains?(word)
    if @content.include?(word.downcase)
      return "#{word.upcase} is a known word"
    else
      return "#{word.upcase} is not a known word"
    end
  end

end
