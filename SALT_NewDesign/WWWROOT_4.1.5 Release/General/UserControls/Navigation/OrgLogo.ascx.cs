namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.Security;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using Bdw.Application.Salt.Web.Utilities;
	using Bdw.Application.Salt.Data;
    using System.Configuration;
	using Localization;

	/// <summary>
	///	This control displays the Organisation logo for the currently logged in User.
	/// It also provides the main navigation for the site.
	/// </summary>
	/// <remarks>
	/// Assumptions: None.
	/// Notes: None.
	/// Author: Peter Vranich
	/// Date: 29/01/0/2004
	/// Changes:
	/// Some HTML was deleted from teh presentation page and references to it have been removed from this page to 
	/// remove the seperate header for the salt administrator 
	/// </remarks>
    public partial class OrgLogo : System.Web.UI.UserControl
    {
      
        #region constants
        /// <summary>
        /// path to folder containg Header Images
        /// </summary>
        const string cm_strHeaderImagePath = "/General/Images/Header/";
        #endregion

	
		
		#region Private Methods
		/// <summary>
		/// The Page_Load method calls the GetHeaderImage method.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
        /// 

        public bool isSaltAdmin = false;
		protected void Page_Load(object sender, System.EventArgs e)
		{


            if (UserContext.UserData.UserType == UserType.SaltAdmin)
            {
                isSaltAdmin = true;
            }

            if (!IsPostBack)
            {
                PaintOrgImage();
            }

		}
        private void PaintOrgImage()
        {
            //1. Get the image name from the UserContext.
            string strImageName = UserContext.UserData.OrgLogo;


            // GetOrganisation(SqlString LangCode, SqlInt32 orgID)
            // UserContext.UserData.OrgID
            BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            DataTable dtOrganisation = objOrganisation.GetOrganisation(Request.Cookies["currentCulture"].Value, UserContext.UserData.OrgID);

            if (dtOrganisation.Rows.Count > 0)
            {
                strImageName = dtOrganisation.Rows[0]["Logo"].ToString();
                if (strImageName.Length > 4)
                {

                    this.imgHeader.Src = "/General/Images/Header/" + strImageName;
                    this.imgHeaderAdmin.Src = "/General/Images/Header/" + strImageName;
                    return;
                }
            }

        }
        #endregion

    }
}