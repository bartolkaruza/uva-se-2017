module Serie2::StatisticsTest

import IO;
import Serie2::Statistics;
import Serie2::TestUtil;

test bool shouldCountClonesCorrectly() {
	return numberOfClones(findDuplicatesForClasses(["Count"])) == 2;
}

test bool shouldCalculatePercentageCorrectly() {
	return percantageOfDuplicatedLines(17, findDuplicatesForClass("Percentage")) == 35.2941176500;
}

test bool shouldCountCloneClasses() {
	return cloneClasses(findDuplicatesForClass("CloneClasses")) == 2;
}

test bool shouldFindBiggestClone() {
	return biggestClone(findDuplicatesForClass("CloneSizes"))[0] == 9;
}

test bool shouldFindBiggestCloneClass() {
	return biggestCloneClass(findDuplicatesForClass("CloneSizes"))[0] == 4;
}

test bool shouldGetExampleClone() {
	return exampleClone(findDuplicatesForClass("CloneExample")) == |project://SystemUnderTest/src/CloneExample.java|(146,113,<8,1>,<12,2>);
}
