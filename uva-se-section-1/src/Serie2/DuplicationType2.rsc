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
	    //case Expression e:
	    //	addNode(e, e.src);
	    //case node n:
	    //	addNode(n, n.src);
    }
    
   	duplicates = domainX(duplicates, coveredChildNodes);
   	
   	duplicates = findConsecutiveSequenceBlocks(duplicates, ast);
   	
    return duplicates;
}

// Code for appending consecutive sequences of blocks
public map[node, set[loc]] findConsecutiveSequenceBlocks(map[node, set[loc]] duplicates, set[Declaration] ast){
	map[node, int] blocks = ();
	
	// Generate all blocks 
	// {1,2,3} {1,2} {3} gives {3}, {1,2}, {2}
	for(d <- duplicates) {
		if(size(duplicates[d]) == 1){
			blocks = createBlocks(duplicates, getNestedChildren(d), blocks);
		}
	}
	
	// The blocks are generated for all children even non duplicate. So this filters out all blocks where all of the children are duplicates
	blocks = (n : blocks[n] | n <- blocks, blocks[n] > 1, all(c <- getChildren(n), c in duplicates));
	
	// Remove all blocks that are covered by another block {3}, {1,2}, {2} gives {3}, {1,2}. Ugly subsumption
	blocks = blocks - (n : blocks[n] | n <- blocks, any(q <- blocks, (n != q && getChildren(n) < getChildren(q) && blocks[n] == blocks[q])));
	
	// Add locs for all blocs
	blocksWithLoc = (n : union({duplicates[c]| c <- getChildren(n)}) | n <- blocks);
	
	// Add duplicates that are not blocks, so we have a full set of duplicates;
	duplicatesWithBlocks = blocksWithLoc + (d: duplicates[d] |d <- duplicates, size(duplicates[d]) > 1, !any(n <- blocksWithLoc, d in getChildren(n)));	
	
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

public map[node, int] createBlocks(map[node, set[loc]] duplicates, list[value] children, map[node, int] blocks){

	for(i <- [0..size(children)]){
		prev = [];
		
		for(j <- [i..size(children)]){
			prev += children[j];
			node n = makeNode("blockNode", prev);
			if(n in blocks){
				blocks[n] += 1;
			}else{
				blocks[n] = 1;
			}			
		}
	}
	return blocks;
}

tuple[map[node, set[loc]], set[node]] addNode(node n, loc src, map[node, set[loc]] duplicates, set[node] coveredChildNodes) {
	set[node] childDuplicates = {};
	if(isValidNode(n, src)){
		n = unsetRec(n);
		n = cleanNodeForType2(n);
		if(n in duplicates) {
			duplicates[n] += {src}; 	
	   		childDuplicates += getDuplicateChildren(n, duplicates); // We dont need the childeren if the parent is in duplicates
		} else {
			//lol(n, duplicates, childDuplicates);
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