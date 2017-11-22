module Serie1

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import String;
import util::Math;
import util::Resources;

import CyclomaticComplexityAst;
import LinesOfCode;


public list[loc] allFiles(loc project){
	//return [f | /file(f) := getProject(project), f.extension == "java", /^.*\/hsqldb\/(src|integration)\/.*/ := f.path];

	return [f | /file(f) := getProject(project), f.extension == "java"];
}

public void runOnSe1(){
	run(|project://uva-se-section-1/src|);
}

public void runModelOnRegressionSet(){
	set[Declaration] astTest = createAstsFromEclipseProject(|project://regression-set|, true);
	M3 modelTest = createM3FromEclipseProject(|project://regression-set|);
	calcSigModel(modelTest, astTest);
}

public void runSmallSql(){
	M3 model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	run(|project://smallsql0.21_src|);
}

public void runHsqlDb() {
	run(|project://hsqldb-2.3.1|);
}

public void run(loc project){
	M3 model = createM3FromEclipseProject(project);
	set[Declaration] ast = createAstsFromEclipseProject(project, true);
	calcSigModel(allFiles(project), ast);
}

//Missing calulations. But all the data needed is here.
public void calcSigModel(list[loc] files, set[Declaration] ast){
	
	int totalLinesOfCode = classesLoc(files);
	println("Total Lines of Code: <totalLinesOfCode>");
	println("Volume: <volumeRanking(totalLinesOfCode)>");
	println();
	//CyclomaticComplexity build up <methodName, Complexity, methodLOC, LocationMethod>
	lrel[str,int,int,loc] methods = complexityPerMethod(ast);
	
	println("Cyclomatic complexity: ");
	println("Comlexity: <systemComplexityRanking(toReal(totalLinesOfCode), relativeComplexity(methods))>");
	println();
	//Unit size
	println("Unit size");
	println("Unit size: <systemComplexityRanking(toReal(totalLinesOfCode), relativeUnitSize(methods))>");
	println();
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
	
	real c1 = comlexityMethods[0] / linesOfCode;
	real c2 = comlexityMethods[1] / linesOfCode;
	real c3 = comlexityMethods[2] / linesOfCode;	
	real c4 = comlexityMethods[3] / linesOfCode;
	
	println("|low		| <c1>");
	println("|moderate	| <c2>");
	println("|high		| <c3>");
	println("|very high	| <c4>");
	
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

public list[int] relativeComplexity(lrel[str,int,int,loc] methods){
	list[int] complexityRanking = [0,0,0,0];

	for(<_,complexity, linesOfCode,_> <- methods){
		complexityRanking[riskEvaluationMethod(complexity)] += linesOfCode;
	}
	
	return complexityRanking;
}

public list[int] relativeUnitSize(lrel[str,int,int,loc] methods){
	list[int] unitSizeRanking = [0,0,0,0];

	for(<_,_, linesOfCode,_> <- methods){
		unitSizeRanking[riskEvaluationMethod(linesOfCode)] += linesOfCode;
	}
	
	return unitSizeRanking;
}

public int riskEvaluationMethod(int complexity){
	if(complexity <= 10){
		return 0;
	}else if(complexity >= 11 && complexity <= 20){
		return 1;
	}else if(complexity >= 21 && complexity <= 50){
		return 2;
	}else {
		return 3;
	}
}
