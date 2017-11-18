module LinesOfCode

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import String;
import Relation;


// Lines of code is een te grote metric. Als men code op een iets andere manier schrijft zou je de lines of code kunnen veranderen.
// Een method kan je op een lijn schrijven of meerdere lines.
public int methodLoc(loc location){
	return locationLoc(location, 1);
}

public int classesLoc(M3 model) {
	set[loc] allCompilationUnits = {};
	
	int totalNumberOfLines = 0;
	
	rel[loc,loc] invertedContainment = invert(model.containment);
	for(c <- classes(model)){
		allCompilationUnits += invertedContainment[c];
	}
	for(x <- allCompilationUnits) {
		int linesOfCodePerClass = classLoc(x);
		println("LOC < linesOfCodePerClass> : <x>");
		totalNumberOfLines += linesOfCodePerClass;
	}
	return totalNumberOfLines;
}

public int classLoc(loc location){
	return locationLoc(location, 0);
}

public int locationLoc(loc location, int startingCount){
	str content = readFile(location);
	
	return startingCount += lineBreaksLoc(content) - emptySpaceLoc(content) - commentsLoc(content);
}

public int commentsLoc(str file){
	int count = 0;
	
	// Count comments of type '//'
	for(/<w:\n\W*?\/{2,}.*>/ := file)
		count += 1;
				
	// Count comments of type '/* */'
	for(/<w:\/\*[\s\S]*?\*\/\r\n>/ := file)
		count += lineBreaksLoc(w);
	
	return count;
}

public int emptySpaceLoc(str file){
	int count = 0;
	for(/<w:\r\n[\t]*?\r\n>/ := file)
		count += 1;
		
	return count;
}

public int lineBreaksLoc(str file){
	int count = 0;
	for(/\r\n/ := file)
		count += 1;
	return count;
}