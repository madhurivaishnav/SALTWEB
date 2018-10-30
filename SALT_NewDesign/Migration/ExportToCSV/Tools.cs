using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;

namespace ExportToCSV
{
	/// <summary>
	/// Summary description for CSVTool.
	/// </summary>
	public class Tools
	{
        public static string GetCSV(SqlDataReader dataReader)
        {
            StringBuilder objSB = new StringBuilder();
            while (dataReader.Read())
            {
                
                for (int i = 0; i!=dataReader.FieldCount; i++)
                {
                    objSB.Append(dataReader.GetSqlValue(i).ToString());
                    if (i<dataReader.FieldCount-1)
                    {
                        objSB.Append(",");
                    }
                }
                objSB.Append(Environment.NewLine);
            }
            return objSB.ToString();
        }
        public static void WriteFile(string filename, string text,bool append)
        {
            try
            {
                using(TextWriter objWriter = new StreamWriter(filename,append,System.Text.Encoding.ASCII))
                {
                    objWriter.Write(text);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
        public static string ReadFile(string fileName)
        {
            string strText="";
            try
            {
                using (TextReader objReader = new StreamReader(fileName))
                {
                    strText = objReader.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return strText;
        }
	}
}
