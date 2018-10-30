using System;
using Localization;

namespace Bdw.Application.Salt.Web.General.Shared
{
	/// <summary>
	/// Summary description for Validation.
	/// </summary>
	public class Validation
	{

		public static string Validate_Frequency_CompletionDates(ref DateTime completionDate, string frequency, string day, string month, string year)
		{

			// frequency or date, not both and must specify at least one
			if (frequency != "0" && (day != string.Empty || month != string.Empty || year != string.Empty))
			{
				return ResourceManager.GetString("Validation.1");//"You can only specify a Frequency or the Completion Date, not both.";
			}
			else if (frequency == "0" && (day == string.Empty || month == string.Empty || year == string.Empty))
			{
				return ResourceManager.GetString("Validation.2");//"You must enter Frequency or Completion Date.";
			}


			// variable assignment - START
			if (!(year.Length == 0 && month.Length == 0 && day.Length == 0))
			{
				try
				{
					// try to crate date object fails if selected values are incorrect (e.g 31st of Feb)
					completionDate = new DateTime(int.Parse(year), int.Parse(month), int.Parse(day));
				}
				catch 
				{
					return ResourceManager.GetString("Validation.3");//"Invalid date.";
				}
			}

			if (completionDate < DateTime.Now.Date && completionDate != DateTime.Parse("1/1/1900"))
			{
				return ResourceManager.GetString("Validation.4");//"Completion Date must be a current or future date.";
			}
			// variable assignment - END

			return string.Empty;
		}
	}
}
