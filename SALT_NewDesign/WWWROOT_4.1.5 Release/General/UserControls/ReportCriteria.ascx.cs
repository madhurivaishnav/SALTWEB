namespace Bdw.Application.Salt.Web.General.UserControls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
    using System.Collections.Specialized;
    using Localization;
    using Bdw.Application.Salt;
    using Bdw.Application.Salt.Utilities;
    using Bdw.Application.Salt.Web.Utilities;
    /// <summary>
	///		Summary description for ReportCriteria.
	/// </summary>
	public partial class ReportCriteria : System.Web.UI.UserControl
	{
        /// <summary>
        /// Table containing the criteria
        /// </summary>
        protected System.Web.UI.WebControls.Table tblCriteriaExpanded;

        /// <summary>
        /// Table containing just a heading
        /// </summary>
        protected System.Web.UI.WebControls.Table tblCriteriaCompressed;

        /// <summary>
        /// Name Value collection of all criteria values
        /// </summary>
        public NameValueCollection Criteria = new NameValueCollection();


        /// <summary>
        /// Alternate rows indicator
        /// </summary>
        private bool m_blnAlternateRow = false;
            

        /// <summary>
        /// Page Load event. 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
           
		}

        /// <summary>
        /// This method renders the contents of the name value collection
        /// into the criteria table 
        /// </summary>
        public void Render()
        {
            ViewState.Add("Criteria",Criteria);
            TableRow tblRow;
            TableCell tclName;
            TableCell tclValue;

            // If criteria has been supplied
            if (Criteria!=null)
            {
                // For all criteria
                for (int intKey=0;intKey!=Criteria.Keys.Count;intKey++)
                {
                    // New Row and Cells
                    tblRow = new TableRow();
                    tclName = new TableCell();
                    tclValue = new TableCell();
                    
                    tclName.Width=System.Web.UI.WebControls.Unit.Percentage(30);
                    tclValue.Width=System.Web.UI.WebControls.Unit.Percentage(70);

                    // Get Key name and value
                    tclName.Text = Criteria.GetKey(intKey);
                    tclValue.Text = Criteria[intKey];
                    if (tclValue.Text.Length==0)
                    {
                        tclValue.Text=ResourceManager.GetString("lblAny");
                    }

                    // Add Columns To the Row
                    tblRow.Cells.Add (tclName);
                    tblRow.Cells.Add (tclValue);
                    
                    // Alternate the rows
                    if (m_blnAlternateRow)
                    {
                        m_blnAlternateRow = false;
                        tblRow.CssClass="TableRow1";
                    }
                    else
                    {
                        m_blnAlternateRow = true;
                        tblRow.CssClass="TableRow2";
                    }
                    this.tblCriteriaExpanded.Rows.Add(tblRow);
                }
            }
        }

        /// <summary>
        /// Add courses to the criteria list via a csv list of course id's
        /// </summary>
        /// <param name="strCourseIDs">Csv list of courses</param>
        public void AddCourses (string strCourseIDs)
        {
            // Local variables
            string[] astrCourseIDs = strCourseIDs.Split(',');
            string strCourseNames="";
          
            // Get Course List
            BusinessServices.Course objCourse = new BusinessServices.Course();
            DataTable dtbCourse = objCourse.GetCourseList(UserContext.UserData.OrgID);
            // Loop through all courses
            foreach (DataRow drwCourse in dtbCourse.Rows)
            {
                // loop through all required courses
                for (int intCourse=0;intCourse<=astrCourseIDs.GetUpperBound(0);intCourse++)
                {
                    // if they match
                    if (astrCourseIDs[intCourse] == drwCourse["CourseID"].ToString())
                    {
                         // Add it to the string.
                         strCourseNames += drwCourse["Name"].ToString();
                         strCourseNames += ", ";
                    }
                }
            }
            // Remove trailing command if it exists and replace with a full stop
            if (strCourseNames.Length>0)
            {
                strCourseNames = strCourseNames.Substring(0,strCourseNames.Length-2);
                strCourseNames += ".";
            }

            // add to the criteria list
            this.Criteria.Add(ResourceManager.GetString("lblCourses"),strCourseNames);
        }



		/// <summary>
		/// Add Policies to the criteria list via a csv list of Policy id's
		/// </summary>
		/// <param name="strPolicyIDs">Csv list of Policies</param>
		public void AddPolicies (string strPolicyIDs,int orgID)
		{
			// Local variables
			string[] astrPolicyIDs = strPolicyIDs.Split(',');
			string strPolicyNames="";
          
			// Get Policy List
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			DataTable dtbPolicy = objPolicy.GetPolicyListAccessableToOrg(orgID);
			// Loop through all Policies
			foreach (DataRow drwPolicy in dtbPolicy.Rows)
			{
				// loop through all required Policies
				for (int intPolicy=0;intPolicy<=astrPolicyIDs.GetUpperBound(0);intPolicy++)
				{
					// if they match
					if (astrPolicyIDs[intPolicy] == drwPolicy["PolicyID"].ToString())
					{
						// Add it to the string.
						strPolicyNames += drwPolicy["PolicyName"].ToString();
						strPolicyNames += ", ";
					}
				}
			}
			// Remove trailing command if it exists and replace with a full stop
			if (strPolicyNames.Length>0)
			{
				strPolicyNames = strPolicyNames.Substring(0,strPolicyNames.Length-2);
				strPolicyNames += ".";
			}

			// add to the criteria list
			this.Criteria.Add(ResourceManager.GetString("lblPolicies"),strPolicyNames);
		}





        /// <summary>
        /// Add units to the criteria list via a csv list of course id's
        /// </summary>
        /// <param name="strUnitIDs">Csv list of units.</param>
        public void AddUnits (string strUnitIDs)
        {
            // Local variables
            if (strUnitIDs!= null && strUnitIDs.Length>0)
            {
                string[] astrUnitIDs = strUnitIDs.Split(',');
                string strUnitNames="";
          
                // Get Unit List
                BusinessServices.Unit objUnit = new BusinessServices.Unit();
                DataTable dtbUnit;
                // Loop through all Units
                foreach (string strUnitID in astrUnitIDs)
                {
                    dtbUnit = objUnit.GetUnit(Int32.Parse(strUnitID));
                    strUnitNames += dtbUnit.Rows[0]["Pathway"].ToString();
                    strUnitNames += "<BR>";
                }

                // Remove trailing command if it exists and replace with a full stop
                if (strUnitNames.Length>0)
                {
                    strUnitNames = strUnitNames.Substring(0,strUnitNames.Length-2);
                    strUnitNames += ".";
                }

                // add to the criteria list
                this.Criteria.Add(ResourceManager.GetString("lblUnits"),strUnitNames);
            }
            else
            {
                // add to the criteria list
                this.Criteria.Add(ResourceManager.GetString("lblUnits"),ResourceManager.GetString("lblAny"));
            }
        }

        /// <summary>
        /// Add courses to the criteria list via a csv list of course id's
        /// </summary>
        /// <param name="strClassifications">Csv list of classifications</param>
        public void AddClassifications (string strClassifications)
        {
            // Local variables
            string[] astrClassificationIDs = strClassifications.Split(',');
            string strClassificationNames="";
            int intClassificationType;
            string strClassificationType;

             // Get Classification Type for the user's organisation
            BusinessServices.Classification objClassification = new BusinessServices.Classification();
            DataTable dtbClassificationType = objClassification.GetClassificationType(Utilities.UserContext.UserData.OrgID);
            intClassificationType = (int)dtbClassificationType.Rows[0]["ClassificationTypeID"];
            strClassificationType = dtbClassificationType.Rows[0]["Name"].ToString();
            
            
            // Get Classification List
            DataTable dtbClassification = objClassification.GetClassificationList(intClassificationType);
            // Loop through all Classifications
            foreach (DataRow drwClassification in dtbClassification.Rows)
            {
                // loop through all required Classifications
                for (int intClassification=0;intClassification<=astrClassificationIDs.GetUpperBound(0);intClassification++)
                {
                    // if they match
                    if (astrClassificationIDs[intClassification] == drwClassification["ClassificationID"].ToString())
                    {
                        // Add it to the string.
                        strClassificationNames += drwClassification["Value"].ToString();
                        strClassificationNames += ", ";
                    }
                }
            }

            // Remove trailing command if it exists and replace with a full stop
            if (strClassificationNames.Length>0)
            {
                strClassificationNames = strClassificationNames.Substring(0,strClassificationNames.Length-2);
                strClassificationNames += ".";
            }

            // add to the criteria list
            this.Criteria.Add(strClassificationType,strClassificationNames);
            
        }

		#region Web Form Designer generated code
        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e"></param>
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
