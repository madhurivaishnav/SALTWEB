using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;
using System.Configuration;
using Localization;

namespace Bdw.Application.Salt.Web
{
    /// <summary>
    /// Default page - this is the Homepage
    /// </summary>
    /// <remarks>
    /// Author: Stephen Kennedy-Clark
    /// Date: May 2004
    /// </remarks>
    public partial class MyTraining : System.Web.UI.Page
    {
        #region Private Variables

        //Madhuri CPD Event Start
        private int GEventid;
        private int GEventrowcount;
        //Madhuri CPD Event End
        protected Boolean isIpad = false;     // determine if the user is using iPad
        private Boolean cpdEnabled = true; // Set to be initally true - is set to false in code if CPD not enabled
        private Boolean LastPassEnabled = true; // Set to be initally true 
        public bool ShowEbook = false;

        /// <summary>
        /// Constant: relative page a toolbook must to post back
        /// </summary>
        private const string c_strPostBackPage = "General/ToolBook/ToolBookListener.aspx";

        /// <summary>
        /// Course ID context that this page will paint in
        /// </summary>
        private int m_intCourseID;

        /// <summary>
        /// datable containg all the courses the users org has access to
        /// </summary>
        private DataTable m_dtbCourses;

        /// <summary>
        /// datable containg all the module Information for this user
        /// </summary>
        private DataTable m_dtbModules;
        #endregion

        #region Protected Variables

        /// <summary>
        /// CopyRight Year label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCopyRightYear;

        /// <summary>
        /// Application name label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblApplicationName;

        //        /// <summary>
        //        /// Step 1 label
        //        /// </summary>
        //        protected System.Web.UI.WebControls.Label lblStep1Label;

        //        /// <summary>
        //        /// Step 1 text label
        //        /// </summary>
        //        protected System.Web.UI.WebControls.Label lblStep1Text;

        //        /// <summary>
        //        /// Step 2 label
        //        /// </summary>
        //        protected System.Web.UI.WebControls.Label lblStep2Label;

        //        /// <summary>
        //        /// Step 2 text label
        //        /// </summary>
        //        protected System.Web.UI.WebControls.Label lblStep2Text;
        //
        //        /// <summary>
        //        /// Clurse label
        //        /// </summary>
        //        protected System.Web.UI.WebControls.Label lblCourse;

        //        /// <summary>
        //        /// Select Course Combo box
        //        /// </summary>
        //        protected System.Web.UI.WebControls.DropDownList cboSelectCourse;

        /// <summary>
        /// Modules Repeater
        /// </summary>
        protected System.Web.UI.WebControls.Repeater rptModules;


        //        /// <summary>
        //        /// Div containing the certificate
        //        /// </summary>
        //        protected System.Web.UI.HtmlControls.HtmlGenericControl divViewCertificate;

        /// <summary>
        /// Header Image
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlImage imgLesson1;

        /// <summary>
        /// Home Page Footer
        /// </summary>
        protected System.Web.UI.WebControls.Label lblHomePageFooter;

        /// <summary>
        /// Hyperlink to the company
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkCompany;

        /// <summary>
        /// Trademark label
        /// </summary>
        protected System.Web.UI.WebControls.Label lblTradeMark;

        /// <summary>
        /// Table containing modules.
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlTable tblModule;
        protected Localization.LocalizedLabel Localizedlabel3;

        protected int rowCourseList;


        /// <summary>
        /// Div holding the legend and key
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlGenericControl divModuleKeyTable;

        protected Localization.LocalizedLabel Localizedlabel4;
        protected System.Web.UI.HtmlControls.HtmlTable tblCourseListDetail;
        protected System.Web.UI.WebControls.PlaceHolder ph1;

        #endregion

        #region Private Methods
        protected void ddlCPDProfile_SelectedIndexChanged(object sender, System.EventArgs e)
        {
          
            string strProfileID = this.ddlCPDProfile.SelectedValue.ToString();

            int ProfileID = -1;
            int UserID = UserContext.UserID;
            int CourseID = int.Parse(Session["CourseID"].ToString());


            if (strProfileID != "")
            {
                ProfileID = int.Parse(strProfileID);

                try
                {
                    BusinessServices.User objUser = new BusinessServices.User();
                    DataTable dtPeriodDetail = objUser.GetProfilePeriodDetail(ProfileID, UserID);
                    DataTable dtPointsEarned = objUser.GetUserPointsEarned(ProfileID, UserID);
                    //Madhuri CPD Event Start
                    Event objEvent = new Event();
                    DataSet ds = new DataSet();
                    ds = objEvent.GetUserEventPointsEarned(UserContext.UserID, UserContext.UserData.OrgID, ProfileID);   // report data  
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        this.lblCPDRequiredPoints.Text = ds.Tables[1].Rows[0]["Points"].ToString();
                        this.lblCPDPointsEarned.Text = ds.Tables[0].Rows[0]["Points"].ToString();

                    }
                    //Madhuri CPD Event End
                    //this.lblProfilePeriod.Text = dtPeriodDetail.Rows[0]["Period"].ToString();
                    //this.lblRequiredPoints.Text = dtPeriodDetail.Rows[0]["Points"].ToString();
                    //this.lblPointsEarned.Text = String.Format("{0:0.0}", dtPointsEarned.Rows[0]["PointsEarned"]);

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        this.lblProfilePeriod.Text = dtPeriodDetail.Rows[0]["Period"].ToString();
                        this.lblRequiredPoints.Text = Convert.ToString(double.Parse(dtPeriodDetail.Rows[0]["Points"].ToString()) + double.Parse(ds.Tables[1].Rows[0]["Points"].ToString()));
                        this.lblPointsEarned.Text = String.Format("{0:0.0}", (double.Parse(dtPointsEarned.Rows[0]["PointsEarned"].ToString()) + double.Parse(ds.Tables[0].Rows[0]["Points"].ToString())));

                    }
                    else
                    {
                        this.lblProfilePeriod.Text = dtPeriodDetail.Rows[0]["Period"].ToString();
                        this.lblRequiredPoints.Text = dtPeriodDetail.Rows[0]["Points"].ToString();
                        this.lblPointsEarned.Text = String.Format("{0:0.0}", dtPointsEarned.Rows[0]["PointsEarned"]);

                    }
                }
                catch
                { 
                
                }
            }

            Session["ProfileID"] = ProfileID;

