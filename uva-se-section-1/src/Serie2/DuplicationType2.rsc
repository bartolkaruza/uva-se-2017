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



// Code for appending consecutive sequences of blocks
public void findConsecutiveSequenceBlocks(map[node, set[loc]] duplicates, set[Declaration] ast){
	bool previousBlockIsDuplicate = false;
	map[node, set[loc]] previousDuplicateBlock;
	for(d <- duplicates) {
		if(size(duplicates[d]) == 1){
			children = getChildren(d);
			
			bottom-up visit(children){
				case node n: if(n in duplicates){
					locs = duplicates[n];
					if(size(locs) > 1){
						//Found block
						if(previousBlockIsDuplicate){
							//TODO found two blocks that are consecutive sequence. Add them together??
							println();
						}
						previousBlockIsDuplicate = true;
					}else{
						previousBlockIsDuplicate = false;
					}
				}
			}
		}
		//index += 1;
	}
}

public map[node, set[loc]] iterateSublists(map[node, set[loc]] duplicates, list[value] children) {
		int x = 0;
		int a = 1;
		do {
			while(size(children) >= x + a) {
				node n = makeNode("ARGH", slice(children, x, x + a));
				if(n in duplicates) {
					println(n);	
				} else {
					duplicates[n] += {n.src}; 
				}
				a += 1;
			}
			a = 1;
			x += 1;
		} while(size(children) < x);
		
		return duplicates;
}

//public void lol(node parent, map[value, set[loc]] duplicates){
//	set[loc] sameBlock = {};
//	int previous = 0;
//	childeren = getChildren((parent));
//	bottom-up visit(childeren){
//		case node n: if(n in duplicates){
//			//if(!(n in coveredChildNodes)){
//				println("lol <duplicates[n]>");
//			//}
//		}
//	}
//}

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
   	//findConsecutiveSequenceBlocks(duplicates, ast);
    return duplicates;
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
		//case \declarationStatement(_):	 return false;
		case \break(): return false;
    		case \break(_): return false;
    		case \parameter(_,_,_): return false;
	}
	return true;
}