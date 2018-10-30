using System;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;

using Localization;

namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
    /// <summary>
    ///		Summary description for UserMenu.
    /// </summary>
    public partial class UserMenu : System.Web.UI.UserControl
    {
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
                    phdOrgImage.Visible = true;
                    //2. Set the src for the image.
                    this.imgHeader.Src = "/General/Images/Header/" + strImageName;
                    this.imgHeaderAdmin.Src = "/General/Images/Header/" + strImageName;
                    return;
                }
            }

            this.phdOrgImage.Visible = false;

        }

        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
        }

        /// <summary>
        ///		Required method for Designer support - do not modify
        ///		the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
        }
        #endregion
    }
}
