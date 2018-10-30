using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Reflection;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
    /// <summary>
    /// SqlUserType
    /// </summary>
	public enum SqlUserType
	{
        /// <summary>
        /// Integrated authentication
        /// </summary>
		IntegratedUser=1,

        /// <summary>
        /// SQL mixed mode authentication
        /// </summary>
	    SQLUser = 2
	}
	/// <summary>
	/// Sql Tools
	/// </summary>
	public abstract class SqlTool
	{
		private static string _IntegratedConnectionString =  "Integrated Security=SSPI;Data Source=\"{0}\";Initial Catalog=\"{1}\"";
		private static string _SQLUserConnectionString =  "Data Source=\"{0}\";Initial Catalog=\"{1}\";User Id=\"{2}\";Password=\"{3}\"";
		//private static string _ConnectionString;
		
		/// <summary>
		/// Set Sql Connection string
		/// </summary>
		/// <param name="serverName">Server name</param>
		/// <param name="databaseName">The initial catalog</param>
		/// <param name="userType">Login User type: Integrated (I), or SQL User (S)</param>
		/// <param name="user">User to authenticate with SQL Server</param>
		/// <param name="password">Password to authenticate with SQL Server</param>
		public static string GetConnectionString(string serverName, string databaseName, SqlUserType userType, string user, string password)
		{
			string connectionString;

			serverName = serverName.Replace("\"","\"\"");
			databaseName = databaseName.Replace("\"","\"\"");
			user = user.Replace("\"","\"\"");
			password = password.Replace("\"","\"\"");

			if (userType==SqlUserType.IntegratedUser)
			{
				connectionString = string.Format(SqlTool._IntegratedConnectionString,serverName,databaseName,user,password);		    
			}
			else
			{
				connectionString = string.Format(SqlTool._SQLUserConnectionString,serverName,databaseName,user,password);		    
			}
			return  connectionString;
		}

		/// <summary>
		/// Check whether Sql Connection string is valid
		/// </summary>
		/// <param name="connectionString">Sql Connection string</param>
		public static bool CheckConnection(string connectionString)
		{
			
			try
			{
				SqlConnection  connection = new SqlConnection(connectionString);		    
				connection.Open();
				connection.Close();
				return true;
			}
			catch(Exception exp)
			{
				MessageBox.Show("Connection failed.\n" + exp.Message);
				return false;
			}
		}


		///<summary>
		/// Execute the sql statement
		///</summary>
		///<param name="connectionString">database connection string </param>		    			
		///<param name="sql">SQL statement to execute</param>
		public static void Execute(string connectionString, string sql)
		{		   
			SqlConnection  connection = new SqlConnection(connectionString);		    
			connection.Open();
			SqlCommand cmd;
			int result;
			String[] lines = sql.Split(new Char[]{'\n'});        
			//StringBuilder buffer = new StringBuilder();
			string executeScript = string.Empty;
			string script;
			foreach(string l in lines)
			{
				string line = l.Trim();			
				if(line.ToLower().Equals("go"))
				{
					//script = buffer.ToString();
					script = executeScript;
					cmd                = new SqlCommand(script,connection);
					cmd.CommandTimeout = 240000;	// 4000 minutes	    
					result             = cmd.ExecuteNonQuery();    		
					cmd.Dispose();
					//buffer = new StringBuilder();
					executeScript = string.Empty;
				}
				else if(!line.StartsWith("--*"))
				{
					executeScript = executeScript + line + "\n";
					//buffer.Append(line);
					//buffer.Append("\n");		
				}
			}    
			//script = buffer.ToString();
			script = executeScript;
			if (script.Length>0)
			{
				cmd  	       = new SqlCommand(script,connection);
                cmd.CommandTimeout = 240000;	// 4000 minutes	    
				result             = cmd.ExecuteNonQuery();    		
				cmd.Dispose();       		        
			}

			connection.Close();
		}			
		
		/// <summary>
		/// Reader SQL script
		/// </summary>
		/// <param name="fileName"></param>
		/// <returns></returns>
		public static string ReadScript( string fileName )
		{
			Assembly assembly = Assembly.GetAssembly(typeof(SqlTool));
			string path = Path.GetDirectoryName(assembly.Location);

			fileName = Path.Combine(path,fileName);
			StreamReader streamReader = new StreamReader(fileName);

			return streamReader.ReadToEnd();
		}

		///<summary>
		/// Execute the sql statement, and return data datareader
		///</summary>		    			
		/// <param name="sql">SQL statement to execute</param>
		/// <param name="connectionString">connection string</param>
		public static SqlDataReader ExecuteReader(string connectionString, string sql)
		{		   
			SqlConnection  connection = new SqlConnection(connectionString);		    
			connection.Open();
			SqlCommand cmd;
			cmd  	       = new SqlCommand(sql,connection);
            cmd.CommandTimeout = 240000;	// 4000 minutes	    
			return cmd.ExecuteReader(CommandBehavior.CloseConnection) ;    		
		}			

		///<summary>
		/// Execute the sql statement, and return data datareader
		///</summary>		    			
		/// <param name="sql">SQL statement to execute</param>
		/// <param name="connectionString">connection string</param>
		public static DataTable ExecuteDataTable(string connectionString, string sql)
		{		   
			DataTable dt = new DataTable();
			SqlConnection  connection = new SqlConnection(connectionString);		    
			connection.Open();
			SqlCommand cmd;
			cmd  	       = new SqlCommand(sql,connection);
            cmd.CommandTimeout = 240000;	// 4000 minutes	    

			SqlDataAdapter dataAdapter = new SqlDataAdapter();
			dataAdapter.SelectCommand = cmd;
			dataAdapter.Fill(dt);

			cmd.Dispose();       		        
			connection.Close();
		
			return dt;    		
		}			


		///<summary>
		/// Execute the sql statement, and return thr first colum of first row
		///</summary>		    			
		///<param name="sql">SQL statement to execute</param>
		///<param name="connectionString">connection string</param>
		public static object ExecuteScalar(string connectionString, string sql)
		{		
			object returnValue;
			SqlConnection  connection = new SqlConnection(connectionString);		    
			connection.Open();
			SqlCommand cmd;
			cmd  	       = new SqlCommand(sql,connection);
            cmd.CommandTimeout = 240000;	// 4000 minutes	    
			
			returnValue = cmd.ExecuteScalar(); 
			
			cmd.Dispose();       		        
			connection.Close();
		
			return returnValue;    		
		}			

	}
}
