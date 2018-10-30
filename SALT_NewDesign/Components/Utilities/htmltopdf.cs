using System;
using System.Diagnostics;
using System.IO;
using System.Configuration;
using System.Web;


namespace Bdw.Application.Salt.Utilities
{
    public static class HtmlToPdf
    {


        /// <summary> 
        /// Convert Html page at a given URL to a PDF file using open-source tool wkhtml2pdf 
        /// </summary> 
        /// <param name="Url"></param> 
        /// <param name="outputFilename"></param> 
        /// <returns></returns> 
        public static bool WKHtmlToPdf(string url, string fileName)
        {

            try
            {
                var wkhtmlDirConfig = ConfigurationSettings.AppSettings["WorkingFolder"];
                var wkhtmlConfig = ConfigurationSettings.AppSettings["WkhtmltopdfPath"];
                var wkhtmlDir = HttpContext.Current.Server.MapPath(wkhtmlDirConfig);
                var wkhtml = HttpContext.Current.Server.MapPath(wkhtmlConfig);
                var p = new Process();
                p.StartInfo.CreateNoWindow = true;
                p.StartInfo.RedirectStandardOutput = true;
                p.StartInfo.RedirectStandardError = true;
                p.StartInfo.RedirectStandardInput = true;
                p.StartInfo.UseShellExecute = false;
                p.StartInfo.FileName = wkhtml;
                p.StartInfo.WorkingDirectory = wkhtmlDir;
                string switches = "";
                switches += "--disable-smart-shrinking ";
                switches += "--zoom 1.2 ";
                switches += "--ignore-load-errors ";
                p.StartInfo.Arguments = switches + " " + url + " " + fileName;
                p.Start();
                //// wait or exit     
                p.WaitForExit();
                //if (p.HasExited == false)
                //    p.Kill();
                //// read the exit code, close process     
                int returnCode = p.ExitCode;
                p.Close();

                return (returnCode == 0 || returnCode == 2);
            }
            catch (Exception ex)
            {
                WriteErrorLog(ex.Message);
            }
           
            return false;
        }
        public static void WriteErrorLog(string ex)
        {
            StreamWriter sw = null;
            try
            {
                sw = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\LogFile.txt", true);
                sw.WriteLine(DateTime.Now.ToString() + ":" + ex);
                sw.Flush();
                sw.Close();
            }
            catch
            {
            }
        }
        
    }
}

