module DuplicationTest

import DuplicationSimple;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import String;
import Set;
import List;
import LinesOfCode;
import util::Math;
import util::Resources;

//public set[Declaration] ast = createAstsFromEclipseProject(|project://regression-set|, true);
//public set[Declaration] ast = createAstsFromEclipseProject(|project://hsqldb-2.3.1|, true);
public set[Declaration] ast = createAstsFromEclipseProject(|project://smallsql0.21_src|, true);

// Generate block variants
int findDuplicates(list[str] myLines, int blockLength) {
	set[str] blocks = {};

	int index = 0;
	int count = 0;
	bool previousMatch = false;
	for(currentLine <- myLines) {
		if(size(myLines) - (index + blockLength) < 0) return count;
		list[str] lines =  [ l | l <- slice(myLines, index, blockLength)];
		str block = ("" | it + line | line <- lines);
		if(block in blocks) {
			if(previousMatch) {
				count += 1;
			} else {
				count += 6;
			}
			previousMatch = true;
			print(count);
			println(" count");
		} else {
			previousMatch = false;
			blocks += block;
		}
		//blocks = push(block, blocks);
		index += 1;
	}
	//return blocks;
}

// Generate block variants
list[str] makeBlocks(list[str] myLines, int blockLength) {
	list[str] blocks = [];

	int index = 0;
	for(currentLine <- myLines) {
		if(size(myLines) - (index + blockLength) < 0) return blocks;
		list[str] lines = slice(myLines, index, blockLength);
		str block = ("" | it + line | line <- lines);
		blocks = push(block, blocks);
		index += 1;
	}
	return blocks;
}


public bool temp() {
	list[loc] files = [f | /file(f) := getProject(|project://hsqldb-2.3.1|), f.extension == "java"];
	//list[loc] files = [|project://regression-set/src/regression/DuplicationVariants.java|];

	int count = 0;
	for(file <- files) {
		println(file);
		list[str] content = [];
		list[str] lines = readFileLines(file);
		content += lines;
		content -= emptyLines(lines);
		content -= allCommentsLoc(lines);
		content = [ trim(ln) | ln <- content];
		findDuplicates(content, 6);
		println(count);
	}
	//println(size(content));
	println(count);

	//for(block <- blocks) println(block);
	//set[str] blockSet =	toSet(blocks);
	//for(blockInSet <- blockSet) println(blockSet);
	//println(size(blockSet));
	//println(	size(blocks));
	return true;
}



public list[Declaration] getTestClassBody() {
visit (ast) {
	//case \class(name,_, _,body): return body;
	case \class(name,_, _,body): if(name == "DuplicationVariants") return body;
	}
}

test bool shouldCountThreeOccurences() {
	println("result");
	println(totalDuplicatedLines(ast));	
	return true;
}
