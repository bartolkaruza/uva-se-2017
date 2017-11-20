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
import util::Math;

import CyclomaticComplexityAst;
import LinesOfCode;

import util::Resources;

public list[loc] allFiles(){
	projectLoc = getProject(|project://smallsql0.21_src/src/smallsql|);

	return [f | /file(f) := projectLoc, f.extension == "java"];
}


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
	
	int totalLinesOfCode = classesLoc(allFiles());
	println("Total Lines of Code: <totalLinesOfCode>");
	println("Volume: <volumeRanking(totalLinesOfCode)>");
	
	////CyclomaticComplexity build up <methodName, Complexity, methodLOC, LocationMethod>
	////lrel[str,int,int,loc] methods = complexityPerMethod(ast);
	//list[int] complexity = complexitySystem(ast);
	//println("Cyclomatic complexity: ");
	//println("Comlexity: <systemComplexityRanking(toReal(totalLinesOfCode), complexity)>");
	
	//Unit size
	//for(<str name, _,int linesOfCode, _> <- methods){
	//	println("unit: <name> size: <linesOfCode>");
	//}
}

public str volumeRanking(int linesOfCode){
	if(linesOfCode <= 66000){
		return "++";
	}else if(linesOfCode >= 67000 && linesOfCode <= 246000){
		return "+";
	}else if(linesOfCode >= 247000 && linesOfCode <= 665000){
		return "o";
	}else if(linesOfCode >= 666000 && linesOfCode <= 1310000){
		return "-";
	}else {
		return "--";
	}
}

public str systemComplexityRanking(real linesOfCode, list[int] comlexityMethods){
	
	//real c1 = comlexityMethods[0] / linesOfCode;
	real c2 = comlexityMethods[1] / linesOfCode;
	real c3 = comlexityMethods[2] / linesOfCode;	
	real c4 = comlexityMethods[3] / linesOfCode;
	
	println("moderate: <c2>, high: <c3>, very high: <c4>");
	
	if(c2 <= 0.20 && c3 <= 0.0 && c4 <= 0.0){
		return "++";
	}else if(c2 <= 0.30 && c3 <= 0.05 && c4 <= 0.0){
		return "+";
	}else if(c2 <= 0.40 && c3 <= 0.1 && c4 <= 0.0){
		return "o";
	}else if(c2 <= 0.50 && c3 <= 0.15 && c4 <= 0.05){
		return "-";
	}else {
		return "--";
	}
}
