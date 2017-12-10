module Serie2::Type2Test

import IO;
import String;
import List;
import Set;
import Relation;
import Map;
import lang::java::jdt::m3::AST;
import lang::java::m3::TypeHierarchy;

import Serie2::DuplicationType2;

public test bool shouldFind2Classes() {
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	map[value, set[loc]] duplicates = ();
	visit (ast) {
		case C:class(n:"Clones", _, _, decl): {
			duplicates = findType2Duplicates(toSet(decl));
		}
	}
	for(d <- duplicates) {
		if(size(duplicates[d]) > 1){
			println(duplicates[d]);
			println();
		}
	}
	//println(ast);
	//set[Declaration] classAst = {<C> | /C:class(str n, _, _, set[Declaration] cast, _) <- ast};
	
	//println(classAst);
	return false;
}

test bool cleanNodeForType2Method() {
	return cleanNodeForType2(method(\void(), "name", [], [])) == method(\void(), "", [], []);
}

test bool cleanNodeForType2MethodWithStatement() {
	return cleanNodeForType2(method(\void(), "name", [], [], \block([]))) == method(\void(), "", [], [], \block([]));
}

test bool cleanNodeForType2SimpleName() {
	println(cleanNodeForType2(simpleName("name")));
	return cleanNodeForType2(simpleName("name")) == simpleName("");
}

test bool cleanNodeForType2Variable() {
	println(cleanNodeForType2(variable("name", 3)));
	return cleanNodeForType2(variable("name", 3)) == variable("", 3);
}

test bool cleanNodeForType2VariableWithExpression() {
	return cleanNodeForType2(variable("name", 3, \null)) == variable("", 3, \null);
}