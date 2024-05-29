namespace Algorithm;

public class Palindrome 
{
	public static bool CheckPalindrome(string value)
	{
		string cleanValue = new(value.Where(char.IsLetterOrDigit).Select(char.ToLower).ToArray());
		
		return IsPalindrome(cleanValue, 0, cleanValue.Length - 1);
	}

	private static bool IsPalindrome(string value, int left, int right)
	{
		if (left >= right)
		{
			return true;
		}
		
		if (value[left] != value[right])
		{
			return false;
		}
		
		return IsPalindrome(value, left + 1, right - 1);
	}
}
