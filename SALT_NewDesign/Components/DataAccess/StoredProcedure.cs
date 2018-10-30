using System;
using System.Configuration;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Reflection;
using System.Text;
using System.Xml;
using Microsoft.Win32;
using System.Security.Permissions;
using System.Web;
using System.Web.Configuration;
using Bdw.Application.Salt.ErrorHandler;

namespace Bdw.Application.Salt.Data
{
	/// <summary>
	/// This class provides common access interface to the SQL server database.  It simplifies database access and centrally controls database connection.
	/// All database accesses must use stored procedures. 
	/// </summary>
	public class StoredProcedure : IDisposable
	{
		private string m_strConnectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
        SqlCommand cmd;

		private bool m_blnDeadLockResolutionOn = Boolean.Parse(ConfigurationSettings.AppSettings["DeadLockResolutionOn"].ToString());
		private int  m_intDeadLockResolutionAttempts = Int32.Parse(ConfigurationSettings.AppSettings["DeadLockResolutionAttempts"].ToString());
		private int  m_intDeadLockResolutionMinWaitTime = Int32.Parse(ConfigurationSettings.AppSettings["DeadLockResolutionMinWaitTime"].ToString());
		private int  m_intDeadLockResolutionMaxWaitTime = Int32.Parse(ConfigurationSettings.AppSettings["DeadLockResolutionMaxWaitTime"].ToString());
		
		// Unused !?
		//string m_strDeadLockResolutionMessage = "Attempt {0} of {1}.";

						
		#region Public Properties

        /// <summary>
        /// Returns a collection of parameters attached to command object
        /// </summary>
		public SqlParameterCollection Parameters
		{
			get 
			{ 
				return cmd.Parameters; 
			}
		}

        /// <summary>
        /// Returns the name of the procedure
        /// </summary>
		public string ProcedureName
		{
			get 
			{ 
				return cmd.CommandText; 
			}
		}

        /// <summary>
        /// Sets and returns the connectionstring
        /// </summary>
		public string ConnectionString
		{
			get 
			{ 
				return m_strConnectionString; 
			}
			set 
			{
				m_strConnectionString = value;
				if (cmd != null)
				{
					cmd.Connection = new SqlConnection(m_strConnectionString);
				}
			}
		}
		#endregion

		#region Constructor, Deconstructor, Disposal
        /// <summary>
        /// Constructor for the stored procedure class
        /// </summary>
        /// <param name="name">Name of the stored procedure</param>
        /// <param name="parameters">SQL Parameters passed in via the parameters parameter</param>
		public StoredProcedure(string name, params SqlParameter[] parameters)
		{   
            cmd = new SqlCommand(name, new SqlConnection(m_strConnectionString));
			cmd.CommandType = CommandType.StoredProcedure;
			cmd.CommandTimeout = 20*60; //minutes

			foreach(SqlParameter param in parameters)
			{
            /// TODO: check the paramaters for x site scripting or sql injection
				//Convert empty string parameter to null value to keep not null constraint in database	
				if (param.SqlDbType == SqlDbType.VarChar ||param.SqlDbType == SqlDbType.Text ||param.SqlDbType == SqlDbType.Char)
				{
					//Check Null value
					//1. Convert null object to DBNull.Value
					if (param.Value==null)
					{
						param.Value = DBNull.Value;
					}
					//2. Convert SqlString isNull property to DBNull.Value
					//Note: SqlString null value will convert to "null" string
					else if(param.Value.GetType().Name == "SqlString") 
					{
						 
						if (((SqlString)param.Value).IsNull)
						{
							param.Value = DBNull.Value;
						}
					}
					//3. Convert all empty string to DBNull.Value
					param.Value = param.Value.ToString().Trim();
					if (param.Value.ToString() == "")
					{
						param.Value = DBNull.Value;
					}
				}
				cmd.Parameters.Add(param);
			}
		}

        /// <summary>
        /// Dispose of the stored procedure
        /// </summary>
		~StoredProcedure()
		{
		}

