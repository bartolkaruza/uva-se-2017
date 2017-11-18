module CyclomaticComplexitTest

import IO;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import LinesOfCode;

public M3 model = createM3FromEclipseProject(|project://regression-set|);
public set[Declaration] ast = createAstsFromEclipseProject(|project://regression-set|, true);

test boolean epShouldCorrectlyTestMethodLOC() {
	//methodLoc(Declaration = declarations[0];
}
