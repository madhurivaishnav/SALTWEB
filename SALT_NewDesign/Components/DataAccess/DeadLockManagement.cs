using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;

namespace Bdw.Application.Salt.Data
{
	/// <summary>
	/// Summary description for DeadLockManagement.
	/// </summary>
	public class DeadLockManagement
	{
		/// <summary>
		/// Execute the specified stored procedure, with the specified result type
		/// </summary>
		/// <param name="storedProcedure">Name of procedure to run</param>
		/// <param name="queryType">Type of query to run</param>
		/// <returns></returns>
		public static object CreateDeadlock(string storedProcedure, QueryType queryType) 
		{
			object retVal = null;
			using (StoredProcedure sp = new StoredProcedure(storedProcedure) )
			{
				switch (queryType) 
				{
					case QueryType.NonQuery:
						sp.ExecuteNonQuery();
						break;
					case QueryType.Reader:
						string test = "";
						using (SqlDataReader sr = sp.ExecuteReader()) 
						{
							while (sr.Read()) 
							{
								test = test + sr[0] + "|";
							}
							retVal = test;
						}
						break;
					case QueryType.Scalar:
						retVal = sp.ExecuteScalar();
						break;
					case QueryType.XMLReader:
						string test2 = "";
						System.Xml.XmlReader sx = sp.ExecuteXMLReader();
						while (sx.Read()) 
						{
							test2 = test2 + sx.ReadOuterXml() + "|";
						}
						retVal = test2;
						break;
					case QueryType.DataSet:
						retVal = sp.ExecuteDataSet();
						break;
					case QueryType.DataTable:
						retVal = sp.ExecuteTable();
						break;
				}
			}
			return retVal;
		}
		
		public static void CreateDeadLockPartA()
		{
			using (StoredProcedure sp = new StoredProcedure("prcDeadLock_PartA"))
			{
				sp.ExecuteNonQuery();
			}
		}

		public static void CreateDeadLockPartB()
		{
			using (StoredProcedure sp = new StoredProcedure("prcDeadLock_PartB"))
			{
				sp.ExecuteNonQuery();
			}
		}
	}
}
