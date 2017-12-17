module Serie2::Statistics
import Set;
import Map;
import Serie1::Serie1;
import Serie1::LinesOfCode;
import IO;

public void printStatistics(loc project, map[value, set[loc]] duplicates) {
	println("***************************************");
	println("Statistics");
	println();
	println("% cloned:	<percantageOfDuplicatedLines(project, duplicates)>");
	println("# of clones:	<numberOfClones(duplicates)>");
	println("# of classes:	<cloneClasses(duplicates)>");
	println();
	println("biggest clone:");
	println(	biggestClone(duplicates));
	println();
	println("biggest class:");
	println(biggestCloneClass(duplicates));
	println();
	println("example clone:");
	println(exampleClone(duplicates));
	println("***************************************");
}

public real percantageOfDuplicatedLines(loc project, map[value, set[loc]] duplicates) {
	return percantageOfDuplicatedLines(classesLoc(allFiles(project)), duplicates);
}

public real percantageOfDuplicatedLines(int totalLines, map[value, set[loc]] duplicates) {
	return duplicatedLines(duplicates) / totalLines * 100;
}

public int numberOfClones(map[value, set[loc]] duplicates) {
	return size(union({duplicates[d] | d <- duplicates}));
}

public int cloneClasses(map[value, set[loc]] duplicates) {
	return size(duplicates);	
}

public set[loc] biggestClone(map[value, set[loc]] duplicates) {
	int sizeOfLargest = 0;
	set[loc] largest; 
	for(d <- duplicates) {
		s = getOneFrom(duplicates[d]);
		int lines = s.end.line - s.begin.line;
		if(lines > sizeOfLargest) {
			largest = duplicates[d];
			sizeOfLargest = lines;
		}
	}
	return largest;
}

public set[loc] biggestCloneClass(map[value, set[loc]] duplicates) {
	int sizeOfLargest = 0;
	set[loc] largest;
	for(d <- duplicates) {
		int clones = size(duplicates[d]);
		if(clones > sizeOfLargest) {
			largest = duplicates[d];
			sizeOfLargest = clones;
		}
	}
	return largest;
}

public loc exampleClone(map[value, set[loc]] duplicates) {
	return getOneFrom({getOneFrom(duplicates[d]) | d <- duplicates});
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