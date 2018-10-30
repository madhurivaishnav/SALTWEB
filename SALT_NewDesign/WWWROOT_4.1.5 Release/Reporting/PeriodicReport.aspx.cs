using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Localization;

using System.Collections;

using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.Data;
using System.Configuration;
using Bdw.Application.Salt.BusinessServices;


using Microsoft.ApplicationBlocks.Data;
using System.Collections.ObjectModel;
using Bdw.Application.Salt.Web.Utilities;
using Uws.Framework.WebControl;
using Bdw.SqlServer.Reporting.ReportService20051;
using Bdw.SqlServer.Reporting.ReportExecution20051;
using System.Web.UI.WebControls;

namespace Bdw.Application.Salt.Web.Reporting
{

    public partial class PeriodicReport : System.Web.UI.Page
    {

        /// <summary>
        /// trvUnitsSelector control.
        /// </summary>
        /// <remarks>
        /// Auto-generated field.
        /// To modify move field declaration from designer file to code-behind file.
        /// </remarks>
        protected global::Uws.Framework.WebControl.TreeView trvUnitsSelector;
        protected System.Web.UI.WebControls.Repeater rptList; 
        private const string CTypeColumnID = "ClassificationTypeID";

        // Classification Item columns
        private const string CListColumnClassificationID = "ClassificationID";
        private const string CListColumnClassificationTypeID = "ClassificationTypeID";
        private const string CListColumnValue = "Value";
        private const string CListColumnActive = "Active";

