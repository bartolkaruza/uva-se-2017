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
public int classesLoc(list[loc] files) {
	int totalNumberOfLines = 0;

	println("number of files <size(files)>");
	for(x <- files) {
		int linesOfCodePerClass = locationLoc(x);
		totalNumberOfLines += linesOfCodePerClass;
	}
	
	return totalNumberOfLines;
}

public int locationLoc(loc location){
	list[str] content = [];
	try content = readFileLines(location);
	catch: return 0;
	
	blanks = emptyLines(content);
	contentWithoutBlanks = content - blanks;
	comments = allCommentsLoc(contentWithoutBlanks, location);
	
	return size(contentWithoutBlanks) - comments;
}


public int multiLineCommentsLoc(list[str] file){
	int comments = 0;
	for(i <- [0..size(file)]){
		if(/^[\s\t]*?\/\*.*?\*\/[\s\t]*?$/ := file[i]){
			//println("<file[i]>");
			tests += file[i];
			comments += 1;
		}
		else if(/^.*?\/\*.*?\*\/.*?$/ := file[i]){
			continue;
		}
		else if(/^[\s\t]*?\/\*/ := file[i]){
			//println("<file[i]>");
			tests += file[i];
			<x,y> = findEndInMultiLineComment(file, i+1);
			i = x;
			
			comments += y + 1;
		}
		else if (/^[\s\t{]+\/\*/ := file[i]){
			//println("<file[i]>");
			<x,y> = findEndInMultiLineComment(file, i+1);
			i = x;
			comments += y;
			//i = com2Loc(file, i+1);
			//continue;
		}
	}
	tests = drop(1, tests);
	return comments;
}

public tuple[int, int] findEndInMultiLineComment(list[str] file, int i){
	int comments = 0;
	for(j <- [i..size(file)]){
		if (/^.*\*\/[\s\t]*?$/ := file[j]){
		//if (/^[\s\t]*?\/{2,}.*/ := file[j]){
			//println("<file[j]>");
			comments += 1;
			tests += file[j];
			return <j+1,comments>;
		}
		//else if(/^.*?\*\/.*?$/ := file[j]) {
		//	return j+1;
		//} 
		else{
			//println("<file[j]>");
			tests += file[j];
			comments += 1;
		}
	}
	return <size(file),comments>;
}

public list[str] tests;

public int allCommentsLoc(list[str] file, loc location){
	int comments = 0;
	tests = [""];
	// Count comments of type '/* */'
	comments += multiLineCommentsLoc(file);
	
	lo = file - tests;
	po = singleLineCommentsLoc(lo);
	comments += size(lo) - size(po);
	return comments;
}

public list[str] singleLineCommentsLoc(list[str] file){
	comments = [x| x <- file, /^[\s\t]*?\/{2,}.*/ := x];
	file = file - comments;
	return file;
}

public list[str] emptyLines(list[str] file){
	return [x| x <- file, /^$|^[\s\t]+$/ := x];
}