module DuplicationTest

import DuplicationSimple;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import String;
import Set;
import List;

//public set[Declaration] ast = createAstsFromEclipseProject(|project://regression-set|, true);
public set[Declaration] ast = createAstsFromEclipseProject(|project://hsqldb-2.3.1|, true);

public list[Declaration] getTestClassBody() {
visit (ast) {
	//case \class(name,_, _,body): return body;
	case \class(name,_, _,body): if(name == "DuplicationVariants") return body;
	}
}

test bool shouldCountThreeOccurences() {
	println("result");
	println(totalDuplicatedLines(ast));	
	return true;
}
