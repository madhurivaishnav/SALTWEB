using System;
using System.IO;
using System.Data;
using System.IO.Compression;
using Ionic.Zip;
using System.Collections;
using Bdw.Application.Salt.Web.Utilities;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;


namespace Bdw.Application.Salt.Web 
{
    public class SCOcontent
{
    public String GeneratePath;
    public String GenerateDir;
    public String CourseName;
    public DataSet ListSCOs(String unpackDirectory, String ZipFileName, String ContentRepository)
	{
        String lstrManifest = "";


        //string unpackDirectory = GetNewFolder(ContentRepository);
      using (ZipFile zip1 = ZipFile.Read(ZipFileName))
      {
          foreach (ZipEntry e in zip1)
          {
              e.Extract(unpackDirectory, ExtractExistingFileAction.OverwriteSilently);
              if (e.FileName.EndsWith("IMSMANIFEST.XML", StringComparison.OrdinalIgnoreCase))
              {
                  lstrManifest = Path.Combine(unpackDirectory, e.FileName);
              }
          }
                          
            try
            {

                // Copy the js files to the required destination on the web server
                WebTool.CopyDirectory(ContentRepository + "/Scorm/v.X.4/", unpackDirectory);
            }
            catch (Exception ex)
            {
               // this.lblMessage.Text = ex.Message;
               // this.lblMessage.CssClass = "WarningMessage";
                new ErrorHandler.ErrorLog(ex, Bdw.Application.Salt.Data.ErrorLevel.High, "UploadToolbookContent.aspx", "UploadContent", "dirNewContentDestination.Create()");
               // return;
            }

          if (!lstrManifest.Equals(""))
          {
              DataSet SCOs = GetSCOs(lstrManifest);

              // tweak the html files here for the quiz stuff
              tweakTitlePages(SCOs, unpackDirectory);

              return SCOs;
          }
          else return new DataSet();
      }
	}

    private void tweakTitlePages(DataSet ds, String strUnpackDirectory)
    {
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            String strFilename = null;
            var fileContents = "";
            try
            {
                strFilename = strUnpackDirectory + "/" + dr["TitlePage"].ToString(); 

                 fileContents = System.IO.File.ReadAllText(@strFilename);
            }
                //COBA
            //catch
            //{
            //    strFilename = strUnpackDirectory + "/index_lms.html";

            //     fileContents = System.IO.File.ReadAllText(@strFilename);
            //}
                //ADAPTIVE
            catch
            {
                strFilename = strUnpackDirectory + "/shared/launchpage.html";

                fileContents = System.IO.File.ReadAllText(@strFilename);
            }
            // get the quiz variables
            fileContents = fileContents.Replace("var bInitSCORM = loadPage()", "var bInitSCORM = loadPage()\n       var isQz = isQuiz(); ");
            
            // change the condition for the alert
            fileContents = fileContents.Replace("if( oldLoc != '' &&", "if( !isQz  && oldLoc != '' && ");

            // add the else bit
            fileContents = fileContents.Replace("mbconf.create();",
                "mbconf.create()\n      return;\n	  }\n	  else{\n        saveVariable( 'TrivantisEPS', 'T'); \n		if (oldLoc!=\"~~~null~~~\")\n		ObjLayerActionGoTo( oldLoc );  \n		init12();\n");

            System.IO.File.WriteAllText(@strFilename, fileContents);
        }
    }