        /// <summary>
        /// Dispose of the instantiated object.
        /// </summary>
		public void Dispose()
		{
			if(cmd != null)
			{
				if(cmd.Connection.State == ConnectionState.Open)
				{
					cmd.Connection.Close();
				}
				cmd.Connection.Dispose();				
				cmd.Dispose();
				cmd = null;
				GC.SuppressFinalize(this);
			}
		}
		#endregion

		#region Public Methods
		private bool IsDeadlock(Exception ex)
		{
			try
			{
				SqlException exDeadLock = (SqlException) ex;
				return (exDeadLock.Number==1205);
			}
			catch
			{
				return false;
			}
		}

		private void Sleep()
		{
			int intWaitTime = GetDeadLockResolutionWaitTime();
			Debug.WriteLine(string.Format("Sleeping {0}ms.",intWaitTime.ToString()));
							
			System.Threading.Thread.Sleep(intWaitTime);

			Debug.WriteLine("Awoken.");
		}

		/// <summary>
		///	Executing this stored procedure.
		/// </summary>
		public void ExecuteNonQuery()
		{
			ExecuteDeadlockSafeQuery(QueryType.NonQuery);
				
		}

		/// <summary>
		///	Executing this stored procedure, Return SqlData reader
		/// </summary>
		public SqlDataReader ExecuteReader()
		{
			object retVal = ExecuteDeadlockSafeQuery(QueryType.Reader);
			if (retVal!=null) 
			{
				return (SqlDataReader)retVal;
			}
			else 
			{
				return null;
			}
		}

		/// <summary>
		///	Executing this stored procedure, Return XML reader
		/// </summary>
		public XmlReader ExecuteXMLReader()
		{
			object retVal = ExecuteDeadlockSafeQuery(QueryType.XMLReader);
			if (retVal!=null) 
			{
				return (XmlReader)retVal;
			}
			else 
			{
				return null;
			}
		}

		/// <summary>
		/// Executes the stored procedure and returns the first field of the first record
		/// </summary>
		public object ExecuteScalar()
		{
			return ExecuteDeadlockSafeQuery(QueryType.Scalar);
		}

		/// <summary>
		///	Executing this stored procedure, fill in a DataTable with the result 
		/// </summary>
		public DataTable ExecuteTable()
		{
			object retVal = ExecuteDeadlockSafeQuery(QueryType.DataTable);
			if (retVal!=null) 
			{
				return (DataTable)retVal;
			}
			else 
			{
				return null;
			}
		}


		/// <summary>
		///	Executing this stored procedure, fill in a DataSet with the result 
		/// </summary>
		public DataSet ExecuteDataSet()
		{
			object retVal = ExecuteDeadlockSafeQuery(QueryType.DataSet);
			if (retVal!=null) 
			{
				return (DataSet)retVal;
			}
			else 
			{
				return null;
			}
		}

		/// <summary>
		/// Execute a Single Query based on the queryType provided
		/// </summary>
		/// <param name="queryType">Query Type value from enum</param>
		/// <returns>Object containing the resultset</returns>
		private object ExecuteSingleQuery(QueryType queryType) 
		{
			object retVal = null;
			//Open connection if closed
			if(cmd.Connection.State == ConnectionState.Closed)
			{
				cmd.Connection.Open();
			}
			//Determine type of query and execute
			switch (queryType) 
			{
				case QueryType.NonQuery:
					cmd.ExecuteNonQuery();
					break;
				case QueryType.Reader:
					retVal = cmd.ExecuteReader(CommandBehavior.CloseConnection);
					break;
				case QueryType.Scalar:
					retVal = cmd.ExecuteScalar();
					break;
				case QueryType.XMLReader:
					retVal = cmd.ExecuteXmlReader();
					break;
				case QueryType.DataSet:
					DataSet ds = new DataSet();
					SqlDataAdapter dataAdapter1 = new SqlDataAdapter();
					dataAdapter1.SelectCommand = cmd;
					dataAdapter1.Fill(ds);
					retVal = ds;
					break;
				case QueryType.DataTable:
					DataTable dt = new DataTable();
					SqlDataAdapter dataAdapter2 = new SqlDataAdapter();
					dataAdapter2.SelectCommand = cmd;
					dataAdapter2.Fill(dt);
					retVal = dt;
					break;
			}
			// return query result
			return retVal;
		}

