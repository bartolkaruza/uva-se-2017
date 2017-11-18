module Serie1

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import String;
import List;
import Exception;

import CyclomaticComplexityAst;
import LinesOfCode;

public void runModelOnRegressionSet(){
	set[Declaration] astTest = createAstsFromEclipseProject(|project://regression-set|, true);
	M3 modelTest = createM3FromEclipseProject(|project://regression-set|);
	calcSigModel(modelTest, astTest);
}

public void runSmallSql(){
	set[Declaration] ast = createAstsFromEclipseProject(|project://smallsql0.21_src/src/smallsql|, true);
	M3 model = createM3FromEclipseProject(|project://smallsql0.21_src/src/smallsql|);
	calcSigModel(model, ast);
}

public void runHsqlDb() {
	set[Declaration] ast = createAstsFromEclipseProject(|project://hsqldb-2.3.1/src/org.hsqldb|, true);
	M3 model = createM3FromEclipseProject(|project://hsqldb-2.3.1/src/org.hsqldb|);
	calcSigModel(model, ast);
}

//Missing calulations. But all the data needed is here.
public void calcSigModel(M3 model, set[Declaration] ast){
	
	//Total lines of code
	set[loc] allCompilationUnits = {};
	
	rel[loc,loc] invertedContainment = invert(model.containment);
	for(c <- classes(model)){
		allCompilationUnits += invertedContainment[c];
	}
	

	
	int totalNumberOfLines = 0;
	
	for(x <- allCompilationUnits){
		int linesOfCodePerClass = classLoc(x);
		println("LOC <linesOfCodePerClass> : <x>");
		totalNumberOfLines += linesOfCodePerClass;
	}
	
	println("Total Lines of Code: <totalNumberOfLines>");
	
	//CyclomaticComplexity build up <methodName, Complexity, methodLOC, LocationMethod>
	lrel[str,int,int,loc] methods = complexityPerMethod(ast);
	println("Cyclomatic complexity: ");
	
	for(x <- methods){
		println(x);
	}
	
	//Unit size
	for(<str name, _,int linesOfCode, _> <- methods){
		println("unit: <name> size: <linesOfCode>");
	}
}
