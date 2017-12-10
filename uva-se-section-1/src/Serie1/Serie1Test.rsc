module Serie1::Serie1Test

import Serie1::Serie1;
import IO;
import util::Math;

test bool duplicationRankingTest5() {
	return duplicationRanking(0.02) == "++";
}

test bool duplicationRankingTest4() {
	return duplicationRanking(0.04) == "+";
}

test bool duplicationRankingTest3() {
	return duplicationRanking(0.10) == "o";
}

test bool duplicationRankingTest2() {
	return duplicationRanking(0.19) == "-";
}

test bool duplicationRankingTest1() {
	return duplicationRanking(0.50) == "--";
}

test bool relativeUnitInterfacing() {
	list[int] results = relativeUnitInterfacing([<"a", 3, 2>, <"b", 5, 3>, <"c", 7, 4>]);
	return results[0] == 9 && results[1] == 7 && results[2] == 4;
}

test bool shouldRank5() {
	str result = unitInterfaceRanking(toReal(1000), [40, 0, 0]);
	return result == "++";
}

test bool shouldRank4() {
	str result = unitInterfaceRanking(toReal(1000), [11, 2, 0]);
	return result == "+";
}

test bool shouldRank3() {
	str result = unitInterfaceRanking(toReal(1000), [15, 4, 2]);
	return result == "+";
}

test bool shouldRank2() {
	str result = unitInterfaceRanking(toReal(1000), [30, 8, 3]);
	return result == "+";
}

test bool shouldRank1() {
	str result = unitInterfaceRanking(toReal(1000), [5, 5, 40]);
	return result == "-";
}
