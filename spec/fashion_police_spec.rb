require_relative("../lib/fashion_police")

describe FashionPolice do
  it "probably should have integration specs"

  describe "provides a tool which" do

    before do
      @fashion_police = FashionPolice.new
      @bad_code = <<-BAD_CODE
    function (argument) {
      console.log('wrong indentation style');
    }
      BAD_CODE
    end

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

  describe "enforces a coding style which" do

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

    describe "puts spaces in function declarations" do

      before do
        @rule = FashionPolice::SpacesInFunctionDeclarations.new
      end

      it "(positive case)" do
        @rule.test("function () { return true; }").should be_true
      end

      it "(negative case)" do
        @rule.test("function(){ return true; }").should be_false
      end

    end

    describe "puts spaces around arguments in parentheses" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInParens.new
      end

      it "(positive case)" do
        @rule.test("function( arg ){ return true; }").should be_true
      end

      it "(negative case)" do
        @rule.test("function(arg){ return true; }").should be_false
      end

    end

    describe "puts spaces around arguments in angle brackets" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInAngleBrackets.new
      end

      it "(positive case)" do
        @rule.test("function( arg ){ return true; }").should be_true
      end

      it "(negative case)" do
        @rule.test("function( arg ){return true;}").should be_false
      end

    end

    describe "puts spaces around arguments in square brackets" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInSquareBrackets.new
      end

      it "(positive case)" do
        @rule.test("function( arg ){ return [ 0 ]; }").should be_true
      end

      it "(negative case)" do
        @rule.test("function( arg ){ return [0]; }").should be_false
      end

    end

    describe "puts spaces before and after colons" do

      before do
        @rule = FashionPolice::SpacesAroundColons.new
      end

      it "(positive case)" do
        @rule.test("foo : bar").should be_true
      end

      it "(negative case)" do
        @rule.test("foo:bar").should be_false
      end

    end

    describe "puts spaces around args to ifs" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInParens.new
      end

      it "(positive case)" do
        @rule.test("if ( condition ) {").should be_true
      end

      it "(negative case)" do
        @rule.test("if(condition){").should be_false
      end

    end

    describe "puts spaces around args to ifs" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInParens.new
      end

      it "(positive case)" do
        @rule.test("if ( true ) {").should be_true
      end

      it "(negative case)" do
        @rule.test("if(true){").should be_false
      end

    end

    describe "puts spaces around elses" do

      before do
        @rule = FashionPolice::SpacesAroundElses.new
      end

      it "(positive case)" do
        @rule.test("} else {").should be_true
      end

      it "(negative cases)" do
        @rule.test("}else{").should be_false
        @rule.test("} else{").should be_false
        @rule.test("}else {").should be_false
        @rule.test("} else  {").should be_false
        @rule.test("}  else {").should be_false
      end

    end

  end

end
