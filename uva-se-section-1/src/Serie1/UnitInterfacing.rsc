module Serie1::UnitInterfacing

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import Map;
import String;
import util::Math;
import util::Resources;
import Serie1::LinesOfCode;

//public set[Declaration] ast = {createAstFromFile(|project://example/src/regression/UnitInterfacingVariants.java|, true)};

public lrel[str, int, int] unitInterfacing(set[Declaration] ast){

	allMethods = [<n, size(l), locationLoc(M.src)> | /M:method(_, str n, l, _, i) := ast || /M:constructor(str n, l, _, i) := ast, size(l)>2];								
	
	return allMethods;
}