using System;
using System.Data;
using System.IO;
using System.Text;
using Localization;
namespace Bdw.Application.Salt.Utilities
{
	/// <summary>
	/// This class provides methods to generate a CSV string from a DataTable
	/// and either write this data to a file or return it via a Stream object.
	/// </summary>
	/// <remarks>
	/// Assumptions: XSD file is a valid XSD file.
	/// Notes:
	/// Author: Peter Vranich, 28/01/0/2004
	/// Changes:
	/// </remarks>
	/// <example></example>
	public class CSVGenerator
	{
		#region Declarations
	
		/// <summary>
		/// Text to appear on first line of the generated CSV string.
		/// </summary>
		private string m_strHeaderText;			
		
		/// <summary>
		/// The generator will use the table column names if this value is not specified
		/// </summary>
		private string[] am_strColumnNames;
		
		/// <summary>
		/// DataTable populated with rows that are used to populate the CSV string.
		/// </summary>
		private DataTable m_dtbDataSource;
		
		/// <summary>
		/// Value to seperate each colunm value.
		/// </summary>
		private const string cm_strColumnDelimiter = ",";

		/// <summary>
		///  Value to seperate each row.
		/// </summary>
		private const string cm_strRowDelimiter = "\r\n";

		#endregion

		#region Public Properties
		/// <summary>
		/// Gets or Sets the header text in output csv file.
		/// This can be one line or multiple lines of text with \r\n as line delimiter
		/// </summary>
		/// <remarks>
		/// Assumptions: NumberToReturn > 0
		/// Notes:
		/// Author: Peter Kneale, 05/02/2004
		/// Changes:
		/// </remarks>
		public string HeaderText
		{
			get
			{
				return m_strHeaderText;
			}
			set
			{
				m_strHeaderText = value;
			}
		}		

		/// <summary>
		/// Gets or Sets the customised column names.
		/// The generator will use the table column names if this value is not specified
		/// If the number of columns doesnt equal the upper bound of this array then an 
		/// error will be raised. Empty Strings are acceptable if no column header is required
		/// for a particular column. Ie:
		/// if Column[i] Not Initialised : Header = DataColumn[i]
		/// if Column[i] Initialised     : Header = ..,Column[i],...
		/// if Column[i] Empty String    : Header = ..,,..
		/// </summary>
		public string[] Columns
		{
			get
			{
				return am_strColumnNames;
			}
			set
			{
				am_strColumnNames = value;
			}
		}

		/// <summary>
		/// Gets or Sets data source table for the csv body.
		/// </summary>
		public DataTable DataSource
		{
			get
			{
				return m_dtbDataSource;
			}
			set
			{
				m_dtbDataSource = value;
			}
		}		

		#endregion

		#region Constructors
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="dataSource">DataTable containing desired information to be written to CSV file.</param>
		public CSVGenerator(DataTable dataSource)
		{
			this.m_dtbDataSource = dataSource;
		}
		#endregion

		#region Public Methods
		/// <summary>
		/// Generates and saves the CSV document to the specified stream
		/// </summary>
		/// <param name="outStream">outStream returns Stream of data from the DataTable in CSV format.</param>
		public  void Generate(Stream outStream)
		{
			string content = this.GenerateContent();	
			
			byte[] info = new UTF8Encoding(true).GetBytes(content);

			outStream.Write(info, 0, info.Length);
		}

		/// <summary>
		/// Generates and saves the CSV document to the specified file.
		/// If the file already exists it will be written over.
		/// If the file doesnt exist then it will be created.
		/// </summary>
		/// <param name="fileName"> File name that you wish to save the content to.</param>
		/// <example>
		/// This will generate a csv file named 'C:\example.txt' from the stored procedure 'spTest'.
		/// The column headings will look like this:
		/// 
		/// ******** Testing Report Generator ******** 
		/// Column One,DBCOLUMN2,Column Three,Column Four,DBCOLUMN3
		/// 
		/// Where DBCOLUMN is the name of the column returned by the stored procedure.
		/// 
		/// <code>
		/// Bdw.Application.Salt.Data.StoredProcedure spGetResults = new Bdw.Application.Salt.Data.StoredProcedure("spTest");
		/// System.Data.DataSet ds;
		/// ds = spGetResults.ExecuteDataSet();
		/// DataTable dtbData = ds.Tables[0] ;
		/// String[] astrColHeadings = new String[5];
		/// astrColHeadings[0]="Column One";
		/// astrColHeadings[2]="Column Three";
		/// astrColHeadings[3]="Column Four";
		/// Salt.Utilities.CSVGenerator csvTest = new Bdw.Application.Salt.Utilities.CSVGenerator(dtbData);
		/// csvTest.Columns = astrColHeadings;
		/// csvTest.HeaderText =" ******** Testing Report Generator ******** ";		
		/// csvTest.Generate ("c:\\example.txt");
		/// </code> 
		/// </example>
		public void Generate(string fileName)
		{
			// if the filename is too short (must have at least a.txt)
			if (fileName.Length<5)
			{
				// Raise appropriate exception
				throw new ArgumentException(ResourceManager.GetString("CSVGenerator.cs.Generate"), "fileName");
			} 
			// If the file has no extension
			if (fileName.IndexOf(".") == -1)
			{
				// Raise appropriate exception
				throw new ArgumentException(ResourceManager.GetString("CSVGenerator.cs.Generate2"), "fileName");
			}


			// Generate content
			string content = this.GenerateContent();
			StreamWriter sw;
			try
			{
				sw = new StreamWriter(fileName);
				// StreamWriter object to write to desired file.
				sw.Write(content);
				sw.Flush();
				
			}			
			catch(Exception ex)
			{
				// Raise appropriate exception				
				throw ex;
			}
			sw.Close();
		}



