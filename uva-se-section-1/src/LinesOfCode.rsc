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
public int classesLoc(M3 model) {
	set[loc] allCompilationUnits = {};
	
	int totalNumberOfLines = 0;
	
	rel[loc,loc] invertedContainment = invert(model.containment);
	for(c <- classes(model)){
		allCompilationUnits += invertedContainment[c];
	}
	for(x <- allCompilationUnits) {
		int linesOfCodePerClass = locationLoc(x);
		println("LOC < linesOfCodePerClass> : <x>");
		totalNumberOfLines += linesOfCodePerClass;
	}
	return totalNumberOfLines;
}

//public int methodLoc(loc location){
//	return locationLoc(location, 1);
//}
//
//public int classLoc(loc location){
//	return locationLoc(location,0);
//}

//public int locationLocImproved(loc location){
//	list[str] allLines = readFileLines(location);
//	
//	int blanks = size([x| x <- allLines, /^$|^[\s\t]+$/ := x]);
//	
//	int comments = size([x| x <- allLines, /^[\s\t]*?\/{2,}.*/ := x]);
//	
//	// Count comments of type '/* */'
//	file = readFile(location);
//	for(/<w:\/\*[\s\S]*?\*\/\r\n>/ := file)
//		comments += lineBreaksLoc(w);
//
//		
//	return size(allLines) - comments - blanks;
//	//return startingCount += lineBreaksLoc(content) - emptySpaceLoc(content) - commentsLoc(content);
//}

public int locationLoc(loc location){
	list[str] content = readFileLines(location);
	
	return size(content) - emptySpaceLoc(content) - commentsLoc(content, location);
}


public int commentsLoc(list[str] file, loc location){
	int comments = 0;
	
	comments += size([x| x <- file, /^[\s\t]*?\/{2,}.*/ := x]);
	
	// Count comments of type '/* */'
	str file = readFile(location);
	for(/<w:\/\*[\s\S]*?\*\/\r\n>/ := file)
		comments += lineBreaksLoc(w);
	
	return comments;
}


public int emptySpaceLoc(list[str] file){
	int blanks = size([x| x <- file, /^$|^[\s\t]+$/ := x]);	
	return blanks;
}


public int lineBreaksLoc(str file){
	int count = 0;
	for(/\r\n/ := file)
		count += 1;
	return count;
}