module Serie2::Serialize

import IO;
import Map;
import Set;
import String;
import util::Eval;

void writeDuplicatesToDisk(map[value, set[loc]] duplicates, int Type) {
	aLoc = getOneFrom(duplicates[getOneFrom(duplicates)]);
	writeFileEnc(toLocation("<aLoc.scheme>://<aLoc.authority>/duplicates<Type>"), "UTF-8", duplicates);
}

map[value, set[loc]] readDuplicatesFromDisk(loc project) {
	return eval(readFileEnc(toLocation("<project.scheme>://<project.authority>/duplicates"), "UTF-8"));
}