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
	
	//loc project = |project://SystemUnderTest|;
	//loc project = |project://smallsql0.21_src|;
	loc project =  |project://hsqldb-2.3.1|;
	
	set[Declaration] ast = createAstsFromEclipseProject(project, true);
	//set[Declaration] ast = createAstsFromEclipseProject(, true);
	//set[Declaration] ast = createAstsFromEclipseProject(|project://hsqldb-2.3.1|, true);
	
	println("search duplicates type 1");
	
	map[value, set[loc]] type1 = findType2Duplicates(ast, Type1);
	//writeDuplicatesToDisk(type1, Type1);
	
	printStatistics(project, type1, Type1);
	
	//makeHasseDiagram(type1, Type1);
	
	println("search duplicates type 2");
	
	map[value, set[loc]] type2 = findType2Duplicates(ast, Type2);
	//writeDuplicatesToDisk(type2, Type2);
	
	printStatistics(project, type2, Type2);
	
	//makeHasseDiagram(type2, Type2);
	
	println("Found all duplicates");

    return ();
}