        private Boolean blnGetDetails = false;

        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
            lnkReportAll.Text = ResourceManager.GetString("lnkReportAll");
            optReportType.Items[0].Text = ResourceManager.GetString("optReportType.1");
            optReportType.Items[1].Text = ResourceManager.GetString("optReportType.2");
            optReportType.Items[2].Text = ResourceManager.GetString("optReportType.3");
            optReportType.Items[3].Text = ResourceManager.GetString("optReportType.4");
            LocalizedLabel3.Text = ResourceManager.GetString("policy0");
            Label6.Text = ResourceManager.GetString("acceptance0");
            Radiobuttonlist3.Items[0].Text = ResourceManager.GetString("acceptance1");
            Radiobuttonlist3.Items[1].Text = ResourceManager.GetString("acceptance2");
            Radiobuttonlist3.Items[2].Text = ResourceManager.GetString("acceptance3");
            expireUnit.Items[0].Text = ResourceManager.GetString("expireUnit1");
            expireUnit.Items[1].Text = ResourceManager.GetString("expireUnit2");
            reportStatusList.Items[0].Text = ResourceManager.GetString("userReportStatus1");
            reportStatusList.Items[1].Text = ResourceManager.GetString("userReportStatus2");
            reportStatusList.Items[2].Text = ResourceManager.GetString("userReportStatus3");
            quizStatusList.Items[0].Text = ResourceManager.GetString("optStatus.1");
            quizStatusList.Items[1].Text = ResourceManager.GetString("optStatus.2");
            quizStatusList.Items[2].Text = ResourceManager.GetString("optStatus.3");
            quizStatusList.Items[3].Text = ResourceManager.GetString("optStatus.4");
            quizStatusList.Items[4].Text = ResourceManager.GetString("optStatus.5");
            quizStatusList.Items[5].Text = ResourceManager.GetString("optStatus.6");
            groupbyList.Items[0].Text = ResourceManager.GetString("radGroupBy.1");
            groupbyList.Items[1].Text = ResourceManager.GetString("radGroupBy.2");
            lstWithinUserSort.Items[0].Text = ResourceManager.GetString("lstWithinUserSort.1");
            lstWithinUserSort.Items[1].Text = ResourceManager.GetString("lstWithinUserSort.2");
            lstWithinUserSort.Items[2].Text = ResourceManager.GetString("lstWithinUserSort.3");
            butSavePeriodicReportSchedule.Text = ResourceManager.GetString("SaveSend");


            
        }
        private void ShowReport(string reportid)
        {

            // //2. Add criteria to the report viewer
            string ParamCourseIDs = "";
            bool Valid = true;
            Valid = !this.cboFCompletionDay.Visible;
            if (!Valid) Valid = ValidateTwoDateControlsForReport(reportid);
            if (Valid)
            {
                try
                {
                    if (CourseIDsVisible.Text == "true") //ParamCourseIDs
                    {
                        ParamCourseIDs = getListValues(courseList);
                    }
                    else if (CourseIDsVisible.Text == "false") //ParamCourseID
                    {
                        ParamCourseIDs = this.courseListDropdown.SelectedValue;
                    }

                }
                catch
                {
                    ParamCourseIDs = ""; // no ParamCourseIDs or ParamCourseID
                }
                PeriodicReportControl.plhPeriodicControls.Visible = false;
                this.pnlSearchCriteria.Visible = false;
                this.lblPageTitle.Visible = false;
                this.plhReportResults.Visible = true;

                int ParamOrganisationID;
                int ParamFailCount;
                int ParamTimeExpired;
                int ParamProfileID;
                int ParamProfilePeriodID;
                int ParamClassificationID;
                DateTime ParamEffectiveDate;
                char ParamCompleted;
                char ParamStatus;
                char ParamAllUnits;
                char ParamTimeExpiredPeriod;
                char ParamQuizStatus;
                string ParamGroupBy;
                char ParamIncludeInactive;
                char ParamOnlyUsersWithShortfall;
                char ParamSortBy;
                string ParamHistoricCourseIDs;
                string ParamFirstName;
                string ParamLastName;
                string ParamUserName;
                string ParamEmail;
                string ParamSubject;
                string ReportRDLname;
                string ReportName;
                string FirstName;
                string LastName;
                string Email;
                string ParamUnitIDs;
                string ParamLicensingID;
                string ParamLangCode;
                string ParamLangInterfaceName;
                string ReportTitle;
                string ParamPolicyIDs;
                string ParamAcceptance;

                DateTime ReportFromDate;
                DateTime FromDate;
                DateTime lToDate;
                //////////////////////////////////    S T R I N G  Params/////////////////////////////
                string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
                string sqlSelect = "select * from tblReportInterface where ReportID = @reportid";


                SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@reportid", reportid) };
                DataTable dtbReportTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
                DataRow Params = dtbReportTable.Rows[0];
                DataColumnCollection ColNames = dtbReportTable.Columns;

                ParamLangCode = Request.Cookies["currentCulture"].Value;

                try
                {
                    ParamLangInterfaceName = Params.ItemArray[ColNames.IndexOf("ParamLangInterfaceName")].ToString();
                }
                catch
                {
                    ParamLangInterfaceName = "Report.UnitComplianceReport";
                }

                try
                {
                    ParamLicensingID = this.licensingPeriodList.SelectedValue;
                }
                catch
                {
                    ParamLicensingID = "Error";
                }

                try
                {
                    string[] astrUnits = this.trvUnitsSelector.GetSelectedValues();
                    string strUnits = String.Join(",", astrUnits);
                    ParamUnitIDs = strUnits;
                }
                catch
                {
                    ParamUnitIDs = "Error";
                }

                try
                {
                    ParamAcceptance = Radiobuttonlist3.SelectedValue.ToString();
                }
                catch
                {
                    ParamAcceptance = "";
                }
                try
                {
                    // Get the selected Policies
                    ParamPolicyIDs = string.Empty; //"0";
                    for (int intIndex = 0; intIndex != this.lstPolicy.Items.Count; intIndex++)
                    {
                        if (this.lstPolicy.Items[intIndex].Selected)
                        {
                            if (ParamPolicyIDs.Length == 0)
                            {
                                ParamPolicyIDs += this.lstPolicy.Items[intIndex].Value;
                            }
                            else
                            {
                                ParamPolicyIDs += "," + this.lstPolicy.Items[intIndex].Value;
                            }
                        }
                    }
                }
                catch
                {
                    ParamPolicyIDs = "";
                }
                try
                {
                    FirstName = firstNameBox.Text;
                }
                catch
                {
                    FirstName = "";
                }
                try
                {
                    LastName = lastNameBox.Text;
                }
                catch
                {
                    LastName = "";
                }
                try
                {
                    Email = emailBox.Text;
                }
                catch
                {
                    Email = "";

                }
                try
                {
                    ReportName = pagTitle.InnerText;

                }
                catch
                {
                    ReportName = "";
                }
                try
                {
                    ReportRDLname = Params.ItemArray[ColNames.IndexOf("RDLname")].ToString();
                }
                catch
                {
                    ReportRDLname = "";

                }
                try
                {
                    ReportTitle = pagTitle.InnerText;
                    if (ReportTitle.Equals("")) ReportTitle = ReportName;
                }
                catch
                {
                    ReportTitle = "Error loading Report Schedule Title";
                }


                try
                {
                    ParamHistoricCourseIDs = getListValues(histCourse);
                }
                catch
                {
                    ParamHistoricCourseIDs = "";
                }
                try
                {
                    ParamFirstName = firstNameBox.Text;
                }
                catch
                {
                    ParamFirstName = "";
                }
                try
                {
                    ParamLastName = lastNameBox.Text;
                }
                catch
                {
                    ParamLastName = "";
                }
                try
                {
                    ParamUserName = userNameBox.Text;
                }
                catch
                {
                    ParamUserName = "";
                }
                try
                {
                    ParamSubject = this.subjectBox.Text;
                }
                catch
                {
                    ParamSubject = "";
                }
                try
                {
                    ParamEmail = this.emailBox.Text;
                }
                catch
                {
                    ParamEmail = "";
                }


                //////////////////////////////////    S I N G L E     C H A R A C T E R   PARAMS /////////////////////////////
                try
                {
                    ParamStatus = this.reportStatusList.SelectedValue[0];
                }
                catch
                {
                    ParamStatus = 'C';
                }
                try
                {
                    ParamCompleted = this.quizStatusList.SelectedValue[0];
                }
                catch
                {
                    ParamCompleted = 'N';
                }



                try
                {
                    ParamAllUnits = 'N';
                }
                catch
                {
                    ParamAllUnits = 'N';
                }
                try
                {
                    ParamTimeExpiredPeriod = this.expireUnit.SelectedValue[0];
                }
                catch
                {
                    ParamTimeExpiredPeriod = 'M';
                }
                try
                {
                    ParamQuizStatus = this.quizStatusList.SelectedValue[0];
                }
                catch
                {
                    ParamQuizStatus = 'C';
                }
                try
                {
                    if (((this.groupbyList.SelectedValue[0] == '1')) && ((reportid == "3") || (reportid == "6")))
                    {
                        ParamGroupBy = "UNIT_USER";
                    }
                    else if (((this.groupbyList.SelectedValue[0] == '0')) && ((reportid == "3") || (reportid == "6")))
                    {
                        ParamGroupBy = "Course";
                    }
                    else //if  (reportid != "3") 
                    {
                        ParamGroupBy = this.groupbyList.SelectedValue[0].ToString();
                    }


                }
                catch
                {
                    ParamGroupBy = "U";
                }
                try
                {
                    if (this.inactiveUserCheck.Checked)
                    {
                        ParamIncludeInactive = 'Y';
                    }
                    else
                    {
                        ParamIncludeInactive = 'N';
                    }

                }
                catch
                {
                    ParamIncludeInactive = 'N';
                }
                try
                {
                    if (this.shortFallCheck.Checked)
                    {
                        ParamOnlyUsersWithShortfall = 'Y';
                    }
                    else
                    {
                        ParamOnlyUsersWithShortfall = 'N';
                    }

                }
                catch
                {
                    ParamOnlyUsersWithShortfall = 'N';
                }
                try
                {
                    ParamSortBy = lstWithinUserSort.SelectedIndex.ToString()[0];
                }
                catch
                {
                    ParamSortBy = 'N';
                }
                try
                {
                    ParamCompleted = this.reportStatusList.SelectedValue.ToString()[0];
                }
                catch
                {
                    ParamCompleted = 'N';
                }
                ////////////////////////////////            D A T E T I M E             ///////////////////////////////////////////

                try
                {
                    lToDate = new DateTime(Convert.ToInt32(cboQCompletionYear.SelectedValue), Convert.ToInt32(cboQCompletionMonth.SelectedValue), Convert.ToInt32(cboQCompletionDay.SelectedValue));
                }
                catch
                {
                    lToDate = System.DateTime.Parse("1/1/1970");
                    if (reportid == "36") lToDate = System.DateTime.Today;
                }
                
                try
                {
                    FromDate = new DateTime(Convert.ToInt32(cboFCompletionYear.SelectedValue), Convert.ToInt32(cboFCompletionMonth.SelectedValue), Convert.ToInt32(cboFCompletionDay.SelectedValue));
                }
                catch
                {
                    FromDate = System.DateTime.Parse("1/1/1970");
                }
                try
                {
                    ReportFromDate = new DateTime(Convert.ToInt32(cboFCompletionYear.SelectedValue), Convert.ToInt32(cboFCompletionMonth.SelectedValue), Convert.ToInt32(cboFCompletionDay.SelectedValue));
                }
                catch
                {
                    ReportFromDate = System.DateTime.Parse("1/1/1970");
                    if ((reportid == "18") || (reportid == "17") || (reportid == "3") || (reportid == "6"))
                    {
                        BusinessServices.Report r = new Report();
                        ReportFromDate = System.DateTime.Parse(r.getToday(UserContext.UserData.OrgID));
                    }
                }




                try
                {
                    ParamEffectiveDate = new DateTime(Convert.ToInt32(cboFCompletionYear.SelectedValue), Convert.ToInt32(cboFCompletionMonth.SelectedValue), Convert.ToInt32(cboFCompletionDay.SelectedValue));
                }
                catch
                {
                    ParamEffectiveDate = System.DateTime.Parse("1/1/1970");
                }
                //////////////////////////////       B O O L E A N         //////////////////////////////////////////


                //////////////////////////////       I N T E G E R         //////////////////////////////////////////






                try
                {
                    ParamOrganisationID = UserContext.UserData.OrgID;
                }
                catch
                {
                    ParamOrganisationID = 0;
                }

                try
                {
                    if (string.IsNullOrEmpty(failCounterBox.Text)) { ParamFailCount = 0; }
                    else { ParamFailCount = int.Parse(this.failCounterBox.Text); }
                }
                catch
                {
                    ParamFailCount = 0;
                }
                try
                {
                    ParamTimeExpired = int.Parse(this.expireBox.Text);
                }
                catch
                {
                    ParamTimeExpired = 0;
                }
                try
                {
                    ParamProfileID = Int32.Parse(profileList.SelectedValue);
                }
                catch
                {
                    ParamProfileID = 0;
                }
                try
                {
                    ParamProfilePeriodID = Int32.Parse(licensingPeriodList.SelectedValue) ;//profileList.SelectedIndex+1; 
                }
                catch
                {
                    ParamProfilePeriodID = 0;
                }
                try
                {
                    ParamClassificationID = int.Parse(this.cboCustomClassification.SelectedValue);
                }
                catch
                {
                    ParamClassificationID = 0;
                }




                bool lRequiresCompleted = false;
                bool lRequiresStatus = false;
                bool lRequiresFailCount = false;
                bool lRequiresCourseIDs = false;
                bool lRequiresCourseID = false;
                bool lRequiresUserID = false;
                bool lRequiresHistoricCourseIDs = false;
                bool lRequiresUnitIDs = false;
                bool lRequiresAdminUserID = false;
                bool lRequiresAllUnits = false;
                bool lRequiresTimeExpired = false;
                bool lRequiresTimeExpiredPeriod = false;
                bool lRequiresQuizStatus = false;
                bool lRequiresGroupBy = false;
                bool lRequiresGroupingOption = false;
                bool lRequiresFirstName = false;
                bool lRequiresLastName = false;
                bool lRequiresUserName = false;
                bool lRequiresEmail = false;
                bool lRequiresIncludeInactive = false;
                bool lRequiresSubject = false;
                bool lRequiresBody = false;
                bool lRequiresToDate = false;
                bool lRequiresFromDate = false;
                bool lRequiresDateTo = false;
                bool lRequiresDateFrom = false;
                bool lRequiresProfileID = false;
                bool lRequiresProfilePeriodID = false;
                bool lRequiresOnlyUsersWithShortfall = false;
                bool lRequiresEffectiveDate = false;
                bool lRequiresSortBy = false;
                bool lRequiresClassificationID = false;
                bool lRequiresOrganisationID = false;
                bool lRequiresServerURL = false;
                bool lRequiresPolicyIDs = false;



                lRequiresOrganisationID = Params.Field<bool>("RequiresParamOrganisationID");
                lRequiresAllUnits = Params.Field<bool>("RequiresParamallUnits");
                lRequiresBody = Params.Field<bool>("RequiresParamBody");
                lRequiresClassificationID = Params.Field<bool>("RequiresParamClassificationID");
                lRequiresCompleted = Params.Field<bool>("RequiresParamCompleted");
                lRequiresCourseIDs = Params.Field<bool>("RequiresParamCourseIDs");
                lRequiresCourseID = Params.Field<bool>("RequiresParamCourseID");
                lRequiresDateFrom = Params.Field<bool>("RequiresParamDateFrom");
                lRequiresDateTo = Params.Field<bool>("RequiresParamDateTo");
                lRequiresFromDate = Params.Field<bool>("RequiresParamFromDate");
                lRequiresToDate = Params.Field<bool>("RequiresParamToDate");
                lRequiresEffectiveDate = Params.Field<bool>("RequiresParamEffectiveDate");
                if ((reportid == "3")||(reportid == "6")) { lRequiresEffectiveDate = true; };
                lRequiresEmail = Params.Field<bool>("RequiresParamEmail");
                lRequiresFailCount = Params.Field<bool>("RequiresParamFailCount");
                lRequiresFirstName = Params.Field<bool>("RequiresParamFirstName");
                lRequiresGroupBy = Params.Field<bool>("RequiresParamGroupBy");
                lRequiresGroupingOption = Params.Field<bool>("RequiresParamGroupingOption");
                lRequiresHistoricCourseIDs = Params.Field<bool>("RequiresParamHistoricCourseIDs");
                lRequiresUserID = Params.Field<bool>("RequiresParamUserID");
                lRequiresAdminUserID = Params.Field<bool>("RequiresParamAdminUserID");
                lRequiresIncludeInactive = Params.Field<bool>("RequiresParamIncludeInactive");

                lRequiresLastName = Params.Field<bool>("RequiresParamLastName");
                lRequiresOnlyUsersWithShortfall = Params.Field<bool>("RequiresParamOnlyUsersWithShortfall");
                lRequiresProfileID = Params.Field<bool>("RequiresParamProfileID");
                lRequiresProfilePeriodID = Params.Field<bool>("RequiresParamProfilePeriodID");
                lRequiresQuizStatus = Params.Field<bool>("RequiresParamQuizStatus");
                lRequiresSortBy = Params.Field<bool>("RequiresParamSortBy");
                lRequiresStatus = Params.Field<bool>("RequiresParamQuizStatus");
                lRequiresSubject = Params.Field<bool>("RequiresParamSubject");
                lRequiresTimeExpired = Params.Field<bool>("RequiresParamTimeExpired");
                lRequiresTimeExpiredPeriod = Params.Field<bool>("RequiresParamTimeExpiredPeriod");
                lRequiresUnitIDs = Params.Field<bool>("RequiresParamUnitIDs");
                lRequiresUserName = Params.Field<bool>("RequiresParamUserName");
                lRequiresServerURL = Params.Field<bool>("RequiresParamServerURL");
                lRequiresPolicyIDs = Params.Field<bool>("RequiresParamPolicyIDs");

                Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] reportParameters = null;
                reportParameters = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[39];

                if (ParamLangInterfaceName.ToString().ToUpper().IndexOf("LICENSING") != -1)
                {
                    reportParameters[0] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[0].Name = "CourseLicensingID";
                    string courseLicensingID = "";
                    RepeaterItemCollection myItemCollection = rptList.Items;
                    bool ReportAll = lnkReportAll.Checked;

                    for (int index = 0; index < myItemCollection.Count; index++)
                    {
                        CheckBox CB = (CheckBox) myItemCollection[index].FindControl("lnkReportPeriod") ;
                        DropDownList DDL = (DropDownList) myItemCollection[index].FindControl("ddlPeriod");
                        if (CB.Checked ) 
                        {
                            if (!courseLicensingID.Equals("")) { courseLicensingID = courseLicensingID + ","; }
                            courseLicensingID = courseLicensingID + DDL.SelectedValue;
                        }
                    }
                    if (ReportAll) { courseLicensingID = "0"; }
                    reportParameters[0].Value =  courseLicensingID;
                }
                else if (lRequiresServerURL)
                {
                    reportParameters[0] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[0].Name = "serverURL";

                    reportParameters[0].Value = Request.Url.Host; //TODO check if this is OK
                }
                if (lRequiresUnitIDs)
                {
                    reportParameters[1] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[1].Name = "unitIDs";
                    string[] selectUnits = ParamUnitIDs.ToString().Split(',');

                    selectUnits = ReturnAdministrableUnitsByUserID(UserContext.UserID, ParamOrganisationID, selectUnits);
                    if (selectUnits.Count() > 0) reportParameters[1].Value = String.Join(",", selectUnits);
                    else reportParameters[1].Value = (" ");



                }

                if (lRequiresUserID)
                {
                    reportParameters[2] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[2].Name = "UserID";
                    reportParameters[2].Value = UserContext.UserID.ToString();
                }
                if (lRequiresAdminUserID)
                {
                    reportParameters[3] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[3].Name = "adminUserID";
                    reportParameters[3].Value = UserContext.UserID.ToString();
                }
                if ((ReportName.ToString().Equals("SummaryReport Stacked Bar")) || (ReportName.ToString().Equals("Summary Report Pie")))
                // Report Titles are usually localised so don't overwrite the localisation
                {
                    reportParameters[4] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[4].Name = "rptReportTitle";
                    reportParameters[4].Value = ReportName.ToString();
                }
                if (lRequiresDateTo)
                {
                    reportParameters[5] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[5].Name = "dateTo";
                    reportParameters[5].Value = lToDate.ToString("dd/MMM/yyyy");
                }

                if (lRequiresToDate)
                {
                    reportParameters[6] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[6].Name = "ToDate";
                    reportParameters[6].Value = lToDate.ToString("dd/MMM/yyyy");


                }


                if (lRequiresDateFrom)
                {
                    reportParameters[7] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[7].Name = "dateFrom";
                    reportParameters[7].Value = FromDate.AddDays(-1).ToString("dd/MMM/yyyy");
                }

                if (lRequiresFromDate)
                {
                    reportParameters[8] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[8].Name = "FromDate";
                    reportParameters[8].Value = FromDate.AddDays(-1).ToString("dd/MMM/yyyy");


                }



                if (lRequiresOrganisationID)
                {
                    reportParameters[9] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[9].Name = "organisationID";
                    reportParameters[9].Value = ParamOrganisationID.ToString();

                }




                if (lRequiresTimeExpired)
                {
                    reportParameters[10] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[10].Name = "warningPeriod";
                    reportParameters[10].Value = ParamTimeExpired.ToString();
                }
                if (lRequiresProfileID)
                {
                    reportParameters[11] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[11].Name = "profileid";
                    reportParameters[11].Value = ParamProfileID.ToString();
                }

                if (lRequiresClassificationID)
                {
                    reportParameters[12] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[12].Name = "classificationID";
                    reportParameters[12].Value = ParamClassificationID.ToString();
                }

                if (lRequiresEffectiveDate)
                {
                    reportParameters[13] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[13].Name = "effectiveDate";
                    reportParameters[13].Value = ReportFromDate.ToString("dd/MMM/yyyy");
                }

                if (lRequiresCompleted)
                {
                    reportParameters[14] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[14].Name = "completed";
                    if (ParamCompleted == '0') reportParameters[14].Value = "true"; else reportParameters[14].Value = "false";
                }



                if (lRequiresAllUnits)
                {
                    reportParameters[17] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[17].Name = "allUnits";
                    if (ParamAllUnits == 'Y') reportParameters[17].Value = "True"; else reportParameters[17].Value = "False";
                }


                if (lRequiresStatus)
                {
                    reportParameters[18] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[18].Name = "courseModuleStatus";
                    reportParameters[18].Value = ParamQuizStatus.ToString();
                }

                if (lRequiresGroupBy)
                {
                    reportParameters[19] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[19].Name = "groupBy";
                    reportParameters[19].Value = ParamGroupBy.ToString();
                }

                reportParameters[20] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                reportParameters[20].Name = "langCode";
                reportParameters[20].Value = ParamLangCode.ToString();

                if (lRequiresIncludeInactive)
                {
                    reportParameters[21] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[21].Name = "IncludeInactive";
                    if (reportid == "36")
                    {
                        if (ParamIncludeInactive == 'Y') reportParameters[21].Value = "true";
                        if (ParamIncludeInactive == 'N') reportParameters[21].Value = "false";
                    }
                    else
                    {
                         if (ParamIncludeInactive == 'Y') reportParameters[21].Value = "1"; else reportParameters[21].Value = "0";
                    }
                }

                if (lRequiresOnlyUsersWithShortfall)
                {
                    reportParameters[22] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[22].Name = "shortfallusers";
                    if (ParamOnlyUsersWithShortfall == 'Y') reportParameters[22].Value = "1"; else reportParameters[22].Value = "0";
                }
                if (lRequiresSortBy)
                {
                    reportParameters[23] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[23].Name = "sortBy";
                    if (ParamSortBy.ToString() == "0") reportParameters[23].Value = "LAST_NAME";
                    if (ParamSortBy.ToString() == "1") reportParameters[23].Value = "QUIZ_SCORE";
                    if (ParamSortBy.ToString() == "2") reportParameters[23].Value = "QUIZ_DATE";

                }
                if (lRequiresCourseIDs)
                {
                    if ((ParamCourseIDs.ToString().Equals("")) & (ParamHistoricCourseIDs.ToString().Equals("")))
                    {
                        string[] selectCourses = ReturnCoursesByOrgID(ParamOrganisationID);
                        ParamCourseIDs = String.Join(",", selectCourses);

                    }


                    reportParameters[24] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[24].Name = "courseIDs";
                    reportParameters[24].Value = ParamCourseIDs.ToString();
                }
                if (lRequiresFirstName)
                {
                    reportParameters[25] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[25].Name = "UserFirstName";
                    reportParameters[25].Value = ParamFirstName.ToString();
                }

                if (lRequiresLastName)
                {
                    reportParameters[26] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[26].Name = "UserLastName";
                    reportParameters[26].Value = ParamLastName.ToString();
                }
                if (lRequiresUserName)
                {
                    reportParameters[27] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[27].Name = "userName";
                    reportParameters[27].Value = ParamUserName.ToString();
                }

                if (lRequiresEmail)
                {
                    reportParameters[28] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[28].Name = "userEmail";
                    reportParameters[28].Value = ParamEmail.ToString();
                }

                if (lRequiresFailCount)
                {
                    reportParameters[29] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[29].Name = "failCounter";
                    reportParameters[29].Value = ParamFailCount.ToString();
                }

                if (lRequiresSubject)
                {
                    reportParameters[30] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[30].Name = "subject";
                    reportParameters[30].Value = ParamSubject.ToString();
                }

                reportParameters[32] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                reportParameters[32].Name = "langInterfaceName";
                if ((reportid == "22") || (reportid == "23") || (reportid == "24") || (reportid == "10"))
                {
                    reportParameters[32].Value = "Report.Summary";
                }
                else
                {
                    reportParameters[32].Value = ParamLangInterfaceName.ToString();
                }

                if (lRequiresTimeExpiredPeriod)
                {
                    reportParameters[33] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[33].Name = "warningUnit";
                    reportParameters[33].Value = ParamTimeExpiredPeriod.ToString() + ParamTimeExpiredPeriod.ToString();
                    //Emerging.ErrorLogger.ErrorLog objErrorLog1 = new Emerging.ErrorLogger.ErrorLog(new DatabaseException("Debug trace,  warningUnit:" + reportParameters[33].Value.ToString()), Emerging.ErrorLogger.ErrorLog.ErrorLevel.InformationOnly, "SALTautomatedREPORTS", "Queue Emails", "Debug trace", "param populate", Globals);


                }

                if (lRequiresProfilePeriodID)
                {
                    reportParameters[34] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[34].Name = "profileperiodid";
                    reportParameters[34].Value = ParamProfilePeriodID.ToString();
                    reportParameters[35] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[35].Name = "rptReportTitle";
                    reportParameters[35].Value = getCPDReportTitle(ParamOrganisationID);

                }

                if (lRequiresPolicyIDs)
                {
                    
                    reportParameters[36] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[36].Name = "policyIDs";
                    reportParameters[36].Value = ParamPolicyIDs;
                    reportParameters[37] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[37].Name = "acceptanceStatus";
                    if (reportid == "36")
                    {
                        if (ParamAcceptance == "0")reportParameters[37].Value ="ACCEPTED";
                        if (ParamAcceptance == "1")reportParameters[37].Value ="NOT_ACCEPTED";
                        if (ParamAcceptance == "2")reportParameters[37].Value ="BOTH";
                    }
                    else
                    {
                        reportParameters[37].Value = ParamAcceptance;
                    }
                }
                if (lRequiresCourseID)
                {
                    if ((ParamCourseIDs.ToString().Equals("")) & (ParamHistoricCourseIDs.ToString().Equals("")))
                    {
                        string[] selectCourses = ReturnCoursesByOrgID(ParamOrganisationID);
                        ParamCourseIDs = String.Join(",", selectCourses);

                    }

                    reportParameters[38] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
                    reportParameters[38].Name = "courseID";
                    reportParameters[38].Value = ParamCourseIDs.ToString();
                }

                rvReport.Parameters =  reportParameters;
                rvReport.ReportPath = "/" + Params.ItemArray[ColNames.IndexOf("RDLname")].ToString();

            }
        }






        

        public string getCPDReportTitle(int OrganisationID)
        {
            try
            {
                using (StoredProcedure sp = new StoredProcedure("prcReport_GetCPDReportName",
                StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, OrganisationID)
                      ))
                {

                    return sp.ExecuteScalar().ToString();
                }
            }
            catch
            {
                return "Continuing Professional Development";
            }
        }


        public string[] ReturnCoursesByOrgID(int organisationID)
        {
            string[] strarrayReturnValue;

            DataTable dtblCourses;
            Course c = new Course();
            dtblCourses = c.GetCourseListAccessableToOrg(organisationID);

            strarrayReturnValue = new string[dtblCourses.Rows.Count];
            int iCount = 0;
            foreach (DataRow drw in dtblCourses.Rows)
            {
                strarrayReturnValue[iCount] = drw[0].ToString();
                ++iCount;
            }
            return strarrayReturnValue;
        }

        protected void rvReport_PageIndexChanged(object sender, System.EventArgs e)
        {
            string reportid = listReports.SelectedValue;
            string[] SummaryReports = new string[] { "22", "24", "10", "23" };
            if ((this.groupbyList.SelectedValue == "0") && (this.listReports.SelectedValue == "3")) //two versions of CurrentAdminReport merged at client request
            {
                reportid = "6";
            }
            else if ((this.groupbyList.SelectedValue == "1") && (this.listReports.SelectedValue == "3"))
            {
                reportid = "3";
            }
            else if ((this.groupbyList.SelectedValue == "0") && (this.listReports.SelectedValue == "27")) //two versions of HistoricAdminReport merged at client request
            {
                reportid = "26";
            }
            else if ((this.groupbyList.SelectedValue == "1") && (this.listReports.SelectedValue == "26"))
            {
                reportid = "27";
            }
            else if (((this.reportStatusList.SelectedValue == "0") || (this.reportStatusList.SelectedValue == "1")) && (this.listReports.SelectedValue == "18"))  //two versions of CurrentAdminReport merged at client request
            {
                reportid = "17";
            }
            else if ((this.reportStatusList.SelectedValue == "2") && (this.listReports.SelectedValue == "17"))
            {
                reportid = "18";
            }
            else if ((this.groupbyList.SelectedValue == "1") && (this.listReports.SelectedValue == "18")) //two versions of CurrentAdminReport merged at client request
            {
                reportid = "17";
            }
            else if ((this.optReportType.SelectedIndex == 0) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "22";
            }
            else if ((this.optReportType.SelectedIndex == 1) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "24";
            }
            else if ((this.optReportType.SelectedIndex == 2) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "10";
            }
            else if ((this.optReportType.SelectedIndex == 3) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "23";
            }


            this.ShowReport(reportid);
        }

        private void InitializeComponent()
        {
            rptList.ItemDataBound += new RepeaterItemEventHandler(rptList_ItemDataBound);
            rptList.ItemCommand += new RepeaterCommandEventHandler(rptList_ItemCommand);
            apptitle.Text = ApplicationSettings.AppName;
        }

        private DataTable GetAdministrableUnitsByUserID(int userID, int organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcUnit_GetAdministrableUnitsByUserID", 
            StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
            StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
            ))
            {
                return sp.ExecuteTable();
            }
        }

        public string[] ReturnAdministrableUnitsByUserID(int userID, int organisationID, string[] units)
        {
            string[] strarrayTemp;
            string[] strarrayReturnValue;
            int intNumUnitsHasAccessTo = 0;
            DataTable dtblUnits;
            dtblUnits = this.GetAdministrableUnitsByUserID(userID, organisationID);

            System.Collections.Hashtable htUnits = new System.Collections.Hashtable();

            // if no units were passed in then return all the units that the administrator can access
            if ((units.Length == 0) || (units.GetValue(0).Equals("")))
            {
                strarrayReturnValue = new string[dtblUnits.Rows.Count];
                int iCount = 0;
                foreach (DataRow drw in dtblUnits.Rows)
                {
                    try
                    {
                        strarrayReturnValue[iCount] = drw[0].ToString();
                    }
                    catch
                    {
                        strarrayReturnValue[iCount] = "";
                    }
                    ++iCount;
                }
            }
            else
            {
                // Fill the hashTable
                foreach (DataRow drw in dtblUnits.Rows)
                {
                    htUnits.Add(drw[0], drw[0]);
                }
                // instantiate a temp string array
                strarrayTemp = new string[htUnits.Count];

                // copy the units that the user does have access to that they want access to
                foreach (string strUnit in units)
                {
                    if (htUnits.ContainsValue(Int32.Parse(strUnit.Trim())))
                    {
                        strarrayTemp[intNumUnitsHasAccessTo] = strUnit.Trim();
                        ++intNumUnitsHasAccessTo;
                    }
                }

                // ReDim 
                strarrayReturnValue = new string[intNumUnitsHasAccessTo];
                for (int i = 0; i < intNumUnitsHasAccessTo; i++)
                {
                    strarrayReturnValue[i] = strarrayTemp[i];
                }
            }


            return strarrayReturnValue;
        }




        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.plhReportResults.Visible = false;
                PeriodicReportControl.plhPeriodicControls.Visible = true;
                this.pnlSearchCriteria.Visible = true;
                this.lblPageTitle.Visible = true;
                // Put user code to initialize the page here
               
                //init report dropdown list
                initReportList();
                //init Document dropdown list
                //initDocumentType();

                //set list select mode
                courseList.SelectionMode = ListSelectionMode.Multiple;
                histCourse.SelectionMode = ListSelectionMode.Multiple;

                //init date components
                Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboQCompletionDay, cboQCompletionMonth, cboQCompletionYear, System.DateTime.Today.Year-5, 10);
                Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboFCompletionDay, cboFCompletionMonth, cboFCompletionYear, System.DateTime.Today.Year-5, 10);


                //display all existing schedules
                this.GetScheduleList();

                //get values from clicking link
                String scheduleId = Request.QueryString["scheduleId"];
                
                String reportId = Request.QueryString["ReportID"];

                int rptId = 0;
                Int32.TryParse(reportId, out rptId);

                switch (rptId)
                {
                    case 2:
                    case 14:
                    case 30:
                    case 17:
                    case 18:
                    case 19:
                    case 3:
                    case 6:
                    case 20:
                    case 36:
                    case 21:
                    case 10:
                    case 22:
                    case 23:
                    case 24:
                    case 25:
                    case 29:
                        PeriodicReportControl.Visible = true;
                        break;
                    default:
                        PeriodicReportControl.Visible = false;
                        break;
                }

                if (reportId == "6") reportId = "3";  //two versions of CurrentAdminReport merged at client request
                if (reportId == "26") reportId = "27";  //two versions of HistoricAdminReport merged at client request
                if (reportId == "18") reportId = "17";  //two versions of CompletedUsersReport merged at client request
                if (reportId == "22")
                {
                    //four versions of SummaryReport merged at client request
                    optReportType.SelectedIndex = 0;
                } if (reportId == "24")
                {
                    reportId = "22";  //four versions of SummaryReport merged at client request
                    optReportType.SelectedIndex = 1;
                }
                if (reportId == "10")
                {
                    reportId = "22";  //four versions of SummaryReport merged at client request
                    optReportType.SelectedIndex = 2;
                }
                if (reportId == "23")
                {
                    reportId = "22";  //four versions of SummaryReport merged at client request
                    optReportType.SelectedIndex = 3;
                }
                
                String orgId = UserContext.UserData.OrgID.ToString();

                // load the treeview other wise get script error
                initUnitList(orgId);
                units.Visible = true;


                //listReports_SelectedIndexChanged(null, null);
                if (scheduleId != null)
                {
                    listReports.Enabled = false;
                    reportId = GetScheduleDetails(scheduleId);
                    //TODO - we now have two copies of these horrible things -- need to get rid of at least one copy
                    if (reportId == "6") reportId = "3";  //two versions of CurrentAdminReport merged at client request
                    if (reportId == "26") reportId = "27";  //two versions of HistoricAdminReport merged at client request
                    if (reportId == "18") reportId = "17";  //two versions of CompletedUsersReport merged at client request
                    if (reportId == "22")
                    {
                        //four versions of SummaryReport merged at client request
                        optReportType.SelectedIndex = 0;
                    } if (reportId == "24")
                    {
                        reportId = "22";  //four versions of SummaryReport merged at client request
                        optReportType.SelectedIndex = 1;
                    }
                    if (reportId == "10")
                    {
                        reportId = "22";  //four versions of SummaryReport merged at client request
                        optReportType.SelectedIndex = 2;
                    }
                    if (reportId == "23")
                    {
                        reportId = "22";  //four versions of SummaryReport merged at client request
                        optReportType.SelectedIndex = 3;
                    }
                    listReports.SelectedValue = reportId;
                    this.scheduleHolder.Text = scheduleId;                    
                }
                else if (reportId != null && scheduleId == null)
                {
                    listReports.Enabled = false;
                    listReports.SelectedValue = reportId;
                    reportChanged(reportId, orgId);
                }

                else
                {
                    this.scheduleHolder.Text = "";                    
                }
                this.pagTitle.InnerText = listReports.SelectedItem.Text;
                lblPageTitle.Text = pagTitle.InnerText;                
            }

            if (Page.IsPostBack)
            {
                String reportId = Request.QueryString["reportId"];
                int rptId = 0;
                Int32.TryParse(reportId, out rptId);




                switch (rptId)
                {
                    case 20:
                        RepeaterItemCollection myItemCollection = rptList.Items;

                        bool OKtoRun = lnkReportAll.Checked;
                        for (int index = 0; index < myItemCollection.Count; index++)
                        {
                            CheckBox CB = (CheckBox)myItemCollection[index].FindControl("lnkReportPeriod");
                            OKtoRun = OKtoRun || CB.Checked;
                        }
                        butSavePeriodicReportSchedule.Enabled = OKtoRun;
                        btnRunReport.Enabled = OKtoRun;
                        break;
                    case 2: 
                    case 14: 
                    case 30: 
                    case 17: 
                    case 18: 
                    case 19: 
                    case 3: 
                    case 6: 

                    case 36: 
                    case 21: 
                    case 10: 
                    case 22: 
                    case 23: 
                    case 24: 
                    case 25: 
                    case 29: 
                        PeriodicReportControl.Visible = true;
                        break;
                    default:
                        PeriodicReportControl.Visible = false;
                        break;
                }
            }
        }

        // dont remove this other wise the tree view will give a acript error!!!!
        protected override void OnPreRender(EventArgs e)
        {
            if (!Page.IsPostBack && !blnGetDetails)
            {
                units.Visible = true;                
            }
            base.OnPreRender(e);
        }

        // see comment for OnPreRender!
        protected override void OnPreRenderComplete(EventArgs e)
        {
            base.OnPreRenderComplete(e);
            if (!Page.IsPostBack && !blnGetDetails)
            {
                reportChanged(listReports.SelectedValue, Convert.ToString(UserContext.UserData.OrgID));
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            //-- Hack. Could not work out how to use the render event in the tree view, therefore this code is run on every page that has a tree view. Hope to refactor after discovering the solution.
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter newWriter = new HtmlTextWriter(sw);

            base.Render(newWriter);

            sb.Replace("Clear All", ResourceManager.GetString("treeClearAll"));
            sb.Replace("Collapse All", ResourceManager.GetString("treeCollapseAll"));
            sb.Replace("Expand All", ResourceManager.GetString("treeExpandAll"));
            sb.Replace("class=\"TreeView_Node\">Help</a>", "class=\"TreeView_Node\">" + ResourceManager.GetString("treeHelp") + "</a>");
            sb.Replace("Select All", ResourceManager.GetString("treeSelectAll"));

            Response.Write(sb.ToString());
            // -End Hack

        }

        private string GetScheduleDetails(String scheduleId)
        {
            string ReturnValue = "0";
            blnGetDetails = true;
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@scheduleid", scheduleId) };
            string sqlSelect = "select * from tblReportSchedule where ScheduleID=@scheduleid";
            DataTable dtbScheduleTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
            firstNameBoxValidator.Enabled = false;
            lastNameBoxFieldValidator.Enabled = false;
            emailBoxValidator.Enabled = false;
            userNameBoxValidator.Enabled = false;
            if (dtbScheduleTable.Rows.Count > 0)
            {
                ReturnValue = dtbScheduleTable.Rows[0]["ReportID"].ToString();
                String paramOrganisationID = dtbScheduleTable.Rows[0]["ParamOrganisationID"].ToString();
                listReports.SelectedValue = ReturnValue;

                reportChanged(ReturnValue, paramOrganisationID);
                string isPeriodic = dtbScheduleTable.Rows[0]["isPeriodic"].ToString();
                PeriodicReportControl.ForWhatPeriod.Visible = ((PeriodicReportControl.NumDateControls.Text == "2") & (isPeriodic=="M"));

                string ReportPeriodType = dtbScheduleTable.Rows[0]["ReportPeriodType"].ToString();
                 
                PeriodicReportControl.rbtnAllDays.Checked = (ReportPeriodType == "1");
                PeriodicReportControl.rbtnPreced.Checked = (ReportPeriodType == "2");
                PeriodicReportControl.rbtnPeriodStartOn.Checked = (ReportPeriodType == "3");
                if (PeriodicReportControl.rbtnPeriodStartOn.Checked)
                {
                    PeriodicReportControl.rbtnPeriodStartOn.CausesValidation = true;
                    PeriodicReportControl.cboFCompletionDay4.Enabled = true;
                    PeriodicReportControl.cboFCompletionMonth4.Enabled = true;
                    PeriodicReportControl.cboFCompletionYear4.Enabled = true;
                    PeriodicReportControl.cboFCompletionDay4.CausesValidation = true;
                    PeriodicReportControl.cboFCompletionMonth4.CausesValidation = true;
                    PeriodicReportControl.cboFCompletionYear4.CausesValidation = true;
                    PeriodicReportControl.cboFCompletionDayValidator4.EnableClientScript = true;
                    PeriodicReportControl.cboFCompletionMonthValidator4.EnableClientScript = true;
                    PeriodicReportControl.cboFCompletionYearValidator4.EnableClientScript = true;
                }


                DateTime reportStartDate = (DateTime)dtbScheduleTable.Rows[0]["ReportStartDate"];
                if (reportStartDate != null)
                {
                }
                String reportFrequency = dtbScheduleTable.Rows[0]["ReportFrequency"].ToString();
                String reportFrequencyPeriod = dtbScheduleTable.Rows[0]["ReportFrequencyPeriod"].ToString();
                if (reportFrequency != null && reportFrequencyPeriod != null)
                {
                    PeriodicReportControl.EveryUnit.SelectedIndex = "DWMY".IndexOf(reportFrequencyPeriod);
                    PeriodicReportControl.EveryHowMany.Text = reportFrequency.ToString();
                }

                String NumberOfReports = dtbScheduleTable.Rows[0]["NumberOfReports"].ToString();
                if ((NumberOfReports != null) & (NumberOfReports != ""))
                {
                    PeriodicReportControl.EndAfter.Checked = true;
                    PeriodicReportControl.EndAfterTextbox.Text = NumberOfReports.ToString();
                    PeriodicReportControl.EndAfterTextbox.Enabled = true;
                    PeriodicReportControl.EndAfterTextbox.CausesValidation = true;
                    PeriodicReportControl.EndAfterTextboxRequiredValidator.EnableClientScript = true;
                    PeriodicReportControl.EndAfterTextboxValidator.EnableClientScript = true;
                }

                String RepEndDate = dtbScheduleTable.Rows[0]["ReportEndDate"].ToString();
                if ((RepEndDate != null)&(RepEndDate != ""))
                {
                    DateTime ReportEndDate = (DateTime)dtbScheduleTable.Rows[0]["ReportEndDate"];
                    PeriodicReportControl.EndOn.Checked = true;
                    PeriodicReportControl.cboFCompletionDay3.SelectedValue = ReportEndDate.Day.ToString();
                    PeriodicReportControl.cboFCompletionMonth3.SelectedValue = ReportEndDate.Month.ToString();
                    PeriodicReportControl.cboFCompletionYear3.SelectedValue = ReportEndDate.Year.ToString();
                    PeriodicReportControl.cboFCompletionDay3.Enabled = true;
                    PeriodicReportControl.cboFCompletionMonth3.Enabled = true;
                    PeriodicReportControl.cboFCompletionYear3.Enabled = true;
                    PeriodicReportControl.cboFCompletionDay3.CausesValidation = true;
                    PeriodicReportControl.cboFCompletionMonth3.CausesValidation = true;
                    PeriodicReportControl.cboFCompletionYear3.CausesValidation = true;
                    PeriodicReportControl.cboFCompletionDayValidator3.EnableClientScript = true;
                    PeriodicReportControl.cboFCompletionMonthValidator3.EnableClientScript = true;
                    PeriodicReportControl.cboFCompletionYearValidator3.EnableClientScript = true;
                }

                String reportTitle = dtbScheduleTable.Rows[0]["reportTitle"].ToString();
                if (reportTitle != null)
                {
                    PeriodicReportControl.ReportTitleTextBox.Text = reportTitle;
                }
                else
                {
                    PeriodicReportControl.ReportTitleTextBox.Text = "Null";
                }
                String documentType = dtbScheduleTable.Rows[0]["DocumentType"].ToString();
                if (documentType != null)
                {
                    PeriodicReportControl.DocType.SelectedValue = documentType;
                }

                //ignore
                //ignore
                String paramCompleted = dtbScheduleTable.Rows[0]["ParamCompleted"].ToString();
                if (paramCompleted != null)
                {
                    //ignore
                }

                String paramStatus = dtbScheduleTable.Rows[0]["ParamStatus"].ToString();
                if (paramStatus != null)
                {
                    this.reportStatusList.SelectedValue = paramStatus;
                }

                String paramFailCount = dtbScheduleTable.Rows[0]["ParamFailCount"].ToString();
                if (paramFailCount != null)
                {
                    this.failCounterBox.Text = paramFailCount;
                }


                String paramCourseIDs = dtbScheduleTable.Rows[0]["ParamCourseIDs"].ToString();
                if (paramCourseIDs != null)
                {
                    if (courseList.Visible)
                    {
                        this.setListValues(courseList, paramCourseIDs);
                    }
                    else if (courseListDropdown.Visible)
                    {
                        this.courseListDropdown.SelectedValue = paramCourseIDs;
                    }
                }

                String paramLicensingPeriod = dtbScheduleTable.Rows[0]["ParamLicensingPeriod"].ToString();
                if (paramLicensingPeriod != null && this.licensingPeriodList.Visible)
                {


                    if (!String.IsNullOrEmpty(this.courseListDropdown.SelectedValue))
                    {
                        setLicencingPreiod(Convert.ToInt32(this.courseListDropdown.SelectedValue));
                    }

                    this.licensingPeriodList.SelectedValue = paramLicensingPeriod;



                }

                if (paramLicensingPeriod != null && this.rptList.Visible)
                {
                    string ReportID = dtbScheduleTable.Rows[0]["ReportID"].ToString();

                    {

                        RepeaterItemCollection myItemCollection = rptList.Items;
                        string strDelimStr = ",";
                        char[] chrDelimiter = strDelimStr.ToCharArray();
                        if (paramLicensingPeriod.Equals("0")) lnkReportAll.Checked = true;
                        string[] LicensingPeriods = paramLicensingPeriod.Split(chrDelimiter);

                        foreach (string LicensingPeriod in LicensingPeriods)
                        {
                            for (int index = 0; index < myItemCollection.Count; index++)
                            {
                                CheckBox CB = (CheckBox)myItemCollection[index].FindControl("lnkReportPeriod");
                                DropDownList DDL = (DropDownList)myItemCollection[index].FindControl("ddlPeriod");
                                ListItem found = DDL.Items.FindByValue(LicensingPeriod);
                                if (found != null)
                                {
                                    CB.Checked = true;
                                    DDL.SelectedIndex = DDL.Items.IndexOf(found);
                                }
                                else
                                {
                                    //CB.Checked = false;
                                }
                            }
                        }


                    }

                }




                String paramHistoricCourseIDs = dtbScheduleTable.Rows[0]["ParamHistoricCourseIDs"].ToString();
                if (paramHistoricCourseIDs != null)
                {
                    //don't know where to get historic course
                    this.setListValues(histCourse, paramHistoricCourseIDs);
                }


                String paramAllUnits = dtbScheduleTable.Rows[0]["ParamAllUnits"].ToString();
                if (paramAllUnits != null)
                {
                    //ignore
                }


                String paramTimeExpired = dtbScheduleTable.Rows[0]["ParamTimeExpired"].ToString();
                if (paramTimeExpired != null)
                {
                    this.expireBox.Text = paramTimeExpired;
                }


                String paramTimeExpiredPeriod = dtbScheduleTable.Rows[0]["ParamTimeExpiredPeriod"].ToString();
                if (paramTimeExpiredPeriod != null)
                {
                    //ignore
                }


                String paramQuizStatus = dtbScheduleTable.Rows[0]["ParamQuizStatus"].ToString();
                if (paramQuizStatus != null)
                {
                    this.quizStatusList.SelectedValue = paramQuizStatus;
                }


                String paramGroupBy = dtbScheduleTable.Rows[0]["ParamGroupBy"].ToString();
                if ((paramGroupBy != null) & (paramGroupBy != ""))
                {
                    this.groupbyList.SelectedValue = paramGroupBy;
                    if (this.groupbyList.SelectedIndex == 1)
                    {
                        SortBy.Visible = true;
                    }
                    else
                    {
                        SortBy.Visible = false;
                    }
                }


                String paramFirstName = dtbScheduleTable.Rows[0]["ParamFirstName"].ToString();
                if (paramFirstName != null)
                {
                    this.firstNameBox.Text = paramFirstName;
                }


                String paramLastName = dtbScheduleTable.Rows[0]["ParamLastName"].ToString();
                if (paramLastName != null)
                {
                    this.lastNameBox.Text = paramLastName;
                }


                String paramUserName = dtbScheduleTable.Rows[0]["ParamUserName"].ToString();
                if (paramUserName != null)
                {
                    this.userNameBox.Text = paramUserName;
                }


                String paramEmail = dtbScheduleTable.Rows[0]["ParamEmail"].ToString();
                if (paramEmail != null)
                {
                    this.emailBox.Text = paramEmail;
                }
 

                String paramIncludeInactive = dtbScheduleTable.Rows[0]["ParamIncludeInactive"].ToString();
                if (paramIncludeInactive != null && "Y".Equals(paramIncludeInactive))
                {
                    this.inactiveUserCheck.Checked = true;
                }


                String paramSubject = dtbScheduleTable.Rows[0]["ParamSubject"].ToString();
                if (paramSubject != null)
                {
                    this.subjectBox.Text = paramSubject;
                }


                String paramBody = dtbScheduleTable.Rows[0]["ParamBody"].ToString();
                if (paramBody != null)
                {
                    this.bodyBox.Text = paramBody;
                }


                String paramProfileID = dtbScheduleTable.Rows[0]["ParamProfileID"].ToString();
                if (paramProfileID != null)
                {
                    profileList.SelectedValue = paramProfileID;
                    LoadPeriod();

                }


                String paramOnlyUsersWithShortfall = dtbScheduleTable.Rows[0]["ParamOnlyUsersWithShortfall"].ToString();
                if (paramStatus != null)
                {
                    shortFallCheck.Checked = true;
                }


                String paramEffectiveDate = dtbScheduleTable.Rows[0]["ParamEffectiveDate"].ToString();
                if (paramEffectiveDate != null)
                {
                    //ignore
                }


                String paramSortBy = dtbScheduleTable.Rows[0]["ParamSortBy"].ToString();
                if (paramSortBy != null)
                {
                    lstWithinUserSort.SelectedIndex = int.Parse(paramSortBy);
                }

                DisplayClassifications();
                String paramClassificationID = dtbScheduleTable.Rows[0]["ParamClassificationID"].ToString();
                if (paramClassificationID != null && paramClassificationID!="")
                {
                    this.cboCustomClassification.SelectedIndex = int.Parse(paramClassificationID);
                }


                String paramUnitIDs = dtbScheduleTable.Rows[0]["ParamUnitIDs"].ToString();
                if (paramUnitIDs != null)
                {
                    this.trvUnitsSelector.SetSelectedValues(paramUnitIDs.Split(','));
                }


                String paramLangCode = dtbScheduleTable.Rows[0]["ParamLangCode"].ToString();
                if (paramStatus != null)
                {
                    //ignore
                }

                if (!(dtbScheduleTable.Rows[0]["ParamDateTo"] is DBNull))
                {
                    DateTime dateTo = (DateTime)dtbScheduleTable.Rows[0]["ParamDateTo"];
                    this.cboQCompletionDay.SelectedValue = dateTo.Day.ToString();
                    this.cboQCompletionMonth.SelectedValue = dateTo.Month.ToString();
                    this.cboQCompletionYear.SelectedValue = dateTo.Year.ToString();
                }


                if (!(dtbScheduleTable.Rows[0]["ParamDateFrom"] is DBNull))
                {
                    DateTime dateFrom = (DateTime)dtbScheduleTable.Rows[0]["ParamDateFrom"];
                    this.cboFCompletionDay.SelectedValue = dateFrom.Day.ToString();
                    this.cboFCompletionMonth.SelectedValue = dateFrom.Month.ToString();
                    this.cboFCompletionYear.SelectedValue = dateFrom.Year.ToString();
                }
                String ParamAcceptance = dtbScheduleTable.Rows[0]["ParamAcceptance"].ToString();
                if (!(dtbScheduleTable.Rows[0]["ParamAcceptance"] is DBNull))
                try
                {
                    Radiobuttonlist3.SelectedValue = ParamAcceptance;
                    String ParamPolicyIDs = dtbScheduleTable.Rows[0]["ParamPolicyIDs"].ToString();
                    string[] selectedValues = ParamPolicyIDs.Split(new char[1] { ',' });
                    String NextPolicyID = "";
                    int selectedValuesCount = selectedValues.Length ;
                    for (int intPolicy = 0; intPolicy != selectedValuesCount; intPolicy++)
                    {
                        NextPolicyID = selectedValues[intPolicy];
                        for (int intIndex = 0; intIndex != this.lstPolicy.Items.Count; intIndex++)
                        {
                            if (this.lstPolicy.Items[intIndex].Value.Equals(NextPolicyID))
                            {
                                this.lstPolicy.Items[intIndex].Selected = true;
                            }
                        }
                    }


                }
                catch
                {
                }
            }
            return ReturnValue;

        }

        private void GetScheduleList()
        {
            // Get all the schedule

            ArrayList al = new ArrayList();
            al.Add(new SqlParameter("@UserID", UserContext.UserID));
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = @"select CONVERT(varchar, ReportFrequency) + ' ' + ReportFrequencyPeriod as column2, "+
                                        "  ' ' as column3, "+
                                        " ScheduleID, RI.ReportID as ReportID, "+
                                        " case "+
                                        " when RI.ReportID = 26 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
                                        " when RI.ReportID = 27 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
                                        " when RI.ReportID = 3 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
                                        " when RI.ReportID = 6 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
                                        " else coalesce(tblLangValue.LangEntryValue,'Missing Localisation') "+
                                        " end as ReportName, ParamOrganisationID as OrganisationID, RI.* " + 
                                        " FROM tblLang INNER JOIN "+
                                        " tblLangValue ON tblLang.LangID = tblLangValue.LangID and tblLang.LangCode = '"+ResourceManager.CurrentCultureName+"' "+
                                        " INNER JOIN tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID "+
                                        " INNER JOIN tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID "+
                                        " AND (tblLangValue.Active = 1) and langresourcename = 'rptreporttitle' "+
                                        " right outer join tblReportinterface RI on RI.paramlanginterfacename = tblLangInterface.langinterfacename " +
                                        " inner join tblReportSchedule as sch  on RI.ReportID = sch.ReportID where UserID=@UserID "+
                                        " and sch.ParamOrganisationID =" + UserContext.UserData.OrgID + " "+
                                        " order by RI.ReportName";

            DataTable dtbReportSchedules = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, (SqlParameter[])al.ToArray(typeof(SqlParameter))).Tables[0];


            if (dtbReportSchedules.Rows.Count > 0)
            {                
            }
            else
            {
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoCourse");//"No courses were found";
                this.lblMessage.CssClass = "FeedbackMessage";
            }

        }

        private String getListValues(ListBox box)
        {
            String selectedValue = "";
            foreach (ListItem li in box.Items)
            {
                if (li.Selected)
                {
                    selectedValue += li.Value + ",";
                }
            }
            if (selectedValue.Length > 0)
            {
                selectedValue = selectedValue.Substring(0, selectedValue.Length - 1);
            }

            return selectedValue;
        }

        private void setListValues(ListBox box, String value)
        {
            string[] selectedValues = value.Split(new char[1] { ',' });
            foreach (ListItem li in box.Items)
            {
                if (selectedValues.Contains(li.Value))
                {
                    li.Selected = true;
                }
            }

        }

        private void toggleControls(Boolean enable)
        {

            System.Web.UI.ControlCollection con = Page.Controls;

            for (int i = 0; i < con.Count; i++)
            {
                setControl(con[i], enable);
            }
        }

        void setControl(Control p, Boolean enable)
        {
            foreach (Control o in p.Controls)
            {
                if (o.GetType().Name == "TextBox" && o.Visible)
                {
                    ((TextBox)o).Enabled = enable;
                }
                else if (o.GetType().Name == "DropDownList" && o.Visible && string.Compare("PageDropDownList", o.ID) != 0)
                {
                    ((DropDownList)o).Enabled = enable;
                }
                else if (o.GetType().Name == "CheckBox" && o.Visible)
                {
                    ((CheckBox)o).Enabled = enable;
                }
                else if (o.GetType().Name == "ListBox" && o.Visible)
                {
                    ((ListBox)o).Enabled = enable;
                }

                if (o.Controls.Count > 0)
                {
                    setControl(o, enable);
                }
            }
        }


        protected void butNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("PeriodicReport.aspx");
        }

        
        
        protected void butEdit_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(this.scheduleHolder.Text))
            {
                toggleControls(true);
            }
        }

        protected void butCancel_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(this.scheduleHolder.Text))
            {
                Response.Redirect(Request.Url.ToString());
            }

        }

        protected void butDelete_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.scheduleHolder.Text))
            {
                String scheduleID = Convert.ToString(this.scheduleHolder.Text);

                string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
                SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@ScheduleID", scheduleID) };
                //save here
                string sqlDelete = "delete from tblReportSchedule where ScheduleID=@ScheduleID ";

                SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlDelete, sqlParams);
                Response.Redirect("PeriodicReport.aspx");
            }
        }

        protected void btnRunReport_Click(object sender, System.EventArgs e)
        {
            string reportid = listReports.SelectedValue;

            string[] SummaryReports = new string[] { "22", "24", "10", "23" };
            if ((this.groupbyList.SelectedValue == "0") && (this.listReports.SelectedValue == "3")) //two versions of CurrentAdminReport merged at client request
            {
                reportid = "6";
            }
            else if ((this.groupbyList.SelectedValue == "1") && (this.listReports.SelectedValue == "3"))
            {
                reportid = "3";
            }
            else if ((this.groupbyList.SelectedValue == "0") && (this.listReports.SelectedValue == "27")) //two versions of HistoricAdminReport merged at client request
            {
                reportid = "26";
            }
            else if ((this.groupbyList.SelectedValue == "1") && (this.listReports.SelectedValue == "26"))
            {
                reportid = "27";
            }
            else if (((this.reportStatusList.SelectedValue == "0")||(this.reportStatusList.SelectedValue == "1")) && (this.listReports.SelectedValue == "18")) //two versions of CurrentAdminReport merged at client request
            {
                reportid = "17";
            }
            else if ((this.reportStatusList.SelectedValue == "2") && (this.listReports.SelectedValue == "17"))
            {
                reportid = "18";
            }            
            else if ((this.optReportType.SelectedIndex == 0) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "22";
            }
            else if ((this.optReportType.SelectedIndex == 1) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "24";
            }
            else if ((this.optReportType.SelectedIndex == 2) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "10";
            }
            else if ((this.optReportType.SelectedIndex == 3) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                reportid = "23";
            }



            this.ShowReport(reportid);

        }

        protected void btnResetReport_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("/Reporting/PeriodicReport.aspx?&ReportID=" + listReports.SelectedValue);

        }


        protected void btnResetReportSchedule_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("/Reporting/PeriodicReport.aspx?&ReportID=" + listReports.SelectedValue);

        }



        public void butSavePeriodicReportSchedule_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            ArrayList al = new ArrayList();
            al.Add(new SqlParameter("@UserID", UserContext.UserID));
            string[] SummaryReports = new string[] { "22","24","10","23" };

            string strSelectedValue = this.listReports.SelectedValue;


            if ((this.groupbyList.SelectedValue == "0") && (strSelectedValue == "3")) //two versions of CurrentAdminReport merged at client request
            {
                al.Add(new SqlParameter("@ReportID", "6"));
            }
            else if ((this.groupbyList.SelectedValue == "1") && (strSelectedValue == "6"))
            {
                al.Add(new SqlParameter("@ReportID", "3"));
            }
            else if ((this.groupbyList.SelectedValue == "0") && (strSelectedValue == "27")) //two versions of HistoricAdminReport merged at client request
            {
                al.Add(new SqlParameter("@ReportID", "26"));
            }
            else if ((this.groupbyList.SelectedValue == "1") && (strSelectedValue == "26"))
            {
                al.Add(new SqlParameter("@ReportID", "27"));
            }
            else if (((this.reportStatusList.SelectedValue == "0") || (strSelectedValue == "1")) && (strSelectedValue == "17")) //two versions of CurrentAdminReport merged at client request
            {
                al.Add(new SqlParameter("@ReportID", "17"));
            }
            else if ((this.reportStatusList.SelectedValue == "2") && (strSelectedValue == "17"))
            {
                al.Add(new SqlParameter("@ReportID", "18"));
            }
            else if ((this.optReportType.SelectedIndex == 0) && (SummaryReports.Contains(strSelectedValue))) //four versions of SummaryReport merged at client request
            {
                al.Add(new SqlParameter("@ReportID", "22"));
            }
            else if ((this.optReportType.SelectedIndex == 1) && (SummaryReports.Contains(strSelectedValue))) //four versions of SummaryReport merged at client request
            {
                al.Add(new SqlParameter("@ReportID", "24"));
            }
            else if ((this.optReportType.SelectedIndex == 2) && (SummaryReports.Contains(strSelectedValue))) //four versions of SummaryReport merged at client request
            {
                al.Add(new SqlParameter("@ReportID", "10"));
            }
            else if ((this.optReportType.SelectedIndex == 3) && (SummaryReports.Contains(this.listReports.SelectedValue.ToString()))) //four versions of SummaryReport merged at client request
            {
                al.Add(new SqlParameter("@ReportID", "23"));
            }
            else al.Add(new SqlParameter("@ReportID", this.listReports.SelectedValue));
            al.Add(new SqlParameter("@paramSortBy" ,lstWithinUserSort.SelectedIndex.ToString()));
            al.Add(new SqlParameter("@ReportFrequency", PeriodicReportControl.EveryHowMany.Text));

            al.Add(new SqlParameter("@ReportFrequencyPeriod", "DWMY"[PeriodicReportControl.EveryUnit.SelectedIndex]));
            al.Add(new SqlParameter("@DocumentType", PeriodicReportControl.DocType.SelectedValue));
            al.Add(new SqlParameter("@ParamOrganisationID", UserContext.UserData.OrgID));
            al.Add(new SqlParameter("@ParamStatus", this.reportStatusList.SelectedValue));
            al.Add(new SqlParameter("@ParamFailCount", (this.failCounterBox.Text == "0" || string.IsNullOrEmpty(failCounterBox.Text)) ? null : this.failCounterBox.Text));

            if (courseList.Visible)
            {
                al.Add(new SqlParameter("@ParamCourseIDs", getListValues(courseList)));
            }
            else if (courseListDropdown.Visible)
            {
                al.Add(new SqlParameter("@ParamCourseIDs", this.courseListDropdown.SelectedValue));
            }
            else
            {
                al.Add(new SqlParameter("@ParamCourseIDs", ""));
            }

            al.Add(new SqlParameter("@ParamHistoricCourseIDs", getListValues(histCourse)));
            al.Add(new SqlParameter("@ParamTimeExpired", this.expireBox.Text));
            al.Add(new SqlParameter("@ParamTimeExpiredPeriod", this.expireUnit.SelectedValue));
            al.Add(new SqlParameter("@ParamQuizStatus", this.quizStatusList.SelectedValue));
            al.Add(new SqlParameter("@ParamGroupBy", this.groupbyList.SelectedValue));
            al.Add(new SqlParameter("@ParamFirstName", this.firstNameBox.Text));
            al.Add(new SqlParameter("@ParamLastName", this.lastNameBox.Text));
            al.Add(new SqlParameter("@ParamUserName", this.userNameBox.Text));
            al.Add(new SqlParameter("@ParamEmail", this.emailBox.Text));
            al.Add(new SqlParameter("@ParamIncludeInactive", this.inactiveUserCheck.Checked ? "Y" : "N"));
            al.Add(new SqlParameter("@ParamSubject", this.subjectBox.Text));
            al.Add(new SqlParameter("@ParamBody", this.bodyBox.Text));
            al.Add(new SqlParameter("@ParamProfileID", profileList.SelectedValue.ToString()));
            al.Add(new SqlParameter("@ParamOnlyUsersWithShortfall", this.shortFallCheck.Checked ? "Y" : "N"));

            string[] astrUnits = this.trvUnitsSelector.GetSelectedValues();
            string strUnits = String.Join(",", astrUnits);
            al.Add(new SqlParameter("@ParamUnitIDs", strUnits));
            al.Add(new SqlParameter("@ParamLangCode", Request.Cookies["currentCulture"].Value));
            if (cboQCompletionDay.SelectedValue == "" || cboQCompletionMonth.SelectedValue == "" || cboQCompletionYear.SelectedValue == "")
            {
                al.Add(new SqlParameter("@ParamDateTo", null));
            }
            else
            {
                al.Add(new SqlParameter("@ParamDateTo", new DateTime(Convert.ToInt32(cboQCompletionYear.SelectedValue), Convert.ToInt32(cboQCompletionMonth.SelectedValue), Convert.ToInt32(cboQCompletionDay.SelectedValue))));
            }

            if (cboFCompletionDay.SelectedValue == "" || cboFCompletionMonth.SelectedValue == "" || cboFCompletionYear.SelectedValue == "")
            {
                al.Add(new SqlParameter("@ParamDateFrom", null));
            }
            else
            {
                al.Add(new SqlParameter("@ParamDateFrom", new DateTime(Convert.ToInt32(cboFCompletionYear.SelectedValue), Convert.ToInt32(cboFCompletionMonth.SelectedValue), Convert.ToInt32(cboFCompletionDay.SelectedValue))));
            }
            string licensingPeriodIDs = "";
            if (!this.listReports.SelectedValue.Equals("20")) { licensingPeriodIDs = this.licensingPeriodList.SelectedValue; }
            else
            {
                string courseLicensingID = "";
                RepeaterItemCollection myItemCollection = rptList.Items;
                for (int index = 0; index < myItemCollection.Count; index++)
                {
                    CheckBox CB = (CheckBox)myItemCollection[index].FindControl("lnkReportPeriod");
                    DropDownList DDL = (DropDownList)myItemCollection[index].FindControl("ddlPeriod");
                    if (CB.Checked)
                    {
                        if (!courseLicensingID.Equals("")) { courseLicensingID = courseLicensingID + ","; }
                        courseLicensingID = courseLicensingID + DDL.SelectedValue;
                    }
                }
                if (courseLicensingID.Equals("")) { courseLicensingID = "0"; }
                licensingPeriodIDs = courseLicensingID;
            }
            al.Add(new SqlParameter("@ParamLicensingPeriod", licensingPeriodIDs));


            // custom classification
            if (this.cboCustomClassification.Items.Count == 0)
            {
                al.Add(new SqlParameter("@ParamClassificationID",0));
            }
            else
            {
                al.Add(new SqlParameter("@ParamClassificationID", this.cboCustomClassification.SelectedIndex));
            }
            al.Add(new SqlParameter("@reportTitle", PeriodicReportControl.ReportTitleTextBox.Text));
            

            char isPeriodic = 'N';
            if (PeriodicReportControl.Now.Checked)
                isPeriodic = 'N';
            else if (PeriodicReportControl.Onceonly.Checked)
                isPeriodic = 'O';
            else if (PeriodicReportControl.Morethanonce.Checked)
                isPeriodic = 'M';
            al.Add(new SqlParameter("@isPeriodic",  isPeriodic));
            

            DateTime reportStartDate = DateTime.Now;
            int reportStartDay;
            int reportStartMonth;
            int reportStartYear;
            if (PeriodicReportControl.OnceonlyDate.Visible)
            {
                Int32.TryParse(PeriodicReportControl.cboFCompletionDay1.SelectedValue, out reportStartDay);
                Int32.TryParse(PeriodicReportControl.cboFCompletionMonth1.SelectedValue, out reportStartMonth);
                Int32.TryParse(PeriodicReportControl.cboFCompletionYear1.SelectedValue, out reportStartYear);
                if ((reportStartDay > 0) && (reportStartMonth > 0) && (reportStartYear > 0))
                    reportStartDate = new DateTime(reportStartYear, reportStartMonth, reportStartDay);
            }
            else if (PeriodicReportControl.MorethanonceDate.Visible)
            {
                Int32.TryParse(PeriodicReportControl.cboFCompletionDay2.SelectedValue, out reportStartDay);
                Int32.TryParse(PeriodicReportControl.cboFCompletionMonth2.SelectedValue, out reportStartMonth);
                Int32.TryParse(PeriodicReportControl.cboFCompletionYear2.SelectedValue, out reportStartYear);
                if ((reportStartDay > 0) && (reportStartMonth > 0) && (reportStartYear > 0))
                    reportStartDate = new DateTime(reportStartYear, reportStartMonth, reportStartDay);
            }
            al.Add(new SqlParameter("@ReportStartDate", reportStartDate));

 
            DateTime reportEndDate = DateTime.Now;
            int reportEndDay;
            int reportEndMonth;
            int reportEndYear;
            if (PeriodicReportControl.EndOn.Checked)
            {
                Int32.TryParse(PeriodicReportControl.cboFCompletionDay3.SelectedValue, out reportEndDay);
                Int32.TryParse(PeriodicReportControl.cboFCompletionMonth3.SelectedValue, out reportEndMonth);
                Int32.TryParse(PeriodicReportControl.cboFCompletionYear3.SelectedValue, out reportEndYear);
                reportEndDate = new DateTime(reportEndYear, reportEndMonth, reportEndDay);
                al.Add(new SqlParameter("@reportEndDate", reportEndDate));
            }
            else
            {
                al.Add(new SqlParameter("@reportEndDate", null));
            }

            int numberOfReports;
            if (PeriodicReportControl.EndAfter.Checked)
            {
                int.TryParse(PeriodicReportControl.EndAfterTextbox.Text, out numberOfReports);
                al.Add(new SqlParameter("@numberOfReports", numberOfReports));
            }
            else
            {
                al.Add(new SqlParameter("@numberOfReports", null));
            }
            int reportPeriodType;
            if (!PeriodicReportControl.ForWhatPeriod.Visible)
            {
                al.Add(new SqlParameter("@reportPeriodType", null));
            }
            else
            {
                if (PeriodicReportControl.rbtnAllDays.Checked)
                    reportPeriodType = 1;
                else if (PeriodicReportControl.rbtnPreced.Checked)
                    reportPeriodType = 2;
                else if (PeriodicReportControl.rbtnPeriodStartOn.Checked)
                    reportPeriodType = 3;
                else
                    reportPeriodType = 0;
                al.Add(new SqlParameter("@reportPeriodType", reportPeriodType));
            }

            DateTime reportFromDate = DateTime.Now;
            int reportFromDay;
            int reportFromMonth;
            int reportFromYear;
            if (PeriodicReportControl.cboFCompletionDay4.Visible && PeriodicReportControl.cboFCompletionMonth4.Visible && PeriodicReportControl.cboFCompletionYear4.Visible)
            {
                Int32.TryParse(PeriodicReportControl.cboFCompletionDay4.SelectedValue, out reportFromDay);
                Int32.TryParse(PeriodicReportControl.cboFCompletionMonth4.SelectedValue, out reportFromMonth);
                Int32.TryParse(PeriodicReportControl.cboFCompletionYear4.SelectedValue, out reportFromYear);
                if ((reportFromDay > 0) && (reportFromMonth > 0) && (reportFromYear > 0))
                    reportFromDate = new DateTime(reportFromYear, reportFromMonth, reportFromDay);
            }

            al.Add(new SqlParameter("@reportFromDate", reportFromDate));

            string ParamAcceptance = "0";

            if (Radiobuttonlist3.Visible)
            {
                ParamAcceptance = Radiobuttonlist3.SelectedValue.ToString();
            }
            al.Add(new SqlParameter("@ParamAcceptance", ParamAcceptance));

            string ParamPolicyIDs = string.Empty;
            if (PolicyIDs.Visible)
            {


                try
                {
                    // Get the selected Policies
                    ParamPolicyIDs = string.Empty; //"0";
                    for (int intIndex = 0; intIndex != this.lstPolicy.Items.Count; intIndex++)
                    {
                        if (this.lstPolicy.Items[intIndex].Selected)
                        {
                            if (ParamPolicyIDs.Length == 0)
                            {
                                ParamPolicyIDs += this.lstPolicy.Items[intIndex].Value;
                            }
                            else
                            {
                                ParamPolicyIDs += "," + this.lstPolicy.Items[intIndex].Value;
                            }
                        }
                    }
                }
                catch
                {
                    ParamPolicyIDs = "";
                }
            }
            al.Add(new SqlParameter("@ParamPolicyIDs", ParamPolicyIDs));



            //save here
            if (!string.IsNullOrEmpty(this.scheduleHolder.Text))
            {//update

                int scheduleId = 0;
                Int32.TryParse(this.scheduleHolder.Text, out scheduleId);
                SaveCCList(scheduleId);

                string sqlUpdate = @"UPDATE tblReportSchedule
                                       SET ReportStartDate = @ReportStartDate
                                          ,ReportFrequency = @ReportFrequency
                                          ,ReportFrequencyPeriod = @ReportFrequencyPeriod
                                          ,DocumentType = @DocumentType
                                          ,ParamOrganisationID = @ParamOrganisationID
                                          ,ParamStatus = @ParamStatus
                                          ,ParamFailCount = @ParamFailCount
                                          ,ParamCourseIDs = @ParamCourseIDs
                                          ,ParamHistoricCourseIDs = @ParamHistoricCourseIDs
                                          ,ParamTimeExpired = @ParamTimeExpired
                                          ,ParamTimeExpiredPeriod = @ParamTimeExpiredPeriod
                                          ,ParamQuizStatus = @ParamQuizStatus
                                          ,ParamGroupBy = @ParamGroupBy
                                          ,ParamFirstName = @ParamFirstName
                                          ,ParamLastName = @ParamLastName
                                          ,ParamUserName = @ParamUserName
                                          ,ParamEmail = @ParamEmail
                                          ,ParamIncludeInactive = @ParamIncludeInactive
                                          ,ParamSubject = @ParamSubject
                                          ,ParamBody = @ParamBody
                                          ,ParamProfileID = @ParamProfileID
                                          ,ParamOnlyUsersWithShortfall = @ParamOnlyUsersWithShortfall
                                          ,ParamUnitIDs = @ParamUnitIDs
                                          ,ParamLangCode = @ParamLangCode
                                          ,ParamDateTo = @ParamDateTo
                                          ,ParamDateFrom = @ParamDateFrom
                                          ,ParamLicensingPeriod = @ParamLicensingPeriod
                                          ,ParamClassificationID = @ParamClassificationID
                                          ,paramSortBy = @paramSortBy
                                          ,reportTitle = @reportTitle
                                          ,isPeriodic = @isPeriodic
                                          ,reportEndDate = @reportEndDate
                                          ,numberOfReports = @numberOfReports
                                          ,reportPeriodType = @reportPeriodType
                                          ,reportFromDate = @reportFromDate 
                                          ,NextRun = null 
                                          ,LastUpdated = getUTCdate() 
                                          ,LastUpdatedBy = @UserID 
                                            ,ParamPolicyIDs = @ParamPolicyIDs
                                            ,ParamAcceptance = @ParamAcceptance
                                     WHERE ScheduleID=@ScheduleID"; //NextRun = null signals the services to recalculate the nextrun date as the enddate etc may have changed
                al.Add(new SqlParameter("@ScheduleID", this.scheduleHolder.Text));
                SqlParameter[] Params = (SqlParameter[]) al.ToArray(typeof(SqlParameter));
                SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlUpdate, Params);
            }
            else
            {//insert
                if (isPeriodic == 'N') // for CC list to be saved before schedule
                {
                    string sqlInsert = "INSERT INTO tblReportSchedule (ParamPolicyIDs,ParamAcceptance,UserID,ReportID,ReportStartDate,ReportFrequency,ReportFrequencyPeriod,DocumentType,ParamOrganisationID,ParamStatus,ParamFailCount,ParamCourseIDs,ParamHistoricCourseIDs,ParamTimeExpired,ParamTimeExpiredPeriod,ParamQuizStatus,ParamGroupBy,ParamFirstName,ParamLastName,ParamUserName,ParamEmail,ParamIncludeInactive,ParamSubject,ParamBody,ParamProfileID,ParamOnlyUsersWithShortfall,ParamUnitIDs,ParamLangCode,ParamDateTo,ParamDateFrom,ParamLicensingPeriod,paramSortBy  ,reportTitle   ,isPeriodic   ,reportEndDate   ,numberOfReports   ,reportPeriodType   ,reportFromDate )" +
                                       "VALUES (@ParamPolicyIDs,@ParamAcceptance,@UserID, @ReportID ,@ReportStartDate,@ReportFrequency,@ReportFrequencyPeriod,@DocumentType,@ParamOrganisationID,@ParamStatus,@ParamFailCount, @ParamCourseIDs, @ParamHistoricCourseIDs, @ParamTimeExpired,@ParamTimeExpiredPeriod,@ParamQuizStatus,@ParamGroupBy,@ParamFirstName, @ParamLastName, @ParamUserName, @ParamEmail, @ParamIncludeInactive, @ParamSubject, @ParamBody, @ParamProfileID, @ParamOnlyUsersWithShortfall, @ParamUnitIDs, @ParamLangCode, @ParamDateTo, @ParamDateFrom, @ParamLicensingPeriod, @paramSortBy, @reportTitle, 'Y', @reportEndDate, @numberOfReports, @reportPeriodType, @reportFromDate);" +
                                       "SELECT CAST(@@Identity AS INTEGER);";

                    int scheduleId = Convert.ToInt32(SqlHelper.ExecuteScalar(connectionString, CommandType.Text, sqlInsert, (SqlParameter[])al.ToArray(typeof(SqlParameter))));
                    SaveCCList(scheduleId);

                    string sqlUpdate = @"UPDATE tblReportSchedule
                                       SET isPeriodic = 'N'
                                       WHERE ScheduleID=@ScheduleID";
                    SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlUpdate, new SqlParameter("@ScheduleID", scheduleId));
                }
                else
                {
                    string sqlInsert = "INSERT INTO tblReportSchedule (ParamPolicyIDs,ParamAcceptance,UserID,ReportID,ReportStartDate,ReportFrequency,ReportFrequencyPeriod,DocumentType,ParamOrganisationID,ParamStatus,ParamFailCount,ParamCourseIDs,ParamHistoricCourseIDs,ParamTimeExpired,ParamTimeExpiredPeriod,ParamQuizStatus,ParamGroupBy,ParamFirstName,ParamLastName,ParamUserName,ParamEmail,ParamIncludeInactive,ParamSubject,ParamBody,ParamProfileID,ParamOnlyUsersWithShortfall,ParamUnitIDs,ParamLangCode,ParamDateTo,ParamDateFrom,ParamLicensingPeriod,paramSortBy  ,reportTitle   ,isPeriodic   ,reportEndDate   ,numberOfReports   ,reportPeriodType   ,reportFromDate )" +
                                       "VALUES (@ParamPolicyIDs,@ParamAcceptance,@UserID, @ReportID ,@ReportStartDate,@ReportFrequency,@ReportFrequencyPeriod,@DocumentType,@ParamOrganisationID,@ParamStatus,@ParamFailCount, @ParamCourseIDs, @ParamHistoricCourseIDs, @ParamTimeExpired,@ParamTimeExpiredPeriod,@ParamQuizStatus,@ParamGroupBy,@ParamFirstName, @ParamLastName, @ParamUserName, @ParamEmail, @ParamIncludeInactive, @ParamSubject, @ParamBody, @ParamProfileID, @ParamOnlyUsersWithShortfall, @ParamUnitIDs, @ParamLangCode, @ParamDateTo, @ParamDateFrom, @ParamLicensingPeriod, @paramSortBy, @reportTitle, @isPeriodic, @reportEndDate, @numberOfReports, @reportPeriodType, @reportFromDate);" +
                                       "SELECT CAST(@@Identity AS INTEGER);";

                    int scheduleId = Convert.ToInt32(SqlHelper.ExecuteScalar(connectionString, CommandType.Text, sqlInsert, (SqlParameter[])al.ToArray(typeof(SqlParameter))));
                    SaveCCList(scheduleId);
                }
            }

            //refresh here
            Response.Redirect("PeriodicReportList.aspx");
        }

        private void SaveCCList(int scheduleId)
        {
            List<int> CCusers = (List<int>)Session["CCUsers"];

            if ((CCusers != null) && (CCusers.Count > 0))
            {
                BusinessServices.Report report = new BusinessServices.Report();

                foreach (int userId in CCusers)
                {
                    report.SaveCCUser(userId, scheduleId);
                }
            }

            Session["CCUsers"] = null;
        }

        private void initReportList()
        {
            //init report dropdown list
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "SELECT case "+
            " when RI.ReportID = 27 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
            " when RI.ReportID = 26 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
            " when RI.ReportID = 3 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
            " when RI.ReportID = 6 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
            " when RI.ReportID = 36 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Policy/PolicyBuilderReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle')) " +
            " else coalesce(LangEntryValue,'Missing Localisation') " +
            " end as ReportName, ReportID " +
            " FROM (SELECT tblLangValue.LangEntryValue, tblLangInterface.langinterfacename FROM tblLang INNER JOIN " +
            " tblLangValue ON tblLang.LangID = tblLangValue.LangID and tblLang.LangCode = '"+ResourceManager.CurrentCultureName+"' "+
            " INNER JOIN tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID "+
            " INNER JOIN tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID "+
            " AND (tblLangValue.Active = 1) and langresourcename = 'rptreporttitle' ) as TI "+
            " right outer join tblReportinterface RI on RI.paramlanginterfacename = TI.langinterfacename "+
            " where (RI.Active = 1) and (RI.ReportID != 6)  and (RI.ReportID != 18) and (RI.ReportID != 24) and (RI.ReportID != 26) and (RI.ReportID != 10)and (RI.ReportID != 23)   ";
            DataTable dtbReportTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect).Tables[0];
            listReports.DataSource = dtbReportTable;
            listReports.DataValueField = "ReportID";
            listReports.DataTextField = "ReportName";
            listReports.DataBind();
        }

        private void initProfileList(String orgId)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            String sqlSelect = "select * from tblProfile where organisationid = @orgid order by ProfileName";
            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@orgid", orgId) };
            DataTable dtbProfileListTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
            profileList.DataSource = dtbProfileListTable;
            profileList.DataValueField = "ProfileID";
            profileList.DataTextField = "ProfileName";
            profileList.DataBind();

        }


        private void initUnitList(String orgid)
        {
            // Get Units accessable to this user.
            BusinessServices.Unit objUnit = new BusinessServices.Unit();
            DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A');

            // Convert this to an xml string for rendering by the UnitTreeConverter.
            string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
            if (strUnits == "")
            {                
            }
            else
            {
                // Change to the appropriate view and load the Units in
                this.trvUnitsSelector.LoadXml(strUnits);
            }
        }


        protected void profileList_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPeriod();

        }


        protected void listReports_SelectedIndexChanged(object sender, EventArgs e)
        {
            string reportid = "";
            if (sender == null)
            {
                reportid = listReports.SelectedValue;
            }
            else
            {
                reportid = ((DropDownList)sender).SelectedValue;
            }

            reportChanged(reportid, Convert.ToString(UserContext.UserData.OrgID));

        }

        protected void course_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (sender.GetType().Name != "DropDownList") return;
            if (this.listReports.SelectedValue != "20") return;
            string courseid = "";
            if (sender == null)
            {
                courseid = listReports.SelectedValue;
            }
            else
            {
                courseid = ((DropDownList)sender).SelectedValue;
            }

            this.setLicencingPreiod(Convert.ToInt32(courseid));

        }

        protected void reportChanged(String reportid, String orgid)
        {

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "select * from tblReportInterface where ReportID = @reportid";
            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@reportid", reportid) };
            DataTable dtbReportTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];

            int counter = dtbReportTable.Rows.Count;
            String RDLname = dtbReportTable.Rows[0]["RDLname"].ToString();
            Boolean RequiresParamCompleted = (Boolean)dtbReportTable.Rows[0]["RequiresParamCompleted"];
            Boolean RequiresParamStatus = (Boolean)dtbReportTable.Rows[0]["RequiresParamStatus"];
            Boolean RequiresParamFailCount = (Boolean)dtbReportTable.Rows[0]["RequiresParamFailCount"];
            Boolean RequiresParamCourseIDs = (Boolean)dtbReportTable.Rows[0]["RequiresParamCourseIDs"];
            Boolean RequiresParamHistoricCourseIDs = (Boolean)dtbReportTable.Rows[0]["RequiresParamHistoricCourseIDs"];
            Boolean RequiresParamUnitIDs = (Boolean)dtbReportTable.Rows[0]["RequiresParamUnitIDs"];
            Boolean RequiresParamAllUnits = (Boolean)dtbReportTable.Rows[0]["RequiresParamAllUnits"];
            Boolean RequiresParamTimeExpired = (Boolean)dtbReportTable.Rows[0]["RequiresParamTimeExpired"];
            Boolean RequiresParamTimeExpiredPeriod = (Boolean)dtbReportTable.Rows[0]["RequiresParamTimeExpiredPeriod"];
            Boolean RequiresParamQuizStatus = (Boolean)dtbReportTable.Rows[0]["RequiresParamQuizStatus"];
            Boolean RequiresParamGroupBy = (Boolean)dtbReportTable.Rows[0]["RequiresParamGroupBy"];
            Boolean RequiresParamGroupingOption = (Boolean)dtbReportTable.Rows[0]["RequiresParamGroupingOption"];
            Boolean RequiresParamFirstName = (Boolean)dtbReportTable.Rows[0]["RequiresParamFirstName"];
            Boolean RequiresParamLastName = (Boolean)dtbReportTable.Rows[0]["RequiresParamLastName"];
            Boolean RequiresParamUserName = (Boolean)dtbReportTable.Rows[0]["RequiresParamUserName"];
            Boolean RequiresParamEmail = (Boolean)dtbReportTable.Rows[0]["RequiresParamEmail"];
            Boolean RequiresParamIncludeInactive = (Boolean)dtbReportTable.Rows[0]["RequiresParamIncludeInactive"];
            Boolean RequiresParamSubject = (Boolean)dtbReportTable.Rows[0]["RequiresParamSubject"];
            Boolean RequiresParamBody = (Boolean)dtbReportTable.Rows[0]["RequiresParamBody"];
            Boolean RequiresParamDateTo = (Boolean)dtbReportTable.Rows[0]["RequiresParamDateTo"] || (Boolean)dtbReportTable.Rows[0]["RequiresParamToDate"];
            Boolean RequiresParamDateFrom = (Boolean)dtbReportTable.Rows[0]["RequiresParamDateFrom"] || (Boolean)dtbReportTable.Rows[0]["RequiresParamFromDate"] || (Boolean)dtbReportTable.Rows[0]["RequiresParamEffectiveDate"];
            Boolean RequiresParamEffective = (Boolean)dtbReportTable.Rows[0]["RequiresParamEffectiveDate"];
            Boolean RequiresParamProfileID = (Boolean)dtbReportTable.Rows[0]["RequiresParamProfileID"];
            Boolean RequiresParamOnlyUsersWithShortfall = (Boolean)dtbReportTable.Rows[0]["RequiresParamOnlyUsersWithShortfall"];
            String ParamLangInterfaceName = (String)dtbReportTable.Rows[0]["ParamLangInterfaceName"];
            Boolean RequiresParamEffectiveDate = (Boolean)dtbReportTable.Rows[0]["RequiresParamEffectiveDate"];
            Boolean RequiresParamSortBy = (Boolean)dtbReportTable.Rows[0]["RequiresParamSortBy"];
            Boolean RequiresParamClassificationID = (Boolean)dtbReportTable.Rows[0]["RequiresParamClassificationID"];
            Boolean RequiresParamOrganisationID = (Boolean)dtbReportTable.Rows[0]["RequiresParamOrganisationID"];
            Boolean RequiresParamServerURL = (Boolean)dtbReportTable.Rows[0]["RequiresParamServerURL"];
            Boolean RequiresParamCourseID = (Boolean)dtbReportTable.Rows[0]["RequiresParamCourseID"];
            Boolean RequiresParamLicensingPeriod = (Boolean)dtbReportTable.Rows[0]["RequiresParamLicensingPeriod"];
            Boolean RequiresParamAcceptanceStatus = (Boolean)dtbReportTable.Rows[0]["RequiresParamAcceptanceStatus"];
            Boolean RequiresParamPolicyIDs = (Boolean)dtbReportTable.Rows[0]["RequiresParamPolicyIDs"];
            string[] SummaryReports = new string[] { "22", "24", "10", "23" };//four versions of SummaryReport merged at client request

            lblReportType.Visible = SummaryReports.Contains(reportid);
            optReportType.Visible = SummaryReports.Contains(reportid);

            if (RequiresParamAcceptanceStatus)
            {
                acceptance.Visible = true;
            }
            else
            {
                acceptance.Visible = false;
            }

            if (RequiresParamPolicyIDs)
            {
                PolicyIDs.Visible = true;
			    Organisation objOrg = new Organisation();
			    DataTable dtbPolicies = objOrg.GetOrganisationPolicies(UserContext.UserData.OrgID);
			    if (dtbPolicies.Rows.Count>0)
			    {
				    lstPolicy.DataSource = dtbPolicies;
				    lstPolicy.DataTextField = "PolicyName";
				    lstPolicy.DataValueField = "PolicyID";
				    lstPolicy.DataBind();
			    }
			    else
			    {
				    this.lblError.Visible = true;
				    this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoPolicy");//"No courses exist within this organisation.";
				    this.lblError.CssClass = "WarningMessage";				    
			    }
			    // If there is at least one course then select it.
			    if (lstPolicy.Items.Count>0)
			    {lstPolicy.SelectedIndex=0;} 

            }
            else
            {
                PolicyIDs.Visible = false;
            }

            if (RequiresParamCompleted)
            {
                reportstatus.Visible = true;
                reportStatusList.SelectedIndex = 0;
            }
            else
            {
                reportstatus.Visible = false;
            }

            if (RequiresParamFailCount)
            {
                failCounter.Visible = true;
            }
            else
            {
                failCounter.Visible = false;
            }

            if (RequiresParamCourseIDs || RequiresParamCourseID)
            {
                //init course dropdown list
                //below code is from course status report
                int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
                BusinessServices.Course objCourse = new BusinessServices.Course(); //Course Object
                // Get Courses accessable to this organisation
                DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(intOrganisationID); // List of courses accesable to the organisation

                if (RequiresParamCourseIDs)
                {
                    courseList.SelectionMode = ListSelectionMode.Multiple;
                    courseListDropdown.Visible = false;
                    CourseIDsVisible.Text = "true";

                    courseList.DataSource = dtbCourses;
                    courseList.DataValueField = "CourseID";
                    courseList.DataTextField = "Name";
                    courseList.DataBind();
                }
                else if (RequiresParamCourseID)
                {

                    courseList.Visible = false;
                    CourseIDsVisible.Text = "false";

                    courseListDropdown.Visible = true;

                    courseListDropdown.DataSource = dtbCourses;
                    courseListDropdown.DataValueField = "CourseID";
                    courseListDropdown.DataTextField = "Name";
                    courseListDropdown.DataBind();

                }

                course.Visible = true;
            }
            else
            {
                course.Visible = false;
            }

            if (RequiresParamLicensingPeriod)
            {
                if (reportid.Equals("20"))
                {
                    rptList.Visible = true;
                    panCourse.Visible = true;
                    course.Visible = false;
                    courseList.Visible = false;
                    CourseIDsVisible.Text = "false";
                    licensingPeriod.Visible = false;
                    DataTable dtCourses = BusinessServices.CourseLicensing.GetCoursesWithPeriod(UserContext.UserData.OrgID);
                    rptList.DataSource = dtCourses;
                    rptList.DataBind();
                    butSavePeriodicReportSchedule.Enabled = false;
                    btnRunReport.Enabled = false;
 

                }
                else
                {
                    rptList.Visible = false;
                    panCourse.Visible = false;
                    licensingPeriod.Visible = true;
                    butSavePeriodicReportSchedule.Enabled = true;
                    btnRunReport.Enabled = true;

                    if (this.courseListDropdown.SelectedValue == "")
                    {
                        if (this.courseListDropdown.Items.Count > 0)
                        {
                            this.courseListDropdown.SelectedIndex = 1;
                            setLicencingPreiod(Convert.ToInt32(this.courseListDropdown.SelectedValue));
                        }
                    }
                }
            }
            else
            {
                licensingPeriod.Visible = false;
            }


            if (RequiresParamHistoricCourseIDs)
            {
                int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
                BusinessServices.Course objCourse = new BusinessServices.Course(); //Course Object
                // Get Courses accessable to this organisation
                DataTable dtbCourses = objCourse.GetPastCourseListForOrg(intOrganisationID); // List of courses accesable to the organisation

                histCourse.SelectionMode = ListSelectionMode.Multiple;
                histCourse.Visible = false;

                histCourse.DataSource = dtbCourses;
                histCourse.DataValueField = "CourseID";
                histCourse.DataTextField = "Name";
                histCourse.DataBind();
                histCourse.Visible = true;
                lblHistoricCourse.Visible = true;
                courseListDropdownValidator.Enabled = false;
                courseListValidator.Enabled = false;
                histCourseListValidator.Enabled = true;

            }
            else
            {
                histCourse.Visible = false;
                histCourse.Enabled = false;
                lblHistoricCourse.Visible = false;
                lblHistoricCourse.Enabled = false;
                courseListValidator.Enabled = false;
                histCourseListValidator.Enabled = false;

            }

            if (RequiresParamUnitIDs)
            {
                initUnitList(orgid);
                units.Visible = true;
            }
            else
            {
                units.Visible = false;
            }

            if (RequiresParamTimeExpiredPeriod)
            {
                expire.Visible = true;
                expireBox.Text = "30";
            }
            else
            {
                expire.Visible = false;
            }

            if (RequiresParamQuizStatus)
            {
                quizStatus.Visible = true;
                quizStatusList.SelectedIndex = 0;
            }
            else
            {
                quizStatus.Visible = false;
            }

            if (RequiresParamGroupBy)
            {
                groupby.Visible = true;
                groupbyList.SelectedIndex = 0;
            }
            else
            {
                groupby.Visible = false;
            }


            // grouping options
            if (RequiresParamClassificationID)
            {
                groupoption.Visible = true;
                if (cboCustomClassification.SelectedIndex == -1)
                {
                    DisplayClassifications();
                }                
            }
            else 
            {
                groupoption.Visible = false;
            }


            if (RequiresParamFirstName)
            {
                firstName.Visible = true;
            }
            else
            {
                firstName.Visible = false;
            }


            if (RequiresParamLastName)
            {
                lastName.Visible = true;
            }
            else
            {
                lastName.Visible = false;
            }

            if (RequiresParamUserName)
            {
                userName.Visible = true;
                firstNameBoxValidator.Enabled = false;
                lastNameBoxFieldValidator.Enabled = false;
                emailBoxValidator.Enabled = false;
                userNameBoxValidator.Enabled = false;
            }
            else
            {
                userName.Visible = false;
            }

            if (RequiresParamEmail)
            {
                email.Visible = true;
                firstNameBoxValidator.Enabled = false;
                lastNameBoxFieldValidator.Enabled = false;
                emailBoxValidator.Enabled = false;
                userNameBoxValidator.Enabled = false;
            }
            else
            {
                email.Visible = false;
            }

            if (RequiresParamIncludeInactive)
            {
                inactiveUser.Visible = true;
            }
            else
            {
                inactiveUser.Visible = false;
            }

            if (RequiresParamSubject)
            {
                reportSubject.Visible = true;
            }
            else
            {
                reportSubject.Visible = false;
            }

            if (RequiresParamBody)
            {
                reportBody.Visible = true;
            }
            else
            {
                reportBody.Visible = false;
            }

            if (RequiresParamDateTo)
            {
                dateTo.Visible = true;
                if (reportid.Equals("2")) { lblDateTo.Text = "User creation date (to) :"; }
                else if (reportid.Equals("14")) { lblDateTo.Text = "(Both blank for current date)    and "; }
                else if (reportid.Equals("19")) { lblDateTo.Text = "(Both blank for current date)    and "; }
                else if (reportid.Equals("25")) { lblDateTo.Text = "(Both blank for current date)      and"; };
            }
            else
            {
                dateTo.Visible = false;
            }

            if ((RequiresParamDateFrom) & (reportid != "20"))
            {
                dateFrom.Visible = true;
                if ((reportid.Equals("26")) || (reportid.Equals("27")) || (reportid.Equals("17")) || (reportid.Equals("18")) || (reportid.Equals("10")) || (reportid.Equals("22")) || (reportid.Equals("23")) || (reportid.Equals("24"))) { lblDateFrom.Text = "Historic Date "; }
                else if (RequiresParamEffective) { lblDateFrom.Text = "Effective date"; }
                else if (reportid.Equals("2")) { lblDateFrom.Text = "User creation date (from) : "; }
                else if ((reportid.Equals("3")) || (reportid.Equals("6"))) { dateFrom.Visible = false; }
                else if (reportid.Equals("14")) { lblDateFrom.Text = "Historic Quiz Date Range  between "; }
                else if (reportid.Equals("19")) { lblDateFrom.Text = "Historic Quiz Date Range  between "; }
                else if (reportid.Equals("25")) { lblDateFrom.Text = "Trend Date Range  between "; };
            }
            else
            {
                dateFrom.Visible = false;
            }

            if (RequiresParamProfileID)
            {
                initProfileList(orgid);
                this.profile.Visible = true;
                LoadPeriod();

            }
            else
            {
                this.profile.Visible = false;
            }

            if (RequiresParamOnlyUsersWithShortfall)
            {
                shortFall.Visible = true;
            }
            else
            {
                shortFall.Visible = false;
            }

            int NumDateControls = 0;
            if (this.dateFrom.Visible) { NumDateControls++; }
            if (this.dateTo.Visible) { NumDateControls++; }
            PeriodicReportControl.NumDateControls.Text = NumDateControls.ToString();
            PeriodicReportControl.ForWhatPeriod.Visible = ((PeriodicReportControl.NumDateControls.Text == "2")&(PeriodicReportControl.Morethanonce.Checked));


        }


        private void DisplayClassifications()
        {
            try
            {
                // Get Classification Type for the dsiplayed user's organisation
                Classification objClassification = new BusinessServices.Classification();
                DataTable dtbClassificationType = objClassification.GetClassificationType(UserContext.UserData.OrgID);


                if (dtbClassificationType.Rows.Count > 0)
                {
                    this.lblCustomClassification.Text = dtbClassificationType.Rows[0]["Name"].ToString();

                    DataTable dtbClassificationList = objClassification.GetClassificationList((int)Convert.ToInt32(dtbClassificationType.Rows[0][CTypeColumnID].ToString()));
                    // Add blank row to the datatable
                    DataRow drwBlank;

                    drwBlank = dtbClassificationList.NewRow();

                    // Add a blank value
                    drwBlank[CListColumnClassificationID] = 0;
                    drwBlank[CListColumnClassificationTypeID] = 0;
                    drwBlank[CListColumnValue] = ResourceManager.GetString("lblAny");
                    drwBlank[CListColumnActive] = 1;

                    dtbClassificationList.Rows.InsertAt(drwBlank, 0);
                    this.cboCustomClassification.DataSource = dtbClassificationList;

                    // Add blank item
                    this.cboCustomClassification.DataTextField = CListColumnValue;
                    this.cboCustomClassification.DataValueField = CListColumnClassificationID;
                    this.cboCustomClassification.DataBind();
                }
                else
                {
                    this.lblCustomClassification.Visible = false;
                    this.cboCustomClassification.Visible = false;
                }

            }
            catch (Exception Ex)
            {
                throw new Exception(Ex.Message);
            }

        }

        
        private void setLicencingPreiod(int courseId)
        {
            licensingPeriodList.Items.Clear();
            DataTable dtPeriodList = BusinessServices.CourseLicensing.GetPeriodList(courseId, UserContext.UserData.OrgID);
            foreach (DataRow dr in dtPeriodList.Rows)
            {
                string display = string.Format("{0:dd/MM/yyyy}", (DateTime)dr["DateStart"])
                    + " - " +
                    string.Format("{0:dd/MM/yyyy}", (DateTime)dr["DateEnd"]);

                string courseLicensingID = dr["CourseLicensingID"].ToString();
                licensingPeriodList.Items.Add(new ListItem(display, courseLicensingID));
            }
        }


        private void LoadPeriod()
        {
            string strProfileid = profileList.SelectedValue.ToString();
            int intProfileID;

            if (strProfileid == "")// not blank selection 
            {
                licensingPeriodList.Items.Clear();
            }
            else
            {
                intProfileID = Int32.Parse(strProfileid);
                BusinessServices.Profile objProfile = new BusinessServices.Profile(); //Profile Object
                DataTable dtbPeriod = objProfile.GetPeriodsForProfile(intProfileID); // List of periods for the selected profile
                licensingPeriodList.DataSource = dtbPeriod;
                licensingPeriodList.DataValueField = "ProfilePeriodID";
                licensingPeriodList.DataTextField = "PeriodName";
                licensingPeriodList.DataBind();
            }
        }                    


        protected void groupbyList_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            if (this.groupbyList.SelectedIndex == 1)
            {
                SortBy.Visible = true;
            }
            else
            {
                SortBy.Visible = false;
            }
        }

        protected void rptList_OnCheckedChanged(object sender, System.EventArgs e)
        {
            lnkReportAll.Checked = false;
        }

        protected void rptList_OnAllCheckedChanged(object sender, System.EventArgs e)
        {
            RepeaterItemCollection myItemCollection = rptList.Items;


            for (int index = 0; index < myItemCollection.Count; index++)
            {
                CheckBox CB = (CheckBox)myItemCollection[index].FindControl("lnkReportPeriod");
                CB.Checked = false;
            }
        }
        
        protected bool ValidateTwoDateControlsForReport(string ReportID)
        {
            bool Valid = true;
            if ((this.cboFCompletionDay.SelectedValue.Length > 0) && (this.cboFCompletionMonth.SelectedValue.Length > 0) && (this.cboFCompletionYear.SelectedValue.Length > 0))
            {
                Valid =  (WebTool.ValidateHistoricDateControl(this.cboFCompletionDay , this.cboFCompletionMonth, this.cboFCompletionYear));
            }
            else if ((ReportID != "18") & (ReportID != "17") & (ReportID != "22") & (ReportID != "23") & (ReportID != "24") & (ReportID != "10"))
            {
                    this.cboFCompletionYear.Items.Add("1997");
                    this.cboFCompletionYear.SelectedValue = "1997";
                    this.cboFCompletionMonth.SelectedValue = "1";
                    this.cboFCompletionDay.SelectedValue = "1";
            }
            else if ((ReportID == "22")||(ReportID == "23")||(ReportID == "24")||(ReportID == "10"))
            {
                this.cboFCompletionYear.SelectedValue = System.DateTime.UtcNow.AddDays(1).Year.ToString();
                this.cboFCompletionMonth.SelectedValue = System.DateTime.UtcNow.AddDays(1).Month.ToString();
                this.cboFCompletionDay.SelectedValue = System.DateTime.UtcNow.AddDays(1).Day.ToString();
            }
            if (Valid)
            {
                if ((this.cboQCompletionDay.SelectedValue.Length > 0) && (this.cboQCompletionMonth.SelectedValue.Length > 0) && (this.cboQCompletionYear.SelectedValue.Length > 0))
                {
                    Valid = (WebTool.ValidateDateControl(this.cboQCompletionDay, this.cboQCompletionMonth, this.cboQCompletionYear));
                }
                else
                {
                    this.cboQCompletionYear.SelectedValue = System.DateTime.UtcNow.AddDays(1).Year.ToString();
                    this.cboQCompletionMonth.SelectedValue = System.DateTime.UtcNow.AddDays(1).Month.ToString();
                    this.cboQCompletionDay.SelectedValue = System.DateTime.UtcNow.AddDays(1).Day.ToString();
                }
            }
            if (Valid)
            {
                this.lblError.Visible = false;
                return true;
            }
            else
            {
                this.lblError.Text = ResourceManager.GetString("lblError.ToFromDate");//"The date must be valid and from date cannot be greater than today";
                this.lblError.Visible = true;
                return false;
            }
        }

        private void rptList_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int courseID = Int32.Parse(drv["CourseID"].ToString());
                DropDownList ddlPeriod = (DropDownList)e.Item.FindControl("ddlPeriod");
                DataTable dtPeriodList = BusinessServices.CourseLicensing.GetPeriodList(courseID, UserContext.UserData.OrgID);
                foreach (DataRow dr in dtPeriodList.Rows)
                {
                    string display = string.Format("{0:dd/MM/yyyy}", (DateTime)dr["DateStart"])
                        + " - " +
                        string.Format("{0:dd/MM/yyyy}", (DateTime)dr["DateEnd"]);
                    string courseLicensingID = dr["CourseLicensingID"].ToString();
                    ddlPeriod.Items.Add(new ListItem(display, courseLicensingID));
                }
            }
        }

        private void rptList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DropDownList ddl = (DropDownList)e.Item.FindControl("ddlPeriod");
            int courseLicensingID = Int32.Parse(ddl.SelectedValue);            
        }

    }

}