    private Boolean seekToChar(FileStream theFile,Char theChar)
    {
        char nextChar = 'ⁿ';
        int nxtChar = 0;
        while ((nextChar != theChar) && (nextChar != Convert.ToChar(0)) && (nxtChar>=0)) 
        {
            nxtChar = theFile.ReadByte();
            if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar); 
        }
        return nextChar == theChar;
    }
    private String getWordIncludeQuotes(FileStream theFile)
    {
        String result = "";
        int nxtChar = 32;
        char nextChar = ' ';
        nxtChar = theFile.ReadByte();
        if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar);
        while ((nxtChar > 0) && ((nextChar == ' ') || (nextChar == Convert.ToChar(13))  || (nextChar == '<') || (nextChar == Convert.ToChar(10))))
        {
            nxtChar = theFile.ReadByte();
            if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar);
        }
        result = nextChar.ToString();
        if (nxtChar == -1)
        {
            return null;
        }
        else
        {

            Boolean finished = false;
            while ((!finished) && (nextChar != Convert.ToChar(13)) && (nextChar != Convert.ToChar(0)) && (nextChar != '<'))
            {
                nxtChar = theFile.ReadByte();
                if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar); else finished = true;
                if ((nextChar != ' ') && (nextChar != Convert.ToChar(0))  && (nextChar != '<')) result += nextChar;
                if (nextChar == ' ')
                {
                   finished = true;
                }
                if (nextChar == '>') finished = true;
            }
            return result;
        }
    }    

    private String getWord(FileStream theFile,Boolean StopOnSpaces)
    {
        String result = "";
        int nxtChar = 32;
        char nextChar = ' ';
        nxtChar = theFile.ReadByte();
        if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar); 
        while ((nxtChar > 0)&&((nextChar == ' ') || (nextChar == Convert.ToChar(13)) || (nextChar == '=') || (nextChar == '"') || (nextChar == '<') || (nextChar == Convert.ToChar(10))))
        {
            nxtChar = theFile.ReadByte();
            if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar); 
        }
        result = nextChar.ToString();
        if (nxtChar == -1)
        {
            return null;
        }
        else
        {

            Boolean finished = false;
            while ((!finished) && (nextChar != Convert.ToChar(13)) && (nextChar != Convert.ToChar(0)) && (nextChar != '=') && (nextChar != '"') && (nextChar != '<'))
            {
                nxtChar = theFile.ReadByte();
                if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar); else finished = true;
                if ((nextChar != ' ') && (nextChar != Convert.ToChar(0)) && (nextChar != '=') && (nextChar != '"') && (nextChar != '<')) result += nextChar;
                if (nextChar == ' ')
                {
                    if (StopOnSpaces)
                    {
                        finished = true;
                    }
                    else
                    {
                        result += nextChar;
                    }
                }

                if (nextChar == '>') finished = true;
            }
            return result;
        }
    }    
    private String getQuotedWord(FileStream theFile)
    {
        String result = "";
        char nextChar = ' ';
        int nxtChar;
        seekToChar(theFile, '"');
        nxtChar = theFile.ReadByte();
        if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar); 
        while ((nxtChar > 0)&&((nextChar == ' ') || (nextChar == Convert.ToChar(13)) || (nextChar == '=') || (nextChar == '"') || (nextChar == '<') || (nextChar == Convert.ToChar(10))))
        {
            nxtChar = theFile.ReadByte();
            if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar);
        }
        Boolean finished = false;
        result = nextChar.ToString();
        while ((!finished) && (nextChar != '>') && (nextChar != Convert.ToChar(0)) && (nextChar != '=') && (nextChar != '"') && (nextChar != '<')) 
        {
            nxtChar = theFile.ReadByte();
            if (nxtChar > 0) nextChar = Convert.ToChar(nxtChar); else finished = true;
            if ((nextChar != ' ') && (nextChar != Convert.ToChar(0))&& (nextChar != '=')&& (nextChar != '"')&& (nextChar != '<')) result += nextChar;
        }
        return result;
    }

    private String getNextQuiz(FileStream theFile)
    {
        String asset = "";
        String dependency = "";
        String quiz = "";
        Boolean found = false;
        Boolean Finished = false;
        found = seekToString(theFile, "href");
        if (found)
        {
            asset = getQuotedWord(theFile);
            while (!Finished)
            {
                dependency = getWord(theFile, true);
                Finished = (dependency==null);
                if (!Finished)
                {
                    Finished = (dependency=="/resource>");
                    if (!Finished)
                    {
                        if (dependency.Substring(0, 2) == "T_")
                        {
                            quiz = dependency;
                            Finished = true;
                        }
                    }
                }
            }
            
            if ((quiz == "")&&(dependency=="/resource>")) asset = getNextQuiz(theFile);
        }
        return asset;
    }
        




    private Boolean seekToTag(FileStream theFile, String Tag)
    {
        Boolean Finished = false;
        String currentTag ="";
        while ((currentTag != null) && (!currentTag.Equals(Tag)) && (!Finished)) 
        {
            Finished = !seekToChar(theFile, '<');
            currentTag = getWord(theFile,true);
            if (currentTag == null) Finished = true;
            if (!Finished)
            {
                Finished = Tag.ToLower().Equals(currentTag.ToLower());
            }

        }
        if (currentTag == null) return false; else return Tag.ToLower().Equals(currentTag.ToLower());
    }
    private Boolean seekToString(FileStream theFile,String Tag)
    {
        Boolean Finished = false;
        String currentTag ="";
        while ((currentTag != null) && (!currentTag.Equals(Tag)) && (!Finished)) 
        {
            currentTag = getWord(theFile,true);
            Finished = (currentTag == null);
            if (!Finished)
            {
                Finished = Tag.ToLower().Equals(currentTag.ToLower());
            }

        }
        if (currentTag == null) return false; else return Tag.ToLower().Equals(currentTag.ToLower());
       
    }
    private Boolean seekToStringIgnoreQuotes(FileStream theFile, String Tag)
    {
        Boolean Finished = false;
        String currentTag = "";
        while ((currentTag != null) && (!currentTag.Equals(Tag)) && (!Finished))
        {
            currentTag = getWordIncludeQuotes(theFile);
            Finished = (currentTag == null);
            if (!Finished)
            {
                if (currentTag.IndexOf("S_AdditionalFiles")!=-1)
                {
                    Finished = Tag.ToLower().Equals(currentTag.ToLower());
                }
                Finished = Tag.ToLower().Equals(currentTag.ToLower());
            }

        }
        if (currentTag == null) return false; else return Tag.ToLower().Equals(currentTag.ToLower());

    }

    public DataSet GetSCOs(String lstrManifest)
    {


       

        using (FileStream manifest = new FileStream(lstrManifest,
            FileMode.Open, FileAccess.Read))
        {
            seekToTag(manifest, "organization");
            seekToTag(manifest, "title>");
            CourseName = getWord(manifest, false);
            Boolean Finished = false;
            System.Collections.ArrayList Titles = new System.Collections.ArrayList();
            System.Collections.ArrayList identifiersT = new System.Collections.ArrayList();
            System.Collections.ArrayList LaunchPoints = new System.Collections.ArrayList();
            System.Collections.ArrayList identifiersL = new System.Collections.ArrayList();
            System.Collections.ArrayList titlePage = new System.Collections.ArrayList();
            System.Collections.ArrayList QFSs = new System.Collections.ArrayList();
            System.Collections.ArrayList quizzes = new System.Collections.ArrayList();
            while (!Finished)
            {
                Finished = !seekToTag(manifest, "item");
                if (!Finished) Finished = !seekToString(manifest, "identifierref");
                if (!Finished) identifiersT.Add(getQuotedWord(manifest));
                if (!Finished) Finished = !seekToTag(manifest, "title>");
                Titles.Add(getWord(manifest,false));
            }
          
            Finished = false;
            try
            {
                manifest.Seek(0, System.IO.SeekOrigin.Begin);
            }
            catch (Exception e)
            {
            }
            String identifier = "";
            while (!Finished)
            {
                Finished = !seekToTag(manifest, "resource");
                if (!Finished) Finished = !seekToString(manifest, "identifier");
                if (!Finished) identifier = getQuotedWord(manifest);
                if (!Finished) Finished = !seekToString(manifest, "adlcp:scormtype");
                if (getQuotedWord(manifest) == "sco")
                {
                    LaunchPoints.Add(getQuotedWord(manifest));
                    identifiersL.Add(identifier);

                    // look for the title page ref here....
                    seekToString(manifest, "identifierref");
                    titlePage.Add(getQuotedWord(manifest));
                    for (int i = 0; i <= 2; i++)
                    {
                        seekToString(manifest, "identifierref"); 
                    }
                    // this one is the quiz
                    // quizzes.Add(getQuotedWord(manifest));
                }
            }
            //COBA integration
            if (LaunchPoints[0].ToString().Contains("presentation_content"))
            {
                LaunchPoints[0] = "Index_lms.html";

            }
            // reset the stream to the start
            identifier = "";
            try
            {
                // look for the title pages in here
                for (int i = 0; i < titlePage.Count; i++)
                {
                    manifest.Seek(0, System.IO.SeekOrigin.Begin);
                    while (seekToTag(manifest, "resource"))
                    {
                        seekToString(manifest, "identifier");
                        if (titlePage[i].ToString() == getQuotedWord(manifest))
                        {
                            seekToString(manifest, "href");
                            identifier = getQuotedWord(manifest);
                            titlePage[i] = identifier;
                           
                        }
                    }                    
                }
            }
            catch (Exception e)
            {
            }
            //COBA integration
            //if (titlePage.Count == 0)
            //{
            //    titlePage[0].ToString() = "presentation.html";
            //}
            Finished = false;
            try
            {
                manifest.Seek(0, System.IO.SeekOrigin.Begin);
            }
            catch (Exception e)
            {
            }
            Finished = !seekToStringIgnoreQuotes(manifest, "identifier=\"S_AdditionalFiles\"");
            while (!Finished)
            {
                if (!Finished) Finished = !seekToString(manifest, "href");
                QFSs.Add(getQuotedWord(manifest));
            }
            
            //Code for COBA getting quick fact sheet
            if (QFSs.Count == 0)
            {
                //String GenerateDir = GetNewFolder(Server.MapPath("/General/"));
                //FileInfo zip = new FileInfo(inputFile.PostedFile.FileName);
                QFSs.Add("COBAQFS.pdf");
            }

            try
            {
                manifest.Seek(0, System.IO.SeekOrigin.Begin);
            }
            catch (Exception e)
            {
            }

            Finished = false;
            quizzes = new System.Collections.ArrayList();
            String Quiz = "";
            while (!Finished)
            {
                Quiz = getNextQuiz(manifest);
                Finished = (Quiz == "");
                if (!Finished)
                {
                    quizzes.Add(Quiz);
                }
            }

            //COBA code integration
            //if (quizzes.Count == 0)
            //{
            //    quizzes.Add("Index_lms.html");
            //}
            //Adaptive code integration
            if (quizzes.Count == 0)
            {
                quizzes.Add("launchpage.html");
            }


            XmlDocument xd =  new XmlDocument();
            xd.Load(lstrManifest);

            XmlNode xn = null;
            try
            {
                 xn = xd.ChildNodes[2].ChildNodes[1];
            }
            //COBAcatch {  xn = xd.ChildNodes[1].ChildNodes[2]; }
           //Adaptive 
            catch { xn = xd.ChildNodes[0].ChildNodes[2]; }
            //XmlNode xn = xd.ChildNodes[0].ChildNodes[2];

            XmlNode previousnode = null;
            


            for(int i = 0;i<quizzes.Count; i++)
            {
                previousnode = null;                
                
                foreach (XmlNode n in xn.ChildNodes)
                {

                    if (n.ChildNodes[0].Attributes[0].Value == quizzes[i].ToString())
                    {
                        quizzes[i] = previousnode.ChildNodes[0].Attributes[0].Value;
                        // we found it so exit
                        break;
                    }
                    //Code by Joseph
                    if (n.ChildNodes[0].Attributes[0].Value.Contains("launchpage.html"))
                    {
                        quizzes[i]="launchpage.html";
                    }
                    //End
                    // do this last so we have the iuiz intro page
                    if (previousnode != n)
                    {
                        previousnode = n;
                    }

                }
            }


            DataSet SCOs = new DataSet("SCOs");
            SCOs.Namespace= "NetFrameWork";
            DataTable tblSCO = new DataTable("tblSCO");
            DataColumn c1 = new DataColumn("launchpoint", Type.GetType("System.String"));
            DataColumn c2 = new DataColumn("title");
            DataColumn c3 = new DataColumn("QFS");
            DataColumn c4 = new DataColumn("Quiz");
            DataColumn c5 = new DataColumn("TitlePage");
            tblSCO.Columns.Add(c1);
            tblSCO.Columns.Add(c2);
            tblSCO.Columns.Add(c3);
            tblSCO.Columns.Add(c4);
            tblSCO.Columns.Add(c5);
            SCOs.Tables.Add(tblSCO);
            DataRow newRow;
            for(int i = 0; i < identifiersL.Count; i++){
                newRow = tblSCO.NewRow();
                if (identifiersL.Count == identifiersT.Count)
                {
                    newRow["title"] = Titles[i];
                }
                else
                {
                    newRow["title"] = LaunchPoints[i];
                }
                try
                {
                    newRow["QFS"] = QFSs[i];
                }
                catch
                {
                }
                try
                {
                    newRow["Quiz"] = quizzes[i];
                }
                catch
                {
                }
                try
                {
                    newRow["TitlePage"] = titlePage[i];
                }
                catch
                {
                }
                newRow["launchpoint"] = LaunchPoints[i];
                tblSCO.Rows.Add(newRow);
            }
            SCOs.AcceptChanges();
            try
            {
                manifest.Close();
            }
            catch
            {
            }
            return SCOs;

        }
    }

    public DataSet GetQuizzes(String lstrManifest)
    {

        using (FileStream manifest = new FileStream(lstrManifest,
            FileMode.Open, FileAccess.Read))
        {
            Boolean Finished = false;
            System.Collections.ArrayList quizzes = new System.Collections.ArrayList();
            String Quiz = "";
            while (!Finished)
            {
                Quiz = getNextQuiz(manifest);
                Finished = (Quiz == "");
                if (!Finished)
                {
                    quizzes.Add(Quiz);
                }
            }


            DataSet Quizzes = new DataSet("Quizzes");
            Quizzes.Namespace = "NetFrameWork";
            DataTable tblquizzes = new DataTable("tblquizzes");
            DataColumn c1 = new DataColumn("quizzeslaunchpoint", Type.GetType("System.String"));
            tblquizzes.Columns.Add(c1);

            Quizzes.Tables.Add(tblquizzes);
            DataRow newRow;
            for (int i = 0; i < quizzes.Count; i++)
            {
                newRow = tblquizzes.NewRow();
                newRow["quizzes"] = quizzes[i];

            }

            return Quizzes;

        }
    }




    private string GetNewFolder(String ContentRepository)
    {
        // Create necessary directories for new content
        string newDir = Guid.NewGuid().ToString();
        string strOutputPath = ContentRepository + "Scorm/Publishing/" + newDir + "/";

        //1. Create a publising temporary folder
        try
        {
            Directory.CreateDirectory(strOutputPath);
        }
        catch (Exception ex)
        {
            return null;
        }
        GeneratePath = strOutputPath;
        GenerateDir = newDir;
        return strOutputPath;
    }


}
}
