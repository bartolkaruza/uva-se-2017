module Serie2::VisualizationTest

import Serie2::Visualization;
import Serie2::TestUtil;

test bool shouldMakeAHasseDiagram() {
	map[value, set[loc]] duplicates = findDuplicatesForClasses(["Visualization", "VisualizationTwo"]);
	makeHasseDiagram(duplicates);
	return true;
}

test bool shouldMakeDotPlot() {
	map[value, set[loc]] duplicates = findDuplicatesForClasses(["Visualization", "VisualizationTwo"]);
	makeDotPlot(duplicates);
	return true;
}