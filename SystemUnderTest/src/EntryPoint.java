
public class EntryPoint {
	
	public void someMethod() {
		System.out.println("non conditional statement");
		if(true) {
			System.out.println("statement in condition");
			if(true) {
				System.out.println("statement in nested if");
			}
		}
		do {
			System.out.println("statement in do while");
		} while(true);
	}
	
	public void anotherMethod() {
		System.out.println("non conditional statement");
		if(true) {
			System.out.println("statement in condition");
			if(true) {
				System.out.println("statement in nested if");
			}
		}
	}

}
