namespace Algorithm;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Write the word to be checked:");
		bool result = Palindrome.CheckPalindrome(Console.ReadLine());

		Console.WriteLine(result);
	}
}
