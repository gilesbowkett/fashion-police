class FashionPolice
  attr_reader :errors
  attr_accessor :rules

  class SpacesNotTabs
    def test(string)
      not string.match(/\t/)
    end

    def error_message
      "Use spaces, not tabs"
    end
  end

  class FourSpaces
    def test(string)
      spaces = string.match(/^(\s+)\S/)
      return true unless spaces && spaces[1]

      return (spaces[1].length % 4 == 0)
    end

    def error_message
      "Four spaces per indentation level"
    end
  end

  class NoSpacesInFunctionDeclarations
    def test(string)
      return true if string.match(/function\(\.*\)\{/)
      return false if string.match(/function\s+\(.*\)\s+\{/)
      return true
    end

    def error_message
      "No spaces in function declarations"
    end
  end

  class BadCode < Exception; end

  def initialize
    @errors = []
    @rules = [ SpacesNotTabs.new,
               FourSpaces.new,
               NoSpacesInFunctionDeclarations.new ]
  end

  def investigate(code)
    code.split("\n").each_with_index do |line, index|
      raise(BadCode) unless permit?(index, line)
    end
  end

  def permit?(line_number, string)
    @rules.inject(true) do |memo, rule|
      unless rule.test(string)
        memo = false
        @errors << {line_number => rule.error_message}
      end
      memo
    end
  end
end