		/// <summary>
		/// Execute a query and retry several times if deadlocked
		/// </summary>
		/// <param name="queryType">QueryType based on enum</param>
		/// <returns>Result set of query</returns>
		private object ExecuteDeadlockSafeQuery(QueryType queryType)
		{
			bool blnSuccess = false;
			object retVal = null;
			//Debug.WriteLine("Begin ExecuteQuery() Method");
			if(cmd == null) 
			{
				throw new ObjectDisposedException(GetType().FullName);
			}
			try
			{
				//Note execution is beginning
				//Debug.WriteLine("\tExecuting " + cmd.CommandText + "...");
				//Execute appropriate query
				retVal = ExecuteSingleQuery(queryType);
				//If query succeeds
				blnSuccess=true;
				//Debug.WriteLine("\tExecuted " + cmd.CommandText + ".");
				//Return query result
				return retVal;
			}
			catch(Exception ex)
			{
				Debug.WriteLine("Error #1:" + cmd.CommandText);
				
				// If we wish to attempt to resolve deadlocks
				if (IsDeadlock(ex))
				{
					Debug.WriteLine("Error Type: DeadLock");
					#region DeadResolution
					if (m_blnDeadLockResolutionOn)
					{
						Debug.WriteLine("DeadLock resolution is on");
						
						int intAttempts = 1;

						#region ReAttempt the Query
						// If we have enough attempts left and a dead lock has occurred
						while (m_intDeadLockResolutionAttempts >0 && IsDeadlock(ex))
						{
							Debug.WriteLine("Attempt #" + intAttempts.ToString() + ".");
				
							// Decrease the number of remaining attempts
							m_intDeadLockResolutionAttempts--;

							// Log the message
							ErrorHandler.ErrorLog objErrorLog = new ErrorLog(ex,ErrorLevel.Warning,"StoredProcedure","ExecuteNonQuery","DeadLock Detection" ,
								"[Stored Procedure Details]: " + this.ToString());

							try
							{
								// Sleep for a random time period
								Sleep();
								
								// Reattempt the query
								retVal = ExecuteSingleQuery(queryType);
								
								Debug.Write("Reattempting the query:Success");
								
								// the query must have succeeded.
								blnSuccess=true;
								
								// Log the successful resolution of the deadlock if it occurred.
								objErrorLog = new ErrorLog(ex,ErrorLevel.InformationOnly,"ExecuteNonQuery","Deadlock resolved.","Reattempted to resolve deadlock and succeeded on attempt #" + intAttempts.ToString(),
									"[Stored Procedure Details]: " + this.ToString());

								//TODO: No longer required?
								// Setting this to null breaks us out of the loop
								ex = null;

								return retVal;
							}
							catch (Exception exReOccur)
							{
								Debug.Write("Reattempting the query:Failure");
								
								objErrorLog = new ErrorLog(exReOccur,ErrorLevel.Warning,"ExecuteNonQuery","Deadlock resolved.","Reattempted to resolve deadlock and failed attempt #" + intAttempts.ToString(),
									"[Stored Procedure Details]: " + this.ToString());

								// If the error is not another deadlock then throw the exception 
								if (!IsDeadlock(exReOccur))
								{
									Debug.WriteLine("This time an error occurred that wasnt a deadlock");
									objErrorLog = new ErrorLog(ex,ErrorLevel.High,"ExecuteNonQuery","Deadlock resolution error.","Reattempted to resolve deadlock and received a different error",
										"[Stored Procedure Details]: " + this.ToString());

									throw new Exception("This error occurred after attempting to resolve a deadlock by re-executing the query." ,exReOccur);
								}
								else
								{
									Debug.WriteLine("Deadlock reoccurred.");
									// capture the deadlock exception again
									ex = exReOccur;
								}
							}
							intAttempts++;
						}
						#endregion
						// If we havent managed a successful query yet
						if (!blnSuccess)
						{
							string strMessage = "The query was not able to be resolved within the number of attempts permissable.";
							Debug.WriteLine(strMessage);
							ErrorLog objErrorLog = new ErrorLog(ex,ErrorLevel.High,"ExecuteNonQuery","Deadlock NOT resolved.",strMessage,
															 "[Stored Procedure Details]: " + this.ToString());

							throw new DatabaseException(this.ToString(), ex);
						}
					}
					else
					{
						Debug.WriteLine("DeadLock resolution is off");
					}
					#endregion					
				}
				else
				{
					Debug.WriteLine("Error Type: Other");
					
					throw new DatabaseException(this.ToString(), ex);
				}
			}
			//Debug.WriteLine("End ExecuteNonQuery() Method");
			return retVal;				
		}
		#endregion

