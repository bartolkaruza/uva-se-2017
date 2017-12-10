module Serie2::Type2Test

import IO;
import String;
import List;
import lang::java::jdt::m3::AST;

import Serie2::DuplicationType2;

test bool shouldFind2Classes() {
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	map[value, set[loc]] duplicates = ();
	set[value] coveredChildNodes = {};
	visit (ast) {
		case C:class(n:"Clones", _, _, decl): findType2Duplicates(toSet(decl), duplicates, coveredChildNodes);
	}
	println(duplicates);
	//println(ast);
	//set[Declaration] classAst = {<C> | /C:class(str n, _, _, set[Declaration] cast, _) <- ast};
	
	//println(classAst);
	return false;
}