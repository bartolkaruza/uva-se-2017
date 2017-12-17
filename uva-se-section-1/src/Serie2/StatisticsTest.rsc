module Serie2::StatisticsTest

import IO;
import Serie2::Statistics;
import Serie2::TestUtil;

test bool shouldCountClonesCorrectly() {
	return numberOfClones(findDuplicatesForClasses(["Count"])) == 2;
}

test bool shouldCalculatePercentageCorrectly() {
	return percantageOfDuplicatedLines(|project://SystemUnderTest/src/Percentage.java|, findDuplicatesForClass("Percentage")) == 35.2941176500;
}

test bool shouldCountCloneClasses() {
	return cloneClasses(findDuplicatesForClass("CloneClasses")) == 2;
}
