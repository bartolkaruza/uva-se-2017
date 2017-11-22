module DuplicationSimple

import IO;
import util::Resources;
import List;
import Set;
import String;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Generate block variants
lrel[int, list[str], str] makeBlocks(list[str] myLines, int blockLength) {
	lrel[int, list[str], str] blocks = [];
	list[str] linesWithoutMethodDeclaration = slice(myLines, 1, size(myLines) - 2);

	for(currentLine <- linesWithoutMethodDeclaration) {
		int index = indexOf(linesWithoutMethodDeclaration, currentLine);
		if(size(linesWithoutMethodDeclaration) - (index + blockLength) < 0) return blocks;
		list[str] lines =  [ l | l <- slice(linesWithoutMethodDeclaration, index, blockLength)];
		tuple[int, list[str], str] block = <index, lines, ("" | it + line | line <- lines)>;
		blocks = push(block, blocks);
	}
}

// Extract duplicates
bool testBlock(str block, str method) {
	return contains(method, block);
}

lrel[int, bool] testMethodBlocks(lrel[int, list[str], str] blocks, tuple[str, loc, list[str], str] toCompare) {
	return [<ln, testBlock(block, toCompare[3])> | <int ln, list[str] _, str block> <- blocks];
}

tuple[str, loc, lrel[str, loc, lrel[int, bool]]] testMethod(tuple[str n, loc l, list[str] lns, str txt] method, lrel[str, loc, list[str], str] otherMethods) {
	print("testing: ");
	println(method.n);
	return <method[0], method[1], [<m[0], m[1], testMethodBlocks(makeBlocks(method.lns, 6), m)> | m <- otherMethods]>;
}

lrel[str, loc, lrel[str, loc, lrel[int, bool]]] extractDuplicateInfo(lrel[str, loc] methods) {
	list[tuple[str, loc, list[str], str]] methodsWithLines = mapper(methods, readMethod);
	return mapper(([] | it + testMethod(m, methodsWithLines[indexOf(methodsWithLines, m) + 1..]) | m <- methodsWithLines), filterNonDuplicate);
}

// ANALYSE
int duplicatedLinesForMethod(tuple[str name, loc l, lrel[str omn, loc l2, lrel[int, bool] res] relations] method) {
	int count = 6;
	for(relation <- method.relations) {
		count += size(takeWhile(relation.res, blockHasDuplicate)) - 1;
	}
	return count;
}

//public int totalDuplicatedLines(set[Declaration] ast) {
//	list[tuple[str, loc]] methods = [<M.name, M.src> | /M:method(_, _, _, _, _) <- ast || /M:constructor(_, _, _, _) <- ast];
//	println("methods retrieved");
//	info = extractDuplicateInfo(methods);
//	println("extraction complete");
//	return sum(([] | it + duplicatedLinesForMethod(m) | m <- info));
//}

public int totalDuplicatedLines(list[Declaration] ast) {
	list[tuple[str, loc]] methods = [<M.name, M.src> | /M:method(_, _, _, _, _) <- ast || /M:constructor(_, _, _, _) <- ast];
	
	println("methods retrieved");
	info = extractDuplicateInfo(methods);
	println("extraction complete");
	return sum(([] | it + duplicatedLinesForMethod(m) | m <- info));
}

// Utility
tuple[str, loc, list[str], str] readMethod(tuple[str, loc] method) {
	list[str] lines = trimLines(readFileLines(method[1]));
	return <method[0], method[1], lines, ("" | it + line | line <- lines)>;
}

public list[str] trimLines(list[str] lns) {
	return [trim(l) | str l <- lns, !isEmpty(trim(l))];
}

bool hasDuplicate(tuple[str n, loc l, lrel[int ln, bool isDuplicate] res] relatedMethod) {
	for(result <- relatedMethod.res) if(result.isDuplicate) return true;
	return false;
}


tuple[str, loc, lrel[str, loc, lrel[int, bool]]] filterNonDuplicate(tuple[str n, loc l, lrel[str, loc, lrel[int, bool]]  dr] methodInfo) {
	return <methodInfo.n, methodInfo.l, takeWhile(methodInfo.dr, hasDuplicate)>;
}

bool blockHasDuplicate(tuple[int ln, bool isDuplicate] block) {
	return block.isDuplicate;
}