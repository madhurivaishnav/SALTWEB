using System;
using System.Text.RegularExpressions;

namespace Bdw.Application.Salt.Utilities
{
	/// <summary>
	/// Summary description for General.
	/// </summary>
	public class GeneralUtilities
    {
        public static string ReplaceCaseInsensitive(string original,
                       string pattern, string replacement)
        {
            int count, position0, position1;
            count = position0 = position1 = 0;
            string upperString = original.ToUpper();
            string upperPattern = pattern.ToUpper();
            int inc = (original.Length / pattern.Length) *
                      (replacement.Length - pattern.Length);
            char[] chars = new char[original.Length + Math.Max(0, inc)];
            while ((position1 = upperString.IndexOf(upperPattern,
                                              position0)) != -1)
            {
                for (int i = position0; i < position1; ++i)
                    chars[count++] = original[i];
                for (int i = 0; i < replacement.Length; ++i)
                    chars[count++] = replacement[i];
                position0 = position1 + pattern.Length;
            }
            if (position0 == 0) return original;
            for (int i = position0; i < original.Length; ++i)
                chars[count++] = original[i];
            return new string(chars, 0, count);
        }
        public static bool IsValidEmailAddress(string emailAddress)
        {
            bool IsValidExpression;
            bool IsFreeOfSpaces;

            string strRegEx = @"([a-z]|[A-Z]|[0-9]|\.|-|_|\')+@([a-z]|[A-Z]|[0-9]|\.|-|_)+";
            IsValidExpression = Regex.IsMatch(emailAddress,strRegEx,RegexOptions.None);

            IsFreeOfSpaces = (emailAddress.IndexOf(" ") == -1);

            return IsValidExpression && IsFreeOfSpaces;
        }
	}
}
