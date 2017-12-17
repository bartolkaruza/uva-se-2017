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

test bool shouldFindBiggestClone() {
	return biggestClone(findDuplicatesForClass("CloneSizes")) == {|project://SystemUnderTest/src/CloneSizes.java|(280,247,<14,1>,<23,2>),|project://SystemUnderTest/src/CloneSizes.java|(29,247,<3,1>,<12,2>)};
}

test bool shouldFindBiggestCloneClass() {
	return biggestCloneClass(findDuplicatesForClass("CloneSizes")) == {|project://SystemUnderTest/src/CloneSizes.java|(890,116,<43,1>,<47,2>),|project://SystemUnderTest/src/CloneSizes.java|(650,115,<31,1>,<35,2>),|project://SystemUnderTest/src/CloneSizes.java|(769,117,<37,1>,<41,2>),|project://SystemUnderTest/src/CloneSizes.java|(531,115,<25,1>,<29,2>)};
}
