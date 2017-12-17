module Serie2::Visualization
import vis::Figure;
import vis::Render;
import IO;
import Set;

public void makeDotDiagram(map[value, set[loc]] duplicates) {
	
}

public void makeHasseDiagram(map[value, set[loc]] duplicates) {
	edges = [];
	nodes = toList({ makeNodeValue(s) | s <- union({duplicates[d] | d <- duplicates})});
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

value makeNodeValue(loc l) {
	return box(text("<l.file> <l.begin.line> <l.end.line>"), id(makeNodeId(l)));
}

str makeNodeId(loc l) {
	return "<l.uri><l.begin.line><l.end.line>";
}
