module CyclomaticComplexityAst

import LinesOfCode;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import List;


public lrel[str, int, int, loc] complexityPerMethod(set[Declaration] ast){

	// Return tuple of <name, CyclomaticComplexity, method location, method LOC>
	allMethods = [<n, complexity(i), locationLoc(M.src), M.src> | /M:method(_, str n, _, _, i) := ast || /M:constructor(str n, _, _, i) := ast];							

	// Do we include abstractmethods? No, they have 0 complexity and lines by definition									
	//allAbstractMethods = [<n,1> | Declaration x <- ast, /method(_, str n, _, _) := x];	
	
	return allMethods;
}

public int complexity(Statement s){
    int result = 1;
    visit (s) {
        case \if(_,_) : result += 1;
        case \if(_,_,_) : result += 1;
        case \case(_) : result += 1;
        case \do(_,_) : result += 1;
        case \while(_,_) : result += 1;
        case \for(_,_,_) : result += 1;
        case \for(_,_,_,_) : result += 1;
        case foreach(_,_,_) : result += 1;
        case \catch(_,_): result += 1;
        case \conditional(_,_,_): result += 1;
        case infix(_,"&&",_) : result += 1;
        case infix(_,"||",_) : result += 1;
    }
    return result;
}
