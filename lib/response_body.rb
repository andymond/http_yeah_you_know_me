module ResponseBody

  attr_reader :game, :finder

  def html_formatter(content)
    "<html><head></head><body>#{content}</body></html>"
  end

  def diagnostics(request_lines)
    "<pre>" + "\r\n" +
   ["Verb: #{verb(request_lines)}",
    "Path: #{path(request_lines)}",
    "Protocol: #{protocol(request_lines)}",
    "Host: #{host(request_lines)}",
    "Port: #{port(request_lines)}",
    "Origin: #{host(request_lines)}",
    "Accept:#{accept(request_lines)}"].join("\n") + "</pre>"
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
