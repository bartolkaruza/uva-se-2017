module CyclomaticComplexity

import util::FileSystem;
import lang::java::\syntax::Disambiguate;
import lang::java::\syntax::Java15;
import ParseTree;

set[MethodDec] allMethods(loc file) = {m | /MethodDec m := parse(#start[CompilationUnit], file)};

public int methodComplexity(MethodDec m) {
	result = 1;
	visit (m) {
		case (Stm)`if (<Expr _>) <Stm _>`: result +=1;
		case (Stm)`do <Stm _> while (<Expr _>);`: result += 1;
	}
	return result;
}

public list[int] allMethodComplexities() {
	return [ methodComplexity(x) | MethodDec x <- allMethods(|project://SystemUnderTest/src/EntryPoint.java|) ];
}

public int averageComplexity() {
	return sum(allMethodComplexities()) / size(allMethodComplexities());
}
