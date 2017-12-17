module Serie2::Serie2

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

import Serie2::DuplicationType2;
import Serie2::Statistics;
import Serie2::Visualization;
import Serie2::Serialize;

public map[value, set[loc]] runSerie2(){
	
	println("Building ast");
	
	set[Declaration] ast = createAstsFromEclipseProject(|project://SystemUnderTest|, true);
	//set[Declaration] ast = createAstsFromEclipseProject(|project://smallsql0.21_src|, true);
	//set[Declaration] ast = createAstsFromEclipseProject(|project://hsqldb-2.3.1|, true);
	
	println("search duplicates");
	
	map[value, set[loc]] duplicates = findType2Duplicates(ast);
	
	writeDuplicatesToDisk(duplicates);
	
	printStatistics(|project://SystemUnderTest|, duplicates);
	
	makeHasseDiagram(duplicates);
	
	println("Found all duplicates");
    //duplicates = (d : duplicates[d] | d <- duplicates, size(duplicates[d]) > 1, !d in coverdChildNodes);
    
    
    
	//for(d <- duplicates) {
	//	if(size(duplicates[d]) > 1) {
	//		println(duplicates[d]);
	//		println();
	//	}
	//}
    return ();
}
