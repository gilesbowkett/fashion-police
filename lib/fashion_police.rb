class FashionPolice
  attr_reader :errors
  attr_accessor :rules

  def initialize
    @errors = []
    @rules = [ lambda {|string| string != "\t"} ]
  end

  def permit?(string)
    @rules.inject(true) do |memo, rule|
      memo = false unless rule[string]
      memo
    end
  end
end

