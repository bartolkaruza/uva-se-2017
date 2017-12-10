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
import DuplicationType2;

import Node;

public map[value, set[loc]] runSerie2(){
	map[value, set[loc]] duplicates = ();
	set[value] coveredChildNodes = {};
	
	println("Building ast");
	
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	//set[Declaration] ast = createAstsFromEclipseProject(|project://smallsql0.21_src|, true);
	//set[Declaration] ast = createAstsFromEclipseProject(|project://hsqldb-2.3.1|, true);
	
	println("search duplicates");
	
	findType2Duplicates(ast, duplicates, coveredChildNodes);
	
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
