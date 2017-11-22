module DuplicationSimple

import IO;
import util::Resources;
import List;
import Set;
import String;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

// Generate block variants
public lrel[int, list[str]] makeBlocks(list[str] myLines, int blockLength) {
	lrel[int, list[str]] blocks = [];
	list[str] linesWithoutMethodDeclaration = slice(myLines, 1, size(myLines) - 2);

	for(currentLine <- linesWithoutMethodDeclaration) {
		int index = indexOf(linesWithoutMethodDeclaration, currentLine);
		if(size(linesWithoutMethodDeclaration) - (index + blockLength) < 0) return blocks;
		tuple[int, list[str]] block = <index, [ l | l <- slice(linesWithoutMethodDeclaration, index, blockLength)]>;
		blocks = push(block, blocks);
	}
}

// Extract duplicates
bool testBlock(list[str] block, str method) {
	return contains(method, ("" | it + line | line <- block));
}

lrel[int, bool] testMethodBlocks(lrel[int, list[str]] blocks, tuple[str, loc, list[str]] toCompare) {
	return [<ln, testBlock(block, ("" | it + l | l <- toCompare[2]))> | <int ln, list[str] block> <- blocks];
}

tuple[str, loc, lrel[str, loc, lrel[int, bool]]] testMethod(tuple[str n, loc l, list[str] lns] method, lrel[str, loc, list[str]] otherMethods) {
	print("testing: ");
	println(method.n);
	return <method[0], method[1], [<m[0], m[1], testMethodBlocks(makeBlocks(method[2], 6), m)> | m <- otherMethods]>;
}

lrel[str, loc, lrel[str, loc, lrel[int, bool]]] extractDuplicateInfo(lrel[str, loc] methods) {
	list[tuple[str, loc, list[str]]] methodsWithLines = mapper(methods, readMethod);
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

int totalDuplicatedLines(set[Declaration] ast) {
	list[tuple[str, loc]] methods = [<M.name, M.src> | /M:method(_, _, _, _, _) <- ast || /M:constructor(_, _, _, _) <- ast];
	info = extractDuplicateInfo(methods);
	return sum(([] | it + duplicatedLinesForMethod(m) | m <- info));
}

int totalDuplicatedLines(list[Declaration] ast) {
	list[tuple[str, loc]] methods = [<M.name, M.src> | /M:method(_, _, _, _, _) <- ast || /M:constructor(_, _, _, _) <- ast];
	println("methods retrieved");
	info = extractDuplicateInfo(methods);
	println("extraction complete");
	return sum(([] | it + duplicatedLinesForMethod(m) | m <- info));
}

// Utility
tuple[str, loc, list[str]] readMethod(tuple[str, loc] method) {
	return <method[0], method[1], trimLines(readFileLines(method[1]))>;
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