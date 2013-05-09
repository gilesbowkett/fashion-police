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
      return false if string.match(/function\s+\(.*\)\{/)
      return true if string.match(/function\s+\(.*\)\s+\{/)
      return true
    end

    def error_message
      "Put spaces in function declarations"
    end
  end

  class SpacesAroundElses
    def test(string)
      return true if string.match(/} else {/)
      return false if string.match(/}else{/)
      return false if string.match(/} +else{/)
      return false if string.match(/}else +{/)
      return false if string.match(/} +else ?{/)
      return false if string.match(/} ?else +{/)
      return true
    end

    def error_message
      "Put spaces around elses"
    end
  end

  class SpacesAroundEqualsSigns
    def test(string)
      return true if string.match(/ = /)
      return false if string.match(/\S=[^=]/)
      return true
    end

    def error_message
      "Put spaces around equals signs"
    end
  end

  class SpacesAroundArgumentsInForLoops
    def test(string)
      return false if string.match(/for\(\S+\s+[^\)]+\)/)
      return true
    end

    def error_message
      "Put spaces around for loop arguments"
    end
  end

  class SpacesAroundArgumentsInParens
    def test(string)
      return true if string.match(/\( .* \)/)
      return true if string.match(/\S*\(function\(/)
      return true if string.match(/\S+\(["'].*["']\)/)
      return false if string.match(/\(\S+\)/)

      return true
    end

    def error_message
      "Put spaces around arguments inside parentheses"
    end
  end

  class SpacesBeforeAngleBrackets
    def test(string)
      return true if string.match(/(\S+ )?\{/)
      return false if string.match(/\S\{/)

      return true
    end

    def error_message
      "Put spaces in front of angle brackets"
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

  class SpacesAroundArgumentsInFunctionDeclarations
    def test(string)
      return true if string.match(/function( .+)?\( [^\)]+ \)/)
      return false if string.match(/function( .+)?\([^\)]+\)/)
      return true
    end

    def error_message
      "Put spaces around for loop arguments"
    end
  end

  class ColumnWidth
    def test(string)
      string.length <= 80
    end

    def error_message
      "Maximum text width: 80 characters"
    end
  end

  class BadCode < Exception; end

  def initialize
    @errors = []
    @rules = [ SpacesNotTabs.new,
               # FourSpaces.new,
               SpacesInFunctionDeclarations.new,
               SpacesAroundElses.new,
               SpacesAroundEqualsSigns.new,
               SpacesAroundArgumentsInForLoops.new,
               SpacesAroundArgumentsInParens.new,
               SpacesBeforeAngleBrackets.new,
               SpacesAroundArgumentsInAngleBrackets.new,
               SpacesAroundArgumentsInSquareBrackets.new,
               SpacesAroundArgumentsInFunctionDeclarations.new,
               ColumnWidth.new ]
  end

  def investigate(code)
    code.split("\n").each_with_index do |line, index|
      next if comment?(line)
      line_number = index + 1
      raise(BadCode) unless permit?(line_number, line)
    end
  end

  def comment?(line)
    line.match(/^ *\/\//)
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

