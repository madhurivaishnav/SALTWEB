using System;
using System.IO;
using System.Collections;

namespace DatabaseScriptCompiler
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class Class1
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main(string[] args)
		{
			/// Program comiles singular script files into Complete script files for Tables, Stored Procedures, Views, Function etc.
			/// Is executed via ..\Database\RecreateDatabase.cmd
			/// This is so the developer remembers to check out the project otherwise exceptions can be thrown for readonly / checkin source files.
			
			string solutionRootPath = Environment.CurrentDirectory.Replace(@"\DatabaseScriptCompiler\bin\Debug", @"\Database").Replace(@"\DatabaseScriptCompiler\bin\Release", @"\Database");

            Console.WriteLine();
            Console.Write("starting procedures.");
			Procedure(solutionRootPath);
            
            Console.WriteLine();
            Console.Write("starting tables.");			
            Table(solutionRootPath);
            
            Console.WriteLine();
            Console.Write("starting functions.");
			Function(solutionRootPath);

            Console.WriteLine();
            Console.Write("starting views.");			
            View(solutionRootPath);

            Console.WriteLine();
            Console.Write("starting triggers.");
			Triggers(solutionRootPath);

            Console.WriteLine();
            Console.Write("starting database.");
			Database(solutionRootPath);

			Console.WriteLine();
			Console.Write("Complete, press ENTER to exit");
			Console.Read();
		}


		static void Procedure(string solutionRootPath)
		{
			string sourcePath = @"\Procedure\"; // must end with slash
			string sourcePattern = "*.PRC";
			string targetPath = @"\CompleteScript\Procedure.sql";

			GenerateScript(solutionRootPath, sourcePath, sourcePattern, targetPath);
		}

		static void Table(string solutionRootPath)
		{
			//-- The problem with table creation is that SALT tables have references. 
			//-- You cannot create a table if it references another table which is not created yet. Tables with references are added only if the table they are referencing has already been added above he table doesn't have a reference.

			//-- Expected string values in table scripts are in the following format
			//-- CREATE TABLE [dbo].[tblTableName]
			//-- REFERENCES [dbo].[tblTableName]
			//-- if this program loops out, it is becuase the full string of either of those is not found. I had found missing "[dbo]." and added those to make scripts consistent.

			string sourcePath = @"\Table\"; // must end with slash
			string sourcePattern = "*.TAB";
			string targetPath = @"\CompleteScript\Table.sql";

			string content = string.Empty;

			ArrayList al = new ArrayList();
			bool allFilesAdded = false;

			//-- keep looping until there is a loop where no file is added to the array
			while (!allFilesAdded)
			{
				allFilesAdded = true;

				//-- loop through all files
				foreach(string file in Directory.GetFiles(solutionRootPath + sourcePath, sourcePattern))
				{
					//-- Read file

					string fileContent = string.Empty;
					using (StreamReader sr = new StreamReader(file)) 
					{
						fileContent = sr.ReadToEnd() + Environment.NewLine + Environment.NewLine;
					}

					//-- (bool) Is the TABLE already in the array 
					bool foundContent = false;
					
					FileInfo fileIO = new FileInfo(file);
                    string fileName = "[" + fileIO.Name.Replace(".TAB", "]").Replace(".", "].[");
                    string fileName2 = fileName.Replace("[dbo].", "");

					foreach(string table in al)
					{
						if (table.IndexOf("CREATE TABLE " + fileName) > -1)
						{
							foundContent = true;
							break;
						}
                        if (table.IndexOf("CREATE TABLE " + fileName2) > -1)
                        {
                            foundContent = true;
                            break;
                        }

					}


					//-- If the TABLE is not in the array, determine if it can be added.
					if (!foundContent)
					{
						allFilesAdded = false;

						//-- If the file does not contain references, add it to the array.
						string findReferences = "REFERENCES";
						
						if (fileContent.IndexOf(findReferences) == -1 && foundContent == false)
						{
							al.Add(fileContent);
						}
						else
						{
							//-- the file contains references. determine if all referenced tables are alreay in the array before adding this TABLE
							bool allReferencesAbove = false;
							int startPos = fileContent.IndexOf(findReferences);

							while (startPos > -1)
							{
								allReferencesAbove = false;
								int endPos = fileContent.IndexOf("(", startPos);

								string tableRef = (fileContent.Substring(startPos + findReferences.Length, endPos - startPos - findReferences.Length)).Trim();

								//-- go through all the tables in the array to check that all referenced tables are present.
								foreach(string table in al)
								{
                                    if (table.IndexOf("CREATE TABLE " + tableRef) > -1 || tableRef == fileName || tableRef == fileName.Replace("[dbo].", "")) // Found the reference or the table is Referencing itself. (Hierarchy references)
									{
										allReferencesAbove = true;
										break;
									}
                                    if (table.IndexOf("CREATE TABLE " + "[dbo]." + tableRef) > -1 || tableRef == fileName || tableRef == fileName.Replace("[dbo].", "")) // Found the reference or the table is Referencing itself. (Hierarchy references)
                                    {
                                        allReferencesAbove = true;
                                        break;
                                    }

								}

                                if (allReferencesAbove)
                                    startPos = fileContent.IndexOf(findReferences, endPos);
                                else
                                {
                                    Console.WriteLine("the referenced to table "+tableRef+" has not been added yet for " + file);
                                    break; //-- reference not found so no point continuting the search.
                                }
							}

							//-- All the referenced tables are in the array so add this table to the array.
							if (allReferencesAbove)
							{
								al.Add(fileContent);
								allFilesAdded = false;
							}
						}
					}
				}
			}

			foreach(string arrayContent in al)
			{
				content += arrayContent + Environment.NewLine + Environment.NewLine;
			}

			using (StreamWriter sw = new StreamWriter(solutionRootPath + targetPath)) 
			{
				sw.WriteLine(content);
			}

			Console.WriteLine("Created .... " + targetPath);
		}


		static void Function(string solutionRootPath)
		{
			
			string sourcePath = @"\Function\"; // must end with slash
			string sourcePattern = "*.UDF";
			string targetPath = @"\CompleteScript\Function.sql";

			GenerateScript(solutionRootPath, sourcePath, sourcePattern, targetPath);
		}
		static void View(string solutionRootPath)
		{
			
			string sourcePath = @"\View\"; // must end with slash
			string sourcePattern = "*.VIW";
			string targetPath = @"\CompleteScript\View.sql";

			GenerateScript(solutionRootPath, sourcePath, sourcePattern, targetPath);
		}
		static void Triggers(string solutionRootPath)
		{
			string sourcePath = @"\Triggers\"; // must end with slash
			string sourcePattern = "*.TRG";
			string targetPath = @"\CompleteScript\Triggers.sql";

			GenerateScript(solutionRootPath, sourcePath, sourcePattern, targetPath);
		}
		static void Database(string solutionRootPath)
		{
			string sourcePath = @"\Database\"; // must end with slash
			string sourcePattern = "*.DBS";
			string targetPath = @"\CompleteScript\Database.sql";

			GenerateScript(solutionRootPath, sourcePath, sourcePattern, targetPath);
		}


		static void GenerateScript(string solutionRootPath, string sourcePath, string sourcePattern, string targetPath)
		{

			string content = string.Empty;

			foreach(string file in Directory.GetFiles(solutionRootPath + sourcePath, sourcePattern))
			{
				
				using (StreamReader sr = new StreamReader(file)) 
				{
					try
					{
						content += sr.ReadToEnd() + Environment.NewLine + Environment.NewLine;
					}
					catch
					{
					}
				}
			}

			using (StreamWriter sw = new StreamWriter(solutionRootPath + targetPath)) 
			{
				sw.WriteLine(content);
			}

			Console.WriteLine("Created .... " + targetPath);
		}
	}
}
