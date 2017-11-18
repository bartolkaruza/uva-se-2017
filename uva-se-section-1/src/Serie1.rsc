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


public set[Declaration] ast = createAstsFromEclipseProject(|project://smallsql0.21_src/src/smallsql|, true);
public M3 model = createM3FromEclipseProject(|project://smallsql0.21_src/src/smallsql|);

// Test project
public set[Declaration] astTest = createAstsFromEclipseProject(|project://example|, true);
public M3 modelTest = createM3FromEclipseProject(|project://example|);


public void RunTest(){
	CalcSigModel(modelTest, astTest);
}

public void RunSmallSql(){
	CalcSigModel(model, ast);
}

//Missing calulations. But all the data needed is here.
public void CalcSigModel(M3 model, set[Declaration] ast){
	
	//Total lines of code
	set[loc] allCompilationUnits = {};
	
	rel[loc,loc] invertedContainment = invert(model.containment);
	for(c <- classes(model)){
		allCompilationUnits += invertedContainment[c];
	}
	

	
	int totalNumberOfLines = 0;
	
	for(x <- allCompilationUnits){
		int linesOfCodePerClass = CountLinesOfCodeClass(x);
		println("LOC <linesOfCodePerClass> : <x>");
		totalNumberOfLines += linesOfCodePerClass;
	}
	
	println("Total Lines of Code: <totalNumberOfLines>");
	
	//CyclomaticComplexity build up <methodName, Complexity, methodLOC, LocationMethod>
	lrel[str,int,int,loc] methods = CyclomaticComplexity(ast);
	println("Cyclomatic complexity: ");
	
	for(x <- methods){
		println(x);
	}
	
	//Unit size
	for(<str name, _,int linesOfCode, _> <- methods){
		println("unit: <name> size: <linesOfCode>");
	}
}
