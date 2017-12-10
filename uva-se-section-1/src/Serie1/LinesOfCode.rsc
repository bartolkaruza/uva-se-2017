module Serie1::LinesOfCode

import IO;
import List;

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
	
	content += readFileLines(location);
	content -= emptyLines(content);
	content -= allCommentsLoc(content);
	
	return size(content);
}


public list[str] allCommentsLoc(list[str] content){
	multiLineComments = multiLineCommentsLoc(content);
	
	content -= multiLineComments;
	
	singleLineComments = singleLineCommentsLoc(content);
	
	return singleLineComments + multiLineComments;
}

public list[str] emptyLines(list[str] file){
	return [x| x <- file, /^$|^[\s\t]+$/ := x];
}

public list[str] singleLineCommentsLoc(list[str] file){
	return [x| x <- file, /^[\s\t]*?\/{2,}.*/ := x];
}

public list[str] multiLineCommentsLoc(list[str] file){
	list[str] comments = [];
	for(i <- [0..size(file)]){
		if(/^[\s\t]*?\/\*.*?\*\/[\s\t]*?$/ := file[i]){
			//println("<file[i]>"); //for debugging
			comments += file[i];
		}else if(/^.*?\/\*.*?\*\/.*?$/ := file[i]){
			continue;
		}else if(/^[\s\t]*?\/\*/ := file[i]){
			//println("<file[i]>");
			comments += file[i];
			<i,y> = findEndInMultiLineComment(file, i+1);
			comments += y;
			
		}else if (/^[\s\t{]+\/\*/ := file[i]){
			//println("<file[i]>");
			<i,y> = findEndInMultiLineComment(file, i+1);
			comments += y;
		}
	}
	return comments;
}

public tuple[int, list[str]] findEndInMultiLineComment(list[str] file, int i){
	list[str] comments = [];
	for(j <- [i..size(file)]){
		if (/^.*\*\/[\s\t]*?$/ := file[j]){
			comments += file[j];
			return <j+1,comments>;
		} else{
			//println("<file[j]>");
			comments += file[j];
		}
	}
	return <size(file), comments>;
}