module DuplicationTest

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import String;
import Set;
import List;

public set[Declaration] ast = createAstsFromEclipseProject(|project://regression-set|, true);

public list[Declaration] getTestClassBody() {
visit (ast) {
	case \class(name,_, _,body): if(name == "DuplicationVariants") return body;
	}
}

tuple[str, list[str]] readMethodLines(<name, location>) {
	return <name, readFileLines(location)>;
}

list[str] trimLines(lines) {
	return [trim(l) | str l <- lines, !isEmpty(trim(l))];
}

list[tuple[str, list[str]]] trimMethods(myMethods) {
	return [<m[0], trimLines(m[1])> | m <- myMethods];
}

list[tuple[str, list[str]]] filterMethods(myMethods, blockLength) {
	return [m | m <- myMethods, size(m[1]) >= blockLength];
}

test bool shouldFilterOutMethod() {
	return size(filterMethods([<"long", ["1", "2", "3", "4", "5", "6"]>, <"short", ["1", "3"]>], 6)) == 1;
}

test bool shouldNotFilterMultiple() {
	return size(filterMethods([<"long", ["1", "2", "3", "4", "5", "6"]>, <"short", ["1", "2", "3", "4", "5", "6"]>], 6)) == 2;
}

list[str] makeBlock(myLines, blockLength) {
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

list[tuple[str, list[str]]] makeBlocks(myMethods, blockLength) {
	return [<m[0], makeBlock(m[1], blockLength)> | m <- myMethods];
}

test bool shouldMakeThreeBlocks() {
	return size(makeBlocks([<"ah", ["1", "2", "3", "4", "5", "6", "7", "8"]>], 6)[0][1]) == 3;
}

test bool shouldMakeNoBlocks() {
	return size(makeBlocks([<"ah", ["1", "2", "3", "4", "5"]>], 6)[0][1]) == 0;
}

test bool shouldCountThreeOccurences() {	
	list[tuple[str, loc]] methods = [<M.name, M.src> | /M:method(_, _, _, _, _) <- getTestClassBody() || /M:constructor(_, _, _, _) <- getTestClassBody()];	
	
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
	
	return true;
}