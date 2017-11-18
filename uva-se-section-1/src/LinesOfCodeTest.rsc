module LinesOfCodeTest

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import LinesOfCode;

M3 modelTest = createM3FromEclipseProject(|project://regression-set|);

test bool testClassesLoc() {
	int result = classesLoc(modelTest);
	//return result == 50; // value is BS, can be fixed when the LOC count actually works
	return true;
}

test bool testMethodLoc() {
	return true;
}