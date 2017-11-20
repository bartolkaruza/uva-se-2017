module Duplication

import IO;
import util::Resources;
import List;
import Set;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

Resource project = getProject(|project://regression-set|);
set[Declaration] astTest = createAstsFromEclipseProject(|project://regression-set|, true);

tuple[str, list[str]] readMethodLines(<name, location>) {
	return <name, readFileLines(location)>;
}

public bool variantsDuplication() {

	allMethods = [<M.name, readFileLines(M.src)> | /M:method(_, str n, _, _, i) := astTest || /M:constructor(str n, _, _, i) := astTest];
	
	for(m <- allMethods, size(m[1]) >= 6) {
		println(allMethods[0]);
	}
	
	
	//[f | /file(f) := projectLoc, f.extension == "java"]
	//print(project);
	list[tuple[loc, list[str]]] filesAndLines = [<f, readFileLines(f)> | /file(f) := project, f.extension == "java"];
	
	//for(x <- filesAndLines) {
	//	println(x);
	//}
	
	return true;
}