module Serie1::LinesOfCodeTest

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import LinesOfCode;
import IO;

list[loc] testData = [|project://regression-set/src/regression/LinesOfCodeVariants.java|];
M3 model = createM3FromFile(|project://regression-set/src/regression/LinesOfCodeVariants.java|);

test bool testClassesLoc() {
	int result = classesLoc(testData);
	return result == 52;
}

test bool testMethodLoc() {
	for(loc x <- methods(model)){
		bool result = testMethod(x, locationLoc(x));
		if(!result)
			return false;
	}
	return true;
}

bool testMethod(loc method, int size){

	rel[loc, int] allMethods = {
	  <|java+constructor:///regression/LinesOfCodeVariants/InnerClass/InnerClass()|, 4>, // seems like a bug
	  <|java+constructor:///regression/LinesOfCodeVariants/LinesOfCodeVariants()|, 4>, // seems like a bug
	  <|java+method:///regression/LinesOfCodeVariants/InnerClass/innerMethod()|, 2>,
	  <|java+method:///regression/LinesOfCodeVariants/abstractMethod()|, 1>, // seems like a bug
	  <|java+method:///regression/LinesOfCodeVariants/commentStyle1()|, 4>,
	  <|java+method:///regression/LinesOfCodeVariants/commentStyle2()|, 4>,
	  <|java+method:///regression/LinesOfCodeVariants/commentStyle3()|, 4>,
	  <|java+method:///regression/LinesOfCodeVariants/commentStyle4()|, 4>,
	  <|java+method:///regression/LinesOfCodeVariants/commentStyle5()|, 4>,
	  <|java+method:///regression/LinesOfCodeVariants/commentStyle6()|, 4>,
	  <|java+method:///regression/LinesOfCodeVariants/methodVariant1()|, 3>,
	  <|java+method:///regression/LinesOfCodeVariants/methodVariant2()|, 5>,
	  <|java+method:///regression/LinesOfCodeVariants/staticMethod()|, 4>
	};
	
	if(size in allMethods[method])  
  		return true;
  	
	println("Failed for method: <method> Expected: <allMethods[method]> Got: <size>");
	return false;
}