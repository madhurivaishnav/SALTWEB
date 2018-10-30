using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;

namespace Bdw.Application.Salt.Data
{
	/// <summary>
	/// This class provides static methods to manipulate Sql Data Type.
	/// </summary>
	public abstract class DatabaseTool
	{
        /// <summary>
        /// Static function returning a string from a datetime
        /// </summary>
        /// <param name="dateTime">DateTime object to convert</param>
        /// <returns>String representation of the datetime</returns>
		public static string ToLongDateTimeString(DateTime dateTime)
		{
			return dateTime.ToString("yyyy-MM-dd HH:mm:ss.fff");
		}
		
		/// <summary>
		/// Convert the value of SqlType to string. If the value is Null, return empty string
		/// </summary>
		/// <param name="o">Object that is to be converted to a string</param>
		/// <returns></returns>
		public static string SqlToString(object o)
		{
			string val;
			
			if(o == null)
			{
				val = "";
				return val;
			}
			val = o.ToString();
			if(o.GetType().Name.Equals("SqlBoolean"))
			{
				if(val == "Null")
				{
					val = "false";
				}
			}
			else if(o.GetType().Name.Equals("SqlInt32"))
			{
				if(val == "Null")
				{
					val = "0";
				}
			}
			else
			{
				if(val == "Null")
				{
					val = "";
				}
			}

			return val;	
		}
		/// <summary>
		/// Convert the value of SqlBoolean to string
		/// </summary>
		/// <param name="o"></param>
		/// <returns></returns>
		public static string SqlToString(SqlBoolean o)
		{
			string val;
			
			if (o.IsNull)
			{
				val = "false";
			}
			else
			{
				val = o.ToString();
			}
			return val;	
		}

		/// <summary>
		/// Convert the value of SqlDateTime to string
		/// </summary>
		/// <param name="o"></param>
		/// <returns></returns>
		public static string SqlToString(SqlDateTime o)
		{
			string val;
			
			if (o.IsNull)
			{
				val = "";
			}
			else
			{
				val = o.ToString();
			}
			return val;	
		}

		/// <summary>
		/// Convert the value of SqlDateTime to string.
		/// Format: d :08/17/2000,g :08/17/2000 16:32, t :16:32, D:Thursday, August 17, 2000,f :Thursday, August 17, 2000 16:32,
		/// </summary>
		/// <param name="o">Datetime to convert.</param>
		/// <param name="format">Format to convert the datetime to.</param>
		/// <returns></returns>
		public static string SqlToString(SqlDateTime o, string format)
		{
			string val;
			
			if (o.IsNull)
			{
				val = "";
			}
			else
			{
				val = o.Value.ToString(format);
			}


			return val;	
		}

				
		#region SqlString array methods
		/// <summary>
		/// Split SqlString to SqlString array
		/// ex: "12,123,234,234" to "12","123", "234", "234"
		/// </summary>
		/// <param name="s"></param>
		/// <param name="separator"></param>
		/// <returns></returns>
		public static SqlString[] SqlStringSplit(SqlString s, char separator)
		{
			string val;
			string[] vals;
			SqlString[] SqlVals;
			//if the string is null, return empty array
			if (s.IsNull || s.Value.Trim().Length == 0)
			{
				return new SqlString[0];
			}

			val = s.Value;
			vals = val.Split(new char[]{separator});

			SqlVals = new SqlString[vals.Length];
			for(int i = 0; i < vals.Length; i++)
			{
				SqlVals[i]= vals[i];	
			}
			
			return SqlVals;
		}

		/// <summary>
		/// Merge SqlString  array to SqlString
		/// ex: "12","123", "234", "234" to "12,123,234,234"
		/// </summary>
		/// <param name="s"></param>
		/// <param name="separator"></param>
		/// <returns></returns>
		public static SqlString SqlStringMerge(SqlString[] s, char separator)
		{
			string val = "";
			//if the array  is empty, return null SqlString 
			if (s.Length == 0)
			{
				return SqlString.Null;
			}

			for(int i = 0; i < s.Length; i++)
			{
				if (s[i].IsNull)
				{
					val += separator;
				}
				else
				{
					val += separator + s[i].Value;
				}
			}
			//Get rid of the first separator
			val = val.Substring(1);

			return val;
		}
		#endregion
	}
}

