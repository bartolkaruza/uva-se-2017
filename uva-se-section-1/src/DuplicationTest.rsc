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
	return size(filterMethods([<"long", ["1", "2", "3", "4", "5", "6"]>, <"short", ["1", "3"]>])) == 1;
}

test bool shouldNotFilterMultiple() {
	return size(filterMethods([<"long", ["1", "2", "3", "4", "5", "6"]>, <"short", ["1", "2", "3", "4", "5", "6"]>])) == 2;
}

list[str] makeBlock(myLines, blockLength) {
	list[str] blocks = [];
	for(currentLine <- myLines) {
		str block = currentLine;
		int index = indexOf(myLines, currentLine);
		int remaining = size(myLines) - (index + blockLength);
		int followingIndex = index + 1;
		if(remaining < 0) {
			continue;
		}
		while(followingIndex < size(myLines)) {
			block = block + "/n" + myLines[followingIndex];
			followingIndex = followingIndex + 1;
		}
		
		blocks = push(block, blocks);
	}
	return blocks;
}

list[str] makeBlocks(myMethods, blockLength) {
	return ([] | merge(it, makeBlock(m[1], blockLength)) | m <- myMethods);
}

test bool shouldMakeThreeBlocks() {
	return size(makeBlocks([<"ah", ["1", "2", "3", "4", "5", "6", "7", "8"]>])) == 3;
}

test bool shouldMakeNoBlocks() {
	return size(makeBlocks([<"ah", ["1", "2", "3", "4", "5"]>])) == 0;
}

test bool shouldCountThreeOccurences() {	
	list[tuple[str, loc]] methods = [<M.name, M.src> | /M:method(_, _, _, _, _) <- getTestClassBody() || /M:constructor(_, _, _, _) <- getTestClassBody()];	
	
	list[str] blocks = reverse(makeBlocks(filterMethods(trimMethods([readMethodLines(x) |x <- methods]), 6), 6));
	
	list[str] sortedBlocks = sort(blocks, bool(str a, str b){ return size(a) > size(b); });
	println(sortedBlocks);

	while(size(blocks) != 0) {
		headAndTail = headTail(blocks);
		blocks = headAndTail[1];
		set[str] blockSet = toSet(blocks);
		if(indexOf(blocks, headAndTail[0]) != -1) println(headAndTail[0]);
	}
	
	//println(reverse(blocks));
	//println(size(blocks));
	//println(size(blockSet));
	
	
	
	
	
	
	//
	//list[tuple[str, str]] cleanMethodLines = removeCommentLines(methodLines);
	//
	//for(x <- methods) println(readMethodLines(x));
	//println(methods[0]);
	return true;
	//println(methods);
}