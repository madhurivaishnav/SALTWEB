using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
    public partial class OrgMailSetup : System.Web.UI.Page
    {
        protected Bdw.Application.Salt.BusinessServices.Organisation objOrganisation;

        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            // language stuff for radio group 2
            radEscMgrMailOpts.Items[0].Text = ResourceManager.GetString("radEscOpts0");
            radEscMgrMailOpts.Items[1].Text = ResourceManager.GetString("radEscOpts1");
            
            objOrganisation = new BusinessServices.Organisation();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pagTitle.InnerText = ResourceManager.GetString("pagTitle");
                LoadData();
            }
        }

        private void LoadData()
        {
            setPageState();
        }

        private void setPageState()
        {            
            BusinessServices.Organisation objOrg = new BusinessServices.Organisation();
            BusinessServices.Course objCourse = new BusinessServices.Course();
            // set datasource
            DataTable dtCourse = objCourse.GetCourseListAccessableToOrg(UserContext.UserData.OrgID, 1);
            // set datatext field
            dtCourse.Select("active = 1");
            chkCourseList.DataSource = dtCourse;
            chkCourseList.DataTextField = "Name";
            chkCourseList.DataValueField = "CourseID";
            chkCourseList.DataBind();
            //set datavalue field

            ListItem itm = null;
            itm = chkCourseList.Items.FindByValue(Session["RemEscID"].ToString());

            if (itm != null)
            {
                // updating existing reminders
                itm.Selected = true;
                chkCourseList.Enabled = false;

                // get the reminder escalation stuff from the db and display
                DataTable dtr = objOrganisation.getEscalationConfigForCourse(UserContext.UserData.OrgID, Int32.Parse(itm.Value));
                DataColumnCollection dc = dtr.Columns;
                DataRow drw = dtr.Rows[0];
                
                //drw.ItemArray[""];

                // initial enrolment stuff
                chkWarnUsers.Checked = (bool)drw.ItemArray[dc.IndexOf("remindusers")];
                txtNumberofDaysDelinq.Text = drw.ItemArray[dc.IndexOf("daystocompletecourse")].ToString().Equals("0") ? "" : drw.ItemArray[dc.IndexOf("daystocompletecourse")].ToString();
                

                // pre expiry stuff
                chkWarnQuizExpiry.Checked = (bool)drw.ItemArray[dc.IndexOf("quizExpiryWarn")];
                txtDaysBeforeWarn.Text = drw.ItemArray[dc.IndexOf("daysquizexpiry")].ToString().Equals("0") ? "" : drw.ItemArray[dc.IndexOf("daysquizexpiry")].ToString();
                chkPreExpInitEnrolment.Checked = (bool)drw.ItemArray[dc.IndexOf("PreExpInitEnrolment")];
                chkPreExpiryResitPeriod.Checked = (bool)drw.ItemArray[dc.IndexOf("PreExpResitPeriod")]; 

                // post expiry
                chkPostExpiryReminder.Checked = (bool)drw.ItemArray[dc.IndexOf("PostExpReminder")];
                txtNumberOfWarns.Text = drw.ItemArray[dc.IndexOf("NumOfRemNotfy")].ToString().Equals("0") ? "" : drw.ItemArray[dc.IndexOf("NumOfRemNotfy")].ToString();
                txtNumberofDaysWarns.Text = drw.ItemArray[dc.IndexOf("RepeatRem")].ToString().Equals("0") ? "" : drw.ItemArray[dc.IndexOf("RepeatRem")].ToString(); 
                chkPostExpiryInit.Checked= (bool)drw.ItemArray[dc.IndexOf("PostExpInitEnrolment")];
                chkPostExpiryResit.Checked = (bool)drw.ItemArray[dc.IndexOf("PostExpResitPeriod")];

                //manager check
                chkWarnMgrs.Checked = (bool)drw.ItemArray[dc.IndexOf("NotifyMgr")]; ;

                if (chkWarnMgrs.Checked)
                {
                    radEscMgrMailOpts.Enabled = true;

                    if ((bool)dtr.Rows[0]["IndividualNotification"]) // if its individual notification select the first radio option
                    {
                        radEscMgrMailOpts.SelectedIndex = 0;
                        chkCumulative.Checked = false;
                        chkCumulative.Enabled = false;

                        txtREegularDays.Text = "";
                        txtREegularDays.Enabled = false;

                    }
                    else // regular list every X days
                    {
                        radEscMgrMailOpts.SelectedIndex = 1;
                        chkCumulative.Checked = (bool)dtr.Rows[0]["IsCumulative"];
                        txtREegularDays.Text = dtr.Rows[0]["NotifyMgrDays"].ToString();
                        txtREegularDays.Enabled = true;
                        chkCumulative.Enabled = true;
                    }
                }
                else
                {
                    radEscMgrMailOpts.SelectedIndex = -1;
                    radEscMgrMailOpts.Enabled = false;

                    chkCumulative.Checked = false;
                    chkCumulative.Enabled = false;

                    txtREegularDays.Text = "";
                    txtREegularDays.Enabled = false;

                    txtDaysBeforeWarn.Enabled = false;

                }

                enableDisable();
            }
            else
            {
                //creating new one
                chkWarnUsers.Checked = false;
                chkWarnMgrs.Checked = false;
                chkWarnQuizExpiry.Checked = false;
                txtNumberofDaysDelinq.Text = "";
                lblValidationMSG.Text = "";
                enableDisable();
            }
            //if (objOrg.orgMailFlagConfig(UserContext.UserData.OrgID, 0, UserContext.UserID))
            //{
            //    btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Start");
            //}
            //else
            //{
            //    btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Stop");
            //}
        }

        private void enableDisable()
        {
            Object o = new Object();
            EventArgs e = new EventArgs();
            chkWarnUsers_check(o, e);
            chkWarnMgrs_check(o, e);
            chkWarnQuizExpiry_check(o, e);
            radEscMgrMailOpts_changed(o, e);
            chkPostExpiryReminder_check(o, e);
 
        }

