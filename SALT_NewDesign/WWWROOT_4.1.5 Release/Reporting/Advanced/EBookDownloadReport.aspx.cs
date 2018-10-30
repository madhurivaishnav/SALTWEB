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
using Localization;
namespace Bdw.Application.Salt.Web.Reporting
{
    public partial class EBookDownloadReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            
            if (!Page.IsPostBack)
            {
                LoadCourseList();

                panelReport.Visible = false;
                panelReportParams.Visible = true;
                LoadUnitTree();
            }
        }

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
            this.rvReport.PageIndexChanged += new EventHandler(this.btnSubmitReport_Click);

        }


        private void LoadCourseList()
        {
            int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
            BusinessServices.Course objCourse = new BusinessServices.Course(); //Course Object
            // Get Courses accessable to this organisation
            DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(intOrganisationID); // List of courses accesable to the organisation

            courseList.SelectionMode = ListSelectionMode.Multiple;

            if (dtbCourses.Rows.Count > 0)
            {

                courseList.DataSource = dtbCourses;
                courseList.DataValueField = "CourseID";
                courseList.DataTextField = "Name";
                courseList.DataBind();
            }
            else
            {
                /*this.plhSearchCriteria.Visible = false;
                this.lblError.Text = ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
                this.lblError.CssClass = "FeedbackMessage";
                this.lblError.Visible = true;*/
                return;
            }

        }

        private void LoadUnitTree()
        {
            BusinessServices.Unit objUnit = new BusinessServices.Unit(); // Unit Object
            DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A'); // Data set to contain unit details
            if (dstUnits.Tables[0].Rows.Count == 0)
            {
                this.panelReportParams.Visible = false;
                this.lblError.Text = ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
                this.lblError.Visible = true;

                return;
            }
            string strUnits = UnitTreeConvert.ConvertXml(dstUnits); // comma seperated list of units
            this.trvUnitPath.LoadXml(strUnits);
        }

        protected void btnSubmitReport_Click(object sender, System.EventArgs e)
        {
            panelReport.Visible = true;
            panelReportParams.Visible = false;

            string[] selectUnits;
            string strCourses = "", strAllCourses = "";
            selectUnits = trvUnitPath.GetSelectedValues();

            // Get the selected courses
            for (int intIndex = 0; intIndex != this.courseList.Items.Count; intIndex++)
            {
                if (this.courseList.Items[intIndex].Selected)
                {
                    if (intIndex == 0)
                    {
                        strCourses += this.courseList.Items[intIndex].Value;

                    }
                    else
                    {
                        strCourses += "," + this.courseList.Items[intIndex].Value;
                    }
                }

                // append the all courses string
                if (intIndex == 0)
                {
                    strAllCourses += this.courseList.Items[intIndex].Value;
                }
                else
                {
                    strAllCourses += "," + this.courseList.Items[intIndex].Value;
                }
            }

            if (strCourses.Length == 0)
                strCourses = strAllCourses;



            int intIncludeIncative = 0;
            if (chkIncludeInactiveUsers.Checked)
            {
                intIncludeIncative = 1;
            }

            BusinessServices.Unit objUnit = new BusinessServices.Unit();
            selectUnits = objUnit.ReturnAdministrableUnitsByUserID(UserContext.UserID, UserContext.UserData.OrgID, selectUnits);
            string strParentUnits = String.Join(",", selectUnits);


            Hashtable parameters = this.rvReport.Parameters;
            parameters["organisationID"] = UserContext.UserData.OrgID;
            parameters["adminUserID"] = UserContext.UserID;
            parameters["effectiveDate"] = DateTime.Now.Date;

            parameters["unitIDs"] = strParentUnits;
            parameters["courseIDs"] = strCourses;

            parameters["IncludeInactive"] = intIncludeIncative;
            parameters["langCode"] = Request.Cookies["currentCulture"].Value;
            parameters["langInterfaceName"] = "Report.EbookDownload";
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
    }
}
