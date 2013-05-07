require_relative("../lib/fashion_police")

describe "FashionPolice provides a tool which" do
  before do
    @fashion_police = FashionPolice.new
    @bad_code = <<-BAD_CODE
  function (argument) {
    console.log('wrong indentation style');
  }
    BAD_CODE
  end

  it "takes a file as input"

  it "detects violations of style rules" do
    expect( lambda {@fashion_police.investigate(@bad_code)} ).to raise_error(FashionPolice::BadCode)
  end

  describe "on error" do

    it "keeps track of line number and error message" do
      @fashion_police.permit?(1, '				function(arg){').should be_false
      @fashion_police.errors.should == [{1 => "Use spaces, not tabs"}]
    end

  end

end

describe "FashionPolice enforces a coding style which" do

  it "uses spaces, not tabs" do
    FashionPolice::SpacesNotTabs.new.test("				").should be_false
  end

  describe "uses four spaces per indent" do

    it "at zero levels in" do
      FashionPolice::FourSpaces.new.test("function").should be_true
    end

    it "at 0.5 levels in" do
      FashionPolice::FourSpaces.new.test("  function").should be_false
    end

    it "at one level in" do
      FashionPolice::FourSpaces.new.test("    function").should be_true
    end

    it "at 1.5 levels in" do
      FashionPolice::FourSpaces.new.test("      function").should be_false
    end

    it "at two levels in" do
      FashionPolice::FourSpaces.new.test("        function").should be_true
    end

  end

  describe "puts no spaces in function declarations" do
    before do
      @rule = FashionPolice::NoSpacesInFunctionDeclarations.new
    end

    it "positive case" do
      @rule.test("function(){ return true; }").should be_true
    end

    it "negative case" do
      @rule.test("function (argument) { return true; }").should be_false
    end

  end

  it "puts spaces around arguments in parentheses"

end