//        protected void btnMailFlag_Click(object sender, EventArgs e)
//        {
//            BusinessServices.Organisation objOrg = new BusinessServices.Organisation();
//            if (objOrg.orgMailFlagConfig(UserContext.UserData.OrgID, 1, UserContext.UserID))
//            {
//                btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Start");
//            }
//            else
//            {
//                btnMailFlag.Text = ResourceManager.GetString("btnStopEmail_Stop");
//            }
//        }

       
        protected void btnOrgMailSetupSave_Click(object sender, EventArgs e)
        {
            // set the variables up here... 
            // initial enrolment stuff
            Boolean blnInitialEnrolmentReminder = chkWarnUsers.Checked;
            int DaysToCompleteCourse = Int32.Parse(txtNumberofDaysDelinq.Text == "" ? "0" : txtNumberofDaysDelinq.Text);
            Boolean blnValid = DaysToCompleteCourse > 0;

            // pre expiry stuff
            Boolean blnPreExpiryReminder = chkWarnQuizExpiry.Checked;
            int daysBeforeExpiryReminder = Int32.Parse(txtDaysBeforeWarn.Text == "" ? "0" : txtDaysBeforeWarn.Text);
            Boolean blnPreExpInitEnrolment = chkPreExpInitEnrolment.Checked;
            Boolean blnPreExpResitPeriod = chkPreExpiryResitPeriod.Checked;

            // post expiry
            Boolean blnPostExpiryReminder = chkPostExpiryReminder.Checked;
            int numberofReminderNotifications = Int32.Parse(txtNumberOfWarns.Text == "" ? "1" : txtNumberOfWarns.Text);
            int intReminderInterval = Int32.Parse(txtNumberofDaysWarns.Text == "" ? "1" : txtNumberofDaysWarns.Text);
            Boolean blnPostExpInitEnrolment = chkPostExpiryInit.Checked;
            Boolean blnPostExpiryResitPeriod = chkPostExpiryResit.Checked;

            bool NotifyMgr = chkWarnMgrs.Checked;
            bool IndividualNotification = radEscMgrMailOpts.SelectedIndex == 0;
            bool IsCumulative = chkCumulative.Checked;
            int NotifyMgrDays = Int32.Parse(txtREegularDays.Text == "" ? "1" : txtREegularDays.Text);

            string strCourseids = "-1";
            //get the list of courses to apply this to
            if (chkCourseList.Items.Count>0)
            {
                foreach (ListItem li in chkCourseList.Items)
                {
                    if (li.Selected) 
                    {
                        strCourseids +=","+li.Value;
                    }   
                }
            }
            if (!strCourseids.Equals("-1"))
            {
                // throw validation error here
            }
            int remEscID = -1;

            // save stuff here
            objOrganisation.updateMailConfig(remEscID, UserContext.UserData.OrgID, strCourseids, DaysToCompleteCourse, blnInitialEnrolmentReminder, numberofReminderNotifications
                    , intReminderInterval, NotifyMgr, IndividualNotification, IsCumulative, NotifyMgrDays, blnPreExpiryReminder, daysBeforeExpiryReminder,blnPreExpInitEnrolment
                    ,blnPostExpiryReminder,blnPostExpInitEnrolment,blnPostExpiryResitPeriod,blnPreExpResitPeriod);


            this.lblValidationMSG.Text = ResourceManager.GetString("lblMessage.Saved");//"The Organisation's Mail config has been saved successfully";
            this.lblValidationMSG.CssClass = "SuccessMessage";
        }

        //protected void cboCourses_SelectedIndexChanged(Object sender, EventArgs e)
        //{
        //    displayCourseConfig(objOrganisation.getEscalationConfigForCourse(UserContext.UserData.OrgID, Int32.Parse(cboCourses.SelectedValue == "" ? "0" : cboCourses.SelectedValue)));
        //}

        protected void chkWarnUsers_check(Object sender, EventArgs e)
        {
            txtNumberofDaysDelinq.Enabled = chkWarnUsers.Checked;
            if (!chkWarnUsers.Checked)
                txtNumberofDaysDelinq.Text = "";
            chkPreExpInitEnrolment.Enabled = chkWarnUsers.Checked && chkWarnQuizExpiry.Checked;
            chkPostExpiryInit.Enabled = chkWarnUsers.Checked && chkPostExpiryReminder.Checked;
        }

        protected void chkWarnMgrs_check(Object sender, EventArgs e)
        {
            if (!chkWarnMgrs.Checked)
            radEscMgrMailOpts.SelectedIndex = -1;
            radEscMgrMailOpts.Enabled = chkWarnMgrs.Checked;
            radEscMgrMailOpts_changed(sender, e);
        }

        protected void radEscMgrMailOpts_changed(object sender, EventArgs e)
        {
            bool enable = radEscMgrMailOpts.SelectedIndex == 1;

            if (!enable)
            {
                chkCumulative.Checked = false;
                txtREegularDays.Text = "";
            }
            txtREegularDays.Enabled = enable;
            chkCumulative.Enabled = enable;
           
        }


        protected void chkWarnQuizExpiry_check(Object sender, EventArgs e)
        {
            if(!chkWarnQuizExpiry.Checked)
            txtDaysBeforeWarn.Text = "";
            txtDaysBeforeWarn.Enabled = chkWarnQuizExpiry.Checked;
            chkPreExpInitEnrolment.Enabled = chkWarnUsers.Checked && chkWarnQuizExpiry.Checked;
            chkPreExpiryResitPeriod.Enabled = chkWarnQuizExpiry.Checked;            
        }

        protected void chkPostExpiryReminder_check(Object sender ,EventArgs e)
        {
            if (!chkPostExpiryReminder.Checked)
            {
                txtNumberOfWarns.Text = "";
                txtNumberofDaysWarns.Text = "";
            }
            
            txtNumberOfWarns.Enabled = chkPostExpiryReminder.Checked;            
            txtNumberofDaysWarns.Enabled = chkPostExpiryReminder.Checked;
            //chkPostExpiryInit.Enabled = chkPostExpiryReminder.Checked  && chkWarnQuizExpiry.Checked;  // CJP 13 NOV 2013
            chkPostExpiryInit.Enabled = chkPostExpiryReminder.Checked && chkWarnUsers.Checked;  // CJP 13 NOV 2013
            chkPostExpiryResit.Enabled = chkPostExpiryReminder.Checked;
        }
    
    }
}
