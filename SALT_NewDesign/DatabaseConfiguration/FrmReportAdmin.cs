using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
    /// <summary>
    /// Form Application Admin
    /// </summary>
	public class FrmReportAdmin : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
        /// <summary>
        /// Label Guide
        /// </summary>
		private System.Windows.Forms.Label lblGuide2;
        /// <summary>
        /// Password box
        /// </summary>
		private System.Windows.Forms.TextBox txtPassword;
        /// <summary>
        /// Username
        /// </summary>
		private System.Windows.Forms.TextBox txtUsername;
        /// <summary>
        /// Password
        /// </summary>
		private System.Windows.Forms.Label lblPassword;
        /// <summary>
        /// Username label
        /// </summary>
		private System.Windows.Forms.Label lblUsername;
        /// <summary>
        /// container
        /// </summary>
		private System.ComponentModel.IContainer components = null;
        /// <summary>
        /// Confirm password
        /// </summary>
		private System.Windows.Forms.TextBox txtConfirmPassword;
        /// <summary>
        /// COnfirm password label
        /// </summary>
		private System.Windows.Forms.Label lblConfirmPassword;


		private static FrmReportAdmin form;

        /// <summary>
        /// FrmApplicationAdmin
        /// </summary>
		public static FrmReportAdmin Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmReportAdmin();
				}
				return form;
			}
		}

        /// <summary>
        /// This call is required by the Windows Form Designer.
        /// </summary>
		public FrmReportAdmin()
		{
			// This call is required by the Windows Form Designer.
			InitializeComponent();

			// TODO: Add any initialization after the InitializeComponent call
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.lblGuide2 = new System.Windows.Forms.Label();
			this.txtPassword = new System.Windows.Forms.TextBox();
			this.txtUsername = new System.Windows.Forms.TextBox();
			this.lblPassword = new System.Windows.Forms.Label();
			this.lblUsername = new System.Windows.Forms.Label();
			this.txtConfirmPassword = new System.Windows.Forms.TextBox();
			this.lblConfirmPassword = new System.Windows.Forms.Label();
			this.pnlTitle.SuspendLayout();
			this.SuspendLayout();
			// 
			// pnlTitle
			// 
			this.pnlTitle.Name = "pnlTitle";
			// 
			// lblTitle
			// 
			this.lblTitle.Name = "lblTitle";
			this.lblTitle.Size = new System.Drawing.Size(278, 19);
			this.lblTitle.Text = "Select Initial Reporting Sever Administrator";
			// 
			// lblGuide
			// 
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(344, 16);
			this.lblGuide.Text = "Please select a user account to be used as the Initial Administrator. ";
			// 
			// btnBack
			// 
			this.btnBack.Name = "btnBack";
			this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.Name = "btnCancel";
			// 
			// btnNext
			// 
			this.btnNext.Name = "btnNext";
			this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
			// 
			// lblGuide2
			// 
			this.lblGuide2.Location = new System.Drawing.Point(24, 128);
			this.lblGuide2.Name = "lblGuide2";
			this.lblGuide2.Size = new System.Drawing.Size(472, 40);
			this.lblGuide2.TabIndex = 5;
			this.lblGuide2.Text = "This user will be the only user to have access to reporting server through the we" +
				"b site until additional users have been assigned appropriate rights.";
			// 
			// txtPassword
			// 
			this.txtPassword.Location = new System.Drawing.Point(152, 216);
			this.txtPassword.MaxLength = 50;
			this.txtPassword.Name = "txtPassword";
			this.txtPassword.PasswordChar = '*';
			this.txtPassword.Size = new System.Drawing.Size(200, 20);
			this.txtPassword.TabIndex = 18;
			this.txtPassword.Text = "";
			// 
			// txtUsername
			// 
			this.txtUsername.Location = new System.Drawing.Point(152, 184);
			this.txtUsername.MaxLength = 50;
			this.txtUsername.Name = "txtUsername";
			this.txtUsername.Size = new System.Drawing.Size(200, 20);
			this.txtUsername.TabIndex = 17;
			this.txtUsername.Text = "";
			// 
			// lblPassword
			// 
			this.lblPassword.Location = new System.Drawing.Point(24, 216);
			this.lblPassword.Name = "lblPassword";
			this.lblPassword.Size = new System.Drawing.Size(72, 21);
			this.lblPassword.TabIndex = 16;
			this.lblPassword.Text = "&Password:";
			// 
			// lblUsername
			// 
			this.lblUsername.Location = new System.Drawing.Point(24, 184);
			this.lblUsername.Name = "lblUsername";
			this.lblUsername.Size = new System.Drawing.Size(72, 21);
			this.lblUsername.TabIndex = 15;
			this.lblUsername.Text = "User &name:";
			// 
			// txtConfirmPassword
			// 
			this.txtConfirmPassword.Location = new System.Drawing.Point(152, 248);
			this.txtConfirmPassword.MaxLength = 50;
			this.txtConfirmPassword.Name = "txtConfirmPassword";
			this.txtConfirmPassword.PasswordChar = '*';
			this.txtConfirmPassword.Size = new System.Drawing.Size(200, 20);
			this.txtConfirmPassword.TabIndex = 20;
			this.txtConfirmPassword.Text = "";
			// 
			// lblConfirmPassword
			// 
			this.lblConfirmPassword.Location = new System.Drawing.Point(24, 248);
			this.lblConfirmPassword.Name = "lblConfirmPassword";
			this.lblConfirmPassword.Size = new System.Drawing.Size(104, 21);
			this.lblConfirmPassword.TabIndex = 19;
			this.lblConfirmPassword.Text = "Confirm Password:";
			// 
			// FrmReportAdmin
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.txtConfirmPassword);
			this.Controls.Add(this.lblConfirmPassword);
			this.Controls.Add(this.txtPassword);
			this.Controls.Add(this.txtUsername);
			this.Controls.Add(this.lblPassword);
			this.Controls.Add(this.lblUsername);
			this.Controls.Add(this.lblGuide2);
			this.Name = "FrmReportAdmin";
			this.Text = " Database Configuration";
			this.Controls.SetChildIndex(this.lblGuide2, 0);
			this.Controls.SetChildIndex(this.pnlTitle, 0);
			this.Controls.SetChildIndex(this.lblGuide, 0);
			this.Controls.SetChildIndex(this.btnBack, 0);
			this.Controls.SetChildIndex(this.btnCancel, 0);
			this.Controls.SetChildIndex(this.btnNext, 0);
			this.Controls.SetChildIndex(this.lblUsername, 0);
			this.Controls.SetChildIndex(this.lblPassword, 0);
			this.Controls.SetChildIndex(this.txtUsername, 0);
			this.Controls.SetChildIndex(this.txtPassword, 0);
			this.Controls.SetChildIndex(this.lblConfirmPassword, 0);
			this.Controls.SetChildIndex(this.txtConfirmPassword, 0);
			this.pnlTitle.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void btnBack_Click(object sender, System.EventArgs e)
		{
			FrmSelectRptWebSQLUser.Form.ShowDialog();
		}

		private void btnNext_Click(object sender, System.EventArgs e)
		{
			if (SaveState())
			{
				 FrmRptConfirm.Form.ShowDialog();
			}
			else
			{
				this.ShowDialog();
			}
		}

		/// <summary>
		/// Check whether the form data are valid
		/// 1. User name and password are required
		/// 2. Password and confirm password must be the same
		/// </summary>
		/// <returns></returns>
		private bool SaveState()
		{
			string userName, password, confirmPassword;
			bool isValid = true;

			userName = this.txtUsername.Text.Trim();
			password = this.txtPassword.Text.Trim();
			confirmPassword = this.txtConfirmPassword.Text.Trim();

			if (userName.Length ==0 || password.Length==0)
			{
				MessageBox.Show("User name and password are required.","Invalid Data");
				isValid = false;
			}
			else if (password!=confirmPassword)
			{
				MessageBox.Show("The password you typed don't match.","Invalid Data");
				isValid = false;
			}
			
			if (isValid)
			{
				ApplicationState.RptAdminUsername = userName;
				ApplicationState.RptAdminPassword = password;
			}
			return isValid;
		}
	}
}

