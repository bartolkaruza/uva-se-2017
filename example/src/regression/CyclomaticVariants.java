package regression;

public class CyclomaticVariants {
	
	private boolean testValue = false;
	
	public void forLoop() {
		for(int x = 0; x < 1; x++) {
			System.out.println("for loop");
		}
	}
	
	public void enhancedForLoop() {
		int[] numbers = {1, 2, 3};
		for(int x : numbers) {
			System.out.println("enhanced for loop" + x);
		}
	}
	
	public void ifStatement() {
		if(testValue) {
			System.out.println("if statement");
		}
	}
	
	public void switchStatement() {
		switch("some value") {
		case "some value":
			System.out.println("some value");
			break;
		case "some other value":
			System.out.println("some other value");
			break;
		}
	}
	
	public void ifNonConditionalElseStatement() {
		if(testValue) {
			System.out.println("if statement");
		} else if(testValue) {
			System.out.println("if non conditional else statement");
		}
	}
	
	public void ifElseStatement() {
		if(testValue) {
			System.out.println("if statement");
		} else if(testValue) {
			System.out.println("if else statement");
		}
	}
	
	public void whileLoop() {
		while(testValue) {
			System.out.println("while loop");
		}
	}
	
	public void doWhileLoop() {
		do {
			System.out.println("do while");
		} while(testValue);
	}
	
	public void conditional() {
		boolean result = testValue ? true : false;
		System.out.println("conditional" + result);
	}
	
	public void tryCatch() {
		try {
			System.out.println("try");
		} catch(Error e) {
			System.out.println("catch" + e);	
		}
	}
	
	public void infixAnd() {
		boolean result = testValue && false;
		System.out.println("infix and" + result);
	}
	
	public void infixOr() {
		boolean result = testValue || false;
		System.out.println("infix and" + result);
	}
	
	public void infixAndInIf() {
		if(testValue && true) {
			System.out.println("infixAndInIf");	
		}
	}
	
	public void infixOrInIf() {
		if(testValue || true) {
			System.out.println("inifxOrInIf");	
		}
	}
	
	public void nestedComplexity() {
		System.out.println("non conditional statement");
		if(testValue) {
			System.out.println("statement in condition");
			if(testValue) {
				System.out.println("statement in nested if");
			} else if(testValue || false) {
				System.out.println("statement in else if");
				do {
					System.out.println("statement in do while");
					for(int x = 0; x > 1; x++) {
						try {
							System.out.println("statement in for");	
						} catch (Error e) {
							System.out.println("statement in catch");
							switch("some value") {
							case "some value":
								System.out.println("some value");
								break;
							case "some other value":
								int[] numbers = {1, 2, 3};
								for(int xy : numbers) {
									System.out.println("enhanced for loop" + xy);
								}
								System.out.println("some other value");
								break;
							}
						}
					}
				} while(testValue && false);
			}
		}	
	}

}
