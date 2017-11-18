module LinesOfCode

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import String;


// Lines of code is een te grote metric. Als men code op een iets andere manier schrijft zou je de lines of code kunnen veranderen.
// Een method kan je op een lijn schrijven of meerdere lines.
public int CountLinesOfCodeMethod(loc location){
	return CountLinesOfCode(location, 1);
}

public int CountLinesOfCodeClass(loc location){
	return CountLinesOfCode(location, 0);
}

public int CountLinesOfCode(loc location, int startingCount){
	str content = readFile(location);
	
	return startingCount += CountLineBreaks(content) - CountEmptySpace(content) - CountComments(content);
}

public int CountComments(str file){
	int count = 0;
	
	// Count comments of type '//'
	for(/<w:\n\W*?\/{2,}.*>/ := file)
		count += 1;
				
	// Count comments of type '/* */'
	for(/<w:\/\*[\s\S]*?\*\/\r\n>/ := file)
		count += CountLineBreaks(w);
	
	return count;
}

public int CountEmptySpace(str file){
	int count = 0;
	for(/<w:\r\n[\t]*?\r\n>/ := file)
		count += 1;
		
	return count;
}

public int CountLineBreaks(str file){
	int count = 0;
	for(/\r\n/ := file)
		count += 1;
	return count;
}