module Serie2


import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;
import Set;
import Relation;
import Map;
import String;
import util::Math;
import util::Resources;

import Node;


map[value, set[loc]] duplicates = ();
set[value] coveredChildNodes = {};

public map[value, set[loc]] RunSerie2(){
	duplicates = ();
	coveredChildNodes = {};
	
	println("Building ast");
	
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	//set[Declaration] ast = createAstsFromEclipseProject(|project://smallsql0.21_src|, true);
	//set[Declaration] ast = createAstsFromEclipseProject(|project://hsqldb-2.3.1|, true);
	
	println("search duplicates");
	findDuplicates(ast);
	
	println("Found all duplicates");
    //duplicates = (d : duplicates[d] | d <- duplicates, size(duplicates[d]) > 1, !d in coverdChildNodes);
    duplicates = domainX(duplicates, coveredChildNodes);
	for(d <- duplicates){
		if(size(duplicates[d]) > 1){
			println(duplicates[d]);
			println();
		}
	}
    return ();
}

// Visit all nodes and add it to a Map
// Need to tweak cases
public void findDuplicates(set[Declaration] ast){
    bottom-up visit (ast) {
        case Statement s: 
	        addNode(s, s.src);	
	    case Declaration d:
	    	addNode(d, d.src);
	    //case Expression e:
	    //	addNode(e, e.src);
	    //case node n:
	    //	addNode(n, n.src);
    }
}

public void addNode(node n, loc src){
	if(isValidNode(n, src)){
		n = unsetRec(n);
		n = cleanNodeForType2(n);
		if(n in duplicates){
			duplicates[n] += {src}; 	
	   		removeChilderen(n);// We dont need the childeren if the parent is in duplicates
		}else {
	    	duplicates[n] = {src};
		}
	}

}

public void removeChilderen(node parent){
	//Revisiting is needed because of a bug
    bottom-up visit (getChildren(parent)) {
        case node n:if(n in duplicates){
        	if(size(duplicates[n]) == size(duplicates[parent])){// BY REMOVING THIS STATEMENT YOU GET EXACT COPIES
        		coveredChildNodes += n;
        	}
        } 
    }
}

// Case to switch statement to clean names, see commented method
public node cleanNodeForType2(node n){
	//switch(n){
	//	case \method(a, b, c, d, e): return method(a, "", c, d, e);// Ignore method name
	//}
	return n;
}

public bool isValidNode(node n, loc src){
	if(src.scheme == "unknown"){
		return false;
	}else if(src.begin.line == src.end.line){ // Single line code count as duplicate???
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