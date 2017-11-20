module DuplicationTest

import Duplication;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import String;
import Set;
import List;

public set[Declaration] ast = createAstsFromEclipseProject(|project://regression-set|, true);

public list[Declaration] getTestClassBody() {
visit (ast) {
	case \class(name,_, _,body): if(name == "DuplicationVariants") return body;
	}
}

test bool shouldFilterOutMethod() {
	return size(filterMethods([<"long", ["1", "2", "3", "4", "5", "6"]>, <"short", ["1", "3"]>], 6)) == 1;
}

test bool shouldNotFilterMultiple() {
	return size(filterMethods([<"long", ["1", "2", "3", "4", "5", "6"]>, <"short", ["1", "2", "3", "4", "5", "6"]>], 6)) == 2;
}

test bool shouldMakeThreeBlocks() {
	return size(makeBlocks([<"ah", ["1", "2", "3", "4", "5", "6", "7", "8"]>], 6)[0][1]) == 3;
}

test bool shouldMakeNoBlocks() {
	return size(makeBlocks([<"ah", ["1", "2", "3", "4", "5"]>], 6)[0][1]) == 0;
}

test bool shouldCountThreeOccurences() {	
	list[tuple[str, loc]] methods = [<M.name, M.src> | /M:method(_, _, _, _, _) <- getTestClassBody() || /M:constructor(_, _, _, _) <- getTestClassBody()];	
	
	detectClones(methods);
	
	return true;
}