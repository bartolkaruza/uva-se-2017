module Serie2::Visualization
import vis::Figure;
import vis::Render;
import IO;
import Set;

str makeNodeId(loc l) {
	return "<l.uri><l.begin.line><l.end.line>";
}

public void makeDotDiagram(map[value, set[loc]] duplicates) {
	
}

public void makeHasseDiagram(map[value, set[loc]] duplicates) {
	edges = [];
	nodes = toList({ box(text("<s.file> <s.begin.line> <s.end.line>"), id(makeNodeId(s))) | s <- union({duplicates[d] | d <- duplicates})});
	for(key <- duplicates) {
		set[loc] locs = duplicates[key];
		for(l <- locs) {
			for(oth <- locs) {
				if(l.file != oth.file) {
					edges += edge(makeNodeId(l), makeNodeId(oth));
				}
			}
		}
	}
	render(graph(nodes, edges, hint("layered"), gap(20)));
}