            PopulateCourseGrid(ProfileID, UserID);
            PopulatePolicyGrid(ProfileID, UserID);
            //Madhuri CPD Event Start
            PopulateEventGrid(UserID, ProfileID);
            //Madhuri CPD Event end
            if (CourseID > 0)
            {
                DisplayModuleGrid(UserID, CourseID, ProfileID);
            }

        }
        private void PopulateCourseGrid(int ProfileID, int UserID)
        {
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtCourseStatus = objUser.GetUserCourseList(ProfileID, UserID);

            this.rptCourseList.DataSource = dtCourseStatus;
            this.rptCourseList.DataBind();
            //for (int i = 0; i < dtCourseStatus.Rows.Count; i++)
            //{
            //    if (dtCourseStatus.Rows[i]["Red"].ToString() == "0")
            //    {
            //        rptCourseList.Items[i].Controls[4].Visible = false;
            //    }

            //}

        }
        private void PopulatePolicyGrid(int ProfileID, int UserID)
        {
            int OrganisationID = UserContext.UserData.OrgID;
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtPolicyStatus = objUser.GetUserPolicyStatus(ProfileID, UserID, OrganisationID);

            dtPolicyStatus.Columns.Add("ProfileID");
            for (int i = 0; i < dtPolicyStatus.Rows.Count; i++)
            {
                dtPolicyStatus.Rows[i]["ProfileID"] = ProfileID;
            }

            this.rptPolicyList.DataSource = dtPolicyStatus;

            if (dtPolicyStatus.Rows.Count > 0)
            {
                this.rptPolicyList.DataBind();
                if (!this.phCourseList.Visible)
                {
                    //hide certificate status
                    this.spCertificate.Visible = false;
                }
            }
            else
            {
                this.phPolicyList.Visible = false;
                if (!this.phCourseList.Visible)
                {
                    this.divCourseKeyTable.Visible = false;
                    this.phEventList.Visible = false;
                }
            }
        }
        /// <summary>
        /// Set page state
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        private void SetPageState()
        {
            // if the user is a salt admin they dont have access to anything on this page
            // hide everything else and paint appropriate message.
            if (UserContext.UserData.UserType == UserType.SaltAdmin)
            {
                Response.Redirect("/Administration/AdministrationHome.aspx");
            }

            // get the users Organisation ID			
            int intOrganisationID = UserContext.UserData.OrgID; // Organisation ID

            // get the course list details
            BusinessServices.Course objCourse = new BusinessServices.Course(); // Course Object
            m_dtbCourses = objCourse.GetCourseListAccessableToUser(UserContext.UserID);

            // get default course
            m_intCourseID = GetDefaultCourseID(m_dtbCourses);
            int CourseID;
            //get CourseID from Session variable
            if (Session["CourseID"] == null)
            {
                CourseID = -1;
                Session["CourseID"] = -1;
            }
            else
            {
                string strCourseID = Session["CourseID"].ToString();
                CourseID = Int32.Parse(strCourseID);
            }
            int ProfileID;
            //get ProfileID from Session variable
            if (Session["ProfileID"] == null)
            {
                ProfileID = -1;
                Session["ProfileID"] = -1;
            }
            else
            {
                string strProfileID = Session["ProfileID"].ToString();
                ProfileID = Int32.Parse(strProfileID);
            }

            // paint the page - Initial Condition for non administrators
            if (!IsPostBack && (UserContext.UserData.UserType != UserType.SaltAdmin))
            {

                PaintInitialPage(m_intCourseID, UserContext.UserID, intOrganisationID, m_dtbCourses);

            }

            if (!IsPostBack)
            {
                // Application Name
                this.lblApplicationName.Text = Utilities.ApplicationSettings.AppName;
                this.lblTradeMark.Text = Utilities.ApplicationSettings.TradeMark;
                this.lblCopyRightYear.Text = Utilities.ApplicationSettings.CopyrightYear;
                this.lblHomePageFooter.Text = Utilities.ApplicationSettings.HomePageFooter;
                this.lnkCompany.Text = Utilities.ApplicationSettings.BrandingCompanyName;
                this.lnkCompany.NavigateUrl = Utilities.ApplicationSettings.BrandingCompanyURL;

                if (ProfileID != -1)
                {
                    this.ddlCPDProfile.SelectedValue = ProfileID.ToString();
                }
            }

            if (CourseID != -1)
            {
                DisplayModuleGrid(UserContext.UserID, CourseID, ProfileID);
            }
            else
            {
                this.phModuleList.Visible = false;
            }

        } //SetPageState
        private void DisplayModuleGrid(int UserID, int CourseID, int ProfileID)
        {
            this.phCourseList.Visible = false;
            this.phEventList.Visible = false;
            this.phPolicyList.Visible = false;
            this.divCourseKeyTable.Visible = false;
            this.PaintModuleList(UserID, CourseID, ProfileID);
        }
        /// <summary>
        /// Paint Page
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        /// <param name="courseID">ID of the course</param>
        /// <param name="userID">ID of the user</param>
        /// <param name="organisationID">ID of the organisation</param>
        /// <param name="courses">Courses must be supplied (in a datatable)</param>
        private void PaintInitialPage(int courseID, int userID, int organisationID, DataTable courses)
        {
            int UserID = UserContext.UserID;
            int intProfileID = -1;

            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtProfileList = objUser.GetProfilePeriodList(UserID);
            if (dtProfileList.Rows.Count > 0)
            {
                if (dtProfileList.Rows.Count == 1)
                {
                    this.ddlCPDProfile.Visible = false;
                    this.lblCPDProfileName.Text = dtProfileList.Rows[0]["ProfileName"].ToString();
                    intProfileID = int.Parse(dtProfileList.Rows[0]["ProfileID"].ToString());
                    // still need to populate this hidden dropdownlist for other functionality to work
                    foreach (DataRow dr in dtProfileList.Rows)
                    {
                        string ProfileID = dr["ProfileID"].ToString();
                        string ProfileName = dr["ProfileName"].ToString();
                        this.ddlCPDProfile.Items.Add(new ListItem(ProfileName, ProfileID));
                    }
                }
                else
                {
                    this.lblCPDProfileName.Visible = false;
                    foreach (DataRow dr in dtProfileList.Rows)
                    {
                        string ProfileID = dr["ProfileID"].ToString();
                        string ProfileName = dr["ProfileName"].ToString();
                        this.ddlCPDProfile.Items.Add(new ListItem(ProfileName, ProfileID));
                    }

                    string strProfileID = this.ddlCPDProfile.SelectedValue.ToString();
                    if (strProfileID != "")
                    {
                        intProfileID = int.Parse(strProfileID);
                    }
                }
            }
            else
            {
                this.phProfileSelect.Visible = false;
            }

            //PaintCourseNotes(courseID); -- course notes are not printed in version 3.0
            if (courses.Rows.Count == 0)
            {
                this.phCourseList.Visible = false;
                this.phEventList.Visible = false;
                this.phModuleList.Visible = false;
            }
            else
            {
                PaintCourseCertificate(userID, courseID, courses);
                PaintModuleList(userID, courseID, intProfileID);
            }

            checkCPD();

            PopulatePolicyGrid(intProfileID, UserID);

            if (!cpdEnabled)
            {
                HtmlTableCell tcCourse = (HtmlTableCell)Page.FindControl("CoursePointsAvailableHeading");
                tcCourse.Visible = false;
                HtmlTableCell tcModule = (HtmlTableCell)Page.FindControl("ModulePointsAvailableHeading");
                tcModule.Visible = false;
                HtmlTableCell tcModuleSub = (HtmlTableCell)Page.FindControl("ModulePointsAvailableSubHeading");
                tcModuleSub.Visible = false;
                HtmlTableCell tcPolicy = (HtmlTableCell)Page.FindControl("PolicyPointsAvailableHeading");
                tcPolicy.Visible = false;
            }
            checkLastPass();
            if (!LastPassEnabled)
            {
                lblLastComp.Visible = false;
                lblDue.Visible = false;
            }

            ShowEbook = checkEbookAccess();





        } //PaintInitialPage
        /// <summary>
        /// Paint Module List. 
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: This method also determins if the certificate link should be shown
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:
        /// </remarks>
        /// <param name="userID">User ID</param>
        /// <param name="courseID">Course ID</param>
        private void PaintModuleList(int userID, int courseID, int ProfileID)
        {
            BusinessServices.User objUser = new BusinessServices.User(); // User Object
            m_dtbModules = objUser.HomePageDetails(userID, courseID, ProfileID);
            txttoolbookloc.Text = "";
            DataTable dtToolbk = objUser.GEtToolBookLocation(courseID);
            if (dtToolbk.Rows.Count > 0)
            {
                for (int i = 0; i < dtToolbk.Rows.Count; i++)
                {
                    if (dtToolbk.Rows[0][0].ToString().Contains("launchpage.html"))
                        txttoolbookloc.Text = "launchpage.html";
                }
            }

            BusinessServices.Course objCourse = new BusinessServices.Course(); // Course Object
            DataTable m_dtbCourse = objCourse.GetCourse(courseID, UserContext.UserData.OrgID);

            string strCourseName = m_dtbCourse.Rows[0]["Name"].ToString();
            string strButtonSet = ApplicationSettings.ButtonSet;

            this.lblCourseModuleList.Text = String.Format(ResourceManager.GetString("lblStep2Text.2"), strCourseName);//"You have chosen <b>" + strCourseName + "</b>, your requirements are as below";

            BusinessServices.Profile objProfile = new BusinessServices.Profile();
            DataTable dtLessonQuiz = objProfile.GetLessonQuizStatus(ProfileID);


            bool ApplyToQuiz = false;
            bool ApplyToLesson = false;

            if (dtLessonQuiz.Rows.Count > 0)
            {
                ApplyToQuiz = bool.Parse(dtLessonQuiz.Rows[0]["ApplyToQuiz"].ToString());
                ApplyToLesson = bool.Parse(dtLessonQuiz.Rows[0]["ApplyToLesson"].ToString());
            }

            string strLessonQuizReg = "";
            if (ApplyToQuiz)
            {
                if (ApplyToLesson)
                {
                    strLessonQuizReg = ResourceManager.GetString("lblLessonQuiz");
                }
                else
                {
                    strLessonQuizReg = ResourceManager.GetString("lblQuizOnly");
                }
            }
            else
            {
                if (ApplyToLesson)
                {
                    strLessonQuizReg = ResourceManager.GetString("lblLessonOnly");
                }
            }

            if (!strLessonQuizReg.Equals(String.Empty))
            {
                this.lblLessonQuizReq.Text = String.Format(ResourceManager.GetString("lblQuizLessonInstruction"), strLessonQuizReg);//"You need to complete the <b>" +strLessonQuizReq + "</b> to earn the points"
            }

            // add a column to teh datatable for the application button set
            m_dtbModules.Columns.Add("ButtonSet", Type.GetType("System.String"));

            //-- New mthod, show certificate link using course status
            DataTable dtbCourseStatus = objUser.GetUserCourseStatus(UserContext.UserID, courseID, UserContext.UserData.OrgID);
            if ((dtbCourseStatus.Rows.Count == 1) && (int.Parse(dtbCourseStatus.Rows[0]["CourseStatusID"].ToString()) == (int)CourseStatus.Complete))
            {
                this.lnkViewCertificate.Visible = true;
            }
            else
            {
                this.lnkViewCertificate.Visible = false;
                foreach (DataRow drwRow in m_dtbModules.Rows)
                {
                    drwRow["ButtonSet"] = ApplicationSettings.ButtonSet;
                }
            }

            // moved the show and hide code here
            this.rptModules.Visible = true;
            this.tblModule.Visible = true;
            this.divModuleKeyTable.Visible = true;
            this.phModuleList.Visible = true;

            rptModules.DataSource = m_dtbModules;
            rptModules.DataBind();

        } //PaintModuleList
        /// <summary>
        /// Paints the detail of the Course Certificate hyperlink. The logic to show / not show this
        /// link is in the PaintModuleList method, this is because it is much more easily achieved
        /// in this location than it can be here
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,11/02/04
        /// Changes:
        /// </remarks>
        /// <param name="courseID">Course ID</param>
        /// <param name="courses">DataTable of courses</param>
        /// <param name="userID">Users ID</param>
        private void PaintCourseCertificate(int userID, int courseID, DataTable courses)
        {
            lnkViewCertificate.NavigateUrl = @"/Certificate.aspx";
        } //PaintCourseCertificate
        /// <summary>
        /// Get Default Course ID
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Author: Stephen Kennedy-Clark,11/02/04
        /// Notes: 
        ///     The default course is the first course int the list returned form the database
        /// If the page has a sessionID in the URL then it is comming back from
        /// a tool book session. Use the session to get the details
        /// if there is no session data then use the first course row
        /// if the courseID that comes back from the session data does not match a course
        /// that the user has access to (ie that is in the course list) then select the first
        /// course
        /// Changes:
        /// </remarks>
        /// <param name="courses">DataTable of Courses that this user has access to</param>
        /// <returns>
        /// Course ID
        /// </returns>
        private int GetDefaultCourseID(DataTable courses)
        {

            int intCourseID = -1; // Course ID acssociated with this session
            string strCookieValue = "";

            try
            {
                strCookieValue = Request.Cookies["SelectedCourse"].Value;
            }
            catch
            {
                strCookieValue = "";
            }

            //selected course as string
            if (strCookieValue.Length != 0 && IsInteger(strCookieValue))
            {
                intCourseID = Int32.Parse(strCookieValue);
            }
            else
            {

                // if the sessionID exists get its value
                if (Request.QueryString["SessionID"] != null)
                {
                    BusinessServices.Course objCourse = new BusinessServices.Course();
                    intCourseID = objCourse.GetCourseBySessionID(Request.QueryString["SessionID"]);
                }
            }
            // check that courseID exists in the courses the user has access to 
            if (intCourseID != -1)
            {
                bool bolCourseExists = false;
                for (int intRowNumber = 0; intRowNumber < courses.Rows.Count; intRowNumber++)
                {
                    if ((int)courses.Rows[intRowNumber]["CourseID"] == intCourseID)
                    {
                        bolCourseExists = true;
                        break;
                    }
                }
                if (!bolCourseExists)
                {
                    intCourseID = -1;
                }

            }

            // If the course id is invalid it will now be -1, if this is the case then use the first course

            if ((intCourseID == -1) && courses.Rows.Count > 0)
            {
                intCourseID = (int)courses.Rows[0]["CourseID"];
            }

            return intCourseID;

        } //GetDefaultCourseID
        /// <summary>
        /// Get Tool Book PostBack URL
        /// Gets the 
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,11/02/04
        /// Changes:
        /// </remarks>
        /// <returns>String, Fully defined path to the root</returns>
        private string GetTBPostBackURL(string sessionID)
        {
            string strReturnValue; // Return Value
            string strPathToRoot = Utilities.WebTool.GetHttpRoot();   // Path to Root          
            strReturnValue = strPathToRoot + c_strPostBackPage;
            return strReturnValue;
        } //GetTBPostBackURL
        /// <summary>
        /// This function returns a boolean value indicating whether a string value can be converted to an
        /// integer.
        /// </summary>
        /// <param name="ValueToCheck">The string value to check</param>
        /// <returns>Return True or False</returns>
        private static bool IsInteger(string ValueToCheck)
        {
            try
            {
                Convert.ToInt32(ValueToCheck);
                return true;
            }
            catch
            {
                return false;
            }

        } //IsInteger



        #endregion

        #region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e">EventArgs</param>
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);

        }

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.rptModules.ItemCreated += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.rptModules_ItemCreated);
            this.rptModules.ItemCommand += new System.Web.UI.WebControls.RepeaterCommandEventHandler(this.rptModules_ItemCommand);
            this.rptCourseList.ItemCommand += new System.Web.UI.WebControls.RepeaterCommandEventHandler(this.rptCourseList_ItemCommand);
            this.rptCourseList.ItemCreated += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.rptCourseList_ItemCreated);
            this.rptPolicyList.ItemCreated += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.rptPolicyList_ItemCreated);
            this.rptModules.ItemDataBound += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.rptModules_ItemDataBound);
            this.rptCourseList.ItemDataBound += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.rptCourseList_ItemDataBound);
            this.rptPolicyList.ItemCommand += new System.Web.UI.WebControls.RepeaterCommandEventHandler(this.rptPolicyList_ItemCommand);
            //Madhuri CPD Event Start
            this.dgrCPD.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrCPD_ItemDataBound);
            this.dgrCPD.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgrCPD_ItemCommand);
            this.dgrCPD.PageIndexChanged += new DataGridPageChangedEventHandler(dgrCPD_PageIndexChanged);
            //Madhuri CPD Event End
            checkLastPassInit();
            checkCPDinit();
            //locDue.Visible = false;
            //locLastComp.Visible = false;

        }

        #endregion

        #region Event Handlers



        /// <summary>
        /// rptModules_ItemCreated responds to the databind event
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes:  This binder looks for any images
        /// Author: Stephen Kennedy-Clark,25 may 2004
        /// Changes:
        /// </remarks>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void rptModules_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            System.Web.UI.WebControls.Image imgTemp;
            System.Web.UI.WebControls.LinkButton lnkTemp;
            foreach (Object objControl in e.Item.Controls)
            {
                if (objControl.GetType().ToString() == "System.Web.UI.WebControls.LinkButton")
                {
                    lnkTemp = ((System.Web.UI.WebControls.LinkButton)objControl);
                    foreach (Object objControl2 in lnkTemp.Controls)
                    {
                        if (objControl2.GetType().ToString() == "System.Web.UI.WebControls.Image")
                        {
                            imgTemp = (System.Web.UI.WebControls.Image)objControl2;
                            imgTemp.ImageUrl = imgTemp.ImageUrl.Replace("ButtonSet", ApplicationSettings.ButtonSet);
                        }
                    }
                }
            }

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {


                System.Web.UI.WebControls.Image imgQuickFacts = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgQuickFacts");
                imgQuickFacts.AlternateText = ResourceManager.GetString("imgQuickFacts");
                imgQuickFacts.ImageUrl = "/general/images/" + ApplicationSettings.ButtonSet + "_bulb_but.gif";
                checkCPD();
                if (!cpdEnabled)
                {
                    HtmlTableCell tcModule = (HtmlTableCell)e.Item.FindControl("ModulePoints");
                    tcModule.Visible = false;
                }
            }
            checkLastPass();
            if (!LastPassEnabled)
            {
                HtmlTableCell tcLastPass = (HtmlTableCell)e.Item.FindControl("LastComp");
                if (null != tcLastPass)
                {
                    tcLastPass.Visible = false;
                    tcLastPass.ColSpan = 0;
                    tcLastPass.Width = "0";
                }
                HtmlTableCell tcDue = (HtmlTableCell)e.Item.FindControl("ModuleQuizDue");
                if (null != tcDue)
                {
                    tcDue.Visible = false;
                    tcDue.ColSpan = 0;
                    tcDue.Width = "0";
                }
                collLastComp.Style.Add("display", "none");
                collDue.Style.Add("display", "none");
                SubHead1.Style.Add("display", "none");
                SubHead2.Style.Add("display", "none");

            }

        }

        private void checkCPDinit()
        {
            if (this.phProfileSelect.Visible == false)
            {
                this.lblPolicyCPDPointsAvailableHeading.Visible = false;
                this.lblCourseCPDPointsAvailable.Visible = false;
                this.lblModuleCPDPointsAvailable.Visible = false;
                cpdEnabled = false;
            }
        }
        private void checkCPD()
        {
            if (this.phProfileSelect.Visible == false)
            {
                this.lblPolicyCPDPointsAvailableHeading.Visible = false;
                this.lblCourseCPDPointsAvailable.Visible = false;
                this.lblModuleCPDPointsAvailable.Visible = false;
                cpdEnabled = false;
            }
        }
        private void checkLastPassInit()
        {

            BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            LastPassEnabled = objOrganisation.ShowLastPassed(UserContext.UserData.OrgID);

        }
        private void checkLastPass()
        {

            BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            LastPassEnabled = objOrganisation.ShowLastPassed(UserContext.UserData.OrgID);

        }

        private bool checkEbookAccess()
        {
            BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            return objOrganisation.GetOrganisationEbookAccess(UserContext.UserData.OrgID);
        }


        private void rptCourseList_ItemDataBound(object source, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // for the courseID of the item iterate through the modules and determine
                // if points allocated to user or not - if allocated then don't add points 
                // otherwise add points to the total. Once all points totalled then populate points
                // label on repeater with value
                double TotalPoints = 0.0;
                Label lblCoursePoints = (Label)e.Item.FindControl("lblCoursePoints");
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int UserID = UserContext.UserID;
                int CourseID = int.Parse(drv["CourseID"].ToString());
                int ProfileID = int.Parse(Session["ProfileID"].ToString());
                BusinessServices.User objUser = new BusinessServices.User();
                DataTable dtModules = objUser.HomePageDetails(UserID, CourseID, ProfileID);
                foreach (DataRow drModule in dtModules.Rows)
                {

                    int ModuleID = int.Parse(drModule["ModuleID"].ToString());
                    BusinessServices.Profile objProfile = new BusinessServices.Profile();
                    DataTable dtLessonQuiz = objProfile.GetLessonQuizStatus(ProfileID);
                    bool ApplyToQuiz = false;
                    bool ApplyToLesson = false;
                    if (dtLessonQuiz.Rows.Count > 0)
                    {
                        ApplyToQuiz = bool.Parse(dtLessonQuiz.Rows[0]["ApplyToQuiz"].ToString());
                        ApplyToLesson = bool.Parse(dtLessonQuiz.Rows[0]["ApplyToLesson"].ToString());
                    }
                    if (ApplyToQuiz && ApplyToLesson)
                    {
                        if (objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 0, 2) || objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 1, 2))
                        {
                            TotalPoints += double.Parse(drModule["Points"].ToString());
                        }
                    }
                    else if (ApplyToQuiz)
                    {
                        if (objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 1, 1))
                        {
                            TotalPoints += double.Parse(drModule["Points"].ToString());
                        }
                    }
                    else if (ApplyToLesson)
                    {
                        if (objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 0, 0))
                        {
                            TotalPoints += double.Parse(drModule["Points"].ToString());
                        }
                    }

                }

                // check if the course has ebook associated or not
                int ebookid = 0;
                bool result = Int32.TryParse(drv["ebookid"].ToString(), out ebookid);
                if (!result || ebookid == 0)
                {
                    LinkButton lnkDownloadEbook = e.Item.FindControl("lnkDownloadEbook") as LinkButton;
                    lnkDownloadEbook.Visible = false;
                }



                lblCoursePoints.Text = TotalPoints.ToString();
            }
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            System.Web.UI.HtmlControls.HtmlTableCell TableCell = (System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("Td3");
            System.Data.DataRowView dr = (System.Data.DataRowView)e.Item.DataItem;
            if (dr.Row.ItemArray[7].Equals("1")) { TableCell.Style.Add("Color", "Red"); }
        }

        private void rptModules_ItemDataBound(object source, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (txttoolbookloc.Text == "launchpage.html")
                {
                    LinkButton Linkbutton1 = (LinkButton)e.Item.FindControl("Linkbutton1");
                    if (Linkbutton1 != null)
                    {
                        Linkbutton1.Visible = false;
                    }
                    LinkButton Linkbutton3 = (LinkButton)e.Item.FindControl("Linkbutton3");
                    if (Linkbutton3 != null)
                    {
                        Linkbutton3.Visible = false;
                    }

                    locQuizAdaptive.Visible = true;
                    LocalizedLabel2.Visible = false;

                    Localizedlabel1.Visible = false;
                }
                else
                {
                    LocalizedLabel2.Visible = true;
                    locQuizAdaptive.Visible = false;

                    Localizedlabel1.Visible = true;
                }


                // This code checking if user has been allocated points from module already.
                // If so then CPD points available is zero
                double zeroPoints = 0.0;
                Label lblModulePoints = (Label)e.Item.FindControl("lblModulePoints");
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int ModuleID = int.Parse(drv["ModuleID"].ToString());
                int UserID = int.Parse(drv["UserID"].ToString());
                int ProfileID = int.Parse(Session["ProfileID"].ToString());
                BusinessServices.Profile objProfile = new BusinessServices.Profile();
                DataTable dtLessonQuiz = objProfile.GetLessonQuizStatus(ProfileID);
                bool ApplyToQuiz = false;
                bool ApplyToLesson = false;
                if (dtLessonQuiz.Rows.Count > 0)
                {
                    ApplyToQuiz = bool.Parse(dtLessonQuiz.Rows[0]["ApplyToQuiz"].ToString());
                    ApplyToLesson = bool.Parse(dtLessonQuiz.Rows[0]["ApplyToLesson"].ToString());
                }
                if (ApplyToQuiz && ApplyToLesson)
                {
                    if (objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 0, 2) || objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 1, 2))
                    {
                        lblModulePoints.Text = drv["Points"].ToString();
                    }
                    else
                    {
                        lblModulePoints.Text = zeroPoints.ToString();
                    }
                }
                else if (ApplyToQuiz)
                {
                    if (objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 1, 1))
                    {
                        lblModulePoints.Text = drv["Points"].ToString();
                    }
                    else
                    {
                        lblModulePoints.Text = zeroPoints.ToString();
                    }
                }
                else if (ApplyToLesson)
                {
                    if (objProfile.ShowModulePoints(ProfileID, UserID, ModuleID, 0, 0))
                    {
                        lblModulePoints.Text = drv["Points"].ToString();
                    }
                    else
                    {
                        lblModulePoints.Text = zeroPoints.ToString();
                    }
                }
            }
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            System.Web.UI.HtmlControls.HtmlTableCell TableCell = (System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("ModuleQuizDue");
            System.Data.DataRowView dr = (System.Data.DataRowView)e.Item.DataItem;
            if ((dr.Row.ItemArray[13] != null) && (TableCell != null))
            {
                if (dr.Row.ItemArray[13].Equals("1")) { TableCell.Style.Add("Color", "Red"); }
            }

        }

        /// <summary>
        /// Entery Point to the page
        /// </summary>
        /// <param name="sender">default object</param>
        /// <param name="e">default arguments</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen K-Clark, 9/02/04
        /// Changes:

        /// </remarks>
        protected void Page_Load(object sender, System.EventArgs e)
        {
            // detect the request to see if the user is using iPad
            isIpad = HttpContext.Current.Request.UserAgent.ToLower().Contains("ipad");
            this.Context.Items["SectionTitle"] = ResourceManager.GetString("lblSectionTitle");
            if (!Page.IsPostBack)
            {

                pagTitle.InnerText = ResourceManager.GetString("pagTitle");

                bool bLocation = false;
                try
                {
                    // check if its come from toolbook
                    bLocation = Request.UrlReferrer.AbsoluteUri.ToString().IndexOf("Toolbook") > 0;
                    if (!bLocation)
                    {
                        // check if its come from view policy
                        bLocation = Request.UrlReferrer.AbsoluteUri.ToString().IndexOf("ViewPolicy.aspx") > 0;
                        if (!bLocation)
                        {
                            // check if its come from quiz summary
                            bLocation = Request.UrlReferrer.AbsoluteUri.ToString().IndexOf("QuizSummary.aspx") > 0;
                            if (!bLocation)
                            {
                                // check if its come from quiz summary
                                bLocation = Request.UrlReferrer.AbsoluteUri.ToString().IndexOf("Scorm") > 0;
                            }
                        }
                    }


                    if (!bLocation)
                    {
                        Session["CourseID"] = -1;
                        Session["ProfileID"] = -1;
                    }
                }
                catch
                {
                    //Do nothing
                }
            }
            SetPageState();
            this.ddlCPDProfile_SelectedIndexChanged(sender, e);

        } //Page_Load

        /// <summary>
        /// Navigate To Toolbook Lesson
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,11/02/04
        /// Changes:
        /// </remarks>		
        /// <param name="moduleID">Module ID</param>
        /// <param name="userID">User ID</param>
        private void NavigateToToolbookLesson(int moduleID, int userID)
        {
            string strToolbookQueryString;  // Toolbook Query Strig in the format: CourseName  ModuleName  Lesson
            string strToolbookLocation;  //File Path from / to the toolbook
            string strSessionData;      // session id
            DataTable dtbSessionInfo;   // datable to hold database query results

            BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();
            dtbSessionInfo = objToolbook.BeforeLessonStart(userID, moduleID);
            strSessionData = (string)dtbSessionInfo.Rows[0]["SessionID"];
            strToolbookLocation = (string)dtbSessionInfo.Rows[0]["Location"];
            Boolean strIsScorm1_2 = true;
            strIsScorm1_2 = (Boolean)dtbSessionInfo.Rows[0]["Scorm1_2"];
            //get ProfileID passed back in query string
            string strProfileID = Session["ProfileID"].ToString();
            string strCourseID = Session["CourseID"].ToString();

            // build the url and querystring to open toolbook with
            // Add Querystring initiater '?' to the begining of the query string
            strToolbookQueryString = @"?";
            if (strIsScorm1_2)
            {
                strToolbookQueryString += "&ReturnURL=/MyTraining.aspx";
            }
            // Add sessionData
            strToolbookQueryString += "&SessionData=" + strSessionData;

            // build the entire URL
            strToolbookQueryString += "&CourseID=" + strCourseID;
            strToolbookQueryString += "&ProfileID=" + strProfileID;
            strToolbookQueryString += "&ModuleID=" + moduleID;
            strToolbookQueryString += "&UserID=" + userID;


            // Redirect the current page to the toolbook Lesson
            if (strIsScorm1_2)
            {
                BusinessServices.Toolbook objToolBook = new BusinessServices.Toolbook();

                objToolBook.StartLesson(strSessionData);
                Response.Redirect("/General/Scorm/ScormDiv.aspx" + strToolbookQueryString);

            }
            else
            {
                strToolbookQueryString += "&PostbackURL=" + GetTBPostBackURL(strSessionData);
                strToolbookQueryString += "&Delay=" + ApplicationSettings.ToolbookDelay.ToString();
                Response.Redirect(strToolbookLocation + strToolbookQueryString);
            }
        }

        /// <summary>
        /// Navigate To Toolbook Quiz
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,11/02/04
        /// Changes:
        /// </remarks>
        /// <param name="moduleID">Module ID</param>
        /// <param name="userID">User ID</param>
        private void NavigateToToolbookQuiz(int moduleID, int userID)
        {
            string strToolbookQueryString;  // Toolbook Query Strig in the format: CourseName  ModuleName  Lesson
            string strToolbookLocation;     // File Path from / to the toolbook
            string strSessionData;          // session id
            DataTable dtbSessionInfo;       // datable to hold database query results

            OrganisationConfig objOrgConfig = new OrganisationConfig();

            BusinessServices.Toolbook objToolbook = new BusinessServices.Toolbook();

            //Code by Joseph For adaptive
            //DataTable dtbAdaptiveCourse;
            //dtbAdaptiveCourse = objToolbook.CheckAdaptiveCourse(moduleID);
            //if (dtbAdaptiveCourse.Rows.Count > 0)
            //{
            //    if (dtbAdaptiveCourse.Rows[0]["LectoraBookmark"].ToString().Trim() == "imsmanifest.xml")
            //    {
            //        Localizedlabel1.Text = "";
            //        LocalizedLabel2.Text = "SCROM Adaptive";
            //        //TODO: populate the page according to the module, course and userid.
            //        //string strContentDestination = ConfigurationSettings.AppSettings["ImportSCORMDestinationDirectory"] + "/AdaptiveFiles" + "/" + Session["CourseID"].ToString() + "/" + moduleID;
            //        Response.Redirect("~/SCROMPlayer.aspx?CourseID=" + Session["CourseID"].ToString() + "&ModuleID=" + moduleID + "&Userid=" + userID);
            //    }
            //    else
            //    {
            //        dtbSessionInfo = objToolbook.BeforeQuizStart(userID, moduleID);
            //        strSessionData = (string)dtbSessionInfo.Rows[0]["SessionID"];
            //        strToolbookLocation = (string)dtbSessionInfo.Rows[0]["Location"];

            //        //get ProfileID passed back in query string
            //        string strProfileID = Session["ProfileID"].ToString();
            //        string strCourseID = Session["CourseID"].ToString();

            //        // build the url and querystring to open toolbook with
            //        // Add Querystring initiater '?' to the begining of the query string
            //        strToolbookQueryString = @"?";

            //        // Add sessionData
            //        strToolbookQueryString += "SessionData=" + strSessionData;

            //        // build the entire URL
            //        strToolbookQueryString += "&CourseID=" + strCourseID;
            //        strToolbookQueryString += "&ProfileID=" + strProfileID;
            //        strToolbookQueryString += "&noq=" + objOrgConfig.GetOne(UserContext.UserData.OrgID, "Number_Of_Quiz_Questions");
            //        strToolbookQueryString += "&ModuleID=" + moduleID;
            //        strToolbookQueryString += "&UserID=" + userID;
            //        strToolbookQueryString += "&PostbackURL=" + GetTBPostBackURL(strSessionData);
            //        strToolbookQueryString += "&Delay=" + ApplicationSettings.ToolbookDelay.ToString();

            //        Boolean strIsScorm1_2 = true;
            //        strIsScorm1_2 = (Boolean)dtbSessionInfo.Rows[0]["Scorm1_2"];

            //        if (strIsScorm1_2)
            //        {
            //            BusinessServices.Toolbook objToolBook = new BusinessServices.Toolbook();

            //            objToolBook.StartQuiz(strSessionData);
            //            Response.Redirect("/General/Scorm/ScormDiv.aspx" + strToolbookQueryString);

            //        }
            //        else
            //        {
            //            strToolbookQueryString += "&PostbackURL=" + GetTBPostBackURL(strSessionData);
            //            strToolbookQueryString += "&Delay=" + ApplicationSettings.ToolbookDelay.ToString();
            //            Response.Redirect(strToolbookLocation + strToolbookQueryString);
            //        }
            //    }
            //}
            //else
            //{
            //End code

            dtbSessionInfo = objToolbook.BeforeQuizStart(userID, moduleID);
            strSessionData = (string)dtbSessionInfo.Rows[0]["SessionID"];
            strToolbookLocation = (string)dtbSessionInfo.Rows[0]["Location"];

            //get ProfileID passed back in query string
            string strProfileID = Session["ProfileID"].ToString();
            string strCourseID = Session["CourseID"].ToString();

            // build the url and querystring to open toolbook with
            // Add Querystring initiater '?' to the begining of the query string
            strToolbookQueryString = @"?";

            // Add sessionData
            strToolbookQueryString += "SessionData=" + strSessionData;

            // build the entire URL
            strToolbookQueryString += "&CourseID=" + strCourseID;
            strToolbookQueryString += "&ProfileID=" + strProfileID;
            strToolbookQueryString += "&noq=" + objOrgConfig.GetOne(UserContext.UserData.OrgID, "Number_Of_Quiz_Questions");
            strToolbookQueryString += "&ModuleID=" + moduleID;
            strToolbookQueryString += "&UserID=" + userID;
            strToolbookQueryString += "&PostbackURL=" + GetTBPostBackURL(strSessionData);
            strToolbookQueryString += "&Delay=" + ApplicationSettings.ToolbookDelay.ToString();

            Boolean strIsScorm1_2 = true;
            strIsScorm1_2 = (Boolean)dtbSessionInfo.Rows[0]["Scorm1_2"];

            if (strIsScorm1_2)
            {
                BusinessServices.Toolbook objToolBook = new BusinessServices.Toolbook();

                objToolBook.StartQuiz(strSessionData);
                Response.Redirect("/General/Scorm/ScormDiv.aspx" + strToolbookQueryString);

            }
            else
            {
                strToolbookQueryString += "&PostbackURL=" + GetTBPostBackURL(strSessionData);
                strToolbookQueryString += "&Delay=" + ApplicationSettings.ToolbookDelay.ToString();
                Response.Redirect(strToolbookLocation + strToolbookQueryString);
            }
            //}
        }

        /// <summary>
        /// Onclick event fired by clicking on a module or quiz in the datagrid
        /// </summary>
        /// <remarks>
        /// Fired when a user clickes on the module datagrid
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,11/02/04
        /// Changes:
        /// </remarks>
        /// <param name="e">Repeater Command Event Arguments</param>
        /// <param name="source">source object</param>
        private void rptModules_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Lesson_OnClick")
            {
                NavigateToToolbookLesson(Convert.ToInt32(e.CommandArgument), UserContext.UserID);
            }
            if (e.CommandName == "Quiz_OnClick")
            {
                NavigateToToolbookQuiz(Convert.ToInt32(e.CommandArgument), UserContext.UserID);
            }
        }

        private void rptCourseList_ItemCreated(object source, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                checkCPD();
                if (!cpdEnabled)
                {
                    HtmlTableCell tcCourse = (HtmlTableCell)e.Item.FindControl("CoursePointsAvailable");
                    tcCourse.Visible = false;
                }
                checkLastPass();
                if (!LastPassEnabled)
                {
                    HtmlTableCell tcLastPass = (HtmlTableCell)e.Item.FindControl("Td2");
                    tcLastPass.Visible = false;
                    tcLastPass.ColSpan = 0;
                    tcLastPass.Width = "0";
                    HtmlTableCell tcDue = (HtmlTableCell)e.Item.FindControl("Td3");
                    tcDue.Visible = false;
                    tcDue.ColSpan = 0;
                    tcDue.Width = "0";

                    colLastComp.Style.Add("display", "none");
                    colDue.Style.Add("display", "none");

                }
            }

        }

        private void rptPolicyList_ItemCreated(object source, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                checkCPD();
                if (!cpdEnabled)
                {
                    HtmlTableCell tcCourse = (HtmlTableCell)e.Item.FindControl("PolicyPointsAvailable");
                    tcCourse.Visible = false;
                }
            }


        }

        private void rptCourseList_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Certificate_Print")
            {
                char sep = Convert.ToChar(",");
                string[] strArg = e.CommandArgument.ToString().Split(sep);
                int CourseStatus = Convert.ToInt32(strArg[0]);
                int CourseID = Convert.ToInt32(strArg[1]);
                int ProfileID;
                if (this.ddlCPDProfile.Visible)
                {
                    ProfileID = int.Parse(this.ddlCPDProfile.SelectedValue.ToString());
                }
                else
                {
                    ProfileID = -1;
                }
                Session["ProfileID"] = ProfileID;
                Session["CourseID"] = CourseID;
                if (CourseStatus == 2)
                {
                    //Need to do this instead of a Response.Redirect in order to create certificate in a new window.
                    Response.Write("<script>");
                    Response.Write("window.open('/Certificate.aspx','_blank')");
                    Response.Write("</script>");

                }
                else //Course not complete so no command
                {
                    Response.Redirect(Request.Url.ToString());
                }
            }
            if (e.CommandName == "Course_Click")
            {
                char sep = Convert.ToChar(",");
                string[] strArg = e.CommandArgument.ToString().Split(sep);
                int CourseID = Convert.ToInt32(strArg[0]);
                int ProfileID = Convert.ToInt32(strArg[1]);
                Session["ProfileID"] = ProfileID;
                Session["CourseID"] = CourseID;
                SetPageState();
            }
            if (e.CommandName == "DownloadEbook")
            {
                Response.Redirect("/General/eBook/EBookDownload.ashx?CourseID=" + e.CommandArgument);
            }
        }


        private void rptCourseList_OnItemCreated(object source, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ID == "Td4")
            {
                e.Item.Visible = false;

            }
        }

        private void rptPolicyList_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Policy_Click")
            {
                char sep = Convert.ToChar(",");
                string[] strArg = e.CommandArgument.ToString().Split(sep);
                int PolicyID = Convert.ToInt32(strArg[0]);
                int ProfileID = Convert.ToInt32(strArg[1]);
                Response.Redirect("/ViewPolicy.aspx?PolicyID=" + PolicyID + "&ProfileID=" + ProfileID);
            }
        }
        #endregion

        //Madhuri CPD Event Start
        private void PopulateEventGrid(int UserID, int ProfileID)
        {
            try
            {

                int OrganisationID = UserContext.UserData.OrgID;
                BusinessServices.Event objUser = new BusinessServices.Event();



                Organisation objOrganisation = new Organisation();
                //this.phEventList.Visible = objOrganisation.GetOrganisationCPDEventAccess(UserContext.UserData.OrgID);

                if (objOrganisation.GetOrganisationCPDEventAccess(UserContext.UserData.OrgID))
                {
                    this.phEvent.Visible = true;

                    DataTable dtUserEventStatus = objUser.GetUserEventStatus(UserID, OrganisationID, ProfileID);
                    if (dtUserEventStatus.Rows.Count > 0)
                    {
                        int PageSize = ApplicationSettings.PageSize;
                        this.dgrCPD.PageSize = PageSize;
                        
                        dgrCPD.DataSource = dtUserEventStatus;                       
                        dgrCPD.DataBind();
                        phEventList.Visible = true;
                    }
                    else
                    {
                        phEventList.Visible = false;
                    }
                    

                    DataTable dtLoadOrg;
                    string strLangCode = Request.Cookies["currentCulture"].Value;
                    dtLoadOrg = objOrganisation.GetOrganisation(strLangCode, UserContext.UserData.OrgID);
                    // If an organisation Exists
                    if (dtLoadOrg.Rows.Count > 0)
                    {
                        this.btnCreateEvent.Visible = Boolean.Parse(dtLoadOrg.Rows[0]["EnableUserCPDEvent"].ToString());
                    }
                    else
                    {
                        this.btnCreateEvent.Visible = false;
                    }
                }
                else
                {
                    this.phEvent.Visible = false;

                }


            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "MyTraining.aspx.cs", "PopulateEventGrid()", "Binding Data to Datagrid");
                throw (Ex);
            }
        }
        private void dgrCPD_ItemCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            if (e.CommandName != "Page")
            {
                string EventPeriodIDValue = @"-1";
                string Action = e.CommandName;
                HiddenField hdUserType = (HiddenField)e.Item.FindControl("hdUserType");
                Label EventID = (Label)e.Item.FindControl("lblEventID");
                Label EventPeriodID = (Label)e.Item.FindControl("lblEventPeriodID");
                string EventIDValue = EventID.Text;
                if (EventPeriodID.Text != "")
                {
                    EventPeriodIDValue = EventPeriodID.Text;
                }

                if (hdUserType.Value == "0" || hdUserType.Value == "1")
                {
                    switch (Action)
                    {
                        case "Add":
                            Session["EventID"] = EventIDValue;
                            Session["EventPeriodID"] = EventPeriodIDValue;
                            Session["Action"] = "Add";
                            Response.Redirect(@"\cpdevent.aspx");
                            break;
                        case "Edit":

                            Session["EventID"] = EventIDValue;
                            Session["EventPeriodID"] = EventPeriodIDValue;
                            Session["Action"] = "Edit";
                            Response.Redirect(@"\cpdevent.aspx");
                            break;
                    }
                }
                else
                {
                    switch (Action)
                    {
                        case "Add":
                            Session["Action"] = "Add";
                            Response.Redirect(@"\Usercpdevent.aspx");
                            break;
                        case "Edit":
                            Session["EventID"] = EventIDValue;
                            Session["EventPeriodID"] = EventPeriodIDValue;
                            Session["Action"] = "Edit";
                            Response.Redirect(@"\Usercpdevent.aspx");
                            break;

                    }
                }

            }

        }
        private void dgrCPD_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
        {
            try
            {

                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    HiddenField lblUserId = (HiddenField)e.Item.FindControl("lblUserId");

                    HiddenField hdpoints = (HiddenField)e.Item.FindControl("hdpoints");
                    HiddenField hdAllowuser = (HiddenField)e.Item.FindControl("hdAllowuser");
                    LinkButton lnkedit = (LinkButton)e.Item.FindControl("lnkedit");
                    LinkButton lnkDelete = (LinkButton)e.Item.FindControl("lnkDelete");
                    LinkButton lnkadd = (LinkButton)e.Item.FindControl("lnkadd");
                    Label lblEventID = (Label)e.Item.FindControl("lblEventID");
                    if (int.Parse(lblUserId.Value) > 0)
                    {
                        //lnkDelete.Visible = true;
                        lnkedit.Visible = true;

                        lnkadd.Visible = false;

                    }
                    else
                    {
                        //e.Item.CssClass = "tablerow2";
                        //lnkDelete.Visible = false;
                        lnkedit.Visible = false;
                        if (hdAllowuser.Value == "True")
                        {
                            lnkadd.Visible = true;
                            if (Double.Parse(hdpoints.Value) > 0)
                            {
                                lnkadd.Visible = true;
                            }
                            else
                            {
                                lnkadd.Visible = false;

                            }

                        }
                        else
                        {
                            lnkadd.Visible = false;
                        }
                    }

                    DataRowView drv = (DataRowView)e.Item.DataItem;
                    int EventID = (int)drv["EventID"];
                    BusinessServices.Event objEvent = new BusinessServices.Event();
                    DataTable dtEvent = objEvent.GetEvent(EventID, -1, UserContext.UserData.OrgID);

                    if (dtEvent.Rows.Count > 0)
                    {
                        if (GEventid != EventID)
                        {
                            GEventid = EventID;
                            GEventrowcount = 0;
                        }
                        else
                        {
                            if (dtEvent.Rows.Count != GEventrowcount + 1)
                            {
                                GEventrowcount++;
                            }
                        }
                        if (!dtEvent.Rows[GEventrowcount]["DateStart"].Equals(System.DBNull.Value))
                        {
                            DateTime dtStart = (DateTime)dtEvent.Rows[GEventrowcount]["DateStart"];
                            if (dtStart < DateTime.Now) //Current Period
                            {
                                Label lblCurrentDate = (Label)e.Item.FindControl("lblCurrentDate");
                                lblCurrentDate.Text =
                                    string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["DateStart"])
                                    + " - " +
                                    string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["DateEnd"]);

                                Label lblStarttime = (Label)e.Item.FindControl("lblStarttime");
                                lblStarttime.Text = string.Format("{0:hh:mm tt}", (DateTime)dtEvent.Rows[GEventrowcount]["DateStart"]);

                                Label lblendtime = (Label)e.Item.FindControl("lblendtime");
                                lblendtime.Text = string.Format("{0:hh:mm tt}", (DateTime)dtEvent.Rows[GEventrowcount]["DateEnd"]);
                            }
                        }
                    }
                    //if (lblEventID.Text == "" || lblEventID.Text == "0")
                    //{
                    //    lnkedit.Visible = false;
                    //    lnkadd.Visible = false;
                    //    //lnkeditUserEvent.Visible = true;
                    //    e.Item.CssClass = "tablerow4 !important";
                    //}
                }
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "MyTraining.aspx.cs", "dgrCPD_ItemDataBound", "Binding Data to Datagrid");
                throw (Ex);
            }
        }
        protected void btnCreateEvent_Click(object sender, System.EventArgs e)
        {
            Session["EventID"] = null;
            Session["EventPeriodID"] = null;
            Session["UserEvent"] = "UserEvent";
            Session["Action"] = "Add";
            Response.Redirect(@"\Usercpdevent.aspx");
        }
        protected string GetFilename(string name)
        {
            try
            {
                if (String.IsNullOrEmpty(name))
                {
                    return "";
                }
                else
                {
                    string fileList = name;
                    string filename = "";

                    if (name.Contains("|") && name.Contains("~"))
                    {
                        string[] delim = { "|" };
                        string[] strname = name.Split(delim, StringSplitOptions.None);

                        for (int i = 0; i < strname.Length; i++)
                        {
                           
                            int underscoreIndex = strname[i].LastIndexOf("~");
                            int dotIndex = strname[i].LastIndexOf(".");
                            string newFilename = strname[i].Substring(0, underscoreIndex);
                            newFilename += strname[i].Substring(dotIndex);
                            filename += newFilename + " | ";
                        }
                        fileList = filename.Remove(filename.Length - 2);
                    }                   
                    return fileList;
                }
            }

            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "MyTraining.aspx.cs", "GetFilename", "GetFilename");
                throw (Ex);
            }
        }
        private void dgrCPD_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            int UserID = UserContext.UserID;

            dgrCPD.CurrentPageIndex = e.NewPageIndex;

            PopulateEventGrid(UserID, int.Parse(Session["ProfileID"].ToString()));
        } 
        //Madhuri CPD Event End 
    }
}
