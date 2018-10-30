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
using System.Data.SqlClient;
using System.Xml;

namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for DeadLockManagement_PartA.
	/// </summary>
	public partial class DeadLockManagement_PartA : System.Web.UI.Page
	{
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
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
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

		}
		#endregion

		protected void btnStartPartA_Click(object sender, System.EventArgs e)
		{
			DeadLockManagement.CreateDeadlock("prcDeadLock_PartA", QueryType.NonQuery); 
			lblResult.Text = "NonQuery Executed.";
		}

		protected void btnScalar_Click(object sender, System.EventArgs e)
		{
			object retVal = DeadLockManagement.CreateDeadlock("prcDeadLock_PartA", QueryType.Scalar); 
			lblResult.Text = "Scalar Query Complete. Returned: " + retVal.ToString();		
		}

		protected void btnReader_Click(object sender, System.EventArgs e)
		{
			object retVal = DeadLockManagement.CreateDeadlock("prcDeadLock_PartA", QueryType.Reader); 
			lblResult.Text = "Reader Query Complete. Returned: " + (String)retVal;		
		}

		protected void btnXmlReader_Click(object sender, System.EventArgs e)
		{
			object retVal = DeadLockManagement.CreateDeadlock("prcDeadLock_PartA", QueryType.XMLReader); 
			lblResult.Text = "XML Reader Query Complete. Returned: " + (String)retVal;		
		
		}

		protected void btnDataSet_Click(object sender, System.EventArgs e)
		{
			object retVal = DeadLockManagement.CreateDeadlock("prcDeadLock_PartA", QueryType.DataSet); 
			DataSet ds = (DataSet)retVal;
			string strResult = ds.GetXml();
			lblResult.Text = "DataSet Query Complete. Returned: " + strResult;		
		
		}

		protected void btnDataTable_Click(object sender, System.EventArgs e)
		{
			object retVal = DeadLockManagement.CreateDeadlock("prcDeadLock_PartA", QueryType.DataTable); 
			DataTable dt = (DataTable)retVal;
			string strResult = dt.Rows[0].ItemArray[0].ToString();
			lblResult.Text = "DataTable Query Complete. Returned: " + strResult;		
		}
	}
}
