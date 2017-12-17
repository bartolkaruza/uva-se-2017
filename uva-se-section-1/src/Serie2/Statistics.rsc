module Serie2::Statistics
import Set;
import Map;
import Serie1::Serie1;
import Serie1::LinesOfCode;

public real percantageOfDuplicatedLines(loc location, map[value, set[loc]] duplicates) {
	return duplicatedLines(duplicates) / locationLoc(location) * 100;
}

public int numberOfClones(map[value, set[loc]] duplicates) {
	return size(union({duplicates[d] | d <- duplicates}));
}

public int cloneClasses(map[value, set[loc]] duplicates) {
	return size(duplicates);	
}

real duplicatedLines(map[value, set[loc]] duplicates) {
	dupSet = union({duplicates[d] | d <- duplicates});
	real lines = 0.0;
	for(dis <- dupSet) {
		bool containedInOtherLoc = false;
		for(oth <- dupSet) {
			if(dis != oth && dis <= oth) {
				containedInOtherLoc = true;
			}
		}
		if(!containedInOtherLoc) {
			lines = dis.end.line - dis.begin.line + lines; 
		}
	}
	return lines;
}