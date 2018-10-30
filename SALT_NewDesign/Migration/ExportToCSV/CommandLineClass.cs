using System;

namespace ExportToCSV
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class CommandLineClass
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main(string[] args)
		{
			
            try
            {
                ExportTool objTool = new ExportTool();
                objTool.Run();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error");
                Console.WriteLine(ex.Message);
            }
		}
	}
}
