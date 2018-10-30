using System;
using System.Collections;
using System.IO;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
//using System.Xml.Linq;
using Microsoft.ApplicationBlocks.Data;
using System.Collections.Generic;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.InfoPath;
using System.Diagnostics;
using Bdw.Application.Salt.ErrorHandler;




namespace Bdw.Application.Salt.Web.General.Scorm
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class Scorm12 : IHttpHandler
    {
        public DataTable GetLastSession(int StudentID, int LessonID, Boolean isLesson)
        {
            using (StoredProcedure sp = new StoredProcedure("prcSCORMgetSession",
                       StoredProcedure.CreateInputParam("@StudentID", SqlDbType.Int, StudentID),
                       StoredProcedure.CreateInputParam("@LessonID", SqlDbType.Int, LessonID),
                       StoredProcedure.CreateInputParam("@isLesson", SqlDbType.Bit, isLesson)
                           ))
            {
                return sp.ExecuteTable();
            }

        }


        public string LMSgetValue(int StudentID, int LessonID, string DME)
        {
            using (StoredProcedure sp = new StoredProcedure("prcSCORMgetValue",
                       StoredProcedure.CreateInputParam("@StudentID", SqlDbType.Int, StudentID),
                       StoredProcedure.CreateInputParam("@LessonID", SqlDbType.Int, LessonID),
                       StoredProcedure.CreateInputParam("@DME", SqlDbType.VarChar, 50, DME)))                          
            {
                return (string) sp.ExecuteScalar();
            }

        }


        public void LMSsetValue(int StudentID, int LessonID, string DME, string value)
        {
             using (StoredProcedure sp = new StoredProcedure("prcSCORMsetValue",
                       StoredProcedure.CreateInputParam("@StudentID", SqlDbType.Int, StudentID),
                       StoredProcedure.CreateInputParam("@LessonID", SqlDbType.Int, LessonID),
                       StoredProcedure.CreateInputParam("@DME", SqlDbType.VarChar, 50, DME),
                       StoredProcedure.CreateInputParam("@value", SqlDbType.VarChar, 4000, value)))
            {
                sp.ExecuteNonQuery();
            }
        }


        public void ProcessRequest(HttpContext context)
        {
            try
            {

          
            String strResponse ="";
            context.Response.ContentType = "text/plain";
           // int intProfileID = -1;
                
            Uri myUri = new Uri(context.Request.UrlReferrer.ToString());
            string param1 = HttpUtility.ParseQueryString(myUri.Query).Get("ProfileID");
            int intProfileID = Int32.Parse(param1); 
 

            //string strProfileID=(context.Request.UrlReferrer.ToString().Split('&')[2].Replace("ProfileID=", "").ToString().Trim()=="")?"-1":context.Request.UrlReferrer.ToString().Split('&')[2].Replace("ProfileID=", "").ToString().Trim();
            // intProfileID = Int32.Parse(strProfileID);

            //int intProfileID = Int32.Parse(context.Request.UrlReferrer.ToString().Split('&')[2].Replace("ProfileID=", ""));
            Boolean Writing = context.Request.Params["Write"].Equals("true");
            int StudentID = UserContext.UserID;
            int ModuleID = Int32.Parse(context.Request.Params["ModuleID"]);
            string SessionID = context.Request.Params["SessionData"];
            String StrNoq = context.Request.QueryString["noq"];
            Boolean isLesson = (null == StrNoq);
            if (Writing)
            {
                //string test = ReadDMEvalue(StudentID, ModuleID, null, isLesson);
                //if (test != "")
                //{
                //    DataSet dsxml = xml2DataSet(test);
                //    // writing dmes
                //    strResponse = writeDMEs(StudentID, ModuleID, SessionID, dsxml, context.Request.Form["SessionData"], intProfileID);

                //}
                if (context.Request.Params["xmlData"] != null)
                {
                    String fxml = context.Request.Params["xmlData"].Replace("%3c", "<").Replace("%2f%3e", "/>");

                    DataSet dsxml = xml2DataSet(fxml);
                    // writing dmes
                    strResponse = writeDMEs(StudentID, ModuleID, SessionID, dsxml, context.Request.Form["SessionData"],intProfileID);
                }
                else 
                {
                    strResponse = WriteDMEvalue(StudentID, ModuleID, context.Request.Params["DME"], context.Request.Params["value"]);
                }
            }
            else 
            {
                ReadDMEvalue(StudentID, ModuleID, null, isLesson);
            }
            context.Response.Write(strResponse);
            }
            catch (Exception exc)
            {

                Debug.WriteLine(exc); 
            }
        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public string writeDMEs(int StudentID, int ModuleID, string strSessID1,DataSet xmlDS,string sessiondata,int ProfileId)
        {

            try
            {
                Boolean isLesson = false;
                Boolean completed = false;                
                int score = 0;
                int interactions = 0;
                string strResult = "";
                int currentpage = 0;
                int Totalpage = 0;

                Hashtable ht = new Hashtable();
                
                foreach (DataRow r in xmlDS.Tables["dme"].Rows)
                {
                    
                    // get the salt variables here...
                    if (r["name"].ToString().ToLower().Contains("salt.variables.var"))
                    {
                        ht.Add(r["name"].ToString().ToLower(), r["value"].ToString());
                    }


                    if (r["name"].ToString().ToLower().Equals("salt.lessonorquiz"))
                    {
                        try
                        {
                            isLesson = (r["value"].ToString().ToLower() == "lesson");
                        }
                        catch
                        {
                            isLesson = true;
                        }
                    }

                    if (r["name"].ToString().Equals("cmi.core.lesson_status"))
                    {
                        if (r["value"].ToString().Equals("completed") || r["value"].ToString().Equals("passed"))
                        {
                            completed = true;
                            if (completed)
                            {
                                //break;
                            }
                        }
                    }

                    ////if (r["name"].ToString().Equals("cmi.core.lesson_status"))
                    ////{
                    ////    completed = r["value"].ToString().Equals("passed");
                    ////    if (completed)
                    ////    {
                    ////        //break;
                    ////    }
                    ////}Adaptive
                    //if (r["name"].ToString().Equals("salt.variables.VarPageInChapter"))
                    //{
                    //    currentpage = int.Parse(r["value"].ToString());

                    //}
                    //if (r["name"].ToString().Equals("cmi.suspend_data"))
                    //{
                    //    string phrase = r["value"].ToString();
                    //    string[] strTallyVisited = phrase.Split(';');
                    //    currentpage = Convert.ToInt32(strTallyVisited[0].Split('=')[1].ToString().Trim());
                        

                    //}
                    //if (r["name"].ToString().Equals("salt.variables.VarPagesInChapter"))
                    //{
                    //    Totalpage = int.Parse(r["value"].ToString());
                    //    //if (Totalpage - 1 == currentpage && Totalpage != 0)
                    //    //{
                    //    //    completed = true;
                    //    //    if (completed)
                    //    //    {
                    //    //        //break;
                    //    //    }
                    //    //}
                    //}
                    //if (r["name"].ToString().Equals("salt.variables.VarRunningPageCount"))
                    //{
                    //    string phrase = r["value"].ToString();
                    //    string[] strTallyVisited = phrase.Split(' ');
                    //    currentpage = Convert.ToInt32(strTallyVisited[1].ToString().Trim());
                    //    Totalpage = Convert.ToInt32(strTallyVisited[3].ToString().Trim());
                    //    if (Totalpage - 1 == currentpage && Totalpage != 0)
                    //    {
                    //        completed = true;
                    //        if (completed)
                    //        {
                    //            //break;
                    //        }
                    //    }
                    //}
                   
                    //if (Totalpage != 0 || currentpage != 0)
                    //{

                    //    if (Totalpage == currentpage)
                    //    {
                    //        completed = true;
                    //        if (completed)
                    //        {
                    //            //break;
                    //        }
                    //    }
                    //}


                    if (r["name"].ToString().Equals("cmi.core.score.raw"))
                    {
                        try
                        {
                            score = int.Parse(r["value"].ToString());
                        }
                        catch
                        {
                            score = 0;
                        }
                    }

                    if (r["name"].ToString().Equals("cmi.core.lesson_score"))
                    {
                        try
                        {
                            score = int.Parse(r["value"].ToString());
                        }
                        catch
                        {
                            score = 0;
                        }
                    }


                    if (r["name"].ToString().Equals("cmi.interactions._count"))
                    {
                        try
                        {
                            interactions = int.Parse(r["value"].ToString());
                            r["value"] = "0";
                        }
                        catch
                        {
                            // do nothing
                        }
                    }

                    if (r["value"].ToString()!="")
                        strResult = WriteDMEvalue(StudentID, ModuleID, r["name"].ToString(), r["value"].ToString());

                }

                if (!isLesson) // train tblQuizQuestion and tblQuizAnswer
                {

                    int intAskedQuestion = 1;
                    int intWeighting = 1;
                    String strLatency = "";
                    String strTime = "";
                    String strText = "";
                    String strType = "";
                    String strID = "";
                    Boolean isCorrect = false;
                    String strCorrectResponse = "";
                    String strStudentResponse = "";
                    int intNextAskedQuestion = 0;
                    String[] strPosAskedQuestion;

                    BusinessServices.Toolbook objToolbook = new Toolbook();
                    DataTable endQuizInfo = objToolbook.BeforeQuizEnd2(StudentID, ModuleID, 46664, score);

                    DataRow tmpRow = endQuizInfo.Rows[0];
                    String SessionID = tmpRow["SessionID"].ToString();
                    

                    foreach (DataRow r in xmlDS.Tables["dme"].Rows)
                    {
                        if (r["name"].ToString().Length > 16)
                        {
                            if (r["name"].ToString().Substring(0, 16).Equals("cmi.interactions"))
                            {
                                strPosAskedQuestion = r["name"].ToString().Split('.');
                                try
                                {
                                    intNextAskedQuestion = int.Parse(strPosAskedQuestion[2]);
                                }
                                catch
                                {
                                }
                                if (intNextAskedQuestion != intAskedQuestion && strText !="")
                                {
                                    saveQuestion(StudentID, intAskedQuestion, intWeighting, strLatency, strTime, strText, strID, isCorrect, strCorrectResponse, strStudentResponse, strType, ModuleID, SessionID);
                                    
                                    intAskedQuestion = intNextAskedQuestion;
                                    intWeighting = 1;
                                    strLatency = "";
                                    strTime = "";
                                    strText = "";
                                    strID = "";
                                    isCorrect = false;
                                    strCorrectResponse = "";
                                    strStudentResponse = "";
                                    strType = "";
                                }
                                try
                                {
                                    if (strPosAskedQuestion[3].Equals("id")) try { strID = r["value"].ToString(); }
                                        catch { };
                                    if (strPosAskedQuestion[3].Equals("latency")) strLatency = r["value"].ToString();
                                    if (strPosAskedQuestion[3].Equals("question"))
                                    {
                                        strText = r["value"].ToString().Replace("\\r", "");
                                        foreach (DictionaryEntry entry in ht)
                                        {
                                            if (entry.Value.ToString().Equals(strText))
                                            {
                                                String[] arr = entry.Key.ToString().Split('_');
                                                strStudentResponse = ht["salt.variables.varquestion_" + arr[1]].ToString();
                                                strCorrectResponse = ht["salt.variables.varvarcorrectanswertext_" + arr[1]].ToString();
                                                break;
                                            }
                                        }                                        
                                    }

                                    if (strPosAskedQuestion[3].Equals("result")) try { isCorrect = r["value"].ToString().ToLower().Equals("correct"); }
                                        catch { };                                    
                                    if (strPosAskedQuestion[3].Equals("time")) strTime = r["value"].ToString();
                                    if (strPosAskedQuestion[3].Equals("type")) strType = r["value"].ToString();
                                    if (strPosAskedQuestion[3].Equals("weighting")) try { intWeighting = int.Parse(r["value"].ToString()); }
                                        catch { };
                                    
                                }
                                catch { };
                            }

                        }
                    }
                    if (!intAskedQuestion.Equals(1))
                    {
                        saveQuestion(StudentID, intAskedQuestion, intWeighting, strLatency, strTime, strText, strID, isCorrect, strCorrectResponse, strStudentResponse, strType, ModuleID, SessionID);
                        intAskedQuestion = 1;
                    }
                    
                

                    if (!isLesson && interactions > 0)
                    {



                        int intUserID;
                        int intQuizID;
                        int intPassMark;
                        int intUnitID;
                        int intModuleID;
                        int intQuizFrequency;
                        int intOldCourseStatus;
                        int intNewCourseStatus;
                        int intNewQuizStatus;
                        int intCourseID;
                        DateTime dtmQuizCompletionDate;
                        intUserID = Int32.Parse(tmpRow["UserID"].ToString());
                        try
                        {
                            intQuizID = Int32.Parse(tmpRow["QuizID"].ToString());
                        }
                        catch { intQuizID = 0; }
                        intPassMark = Int32.Parse(tmpRow["PassMark"].ToString());
                        intUnitID = Int32.Parse(tmpRow["UnitID"].ToString());
                        intModuleID = Int32.Parse(tmpRow["ModuleID"].ToString());
                        intQuizFrequency = tmpRow["QuizFrequency"] == null ? Int32.Parse(tmpRow["QuizFrequency"].ToString()) : 0;
                        intOldCourseStatus = Int32.Parse(tmpRow["OldCourseStatus"].ToString());
                        intNewCourseStatus = Int32.Parse(tmpRow["NewCourseStatus"].ToString());
                        intNewQuizStatus = Int32.Parse(tmpRow["NewQuizStatus"].ToString());
                        intCourseID = Int32.Parse(tmpRow["CourseID"].ToString());
                        dtmQuizCompletionDate = (tmpRow["QuizCompletionDate"] == System.DBNull.Value ? DateTime.Parse("1/1/1900") : (DateTime)tmpRow["QuizCompletionDate"]);

                        endQuizInfo = objToolbook.EndQuizSession_UpdateTables(SessionID, 46664, score, intUserID, intQuizID, intPassMark, intUnitID, ModuleID, intCourseID, intOldCourseStatus, intNewQuizStatus, intNewCourseStatus, intQuizFrequency, dtmQuizCompletionDate);
                        
                        // read cert flag
                        tmpRow = endQuizInfo.Rows[0];
                        Boolean blnSendCert = (bool)tmpRow["sendcert"];
                        
                        if (blnSendCert)
                        {
                            DefaultQuiz dq = new DefaultQuiz();
                            dq.certemail(intUserID, intCourseID, 0);
                        }                                              
                    }

                        //code for adaptive
                    else 
                    {
                        if (endQuizInfo.Rows[0]["toolbooklocation"].ToString().Trim().Contains("launchpage.html"))
                        {
                            if (!isLesson && sessiondata == SessionID&&score==100)
                            {

                                int intUserIDAdapt;
                                int intQuizIDAdapt;
                                int intPassMarkAdapt;
                                int intUnitIDAdapt;
                                int intModuleIDAdapt;
                                int intQuizFrequencyAdapt;
                                int intOldCourseStatusAdapt;
                                int intNewCourseStatusAdapt;
                                int intNewQuizStatusAdapt;
                                int intCourseIDAdapt;
                                DateTime dtmQuizCompletionDateAdapt;
                                intUserIDAdapt = Int32.Parse(tmpRow["UserID"].ToString());
                                try
                                {
                                    intQuizIDAdapt = Int32.Parse(tmpRow["QuizID"].ToString());
                                }
                                catch { intQuizIDAdapt = 0; }


                                intPassMarkAdapt = Int32.Parse(tmpRow["PassMark"].ToString());
                                intUnitIDAdapt = Int32.Parse(tmpRow["UnitID"].ToString());
                                intModuleIDAdapt = Int32.Parse(tmpRow["ModuleID"].ToString());
                                intQuizFrequencyAdapt = tmpRow["adaptivequizfreq"] == null ? 0 : Int32.Parse(tmpRow["adaptivequizfreq"].ToString());
                                intOldCourseStatusAdapt = Int32.Parse(tmpRow["OldCourseStatus"].ToString());
                                intNewCourseStatusAdapt = Int32.Parse(tmpRow["NewCourseStatus"].ToString());
                                intNewQuizStatusAdapt = Int32.Parse(tmpRow["NewQuizStatus"].ToString());
                                intCourseIDAdapt = Int32.Parse(tmpRow["CourseID"].ToString());
                                dtmQuizCompletionDateAdapt = (tmpRow["QuizCompletionDate"] == System.DBNull.Value ? DateTime.Parse("1/1/1900") : (DateTime)tmpRow["QuizCompletionDate"]);
                                if (score == 100)
                                {
                                    endQuizInfo = objToolbook.EndQuizSession_UpdateTables(SessionID, 46664, score, intUserIDAdapt, intQuizIDAdapt, intPassMarkAdapt, intUnitIDAdapt, ModuleID, intCourseIDAdapt, intOldCourseStatusAdapt, intNewQuizStatusAdapt, intNewCourseStatusAdapt, intQuizFrequencyAdapt, dtmQuizCompletionDateAdapt);


                                    if (ProfileId > -1)
                                    {
                                        BusinessServices.Profile objProfile = new BusinessServices.Profile();
                                        bool ApplyToQuiz = objProfile.QuizRequiredForPoints(ProfileId);
                                        if (ApplyToQuiz) // quiz only
                                        {

                                            if (!(objProfile.CheckQuizPointsAlreadyGivenForPeriod(ProfileId, intUserIDAdapt, ModuleID, 1)))
                                            {
                                                objProfile.ApplyCPDPoints(ProfileId, intUserIDAdapt, ModuleID, 1);
                                            }
                                        }
                                    }
                                }
                                // read cert flag
                                tmpRow = endQuizInfo.Rows[0];
                                Boolean blnSendCert = (bool)tmpRow["sendcert"];

                                if (blnSendCert)
                                {
                                    DefaultQuiz dq = new DefaultQuiz();
                                    dq.certemail(intUserIDAdapt, intCourseIDAdapt, 0);
                                }
                            }
                            else if (!isLesson && sessiondata == SessionID && (score >0 && score<100))
                            {
                                 int intUserIDAdapt;
                                int intQuizIDAdapt;
                                int intPassMarkAdapt;
                                int intUnitIDAdapt;
                                int intModuleIDAdapt;
                                int intQuizFrequencyAdapt;
                                int intOldCourseStatusAdapt;
                                int intNewCourseStatusAdapt;
                                int intNewQuizStatusAdapt;
                                int intCourseIDAdapt;
                                DateTime dtmQuizCompletionDateAdapt;
                                intUserIDAdapt = Int32.Parse(tmpRow["UserID"].ToString());
                                try
                                {
                                    intQuizIDAdapt = Int32.Parse(tmpRow["QuizID"].ToString());
                                }
                                catch { intQuizIDAdapt = 0; }


                                intPassMarkAdapt = Int32.Parse(tmpRow["PassMark"].ToString());
                                intUnitIDAdapt = Int32.Parse(tmpRow["UnitID"].ToString());
                                intModuleIDAdapt = Int32.Parse(tmpRow["ModuleID"].ToString());
                                intQuizFrequencyAdapt = tmpRow["adaptivequizfreq"] == null ? 0 : Int32.Parse(tmpRow["adaptivequizfreq"].ToString());
                                intOldCourseStatusAdapt = Int32.Parse(tmpRow["OldCourseStatus"].ToString());
                                intNewCourseStatusAdapt = Int32.Parse(tmpRow["NewCourseStatus"].ToString());
                                intNewQuizStatusAdapt = Int32.Parse(tmpRow["NewQuizStatus"].ToString());
                                intCourseIDAdapt = Int32.Parse(tmpRow["CourseID"].ToString());
                                dtmQuizCompletionDateAdapt = (tmpRow["QuizCompletionDate"] == System.DBNull.Value ? DateTime.Parse("1/1/1900") : (DateTime)tmpRow["QuizCompletionDate"]);
                                if (score == 100)
                                {
                                    endQuizInfo = objToolbook.EndQuizSession_UpdateTables(SessionID, 46664, score, intUserIDAdapt, intQuizIDAdapt, intPassMarkAdapt, intUnitIDAdapt, ModuleID, intCourseIDAdapt, intOldCourseStatusAdapt, intNewQuizStatusAdapt, intNewCourseStatusAdapt, intQuizFrequencyAdapt, dtmQuizCompletionDateAdapt);


                                    if (ProfileId > -1)
                                    {
                                        BusinessServices.Profile objProfile = new BusinessServices.Profile();
                                        bool ApplyToQuiz = objProfile.QuizRequiredForPoints(ProfileId);
                                        if (ApplyToQuiz) // quiz only
                                        {

                                            if (!(objProfile.CheckQuizPointsAlreadyGivenForPeriod(ProfileId, intUserIDAdapt, ModuleID, 1)))
                                            {
                                                objProfile.ApplyCPDPoints(ProfileId, intUserIDAdapt, ModuleID, 1);
                                            }
                                        }
                                    }
                                }
                               
                               
                            }

                        }
                    }
                  //end code

                    delDME(StudentID, ModuleID);  
                }

                if (completed && isLesson)
                {
                    delDME(StudentID, ModuleID);
                    Module.InsertLessonStatus(StudentID, ModuleID, LessonStatus.Completed);
                }

                return "";
            }
            catch (Exception exc)
            {
               // do some thign here
                Debug.WriteLine(exc.StackTrace);
                return "";
            }

        }

        private void delDME(int StudentID,int ModuleID )
        {
            // delete dmes
            using (StoredProcedure sp = new StoredProcedure("prcSCORMdeleteDME",
                        StoredProcedure.CreateInputParam("@StudentID", SqlDbType.Int, StudentID),
                        StoredProcedure.CreateInputParam("@LessonID", SqlDbType.Int, ModuleID)))
            {
                sp.ExecuteNonQuery();
            }
        }


        private void saveQuestion(int StudentID, int intAskedQuestion, int intWeighting, string strLatency, string strTime, string strText, string strID, bool isCorrect, string strCorrectResponse, string strStudentResponse, string strType, int ModuleID, string strSessID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcSCORMtrainQandA",
                        StoredProcedure.CreateInputParam("@StudentID", SqlDbType.Int, StudentID),
                        StoredProcedure.CreateInputParam("@intModuleID", SqlDbType.Int, ModuleID),
                        StoredProcedure.CreateInputParam("@intAskedQuestion", SqlDbType.Int, intAskedQuestion),
                        StoredProcedure.CreateInputParam("@intWeighting", SqlDbType.Int, intWeighting),
                        StoredProcedure.CreateInputParam("@strLatency", SqlDbType.NVarChar, 100, strLatency),
                        StoredProcedure.CreateInputParam("@strTime", SqlDbType.NVarChar, 100, strTime),
                        StoredProcedure.CreateInputParam("@strText", SqlDbType.NVarChar, 1000, strText),
                        StoredProcedure.CreateInputParam("@strCorrectResponse", SqlDbType.NVarChar, 1000, strCorrectResponse),
                        StoredProcedure.CreateInputParam("@strStudentResponse", SqlDbType.NVarChar, 1000, strStudentResponse),
                        StoredProcedure.CreateInputParam("@strType", SqlDbType.NVarChar, 100, strType),
                        StoredProcedure.CreateInputParam("@strID", SqlDbType.NVarChar, 100, strID),
                        StoredProcedure.CreateInputParam("@isCorrect", SqlDbType.Bit, isCorrect),
                        StoredProcedure.CreateInputParam("@strQuizSessionID", SqlDbType.NVarChar, 200, strSessID)))
            {
                sp.ExecuteNonQuery();
            }
        }

        public string WriteDMEvalue(int StudentID,int ModuleID,string DME, string value)
        {
            try
            {
                //write to database;
                LMSsetValue(StudentID, ModuleID, DME, value);
                return ("<XML><errorcode>0</errorcode></XML>"); // No Error
            }
            catch (Exception e)
            {
                return ("101 " + e.ToString()); // general Exception
            }
        }


        public string ReadDMEvalue(int StudentID, int ModuleID, string DME,Boolean isLesson)
        {
            try
            {
                //read from database;
                string value = "<XML>";
                if ( DME == null)
                {
                    DataTable cachedPairs = GetLastSession(StudentID, ModuleID, isLesson);
                    
                    for (int i = 0;i < cachedPairs.Rows.Count;i++)
                    {
                        value += "<" + cachedPairs.Rows[i][0] + ">"+ cachedPairs.Rows[i][1] + "</"+ cachedPairs.Rows[i][0] +">";
                    }
                    
                }
                else
                {
                    value = LMSgetValue(StudentID, ModuleID, DME);
                }

                value += "<errorcode>0</errorcode></XML>";
                return (value); // No Error
            }
            catch (Exception e)
            {
                return ("101 "+e.ToString()); // general Exception
            }
        }


        private DataSet xml2DataSet(String strXML)
        {
            // Create a new DataSet.
            DataSet ds = new DataSet();
            ds.ReadXml(new StringReader(strXML)) ;
            return ds;            
        }
    }
}
