module Serie2::Type2Test

import IO;
import String;
import List;
import Set;
import Relation;
import Map;
import Node;
import lang::java::jdt::m3::AST;
import lang::java::m3::TypeHierarchy;

import Serie2::DuplicationType2;

public test bool shouldFind2Classes() {
	return countDuplicates(findDuplicatesForClass("Clones")) == 3;
}

test bool shouldIterateSublists() {
	map[node, set[loc]] nodes = ();
	nodes = iterateSublists(nodes, getChildren(getOneFrom(getBlockFromMethod("ShouldFindSingleClass"))));
	
	//println(nodes);
	
	//println(size(nodes));;
	for(n <- nodes) {
		println(getOneFrom(nodes[n]));
	}
	////println(iterateSublists(nodes, getChildren(getOneFrom(nodes))));
	return false;
}

test bool shouldFindSingleClassOnMultiline() {
	return countDuplicates(findDuplicatesForClass("ShouldFindSingleClass")) == 1;
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



map[node, set[loc]] findDuplicatesForClass(str className) {
	map[node, set[loc]] duplicates = ();
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	visit (ast) {
		case C:class(className, _, _, decl): {
			duplicates = findType2Duplicates(toSet(decl));
		}
	}
	for(d <- duplicates) {
		if(size(duplicates[d]) > 1) {
			println(duplicates[d]);
			println();
		}
	}
	return duplicates;
}

list[node] getBlockFromMethod(str methodName) {
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	list[node] foundBlock = [];
	top-down-break visit (ast) {
		case M:method(_, methodName, _, _, block): foundBlock += block;
	}
	return foundBlock;
	
}

int countDuplicates(map[value, set[loc]] nodes) {
	int duplicateClasses = 0;
	for(d <- nodes) {
		if(size(nodes[d]) > 1) {
			duplicateClasses += 1;
		}
	}
	return duplicateClasses;
}
