using System;
using System.Configuration;
using System.Resources;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace ExportToCSV
{
	/// <summary>
	/// Summary description for ExportTool.
	/// </summary>
	public class ExportTool
	{
        private string m_strConnectionString;
        private string m_strSQL;
        private int m_intOrganisationID;
        private string m_strFileName;

		public ExportTool()
		{
		    Setup();
		}
        private void Setup()
        {
            LoadSettings();
            AdjustSettings();
            
        }
        public void Run()
        {
            // Delete previous results
            File.Delete(m_strFileName);
            Tools.WriteFile(m_strFileName,"UserName, Password, First Name, Last Name, Email, External ID,Unit ID, Classification Name, Classification Value, Salt 2.5 Unit Name\n",false);
            // Setup ADO.net
            SqlConnection objConn = new SqlConnection(m_strConnectionString);
            SqlCommand objCmd = new SqlCommand(m_strSQL,objConn);
            objConn.Open();
            SqlDataReader objReader = objCmd.ExecuteReader(CommandBehavior.CloseConnection);
            
            // Append each result to the output file
            if (objReader.HasRows)
            {
                string strCSV = Tools.GetCSV(objReader);
                Tools.WriteFile(m_strFileName,strCSV,true);
            }
            while (objReader.NextResult())
            {   
                if (objReader.HasRows)
                {
                    string strCSV = Tools.GetCSV(objReader);
                    Tools.WriteFile(m_strFileName,strCSV,true);
                }
                
            }

            // Done
            objConn.Close();
        }

        private void LoadSettings()
        {
            // Read 'App.Config' settings
            m_intOrganisationID     = Convert.ToInt32( ConfigurationSettings.AppSettings["OrganisationID"]);
            m_strConnectionString   = ConfigurationSettings.AppSettings["ConnectionString"];
            m_strFileName           = ConfigurationSettings.AppSettings["FileName"];
            
            // Read 'Script.txt' file.
            m_strSQL = Tools.ReadFile("Script.txt");
        }
        private void AdjustSettings()
        {
            m_strSQL = m_strSQL.Replace("%OrganisationID%",m_intOrganisationID.ToString());
        }
            
	}
}
