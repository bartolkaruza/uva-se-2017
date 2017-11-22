module DuplicationSimple

import IO;
import util::Resources;
import List;
import Set;
import String;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import LinesOfCode;
import util::Math;

public tuple[set[str], int] duplicateForLines(list[str] myLines, int blockLength, set[str] blocks) {
	int index = 0;
	int count = 0;
	bool previousMatch = false;
	for(currentLine <- myLines) {
		if(size(myLines) - (index + blockLength) < 0) return <blocks, count>;
		list[str] lines =  [ l | l <- slice(myLines, index, blockLength)];
		str block = ("" | it + line | line <- lines);
		if(block in blocks) {
			if(previousMatch) {
				count += 1;
			} else {
				count += 6;
			}
			previousMatch = true;
		} else {
			previousMatch = false;
			blocks += block;
		}
		index += 1;
	}
}

public int duplicateLoc(list[loc] files) {
	int count = 0;
	set[str] blocks = {};
	for(file <- files) {
		println(file);
		list[str] content = readFileLines(file);
		content -= emptyLines(content);
		content -= allCommentsLoc(content);
		content = [ trim(ln) | ln <- content];
		tuple[set[str], int] duplicates = duplicateForLines(content, 6, blocks);
		count += duplicates[1];
		blocks = duplicates[0];
	}
	return count;
}