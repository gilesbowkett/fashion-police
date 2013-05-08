require_relative("../lib/fashion_police")

describe FashionPolice do
  it "probably should have integration specs"
    # because these rules could work in isolation while colliding in combination

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

    describe "puts spaces around args to whiles" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInParens.new
      end

      it "(positive case)" do
        @rule.test("while ( condition ) {").should be_true
      end

      it "(negative case)" do
        @rule.test("while(condition){").should be_false
      end

    end

    describe "puts spaces around args to for loops which go through array elements" do

      it "(positive case)" do
        @rule = FashionPolice::SpacesAroundArgumentsInParens.new
        @rule.test("for ( prop in object ) {").should be_true
      end

      it "(negative case)" do
        @rule = FashionPolice::SpacesAroundArgumentsInForLoops.new
        @rule.test("for(prop in object){").should be_false
      end

    end

    describe "puts spaces around args to iterating for loops" do

      it "(positive case)" do
        @rule = FashionPolice::SpacesAroundArgumentsInParens.new
        @rule.test("for ( var i = 0; i < 100; i++ ) {").should be_true
      end

      it "(negative case)" do
        @rule = FashionPolice::SpacesAroundArgumentsInForLoops.new
        @rule.test("for(var i=0;i<100;i++) {").should be_false
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

    describe "puts spaces around anonymous function args" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInFunctionDeclarations.new
      end

      it "(positive case)" do
        @rule.test("var square = function( number ) {").should be_true
      end

      it "(negative cases)" do
        @rule.test("var square = function(number){").should be_false
      end

    end

    describe "puts spaces around named function args" do

      before do
        @rule = FashionPolice::SpacesAroundArgumentsInFunctionDeclarations.new
      end

      it "(positive case)" do
        @rule.test("var factorial = function factorial( number ) {").should be_true
      end

      it "(negative cases)" do
        @rule.test("var factorial=function factorial(number){").should be_false
      end

    end

    describe "puts spaces around equals signs" do

      before do
        @rule = FashionPolice::SpacesAroundColonsAndEqualsSigns.new
      end

      it "(positive case)" do
        @rule.test("var square = function( number ) {").should be_true
      end

      it "(negative cases)" do
        @rule.test("var square=function( number ){").should be_false
      end

    end

    describe "puts spaces before and after colons" do

      before do
        @rule = FashionPolice::SpacesAroundColonsAndEqualsSigns.new
      end

      it "(positive case)" do
        @rule.test("foo : bar").should be_true
      end

      it "(negative case)" do
        @rule.test("foo:bar").should be_false
      end

    end

  end

end
