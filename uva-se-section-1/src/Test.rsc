module Test

import IO;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

public M3 model = createM3FromEclipseProject(|project://SystemUnderTest|);
public set[Declaration] declarations = createAstsFromEclipseProject(|project://SystemUnderTest|, true);

public set[Declaration] checkAst() {
	Declaration = declarations[0];
}
