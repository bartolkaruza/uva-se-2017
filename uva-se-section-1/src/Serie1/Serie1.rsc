module Serie1::Serie1

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

import Serie1::CyclomaticComplexityAst;
import Serie1::LinesOfCode;
import common::DuplicationSimple;
import Serie1::UnitInterfacing;


public list[loc] allFiles(loc project) {
	return [f | /file(f) := getProject(project), f.extension == "java"];
}

public void runOnSe1(){
	run(|project://uva-se-section-1/src|);
}

public void runModelOnRegressionSet(){
	run(|project://regression-set|);
}

public void runSmallSql(){
	run(|project://smallsql0.21_src|);
}

public void runHsqlDb() {
	run(|project://hsqldb-2.3.1|);
}

public void run(loc project){
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
	int linesOfCodeMethods = 0;
	//CyclomaticComplexity build up <methodName, Complexity, methodLOC, LocationMethod>
	lrel[str,int,int,loc] methods = complexityPerMethod(ast);
	for(<_,_, linesOfCode,_> <- methods){
		linesOfCodeMethods += linesOfCode;	
	}
	println("Cyclomatic complexity: ");
	complexityResult = systemComplexityRanking(toReal(linesOfCodeMethods), relativeComplexity(methods));
	println("Comlexity: <complexityResult>");
	println();
	
	//Unit size
	println("Unit size:");
	unitSizeResult = systemComplexityRanking(toReal(linesOfCodeMethods), relativeUnitSize(methods));
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
	str unitInterfacingResult = unitInterfaceRanking(toReal(linesOfCodeMethods), relativeUnitInterfacing(unitInterfacing(ast)));
	println();
	
	println("| Volume 		| <volumeResult>");
	println("| Comlexity		| <complexityResult>");
	println("| Unit size		| <unitSizeResult>");
	println("| Duplicates		| <duplicationResult>");
	println("| Unit Interfacing	| <unitInterfacingResult>");
	println();
	sigToIsoModel(complexityResult, unitSizeResult, volumeResult, duplicationResult, unitInterfacingResult);
}

public void sigToIsoModel(str complexity, str unitSize, str linesOfCode, str duplication, str unitInterface){
	t = ("--":1, "-":2, "o":3, "+":4, "++":5);
	c = t[complexity];
	u = t[unitSize];
	v = t[linesOfCode];
	d = t[duplication];
	i = t[unitInterface];
	
	analysability = (v + u + d)/3;
	changeability = (c + d)/2;
	//stability = ()/2;
	testability = (c + u)/2;
	reusability = (u + i)/2;
	tInverted = invert(t);
	
	println("| analysability		| <takeOneFrom(tInverted[analysability])[0]>");
	println("| changeability 	| <takeOneFrom(tInverted[changeability])[0]>");
	println("| stability 		|");
	println("| testability 		| <takeOneFrom(tInverted[testability])[0]>");
	println("| reusability		| <takeOneFrom(tInverted[reusability])[0]>");
	
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

public str unitInterfaceRanking(real linesOfCode, list[int] categories){
	
	real c1 = categories[0] / linesOfCode;
	real c2 = categories[1] / linesOfCode;
	real c3 = categories[2] / linesOfCode;
	
	println("| low		| <c1>");
	println("| moderate	| <c2>");
	println("| high		| <c3>");
	
	if(c1 <= 0.05 && c2 <= 0.0 && c3 <= 0.0){
		return "++";
	}else if(c1 <= 0.139 && c2 <= 0.028 && c3 <= 0.008){
		return "+";
	}else if(c1 <= 0.20 && c2 <= 0.05 && c3 <= 0.03){
		return "o";
	}else if(c1 <= 0.40 && c2 <= 0.10 && c3 <= 0.05){
		return "-";
	}else {
		return "--";
	}
}

public list[int] relativeUnitInterfacing(lrel[str,int,int] interfaces){
	list[int] unitInterfacingRanking = [0,0,0];

	for(<_,numberOfParams, linesOfCode> <- interfaces){
			
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


// Threshold values are kept the same as complexity,
// because they are not specified by the paper
public int riskEvaluationUnitSize(int linesOfCode) {
	if(linesOfCode <= 30) {
		return 0;
	}else if(linesOfCode <= 44) {
		return 1;
	}else if(linesOfCode <= 74) {
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
	}else if(duplication <= 0.05){
		return "+";
	}else if(duplication <= 0.10){
		return "o";
	}else if(duplication <= 0.20){
		return "-";
	}else {
		return "--";
	}
}
