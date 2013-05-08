require_relative("../lib/fashion_police")

describe FashionPolice do
  it "probably should have integration specs"
    # because these rules could work in isolation while colliding in combination
    # base them on the examples in https://github.com/rwldrn/idiomatic.js/

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

    describe "puts spaces before function definitions" do

      before do
        @rule = FashionPolice::SpacesInFunctionDeclarations.new
      end

      it "(positive case)" do
        @rule.test("function() { return true; }").should be_true
      end

      it "(negative case)" do
        @rule.test("function (){ return true; }").should be_false
      end

    end

    it "allows some leeway for functions invoking anonymous functions" do
      @rule = FashionPolice::SpacesInFunctionDeclarations.new
      @rule.test("foo(function() {});").should be_true
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

    describe "puts spaces before angle brackets" do

      before do
        @rule = FashionPolice::SpacesBeforeAngleBrackets.new
      end

      it "(positive case)" do
        @rule.test("function( arg ) { return true; }").should be_true
      end

      it "(negative case)" do
        @rule.test("function( arg ){ return true; }").should be_true
      end

    end

    it "allows some leeway when giving a function an object without spaces" do
      @rule = FashionPolice::SpacesBeforeAngleBrackets.new
      @rule.test("    foo({").should be_true
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

    it "makes an exception for parentheses around square brackets" do
      @rule = FashionPolice::SpacesAroundArgumentsInParens.new
      @rule.test("foo([ 'alpha', 'beta' ]);").should be_true
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

    describe "allows hashes, un-preceded by spaces, as arguments to functions" do

      it "(positive case)" do
        @rule = FashionPolice::SpacesAroundArgumentsInParens.new
        @rule.test("var fooBar = new FooBar({ a : 'alpha' });").should be_true
      end

      it "(negative case)" do
        @rule = FashionPolice::SpacesAroundArgumentsInAngleBrackets.new
        @rule.test("var fooBar = new FooBar({a : 'alpha'});").should be_false
      end

    end

    it "makes an exception for function invocations with parentheses around square brackets" do
      @rule = FashionPolice::SpacesAroundArgumentsInParens.new
      @rule.test("foo([ 'alpha', 'beta' ]);").should be_true
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

      it "(positive cases)" do
        @rule.test("var factorial = function factorial( number ) {").should be_true
        @rule.test("function FooBar( options ) {").should be_true
      end

      it "(negative cases)" do
        @rule.test("var factorial = function factorial(number){").should be_false
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

  describe "limits column width to 80 characters" do

    before do
      @rule = FashionPolice::ColumnWidth.new
    end

    it "(positive case)" do
      @rule.test("sdfasdfasdf").should be_true
    end

    it "(negative case)" do
      too_big = "                                                                                  "
      @rule.test(too_big).should be_false
    end

  end

end