		#region Override ToString Method
		/// <summary>
		/// Returns a string representation of the stored procedure, the string can be executed in query analyser
		/// </summary>
		public override string ToString()
		{
			//Estimate size of output, 50 for the sp name, and 50 for each parameter
			int estSize = (cmd.Parameters.Count * 50) + 50;
			PropertyInfo property;
			object val;

			StringBuilder sb = new StringBuilder(estSize);

			sb.Append(cmd.CommandText + " ");

			foreach(SqlParameter parameter in cmd.Parameters)
			{

				val = parameter.Value;
				//1. General null value or DBNull value
				if(val == null || Convert.IsDBNull(val))
				{
					sb.AppendFormat("{0}= null", parameter.ParameterName);
					sb.Append(", ");
					continue;
				}
				//2. SQL data type Null value 
				//Check whether the value has IsNull property (Sql data type)
				property = val.GetType().GetProperty("IsNull");
				//If the IsNull property exists, check the value
				if (property != null && (bool)property.GetValue(val,null))
				{
					sb.AppendFormat("{0}= null", parameter.ParameterName);
					sb.Append(", ");
					continue;
				}
				//3. Other non null values
				switch(parameter.SqlDbType)
				{
					case SqlDbType.Int:
						sb.AppendFormat("{0}={1}", parameter.ParameterName, val.ToString());
						break;
					case SqlDbType.DateTime: goto case SqlDbType.Int;
					case SqlDbType.Money: goto case SqlDbType.Int;
					case SqlDbType.Decimal: goto case SqlDbType.Int;
					case SqlDbType.Float: goto case SqlDbType.Int;
					case SqlDbType.Bit:
						if(val.ToString() == "False")
						{						
							sb.AppendFormat("{0}= 0", parameter.ParameterName);
						}
						else if(val.ToString() == "True")
						{						
							sb.AppendFormat("{0}= 1", parameter.ParameterName);
						}
						else
						{
							sb.AppendFormat("{0}={1}", parameter.ParameterName, val.ToString());
						}
						break;
					default:
						sb.AppendFormat("{0}='{1}'", parameter.ParameterName, val.ToString());
						break;
				}
				sb.Append(", ");
			}

			return sb.ToString().TrimEnd(' ', ',');
		}
		#endregion

		#region Public Static Methods
        /// <summary>
        /// Creates an input parameter
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateInputParam(string name, SqlDbType sqlType) 
		{
			SqlParameter param = new SqlParameter(name, sqlType);
			param.Direction = ParameterDirection.Input;
			return param;
		}
		
//		public static SqlParameter CreateInputParam(string name, SqlDbType sqlType, int length) 
//		{
//			SqlParameter param = new SqlParameter(name, sqlType, length);
//			param.Direction = ParameterDirection.Input;
//			return param;
//		}
		
        /// <summary>
        /// Creates an input parameter with a value
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="val">Value of the parameter</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateInputParam(string name, SqlDbType sqlType, object val) 
		{
			SqlParameter param = new SqlParameter(name, sqlType);
			param.Direction = ParameterDirection.Input;
			param.Value = val;
			return param;
		}

        /// <summary>
        /// Creates an input parameter with a value and a length
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="val">Value of the parameter</param>
        /// <param name="length"></param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateInputParam(string name, SqlDbType sqlType, int length, object val) 
		{
			SqlParameter param = new SqlParameter(name, sqlType, length);
			param.Direction = ParameterDirection.Input;
			param.Value = val;
			return param;
		}
		
