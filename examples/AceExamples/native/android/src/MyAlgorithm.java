package mypackage;

public class MyAlgorithm {
	int _startingNumber = 0;

	public MyAlgorithm() {}

	public void setStartingNumber(int n) {
		_startingNumber = n;
	}

	public int getNextPrime() {
		int n = _startingNumber;
		while (!isPrime(n)) {
			n++;
		}
		_startingNumber = n + 1;
		return n;
	}

	public static boolean isPrime(int n) {
		assert n > 0;

		if (n <= 2)
			return true;

		// No even numbers > 2 are prime
	    if (n % 2 == 0)
			return false;

		// Check all possible odd factors up to the square root of n
		for (int i = 3; i*i <= n; i+=2) {
			if (n % i == 0)
				return false;
		}
		return true;
	}
}
