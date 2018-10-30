using System;
using System.Text.RegularExpressions;

namespace Bdw.Application.Salt.BusinessServices
{
	//Modified from http://refactormycode.com/codes/333-sanitize-html
	public class HTMLSanitizer
	{
		private static Regex _tags = new Regex("<[^>]*(>|$)", RegexOptions.Singleline | RegexOptions.ExplicitCapture | RegexOptions.Compiled);
		private static Regex _whitelist = new Regex(@"
    ^</?(a|b(lockquote)?|code|em|h(1|2|3|4)|i|li|ol|p(re)?|s(ub|up|trong|trike)?|ul)>$
    |^<(b|h)r\s?/?>$
    |^<a[^>]+>$
    |^<img[^>]+/?>$
	|^</?object[^>]*?/?>$
	|^</?t(able|r|d)[^>]*?/?>$
    |<param[^>]+/?>$",
			RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace |
			RegexOptions.ExplicitCapture | RegexOptions.Compiled);

		/// <summary>
		/// sanitize any potentially dangerous tags from the provided raw HTML input using 
		/// a whitelist based approach, leaving the "safe" HTML tags
		/// </summary>
		public static string Sanitize(string html)
		{

			string tagname = "";
			Match tag;
			MatchCollection tags = _tags.Matches(html);

			// iterate through all HTML tags in the input
			for (int i = tags.Count-1; i > -1; i--)
			{
				tag = tags[i];
				tagname = tag.Value.ToLower();

				if (!_whitelist.IsMatch(tagname))
				{
					// not on our whitelist?
					html = html.Remove(tag.Index, tag.Length);
				}
     
			}

			return html;
		}


		/// <summary>
		/// Utility function to match a regex pattern: case, whitespace, and line insensitive
		/// </summary>
		private static bool IsMatch(string s, string pattern)
		{
			return Regex.IsMatch(s, pattern, RegexOptions.Singleline | RegexOptions.IgnoreCase |
				RegexOptions.IgnorePatternWhitespace | RegexOptions.ExplicitCapture);
		}
	
	}
}
