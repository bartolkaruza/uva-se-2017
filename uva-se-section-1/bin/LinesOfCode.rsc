module LinesOfCode

public set[Declaration] declarations = createAstsFromEclipseProject(|project://SystemUnderTest|, true);