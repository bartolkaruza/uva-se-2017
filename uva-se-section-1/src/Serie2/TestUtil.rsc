module Serie2::TestUtil

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

public map[node, set[loc]] findDuplicatesForClasses(list[str] classNames) {
	map[node, set[loc]] duplicates = ();
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	declarations = [];
	visit (ast) {
		case C:class(className, _, _, decl): {
			if(lastIndexOf(classNames, className) != -1) {
				declarations += decl;
			}
		}
	}
	duplicates = findType2Duplicates(toSet(declarations), Type1);
	for(d <- duplicates) {
		if(size(duplicates[d]) > 1) {
			println(duplicates[d]);
			println();
		}
	}
	return duplicates;
}

public map[node, set[loc]] findDuplicatesForClass(str className) {
	map[node, set[loc]] duplicates = ();
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	visit (ast) {
		case C:class(className, _, _, decl): {
			duplicates = findType2Duplicates(toSet(decl), Type1);
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

public map[node, set[loc]] findDuplicatesForClassType2(str className) {
	map[node, set[loc]] duplicates = ();
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	visit (ast) {
		case C:class(className, _, _, decl): {
			duplicates = findType2Duplicates(toSet(decl), Type2);
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

public list[node] getBlockFromMethod(str methodName) {
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	list[node] foundBlock = [];
	top-down-break visit (ast) {
		case M:method(_, methodName, _, _, block): foundBlock += block;
	}
	return foundBlock;
	
}

public int countDuplicates(map[value, set[loc]] nodes) {
	int duplicateClasses = 0;
	for(d <- nodes) {
		if(size(nodes[d]) > 1) {
			duplicateClasses += 1;
		}
	}
	return duplicateClasses;
}