		/// <summary>
		/// Generates a string from column values in m_dtbDataSource.
		/// Columns are delimited by cm_strColumnDelimiter.
		/// Rows are delimited by cm_strRowDelimiter.
		/// Columns containing string values are enclosed in double quotes.
		/// </summary>
		/// <returns>String: Comma Seperated Values From m_dtbDataSource</returns>

		private string GenerateContent() 
		{
			// if the array was populated
			if (am_strColumnNames != null)   
			{
				// Check we have the required number of column headers
				if (am_strColumnNames.GetUpperBound(0) != m_dtbDataSource.Columns.Count -1)
				{
					// Raise appropriate exception
					throw new ArgumentException(ResourceManager.GetString("CSVGenerator.cs.GenerateContent"), "am_strColumnNames");
				}
			}

			// Index variables used to iterate through columns
			int intIndex;
			
			// String builder object used hold Comma Seperated String
			StringBuilder stbCSV = new StringBuilder();

			// Add Header String
			stbCSV.Append (this.HeaderText);

			stbCSV.Append (cm_strRowDelimiter); 
			
			// For each column.
			for (intIndex=0;intIndex!=m_dtbDataSource.Columns.Count;intIndex++)
			{
				// If custom headers are in use.
				if (am_strColumnNames!=null)
				{
					// If a custom header name is supplied
					if (am_strColumnNames[intIndex] != null)
					{
						// Use it.
						stbCSV.Append (am_strColumnNames[intIndex].ToString() );
					}
					else
					{
						// Otherwise, Use the table column name.
						stbCSV.Append (m_dtbDataSource.Columns[intIndex].ColumnName.ToString() );
					}
				}
				else
				{
					// Otherwise, Use the table column name.
					stbCSV.Append (m_dtbDataSource.Columns[intIndex].ColumnName.ToString() );
				}
				stbCSV.Append (cm_strColumnDelimiter); 
			}
			// Remove trailing comma from header.
			stbCSV.Remove(stbCSV.Length-1,1);
			stbCSV.Append (cm_strRowDelimiter); 

			// Cycle through each data row present in the m_dtbDataSource data table.
			foreach (DataRow drwCurrentDataRow in m_dtbDataSource.Rows)
			{
				
				// Cycle through each data column present in the m_dtbDataSource data table.
				for (intIndex=0;intIndex!=m_dtbDataSource.Columns.Count;intIndex++)
				{
					// Select appropriate action based on the data type of the column
					switch (m_dtbDataSource.Columns[intIndex].DataType.ToString())
					{
						case "System.Boolean":
						{
							stbCSV.Append (drwCurrentDataRow.ItemArray[intIndex].ToString()); 
							stbCSV.Append (cm_strColumnDelimiter);
							break;
						}
			
						case "System.DateTime":
						{
							if (drwCurrentDataRow.ItemArray[intIndex].ToString().Length > 0 )
							{
								DateTime dteDateTimeValue = new DateTime ();
								dteDateTimeValue = System.Convert.ToDateTime( drwCurrentDataRow.ItemArray[intIndex] );
								stbCSV.Append (dteDateTimeValue.ToShortDateString() + " " + dteDateTimeValue.ToLongTimeString()); 
								stbCSV.Append(cm_strColumnDelimiter);
							}
							break;
						}

						// All numeric data types fall though to the same case.
						case "System.Double":
						case "System.Single":
						case "System.Int64":
						case "System.Int32":
						case "System.Int16":
						case "System.Decimal":
						{
							stbCSV.Append (drwCurrentDataRow.ItemArray[intIndex].ToString()); 
							stbCSV.Append(cm_strColumnDelimiter);
							break;
						}
						
						case "System.Byte":
						case "System.Byte[]":
						{
							stbCSV.Append (drwCurrentDataRow.ItemArray[intIndex].ToString()); 
							stbCSV.Append(cm_strColumnDelimiter);
							break;
						}
						case "System.String":
						{
							// Add quotes around string values.
							stbCSV.Append ("\"");

							// szValue contains the current value but with newlines replaced with '\n'
							string strValue = drwCurrentDataRow.ItemArray[intIndex].ToString().Replace(Environment.NewLine, "\n");
							
							// Replace Values that interfere with the delimiting.
							strValue = strValue.Replace ("\n","");
							strValue = strValue.Replace (cm_strColumnDelimiter,"");
							strValue = strValue.Replace ("\"","'");
							// Append Final Value
							stbCSV.Append (strValue.ToString());
							
							// End quote
							stbCSV.Append ("\"");
							
							stbCSV.Append(cm_strColumnDelimiter);
							
							break;
						}

						default:
						{
							// Field data types such as GUID, Image, Binary, Object cannot be displayed.
							stbCSV.Append (ResourceManager.GetString("CSVGenerator.cs.GenerateContent2")); 
							stbCSV.Append(cm_strColumnDelimiter);
							break;
						}
					}						
				}

				// Remove trailing comma.
				stbCSV.Remove(stbCSV.Length-1,1);
				stbCSV.Append (cm_strRowDelimiter); 
			}
			// Return string from string builder object.
			return (stbCSV.ToString());
		}
		#endregion
	}
}
