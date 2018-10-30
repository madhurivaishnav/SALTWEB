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
namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for ViewErrorLog.
	/// </summary>
	public partial class ViewErrorLog : System.Web.UI.Page
	{

        /// <summary>
        /// Datagrid of results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid dgErrorLogResults;

        /// <summary>
        /// Label for errors 
        /// </summary>
		protected System.Web.UI.WebControls.Label lblError;
       
        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblErrorLogID;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblSource;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblModule;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblFunction;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblCode;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblMessage;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblStackTrace;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblErrorLevel;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblErrorStatus;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblResolution;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblDateCreated;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label lblDateUpdated;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhErrorLog;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhErrorEntry;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtErrorLogID;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtSource;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtModule;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtFunction;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtCode;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtMessage;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtStackTrace;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtErrorLevel;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtErrorStatus;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtResolution;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtDateCreated;
        /// <summary>
        /// 
        /// </summary>
        protected System.Web.UI.WebControls.Label txtDateUpdated;

        /// <summary>
        /// 
        /// </summary>
        private const int m_intID=0;
        private const int m_intErrorLevel=1;
        private const int m_intMessage=2;
        private const int m_intSource=3;
        private const int m_intErrorStatusDesc=4;
        private const int m_intErrorLevelDesc=5;
        private const int m_intResolution=6;
        
        /// <summary>
        /// Table row for pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

		#region Private Methods
			/// <summary>
			/// Show the results from the error log report as the page loads.
			/// </summary>
			/// <remarks>
			/// Assumptions:None
			/// Notes:
			/// Author: Peter Kneale, 05/02/2004
			/// Changes:
			/// </remarks>
			/// <param name="sender">-</param>
			/// <param name="e">-</param>
			protected void Page_Load(object sender, System.EventArgs e)
			{
				if(!Page.IsPostBack)
				{
					BindGrid();
				}
			}

            private void BindGrid()
            {
                BusinessServices.Error objError = new BusinessServices.Error();
                
                // Get datatable of errors
                DataTable dtbErrorLog = objError.GetReport(UserContext.UserData.OrgID);
                
                // Bind to the grid
                dgErrorLogResults.DataKeyField      = "ErrorLogID";
                dgErrorLogResults.DataSource        = dtbErrorLog;
                dgErrorLogResults.DataBind();
            }
		
		#endregion

        

        /// <summary>
        /// Fired as data is bound to the grid
        /// </summary>
        /// <param name="sender">sender</param>
        /// <param name="e">e</param>
        private void dgErrorLogResults_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            // If its data thats being bound
            if (e.Item.ItemType == ListItemType.EditItem)
            {
                // Get listbox and texbox for Error Status
                ListBox lstErrorStatus = (ListBox) e.Item.Cells[m_intErrorStatusDesc].FindControl("lstErrorStatus");
                TextBox txtErrorStatus = (TextBox)e.Item.FindControl("txtErrorStatus");
                string strErrorStatusID = txtErrorStatus.Text;
                    
                // Get listbox and texbox for Error Level
                ListBox lstErrorLevel = (ListBox) e.Item.Cells[m_intErrorStatusDesc].FindControl("lstErrorLevel");
                TextBox txtErrorLevel = (TextBox)e.Item.FindControl("txtErrorLevel");
                string strErrorLevelID = txtErrorLevel.Text;
                   
                // Bind the controls to the datatables
                lstErrorStatus.DataSource=BusinessServices.Error.ErrorStatusList();
                lstErrorStatus.DataBind();

                // Bind the controls to the datatables
                lstErrorLevel.DataSource=BusinessServices.Error.ErrorLevelList();
                lstErrorLevel.DataBind();	
                
                // Select the appropriate values
                lstErrorStatus.Items.FindByValue(strErrorStatusID).Selected=true;

                // Select the appropriate values
                lstErrorLevel.Items.FindByValue(strErrorLevelID).Selected=true;
			}   

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.EditItem)
            {
                // remove html code
                e.Item.Cells[m_intMessage].Text=Server.HtmlEncode(((DataBoundLiteralControl) e.Item.Cells[m_intMessage].Controls[0]).Text);
            }
                
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.EditItem)
            {
                
                ErrorLevel x = (ErrorLevel) Int32.Parse (((DataBoundLiteralControl) e.Item.Cells[m_intErrorLevel].Controls[0]).Text);
                switch (x)
                {
                    case ErrorLevel.High:
                    {
                        e.Item.CssClass="ErrorRow_High";
                        break;
                    }
                    case ErrorLevel.Medium:
                    {
                        e.Item.CssClass="ErrorRow_Medium";
                        break;
                    }
                    case ErrorLevel.Low:
                    {
                        e.Item.CssClass="ErrorRow_Low";
                        break;
                    }
                    case ErrorLevel.Warning:
                    {
                        e.Item.CssClass="ErrorRow_Warning";
                        break;
                    }
                    case ErrorLevel.InformationOnly:
                    {
                        e.Item.CssClass="ErrorRow_InformationOnly";
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                
                    

                
              
            }
        }

        private void Edit (DataGridCommandEventArgs e)
        {
            this.dgErrorLogResults.EditItemIndex = (int)e.Item.ItemIndex;
            this.BindGrid();            
        }
        private void View(DataGridCommandEventArgs e)
        {
            // Collect the new values
            int intID = (int)this.dgErrorLogResults.DataKeys[e.Item.ItemIndex];

            // Get the error entry
            BusinessServices.Error objError = new BusinessServices.Error();
            DataTable dtbError = objError.GetError(intID, UserContext.UserData.OrgID);
            
            // Populate the values
            this.lblErrorLogID.Text     = Server.HtmlEncode(dtbError.Rows[0]["ErrorLogID"].ToString());
            this.lblCode.Text           = Server.HtmlEncode(dtbError.Rows[0]["Code"].ToString());
            this.lblSource.Text         = Server.HtmlEncode(dtbError.Rows[0]["Source"].ToString());
            this.lblModule.Text         = Server.HtmlEncode(dtbError.Rows[0]["Module"].ToString());
            this.lblFunction.Text       = Server.HtmlEncode(dtbError.Rows[0]["Function"].ToString());
            this.lblMessage.Text        = Server.HtmlEncode(dtbError.Rows[0]["Message"].ToString());
            this.lblStackTrace.Text     = Server.HtmlEncode(dtbError.Rows[0]["StackTrace"].ToString());
            this.lblErrorLevel.Text     = Server.HtmlEncode(dtbError.Rows[0]["ErrorLevelDescription"].ToString());
            this.lblErrorStatus.Text    = Server.HtmlEncode(dtbError.Rows[0]["ErrorStatusDescription"].ToString());
            this.lblResolution.Text     = Server.HtmlEncode(dtbError.Rows[0]["Resolution"].ToString());
            this.lblDateCreated.Text    = Server.HtmlEncode(dtbError.Rows[0]["DateCreated"].ToString());
            this.lblDateUpdated.Text    = Server.HtmlEncode(dtbError.Rows[0]["DateUpdated"].ToString());
            
            // Show the single entry and hide the log
            this.plhErrorLog.Visible=false;
            this.plhErrorEntry.Visible=true;
        }
        private void Update(DataGridCommandEventArgs e)
        {
            // Collect the new values
            int intID = (int)this.dgErrorLogResults.DataKeys[e.Item.ItemIndex];
            string strResolution = ((TextBox)e.Item.FindControl("txtResolution")).Text;
            string strErrorStatus = ((ListBox)e.Item.FindControl("lstErrorStatus")).SelectedValue;
            string strErrorLevel = ((ListBox)e.Item.FindControl("lstErrorLevel")).SelectedValue;
            
            BusinessServices.Error objError = new BusinessServices.Error();
            
            // Update the error
            objError.Update(intID,Int32.Parse(strErrorLevel),Int32.Parse(strErrorStatus),strResolution);

            // Deselect the row
            this.dgErrorLogResults.EditItemIndex = -1;
            this.BindGrid();
        }
        
        private void dgErrorLogResults_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName.ToLower())
            {
                case "edit":
                {
                    Edit(e);
                    break;
                }
                case "update":
                {
                    Update(e);         
                    break;
                }
                case "view":
                {
                    View(e);         
                    break;
                }
                case "cancel":
                {
                    this.dgErrorLogResults.EditItemIndex = -1;
                    this.BindGrid();
                    break;
                }
            } //switch
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {    
            this.dgErrorLogResults.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgErrorLogResults_ItemCommand);
            this.dgErrorLogResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgErrorLogResults_ItemDataBound);

        }
        #endregion
    }
}
