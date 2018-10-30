using System;
using System.Collections;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Net;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.Web.Utilities
{
	/// <summary>
	/// Web Utility tools.
	/// </summary>
	public abstract class WebTool
	{	
		/// <summary>
		/// Chheck whether it is a valid date
		/// </summary>
		/// <param name="year">The year (1-99999)</param>
		/// <param name="month">The month (1-12)</param>
		/// <param name="day">The day (1-31)</param>
		/// <returns></returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static bool IsValidDate(int year, int month, int day)
		{ 
			try
			{ 
				DateTime dteDate = new DateTime(year,month, day);
				return true;
			}
			catch(ArgumentOutOfRangeException)
			{
				return false;
			}
		}

		/// <summary>
		/// Gets the root application directory.
		/// </summary>
		/// <example>
		/// http://localhost/virtual1/virtual2/
		/// <br></br>
		/// https://localhost:81/virtual1/virtual2/
		/// </example>
		public static string GetHttpRoot()
		{
				string strHttps;
				string strHost;
				string strRootPath;
				string strApplicationPath;
				
				strHttps = HttpContext.Current.Request.ServerVariables["HTTPS"].ToString();
				strHost = HttpContext.Current.Request.ServerVariables["HTTP_HOST"].ToString();
				strApplicationPath = HttpContext.Current.Request.ApplicationPath.ToString();
				
				if(strHttps.Trim().ToLower() == "off")
				{
					strRootPath = "http://";
				}
				else
				{
					strRootPath = "https://";
				}
				
				strRootPath += strHost + strApplicationPath;
				
				if(!strRootPath.EndsWith("/"))
				{
					strRootPath += "/";
				}
				
				return strRootPath;
		}

		/// <summary>
		/// Returns the specified path mapped to a physical location on the web server
		/// </summary>
		public static string MapToPhysicalPath(string strPath)
		{
			return HttpContext.Current.Server.MapPath(strPath);
		}

		/// <summary>
		/// Copies an entire directory structure
		/// </summary>
		/// <param name="strSource">The source directory to copy from</param>
		/// <param name="strDestination">The destination directory to copy to</param>
		public static void CopyDirectory(string strSource, string strDestination)
		{
			// Ensure the destination directory is correctly terminated 
			if (strDestination[strDestination.Length - 1] != Path.DirectorySeparatorChar)
			{
				strDestination += Path.DirectorySeparatorChar;
			}

			// Create the destination directory if required
			if (!Directory.Exists(strDestination))
			{
				Directory.CreateDirectory(strDestination);
			}

			// Cycle through each file system entry (files and direcotries)
			foreach (string strEntry in Directory.GetFileSystemEntries(strSource))
			{
				// Sub directories
				if (Directory.Exists(strEntry)) 
				{
					// Current entry is a sub directory
					CopyDirectory(strEntry, strDestination + Path.GetFileName(strEntry));
				}
				else
				{
					// Current entry is a file
					File.Copy(strEntry, strDestination + Path.GetFileName(strEntry), true);
				}
			}
		}

		/// <summary>
		/// Sets up a date control to display the current date by default
		/// This should be moved to a utility class as the Admin report also accesses this code
		/// </summary>
		/// <param name="objDayListbox">The Day Listbox</param>
		/// <param name="objMonthListbox">The Month Listbox</param>
		/// <param name="objYearListbox">The Year Listbox</param>
		public static void SetupHistoricDateControl(DropDownList objDayListbox, DropDownList objMonthListbox, DropDownList objYearListbox)
		{
			// Setup 'Effective' Date Controls
			objDayListbox.Items.Add("");
			for (int intDay=1; intDay<=31; intDay++)
			{
				objDayListbox.Items.Add(intDay.ToString());
			}

			objMonthListbox.Items.Add("");
			for (int intMonth=1; intMonth<=12; intMonth++)
			{
				objMonthListbox.Items.Add(intMonth.ToString());
			}

			objYearListbox.Items.Add("");
			for (int intYear=System.DateTime.Today.Year; intYear!=System.DateTime.Today.Year - 10; intYear--)
			{
				objYearListbox.Items.Add(intYear.ToString());
			}

			// Select the current Day and month
			objDayListbox.SelectedIndex = 0;
			objMonthListbox.SelectedIndex = 0;
		}

		/// <summary>
		/// Checks that the date entered in the date controll is valid
		/// Criteria:
		/// 1. Validate date
		/// 2. Must not be in the future
		/// </summary>
		/// <param name="year">year as string</param>
		/// <param name="month">month as string</param>
		/// <param name="day">day as string</param>
		public static bool ValidateHistoricDateControl(DropDownList objDayListbox, DropDownList objMonthListbox, DropDownList objYearListbox)
		{
			string year, month,day;

			year = objYearListbox.SelectedValue;
			month = objMonthListbox.SelectedValue;
			day = objDayListbox.SelectedValue;

			bool bRetVal = true;

			if (!(year.Length == 0 && month.Length == 0 && day.Length == 0))
			{
				try
				{
					DateTime dtTest = new DateTime(int.Parse(year), int.Parse(month), int.Parse(day));
					if (dtTest.CompareTo(System.DateTime.Today) >= 1)
					{
						// Can't provide a historic date in the future
						bRetVal = false;
					}
				}
				catch
				{
					bRetVal = false;
				}
			}

			return bRetVal;
		}
		
		/// <summary>
		/// Checks that the date entered in the date controll is valid
		/// Criteria:
		/// 1. Validate date
		/// </summary>
		/// <param name="year">year as string</param>
		/// <param name="month">month as string</param>
		/// <param name="day">day as string</param>
		public static bool ValidateDateControl(DropDownList objDayListbox, DropDownList objMonthListbox, DropDownList objYearListbox)
		{
			string year, month,day;

			year = objYearListbox.SelectedValue;
			month = objMonthListbox.SelectedValue;
			day = objDayListbox.SelectedValue;

			bool bRetVal = false;

			if (!(year.Length == 0 && month.Length == 0 && day.Length == 0))
			{
				try
				{
					// try to crate date object fails if selected values are incorrect (e.g 31st of Feb)
					DateTime dtTest = new DateTime(int.Parse(year), int.Parse(month), int.Parse(day));
					bRetVal = true;
				}
				catch {}
			}

			return bRetVal;
		}

		public static void SetupDateControl(DropDownList objDayListbox,DropDownList objMonthListbox,DropDownList objYearListbox, int intDateStart, int intYearsToAdd)
		{
			
			objDayListbox.Items.Clear();
			objMonthListbox.Items.Clear();
			objYearListbox.Items.Clear();

			objDayListbox.Items.Add(new ListItem(string.Empty, string.Empty));
			for (int intDay=1;intDay<=31;intDay++)
			{
				objDayListbox.Items.Add (intDay.ToString());
			}

			objMonthListbox.Items.Add(new ListItem(string.Empty, string.Empty));
			for (int intMonth=1;intMonth<=12;intMonth++)
			{
				objMonthListbox.Items.Add (intMonth.ToString());
			}

			objYearListbox.Items.Add(new ListItem(string.Empty, string.Empty));

			for (int intYear = intDateStart; intYear <= intDateStart + intYearsToAdd; intYear++)
			{
				ListItem itmEntry = new ListItem();
				itmEntry.Text = intYear.ToString();
				itmEntry.Value= intYear.ToString();

				objYearListbox.Items.Add (itmEntry);
			}
		}

	}
}
