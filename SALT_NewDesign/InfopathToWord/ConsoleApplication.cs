using System;

namespace InfopathToWord
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class ConsoleApplication
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main(string[] args)
		{
			Converter objConverter = new Converter();
            try
            {
                objConverter.Start();
            }
            catch (Exception ex)
            {
                Console.WriteLine("** Error **");
                Console.WriteLine(ex.Message);
            }
		}
	}
}
