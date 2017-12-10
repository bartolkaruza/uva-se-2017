
public class Clones {
	
	void classOneOccurrenceOne() {
		int x = 0;
		x++;
		x--;
		System.out.println(x);
	}
	
	void classOneOccurrenceTwo() {
		int x = 0;
		x++;
		x--;
		System.out.println(x);
	}
	
	
	/**
	 * Different from class 1 under Type 1
	 * Same as class 1 under Type 2
	 * Same as class 1 under Type 3
	 */
	void classTwoOccurrenceOne() {
		int y = 0;
		y++;
		y--;
		System.out.println(y);
	}
	
	void classTwoOccurrenceTwo() {
		int y = 0;
		y++;
		y--;
		System.out.println(y);
	}
	
	/**
	 * Different from class 1 under Type 1
	 * Different from class 1 under Type 2
	 * Same as class 1 under Type 3
	 * Same as class 2 under Type 3
	 */
	void classThreeOccurenceOne() {
		int x = 0;
		
		x++;
		System.out.println(x);
	}
	
	void classThreeOccurenceThree() {
		int x = 0;
		x++;
		
		System.out.println(x);
	}
	
}