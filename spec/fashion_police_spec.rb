require_relative("../lib/fashion_police")

describe "FashionPolice enforces a coding style which" do
  before do
    @fashion_police = FashionPolice.new
  end

  describe "on error" do
    it "returns line number"
    it "returns error message"
  end

  it "takes a file as input"

  it "uses spaces, not tabs" do
    @fashion_police.permit?("	").should be_false
    @fashion_police.errors.should == [{1 => "Use spaces, not tabs"}]
  end

  it "uses four spaces per indent"
    # number_of_spaces % 4 == 0
  it "puts no spaces in function declarations"
  it "puts spaces around arguments in parentheses"
end

