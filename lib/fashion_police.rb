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

  class SpacesInFunctionDeclarations
    def test(string)
      return false if string.match(/function\(\.*\)\{/)
      return true if string.match(/function\s+\(.*\)\s+\{/)
      return true
    end

    def error_message
      "Put spaces in function declarations"
    end
  end

  class SpacesAroundColons
    def test(string)
      return true if string.match(/ : /)
      return false if string.match(/\S:\S/)
    end

    def error_message
      "Put spaces around colons"
    end
  end

  class SpacesAroundArgumentsInParens
    def test(string)
      return true if string.match(/\( .* \)/)
      return false if string.match(/\(\S+\)/)

      return true
    end

    def error_message
      "Put spaces around arguments inside parentheses"
    end
  end

  class SpacesAroundArgumentsInAngleBrackets
    def test(string)
      return true if string.match(/\{ .* \}/)
      return false if string.match(/\{[^\}]+\}/)

      return true
    end

    def error_message
      "Put spaces around arguments inside angle brackets"
    end
  end

  class SpacesAroundArgumentsInSquareBrackets
    def test(string)
      return true if string.match(/\[ .* \]/)
      return false if string.match(/\[[^\]]+\]/)

      return true
    end

    def error_message
      "Put spaces around arguments inside square brackets"
    end
  end

  class BadCode < Exception; end

  def initialize
    @errors = []
    @rules = [ SpacesNotTabs.new,
               FourSpaces.new,
               SpacesInFunctionDeclarations.new ] # FIXME: add all rule classes
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

