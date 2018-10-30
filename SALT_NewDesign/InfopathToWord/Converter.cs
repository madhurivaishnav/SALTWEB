using System;
using System.IO;
using System.Configuration;

namespace InfopathToWord
{
	/// <summary>
	/// Summary description for Converter.
	/// </summary>
	public class Converter
	{
		public Converter()
		{
			
		}
        private void SearchForFiles()
        {
            DirectoryInfo objDir = new DirectoryInfo(Environment.CurrentDirectory);
            
            Console.WriteLine("Searching for InfoPath XML files");
            foreach (FileInfo objFile in objDir.GetFiles("*.xml"))
            {
                string strContentName = objFile.Name.Replace(".xml","");
                
                string strConvert1 = strContentName + ".fo";
                string strConvert2 = strContentName + "." + ConfigurationSettings.AppSettings["OutputExtension"];

                Convert_XML_To_XSLFO(objFile.Name, strConvert1);

                Convert_XSLFO_To_RDF( strConvert1, strConvert2 );
            }
        }
        private void Convert_XML_To_XSLFO (string inFileName, string outFileName)
        {
            Console.WriteLine("Converting:" + inFileName + " to " + outFileName);
            string strXslFileName = ConfigurationSettings.AppSettings["XSLFile"];
            
            XHelper objHelper = new XHelper(inFileName,strXslFileName,outFileName);
            
            objHelper.Translate();
        }
        private void Convert_XSLFO_To_RDF (string inFileName, string outFileName)
        {
            Console.WriteLine("Converting:" + inFileName + " to " + outFileName);
            
            string strCommandLineTool = ConfigurationSettings.AppSettings["CommandLineTool"];
            string strArguments;

            strArguments = inFileName;
            strArguments = strArguments + " " + outFileName;

            System.Diagnostics.Process objProcess = System.Diagnostics.Process.Start(strCommandLineTool,strArguments);
            objProcess.WaitForExit();
            int intExitCode = objProcess.ExitCode;
            if (intExitCode!=0)
            {
                throw new Exception("The command line tool returned an error : " + intExitCode.ToString());
            }
            File.Delete(inFileName);
        }
        public void Start()
        {
            SearchForFiles();
        }


	}
}
