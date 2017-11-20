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
		//println("file <x>");
	
		int linesOfCodePerClass = locationLoc(x);
		totalNumberOfLines += linesOfCodePerClass;
	}
	
	return totalNumberOfLines;
}

public int locationLoc(loc location){
	try list[str] content = readFileLines(location);
	catch: return 0;
	comm = [""];
	//c = content;
	//
	//c = c - [x| x <- c, /^$|^[\s\t]+$/ := x];
	//c = c - [x| x <- c, /^[\s\t]*?\/{2,}.*/ := x];
	
	//ak = 0;
	//int comments = 0;
	//
	//str file = readFile(location);
	//for(/<w:\/\*[\s\S]*?\*\/\r\n>/ := file)
	//	comments += lineBreaksLoc(w);
	//
	//k = size(c) - comLoc(c);	
	//

	//println("size <s> comments <e>, <location>");
	//
	oke = [x| x <- content, /^$|^[\s\t]+$/ := x];
	c = content - oke;
	comments = commentsLoc(c, location);

	emptys = emptySpaceLoc(content);
	//println("Blanks <emptys>, Comments <comments>  <location>");
	//println("wut <size(comm)>");
	return size(content) - emptys - comments;
	//return size([x| x <- content, /^$|^[\s\t]+$/ := x]);
}
private int ak;
private list[str] comm;

public int comLoc(list[str] file){
	for(i <- [0..size(file)]){
		if(/^[\s\t]*?\/\*.*?\*\/[\s\t]*?$/ := file[i]){
			//println("<file[i]>");
			ak += 1;
		}
		//else if(/^.*?\/\*.*?\*\/.*?$/ := file[i]){
		//	continue;
		//}
		else if(/^[\s\t]*?\/\*/ := file[i]){
			i = com2Loc(file, i+1);
			ak += 1;
		}
		//else if (/^[\w,;,}]*?\/\*/ := file[i]){
		//	//i = com2Loc(file, i+1);
		//	continue;
		//}
	}
	return ak;
}

public int com2Loc(list[str] file, int i){
	for(j <- [i..size(file)]){
		if (/^.*?\*\/[\s\t]*?$/ := file[j]){
			//println("<file[j]>");
			ak += 1;
			return j+1;
		}
		//else if(/^.*?\*\/.*?$/ := file[j]) {
		//	return j+1;
		//} 
		else{
			//println("<file[j]>");
			ak += 1;
		}
	}
	//println("<file[i]>");
	return size(file);
}

public int commentsLoc(list[str] file, loc location){
	int comments = 0;
	
	// Count comments of type '/* */'
	ak = 0;
	po = [x| x <- file, /^[\s\t]*?\/{2,}.*/ := x];
	lk = file - po;
	comments += size(po);
	comments += comLoc(lk);
	//str file = readFile(location);
	//for(/<w:\/\*[\s\S]*?\*\/\r\n>/ := file)
	//	comments += lineBreaksLoc(w);
	//hh = file - comm;
	//comments += size([x| x <- hh, /^[\s\t]*?\/{2,}.*/ := x]);
	
	return comments;
}


public int emptySpaceLoc(list[str] file){
	int blanks = 0;
	blanks += size([x| x <- file, /^$|^[\s\t]+$/ := x]);	
	return blanks;
}