module Serie2::DuplicationType2

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import Map;
import String;
import Node;
import util::Math;
import util::Resources;

// Visit all nodes and add it to a Map
// Need to tweak cases
public map[value, set[loc]] findType2Duplicates(set[Declaration] ast) {
	map[value, set[loc]] duplicates = ();
	set[value] coveredChildNodes = {};
	

	bottom-up visit (ast) {
        case Statement s: {
	        tuple[map[value, set[loc]], set[value]] result = addNode(s, s.src, duplicates, coveredChildNodes);
	        duplicates = result[0];
	        coveredChildNodes += result[1];	
	    }
	    case Declaration d: {
	    		tuple[map[value, set[loc]], set[value]] result = addNode(d, d.src, duplicates, coveredChildNodes);
	        duplicates = result[0];
	        coveredChildNodes += result[1];
	    }
	    //case Expression e:
	    //	addNode(e, e.src);
	    //case node n:
	    //	addNode(n, n.src);
    }
   	duplicates = domainX(duplicates, coveredChildNodes);
    return duplicates;
}



tuple[map[value, set[loc]], set[value]] addNode(node n, loc src, map[value, set[loc]] duplicates, set[value] coveredChildNodes) {
	set[value] childDuplicates = {};
	if(isValidNode(n, src)){
		n = unsetRec(n);
		n = cleanNodeForType2(n);
		if(n in duplicates) {
			duplicates[n] += {src}; 	
	   		childDuplicates += getDuplicateChildren(n, duplicates); // We dont need the childeren if the parent is in duplicates
		} else {
	    		duplicates[n] = {src};
		}
	}
	return <duplicates, childDuplicates>;
}

set[value] getDuplicateChildren(node parent, map[value, set[loc]] duplicates) {
	//Revisiting is needed because of a bug
	set[value] coveredChildNodes = {};
    bottom-up visit (getChildren(parent)) {
        case node n:if(n in duplicates) {
        		if(size(duplicates[n]) == size(duplicates[parent])){// BY REMOVING THIS STATEMENT YOU GET EXACT COPIES
        			coveredChildNodes += n;
        		}
        } 
    }
    return coveredChildNodes;
}

// Case to switch statement to clean names, see commented method
node cleanNodeForType2(node n) {
	switch(n){
		case \method(a, b, c, d, e): return method(a, "", c, d, e);
		case \method(a, b, c, d): return method(a, "", c, d);
		
		// TODO Not working yet : cleanNodeForType2SimpleName && cleanNodeForType2Variable && cleanNodeForType2VariableWithExpression
		case \variable(n, b): return variable("", b);
		case \simpleName(n): {
			return simpleName("");
		}
	}
	return n;
}

bool isValidNode(node n, loc src) {
	if(src.scheme == "unknown") {
		return false;
	} else if(src.begin.line == src.end.line) { // Single line code count as duplicate???
		return false;
	}	

	switch(n){
		case \import(_): return false;
		case \package(_): return false;
		case \package(_, _): return false;
		//case \declarationStatement(_): return false;
		case \break(): return false;
    		case \break(_): return false;
    		case \parameter(_,_,_): return false;
	}
	return true;
}