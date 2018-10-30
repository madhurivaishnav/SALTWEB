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
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using System.Configuration;

using Localization;

namespace Bdw.Application.Salt.Web
{
	/// <summary>
	/// Summary description for Certificate.
	/// </summary>
	public partial class Certificate : System.Web.UI.Page
	{
        private string m_strOrganisationImagesPath = ConfigurationSettings.AppSettings["OrganisationImagesPath"];

        # region Private Event Handlers

        /// <summary>
        /// Event handler for the page load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            SetPageState();
            string strCss;
            if (Request.QueryString["css"] != null)
            {
                strCss = "/General/Css/" + Request.QueryString["css"].ToString();
            }
            else
            {
                strCss = getStylesheet();
            }
            lnkStyleSheet.Attributes.Add("href", strCss);
		}
        #endregion

        #region Private Methods

        protected string getStylesheet()
        {
            string strCss = "";

            // If the organisation is known
            try
            {
                OrganisationConfig objOrgConfig = new OrganisationConfig();
                strCss = objOrgConfig.GetOne(Utilities.UserContext.UserData.OrgID, "css");

                // If its an empty string then use the application name
                if (strCss.Length == 0)
                {
                    strCss = Utilities.ApplicationSettings.StyleSheet;
                }

                // append '.css' if requied
                if (!strCss.ToLower().EndsWith(".css"))
                {
                    strCss += ".css";
                }

                strCss = "/general/css/" + strCss;
            }

            // If the organisation isnt known then default css is used.
            catch
            {
                // Update the stylesheet link
                strCss = Utilities.ApplicationSettings.StyleSheet;

                // append '.css' if requied
                if (!strCss.ToLower().EndsWith(".css"))
                {
                    strCss += ".css";
                }
                strCss = "/general/css/" + strCss;
            }
            return strCss;
        }

        /// <summary>
        /// Set the initial page state
        /// </summary>
        private void SetPageState()
        {
            int intCourseID;
            int userId;
            int orgid;

            // Set the current user's Name
            BusinessServices.User objUser = new User();
            if (HttpContext.Current.User.Identity.Name != "")
            {
                userId = UserContext.UserID;
                orgid = UserContext.UserData.OrgID;
            }
            else
            {
                userId = int.Parse(Request.QueryString["userid"].ToString());
                orgid = int.Parse(Request.QueryString["orgid"].ToString());
            }

            DataTable dtbUser = objUser.GetUser(userId);
			string strLangCode = Request.Cookies["currentCulture"].Value;

            // Set the current user's Organisation
            DataTable objOrg = (new Organisation()).GetOrganisation(strLangCode, orgid);


            // Set the current Course
            if (Session["CourseID"] != null)
                intCourseID = int.Parse(Session["CourseID"].ToString());
            else
                intCourseID = int.Parse(Request.QueryString["courseid"].ToString());
            DataTable dtbCourse = (new Course()).GetCourse(intCourseID, orgid);

			
            // Set the date that the user's status change to completed for the course
            DataTable dtbCourseStatus = objUser.GetUserCourseStatus(userId, intCourseID, orgid);
            if ( (dtbCourseStatus.Rows.Count == 1) && (int.Parse(dtbCourseStatus.Rows[0]["CourseStatusID"].ToString()) == (int) CourseStatus.Complete) )
            {


				// A replace line for joke certificates. Delete if you need.
				//lblCertificateComplete.Text = lblCertificateComplete.Text.Replace("_Archive_Legal Technology", "Emerging Systems").Replace("Anti Money Laundering", "How to embezzle and still show a profit!");
            }
            else
            {
				int intProfileID;
                if (Session["ProfileID"] != null)
                    intProfileID = int.Parse(Session["ProfileID"].ToString());
                else
                    intProfileID = int.Parse(Request.QueryString["profileid"].ToString());

				DataTable m_dtbModules = objUser.HomePageDetails(userId, intCourseID, intProfileID);

				foreach(DataRow drwRow in m_dtbModules.Rows)
				{
					if( (int) drwRow["QuizStatus"] != (int) QuizStatus.Passed )
					{
						throw new RecordNotFoundException(ResourceManager.GetString("UserNotFound"));//"Can not find a record of user having passed that course");
					}

				}
				// dont show the certificate link if there are no modules in the list
				if (m_dtbModules.Rows.Count == 0)
				{
					throw new RecordNotFoundException(ResourceManager.GetString("UserNotFound"));//"Can not find a record of user having passed that course");
				}
                
            }
			System.DateTime CourseDate = (DateTime) dtbCourseStatus.Rows[0]["DateCreated"];
			lblCertificateComplete.Text = String.Format(ResourceManager.GetString("lblCertificateComplete"), dtbUser.Rows[0]["FirstName"] + " " + dtbUser.Rows[0]["LastName"]
				, objOrg.Rows[0]["OrganisationName"].ToString()
				, dtbCourse.Rows[0]["Name"].ToString()
				, CourseDate.Date.ToString("d MMMM yyyy"));
			
			if (objOrg.Rows[0]["IncludeCertificateLogo"].ToString() != "")
			{
				if((bool)objOrg.Rows[0]["IncludeCertificateLogo"])
				{
					if(objOrg.Rows[0]["Logo"].ToString()!="")
					{
						string strAppPath = HttpContext.Current.Request.ApplicationPath;
						if(strAppPath == @"/") 
						{
							this.imgCompanyLogo.ImageUrl = m_strOrganisationImagesPath + objOrg.Rows[0]["Logo"].ToString();
						}
						else
						{
							this.imgCompanyLogo.ImageUrl = strAppPath + m_strOrganisationImagesPath + objOrg.Rows[0]["Logo"].ToString();
						}						
						this.pnlLogoImage.Visible = true;
					}
					else
					{
						this.pnlLogoImage.Visible= false;						
					}
				}
				else
				{
					this.pnlLogoImage.Visible= false;
				}
			}
			else
			{
				this.pnlLogoImage.Visible= false;	
			}


        }
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

        }
		#endregion
	}
}
