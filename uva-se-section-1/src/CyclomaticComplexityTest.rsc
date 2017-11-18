module CyclomaticComplexityTest

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import String;
import CyclomaticComplexityAst;
import lang::java::\syntax::Disambiguate;
import lang::java::\syntax::Java15;

public M3 model = createM3FromEclipseProject(|project://regression-set|);
public set[Declaration] ast = createAstsFromEclipseProject(|project://regression-set|, true);

public list[Declaration] getTestClassBody() {
visit (ast) {
	case \class(name,_, _,body): if(name == "CyclomaticVariants") return body;
	}
}

test bool shouldReturnRightComplexityForVariants() {
	 return !(false in mapper(complexityPerMethod(toSet(getTestClassBody())), testMethod));
}

bool testMethod(tuple[str, int, int, loc] method) {
	switch(method[0]) {
	 	case "switchStatement": return checkValue(method, 3);
	 	case "tryCatch": return checkValue(method, 2);
	 	case "ifStatement": return checkValue(method, 2);
	 	case "ifNonConditionalElseStatement": return checkValue(method, 3);
	 	case "ifElseStatement": return checkValue(method, 3);
	 	case "whileLoop": return checkValue(method, 2);
	 	case "doWhileLoop": return checkValue(method, 2);
	 	case "infixAnd": return checkValue(method, 2);
	 	case "infixOr": return checkValue(method, 2);
	 	case "infixAndInIf": return checkValue(method, 3);
	 	case "infixOrInIf": return checkValue(method, 3);
	 	case "forLoop": return checkValue(method, 2);
	 	case "enhancedForLoop": return checkValue(method, 2);
	 	case "conditional": return checkValue(method, 2);
	 	case "nestedComplexity": return checkValue(method, 12);
	 }
	 print("method not tested yet: " + method[0] + " ");
	 println(method[1]); 
	 return false;
}

bool checkValue(tuple[str, int, int, loc] method, int expected) {
	bool result = method[1] == expected;
	if(!result) {
		print("failed " + method[0] + "at: " + method[3] + "expected: ");
	 	print(expected);
	 	print(" received: ");
	 	print(method[1]);
	}
	return result;
}
