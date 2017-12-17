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

import Serie2::TestUtil;

import Serie2::DuplicationType2;

public test bool shouldFind2Classes() {
	return countDuplicates(findDuplicatesForClass("Clones")) == 3;
}

test bool shouldFindType2Classes() {
	return countDuplicates(findDuplicatesForClass("Type2Clones")) == 1;
}

test bool shouldFindSingleClassOnMultiline() {
	return countDuplicates(findDuplicatesForClass("ShouldFindSingleClass")) == 1;
}

test bool cleanNodeForType2Method() {
	return cleanNodeForType2(method(\void(), "name", [], [])) == method(\wildcard(), "", [], []);
}

test bool cleanNodeForType2MethodWithStatement() {
	return cleanNodeForType2(method(\void(), "name", [], [], \block([]))) == method(\wildcard(), "", [], [], \block([]));
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
