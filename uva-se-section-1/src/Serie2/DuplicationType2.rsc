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
import Type;

// Visit all nodes and add it to a Map
// Need to tweak cases
public map[node, set[loc]] findType2Duplicates(set[Declaration] ast) {
	map[node, set[loc]] duplicates = ();
	set[node] coveredChildNodes = {};
	

	bottom-up visit (ast) {
        case Statement s: {
	        tuple[map[node, set[loc]], set[node]] result = addNode(s, s.src, duplicates, coveredChildNodes);
	        duplicates = result[0];
	        coveredChildNodes += result[1];	
	    }
	    case Declaration d: {
	    	tuple[map[node, set[loc]], set[node]] result = addNode(d, d.src, duplicates, coveredChildNodes);
	        duplicates = result[0];
	        coveredChildNodes += result[1];
	    }
	    //case node n:
	    //	addNode(n, n.src);
    }
    
   	duplicates = domainX(duplicates, coveredChildNodes);
   	
   	duplicates = findConsecutiveSequenceBlocks(duplicates, ast);
   	
    return duplicates;
}

// Code for appending consecutive sequences of blocks
public map[node, set[loc]] findConsecutiveSequenceBlocks(map[node, set[loc]] duplicates, set[Declaration] ast){
	map[list[value], int] blocks = ();
	
	// Generate all blocks 
	// {1,2,3} {1,2} {3} gives {3}, {1,2}, {2}
	println("Building blocks");
	for(d <- duplicates) {
		if(size(duplicates[d]) == 1){
			blocks = createBlocks(duplicates, getNestedChildren(d), blocks);
		}
	}
	
	println("Filter all duplicate blocks");
	// The blocks are generated for all children even non duplicate. So this filters out all blocks where all of the children are duplicates
	blocks = (n : blocks[n] | n <- blocks, blocks[n] > 1, all(c <- (n), c in duplicates));
	
	println("Perform subsumption");
	// Remove all blocks that are covered by another block {3}, {1,2}, {2} gives {3}, {1,2}. Ugly subsumption
	blocks = blocks - (n : blocks[n] | n <- blocks, any(q <- blocks, (n != q && (n) < (q) && blocks[n] == blocks[q])));
	
	// Add locs for all blocs
	blocksWithLoc = (makeNode("blockNode", n) : union({duplicates[c]| c <- (n)}) | n <- blocks);
	
	println("Merge duplicates and blocks");
	// Add duplicates that are not blocks, so we have a full set of duplicates;
	duplicatesWithBlocks = blocksWithLoc + (d: duplicates[d] |d <- duplicates, size(duplicates[d]) > 1, !any(n <- blocksWithLoc, d in getChildren(n)));
	duplicatesWithBlocks = (d: duplicates[d] | d <- duplicates, size(duplicates[d]) > 1);	
	
	return duplicatesWithBlocks;
}

public list[value] getNestedChildren(node n){
	children = getChildren(n);
	if([[*l]] := children){ 
		return l;
	}
	return children;
}

public set[loc] mergLocs(set[loc] locs1, set[loc] locs2){
}

public map[list[value], int] createBlocks(map[node, set[loc]] duplicates, list[value] children, map[list[value], int] blocks){

	for(i <- [0..size(children)]){
		prev = [];
		
		for(j <- [i..size(children)]){
			prev += children[j];
			//node n = makeNode("blockNode", prev);
			if(prev in blocks){
				blocks[prev] += 1;
			}else{
				blocks[prev] = 1;
			}			
		}
	}
	return blocks;
}

tuple[map[node, set[loc]], set[node]] addNode(node n, loc src, map[node, set[loc]] duplicates, set[node] coveredChildNodes) {
	set[node] childDuplicates = {};
	n = unsetRec(n);
	n = cleanNodeForType2(n);
	if(isValidNode(n, src)){
		if(n in duplicates) {
			duplicates[n] += {src}; 	
	   		childDuplicates += getDuplicateChildren(n, duplicates); // We dont need the childeren if the parent is in duplicates
		} else {
    		duplicates[n] = {src};
		}
	}
	return <duplicates, childDuplicates>;
}

set[node] getDuplicateChildren(node parent, map[node, set[loc]] duplicates) {
	//Revisiting is needed because of a bug
	set[node] coveredChildNodes = {};
    bottom-up visit (getChildren(parent)) {
        case node n:if(n in duplicates) {
        		if(size(duplicates[n]) == size(duplicates[parent])){// BY REMOVING THIS STATEMENT YOU GET EXACT COPIES
        			coveredChildNodes += n;
        		}
        } 
    }
    return coveredChildNodes;
}

//// Case to switch statement to clean names, see commented method
//node cleanNodeForType2(node n) {
//	switch(n){
//		case \method(a, b, c, d, e): return method(a, "", c, d, e);
//		case \method(a, b, c, d): return method(a, "", c, d);
//		case \variable(a, b): return variable("", b);		
//		case \variable(a, b, c): return variable("", b, c);
//		case \simpleName(a): return simpleName("");
//	}
//	return n;
//}

// Case to switch statement to clean names, see commented method
node cleanNodeForType2(node n) {
	Type t = wildcard();
	n = visit(n){
		case \method(a, b, c, d, e) => method(t, "", c, d, e)
		case \method(a, b, c, d) => method(t, "", c, d)
		case \variable(a, b) => variable("", b)
		case \variable(a, b, c) => variable("", b, c)
		case \variables(a, b) => variables(t, b)
		case \simpleName(a) => simpleName("")
	}
	return n;
}

bool isValidNode(node n, loc src) {
	if(src.scheme == "unknown") {
		return false;
	}	

	switch(n){
		case \import(_): return false;
		case \package(_): return false;
		case \package(_, _): return false;
		case \break(): return false;
		case \break(_): return false;
		case \parameter(_,_,_): return false;
	}
	return true;
}