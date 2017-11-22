/* licensing information
 * 
 * 
 */
package regression;

/**
 * Class documentation
 */
public abstract class LinesOfCodeVariants {
	
	public LinesOfCodeVariants () {
		System.out.println("1");
		System.out.println("2");/*
		/*
		// */
	}
	
	
	
	public abstract void abstractMethod();
	
	public static void staticMethod() {
		System.out.println("1");
		System.out.println("2");
	}
	
	// some comment
	public void commentStyle1() {
		System.out.println("1");
		System.out.println("2");
	}
	
	// some comment //
	public void commentStyle2() {
		System.out.println("1");
		System.out.println("2");
	}
	
	/**
	 * some comment
	 */
	public void commentStyle3() {
		System.out.println("1");
		System.out.println("2");
	}
	
	public void commentStyle4() {
		System.out.println("1");
		// comment
		System.out.println("2");
	}
	
	public void commentStyle5() {
		System.out.println("1");
		/**
		 * some comment 
		 */
		System.out.println("2");
	}
	
	public void commentStyle6() {
		System.out.println("1"); // comment
		System.out.println("2");
	}
	
	static class InnerClass {
		InnerClass() {
			System.out.println("1");
			System.out.println("2");
		}
		void innerMethod() {		
		}
	}
	
	public void methodVariant1() {
		System.out.println("1");
	}
	
	public void methodVariant2() {
		System.out.println("text on "
				+ "/* multiple */"
				+ "// lines");
	}
	
}