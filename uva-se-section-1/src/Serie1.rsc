module Serie1

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import Map;
import String;
import util::Math;
import util::Resources;

import CyclomaticComplexityAst;
import LinesOfCode;
import DuplicationSimple;
import UnitInterfacing;


public list[loc] allFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java", /^.*\/hsqldb\/(src|integration)\/.*/ := f.path];

	return [f | /file(f) := getProject(project), f.extension == "java"];
}

public void runOnSe1(){
	run(|project://uva-se-section-1/src|);
}

public void runModelOnRegressionSet(){
	set[Declaration] astTest = createAstsFromEclipseProject(|project://regression-set|, true);
	//M3 modelTest = createM3FromEclipseProject(|project://regression-set|);
	calcSigModel(modelTest, astTest);
}

public void runSmallSql(){
	//M3 model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	run(|project://smallsql0.21_src|);
}

public void runHsqlDb() {
	run(|project://hsqldb-2.3.1|);
}

public void run(loc project){
	//M3 model = createM3FromEclipseProject(project);
	set[Declaration] ast = createAstsFromEclipseProject(project, true);
	calcSigModel(allFiles(project), ast);
}

//Missing calulations. But all the data needed is here.
public void calcSigModel(list[loc] files, set[Declaration] ast){
	
	int totalLinesOfCode = classesLoc(files);
	println("Total Lines of Code: <totalLinesOfCode>");
	volumeResult = volumeRanking(totalLinesOfCode);
	println("Volume: <volumeResult>");
	println();
	//CyclomaticComplexity build up <methodName, Complexity, methodLOC, LocationMethod>
	lrel[str,int,int,loc] methods = complexityPerMethod(ast);
	
	println("Cyclomatic complexity: ");
	complexityResult = systemComplexityRanking(toReal(totalLinesOfCode), relativeComplexity(methods));
	println("Comlexity: <complexityResult>");
	println();
	//Unit size
	println("Unit size:");
	unitSizeResult = systemComplexityRanking(toReal(totalLinesOfCode), relativeUnitSize(methods));
	println("Unit size: <unitSizeResult>");
	println();
	
	//Duplicate
	println("Duplicates:");
	numberOfDuplicates = toReal(duplicateLoc(files));
	println("Number of duplicates: <numberOfDuplicates> percentage <numberOfDuplicates/toReal(totalLinesOfCode)>");
	duplicationResult = duplicationRanking(numberOfDuplicates/toReal(totalLinesOfCode));
	println("rating: <duplicationResult>");
	println();
	
	println("Unit interfacing:");
	interfaces = unitInterfacing(ast);
	println("Number of interfaces: <size(interfaces)>");
	println();
	
	println("| Volume 	| <volumeResult>");
	println("| Comlexity	| <complexityResult>");
	println("| Unit size	| <unitSizeResult>");
	println("| Duplicates	| <duplicationResult>");
	println();
	sigToIsoModel(complexityResult, unitSizeResult, volumeResult, duplicationResult);
}

public void sigToIsoModel(str complexity, str unitSize, str linesOfCode, str duplication){
	t = ("--":1, "-":2, "o":3, "+":4, "++":5);
	c = t[complexity];
	u = t[unitSize];
	v = t[linesOfCode];
	d = t[duplication];
	
	analysability = (v + u + d)/3;
	changeability = (c + d)/2;
	//stability = ()/2;
	testability = (c + u)/2;
	tInverted = invert(t);
	
	println("| analysability	| <tInverted[analysability]>");
	println("| changeability 	| <tInverted[changeability]>");
	println("| stability 		");
	println("| testability 		| <tInverted[testability]>");
	
}

public str volumeRanking(int linesOfCode){
	if(linesOfCode <= 66000){
		return "++";
	} 
	if(linesOfCode > 66000 && linesOfCode <= 246000){
		return "+";
	}
	if(linesOfCode > 246000 && linesOfCode <= 665000){
		return "o";
	}
	if(linesOfCode > 665000 && linesOfCode <= 1310000){
		return "-";
	}
	return "--";
}


public str unitInterfacing(real linesOfCode, list[int] comlexityMethods){
	
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

public str systemComplexityRanking(real linesOfCode, list[int] comlexityMethods){
	
	real c1 = comlexityMethods[0] / linesOfCode;
	real c2 = comlexityMethods[1] / linesOfCode;
	real c3 = comlexityMethods[2] / linesOfCode;	
	real c4 = comlexityMethods[3] / linesOfCode;
	
	println("| low		| <c1>");
	println("| moderate	| <c2>");
	println("| high		| <c3>");
	println("| veryhigh	| <c4>");
	
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
		complexityRanking[riskEvaluationComplexity(complexity)] += linesOfCode;
	}
	
	return complexityRanking;
}

public list[int] relativeUnitSize(lrel[str,int,int,loc] methods){
	list[int] unitSizeRanking = [0,0,0,0];

	for(<_,_, linesOfCode,_> <- methods){
		unitSizeRanking[riskEvaluationUnitSize(linesOfCode)] += linesOfCode;
	}
	
	return unitSizeRanking;
}

public list[int] relativeUnitInterfacing(lrel[str,int,int] interfaces){
	list[int] unitInterfacingRanking = [0,0,0];

	for(<_,numberOfParams, linesOfCode> <- methods){
			
			if(numberOfParams > 2){
				unitInterfacingRanking[0] += linesOfCode;
			}
			if(numberOfParams > 4){
				unitInterfacingRanking[1] += linesOfCode;
			}
			if(numberOfParams > 6){
				unitInterfacingRanking[2] += linesOfCode;
			}
	
	}
	
	return unitInterfacingRanking;
}

public int riskEvaluationInterface(int numberOfParams){
	if(complexity > 2){
		return 0;
	}
	if(complexity > 5){
		return 1;
	}
	if(complexity > 7){
		return 2;
	}
	return 3;
}

// Threshold values are kept the samme as complexity,
// because they are not specified by the paper
public int riskEvaluationUnitSize(int linesOfCode) {
	if(linesOfCode <= 10) {
		return 0;
	}else if(linesOfCode <= 20) {
		return 1;
	}else if(linesOfCode <= 50) {
		return 2;
	}else {
		return 3;
	}
}

public int riskEvaluationComplexity(int complexity){
	if(complexity <= 10){
		return 0;
	}else if(complexity > 10 && complexity <= 20){
		return 1;
	}else if(complexity > 20 && complexity <= 50){
		return 2;
	}else {
		return 3;
	}
}

public str duplicationRanking(real duplication){
	if(duplication <= 0.03){
		return "++";
	}else if(duplication > 0.03 && duplication <= 0.05){
		return "+";
	}else if(duplication > 0.05 && duplication <= 0.10){
		return "o";
	}else if(duplication > 0.10 && duplication <= 0.20){
		return "-";
	}else {
		return "--";
	}
}
