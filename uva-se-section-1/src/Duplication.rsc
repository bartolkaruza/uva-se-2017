module Duplication

import IO;
import util::Resources;
import List;
import Set;
import String;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

public bool detectClones(list[tuple[str, loc]] methods) {
list[tuple[str, list[str]]] methodsWithBlocks = makeBlocks(filterMethods(trimMethods([readMethodLines(x) |x <- methods]), 6), 6);
	
	while(size(methodsWithBlocks) != 0) {
		headAndTail = pop(methodsWithBlocks);
		methodsWithBlocks = headAndTail[1];
		for(otherMethod <- methodsWithBlocks) {
			otherMethodSet = toSet(otherMethod[1]);
			thisSet = toSet(headAndTail[0][1]);
			if(size(thisSet + otherMethodSet) < size(thisSet) + size(otherMethodSet)) {
				println("clone in: " + headAndTail[0][0]);
				println("and: " + otherMethod[0]);
			}
		}
	}
	return false;
}

public list[tuple[str, list[str]]] makeBlocks(myMethods, blockLength) {
	return [<m[0], makeBlock(m[1], blockLength)> | m <- myMethods];
}

public list[str] makeBlock(myLines, blockLength) {
	list[str] blocks = [];
	for(currentLine <- myLines) {
		str block = currentLine;
		int index = indexOf(myLines, currentLine);
		int remaining = size(myLines) - (index + blockLength);
		int followingIndex = index + 1;
		if(remaining < 0) {
			break;
		}
		while(followingIndex < size(myLines)) {
			block = block + "/n" + myLines[followingIndex];
			followingIndex = followingIndex + 1;
		}
		
		blocks = push(block, blocks);
	}
	return blocks;
}

public tuple[str, list[str]] readMethodLines(<name, location>) {
	return <name, readFileLines(location)>;
}

public list[str] trimLines(lines) {
	return [trim(l) | str l <- lines, !isEmpty(trim(l))];
}

public list[tuple[str, list[str]]] trimMethods(myMethods) {
	return [<m[0], trimLines(m[1])> | m <- myMethods];
}

public list[tuple[str, list[str]]] filterMethods(myMethods, blockLength) {
	return [m | m <- myMethods, size(m[1]) >= blockLength];
}