        /// <summary>
        /// Creates an input parameter with a scale, precision and a length
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="precision">Precison of the value</param>
        /// <param name="scale">Scale of the value</param>
        /// <param name="val">Value of the parameter.</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateInputParam(string name, SqlDbType sqlType, int precision,int scale, object val) 
		{
			SqlParameter param = new SqlParameter(name, sqlType);
			param.Direction = ParameterDirection.Input;
			param.Precision = Convert.ToByte(precision);
			param.Scale = Convert.ToByte(scale);
			param.Value = val;
			return param;
		}

        /// <summary>
        /// Creates a new output parameter
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateOutputParam(string name, SqlDbType sqlType) 
		{
			SqlParameter param = new SqlParameter(name, sqlType);
			param.Direction = ParameterDirection.InputOutput;
			return param;
		}
		
        /// <summary>
        /// Creates a new output parameter 
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="length">Length of the parameter</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateOutputParam(string name, SqlDbType sqlType, int length) 
		{
			SqlParameter param = new SqlParameter(name, sqlType, length);
			param.Direction = ParameterDirection.InputOutput;
			return param;
		}
		
        /// <summary>
        /// Creates a new output parameter of a certain length and value
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="length">Length of the parameter</param>
        /// <param name="val">Value of the new parameter</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateOutputParam(string name, SqlDbType sqlType, int length, object val) 
		{
			SqlParameter param = new SqlParameter(name, sqlType, length);
			param.Direction = ParameterDirection.InputOutput;
			param.Value = val;
			return param;
		}
		
        /// <summary>
        /// Creates a new output parameter
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="precision">Precison of the value</param>
        /// <param name="scale">Scale of the value</param>
        /// <param name="val">Value of the parameter.</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateOutputParam(string name, SqlDbType sqlType, int precision,int scale, object val) 
		{
			SqlParameter param = new SqlParameter(name, sqlType);
			param.Direction = ParameterDirection.InputOutput;
			param.Precision = Convert.ToByte(precision);
			param.Scale = Convert.ToByte(scale);
			param.Value = val;
			return param;
		}

        /// <summary>
        /// Creates a new return parameter 
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateReturnParam(string name, SqlDbType sqlType) 
		{
			SqlParameter param = new SqlParameter(name, sqlType);
			param.Direction = ParameterDirection.ReturnValue;
			return param;
		}

        /// <summary>
        /// Creates a new return parameter 
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="length">Length of the parameter</param>
        /// <returns>A new sql parameter.
        /// </returns>
		public static SqlParameter CreateReturnParam(string name, SqlDbType sqlType, int length) 
		{
			SqlParameter param = new SqlParameter(name, sqlType, length);
			param.Direction = ParameterDirection.ReturnValue;
			return param;
		}

        /// <summary>
        /// Creates a new return parameter 
        /// </summary>
        /// <param name="name">Name of the parameter</param>
        /// <param name="sqlType">sqlType of the parameter</param>
        /// <param name="length">Length of the parameter</param>
        /// <param name="val">Value of the parameter.</param>
        /// <returns>A new sql parameter.</returns>
		public static SqlParameter CreateReturnParam(string name, SqlDbType sqlType, int length, object val) 
		{
			SqlParameter param = new SqlParameter(name, sqlType, length);
			param.Direction = ParameterDirection.ReturnValue;
			param.Value = val;
			return param;
		}
		#endregion

		#region Private Methods
		/// <summary>
		/// Gets a random number between the two DeadLockResolution Wait Times defined in Web.Config
		/// </summary>
		/// <returns>A random wait time.</returns>
		private int GetDeadLockResolutionWaitTime()
		{
			Random objRan = new Random();
			// Get a random number up to the maximum value
			int intRandomNumber=0;
			while (intRandomNumber <= m_intDeadLockResolutionMinWaitTime)
			{
				intRandomNumber = objRan.Next(m_intDeadLockResolutionMaxWaitTime);
			}	

			//intRandomNumber = 100;
			return intRandomNumber;
		}
		#endregion
	}
}
