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

test bool shouldCountRegressionDuplicates() {
	list[loc] files = [f | /file(f) := getProject(|project://regression-set|), f.extension == "java"];
	return duplicateLoc(files) == 19;
}

bool shouldSmallSqlDuplicates() {
	list[loc] files = [f | /file(f) := getProject(|project://smallsql0.21_src|), f.extension == "java"];
	int count = duplicateLoc(files);
	return count == 1510;
}