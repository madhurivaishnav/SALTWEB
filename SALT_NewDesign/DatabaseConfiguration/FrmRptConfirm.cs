using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using System.Configuration;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
    /// <summary>
    /// Complete form
    /// </summary>
	public class FrmRptConfirm : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
		private System.Windows.Forms.Label lblGuide2;
		private System.Windows.Forms.Label lblSQLServer;
		private System.Windows.Forms.Label lblDatabase;
		private System.Windows.Forms.Label lblDboLogin;
		private System.Windows.Forms.Label lblWebSQLLogin;
		private System.Windows.Forms.Label lblAdministrator;
		private System.Windows.Forms.Label lblSQLServerText;
		private System.Windows.Forms.Label lblDatabaseText;
		private System.Windows.Forms.Label lblDboLoginText;
		private System.Windows.Forms.Label lblWebSQLLoginText;
		private System.Windows.Forms.Label lblAdministratorText;

		private System.ComponentModel.IContainer components = null;

		private static FrmRptConfirm form;

        /// <summary>
        /// 
        /// </summary>
		public static FrmRptConfirm Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmRptConfirm();
				}
				return form;
			}
		}
        /// <summary>
        /// This call is required by the Windows Form Designer.
        /// </summary>
		public FrmRptConfirm()
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
			this.lblSQLServer = new System.Windows.Forms.Label();
			this.lblDatabase = new System.Windows.Forms.Label();
			this.lblDboLogin = new System.Windows.Forms.Label();
			this.lblWebSQLLogin = new System.Windows.Forms.Label();
			this.lblAdministrator = new System.Windows.Forms.Label();
			this.lblSQLServerText = new System.Windows.Forms.Label();
			this.lblDatabaseText = new System.Windows.Forms.Label();
			this.lblDboLoginText = new System.Windows.Forms.Label();
			this.lblWebSQLLoginText = new System.Windows.Forms.Label();
			this.lblAdministratorText = new System.Windows.Forms.Label();
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
			this.lblTitle.Size = new System.Drawing.Size(144, 19);
			this.lblTitle.Text = "Confirm Configuration";
			// 
			// lblGuide
			// 
			this.lblGuide.AutoSize = false;
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(508, 32);
			this.lblGuide.Text = "The installer is ready to configure your database connection and create database " +
				"schema if required. It may take several minutes.";
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
			this.lblGuide2.Size = new System.Drawing.Size(352, 23);
			this.lblGuide2.TabIndex = 5;
			this.lblGuide2.Text = "Click \"Next\" to start the configuration.";
			// 
			// lblSQLServer
			// 
			this.lblSQLServer.Location = new System.Drawing.Point(24, 168);
			this.lblSQLServer.Name = "lblSQLServer";
			this.lblSQLServer.Size = new System.Drawing.Size(100, 16);
			this.lblSQLServer.TabIndex = 6;
			this.lblSQLServer.Text = "SQL Server:";
			// 
			// lblDatabase
			// 
			this.lblDatabase.Location = new System.Drawing.Point(24, 192);
			this.lblDatabase.Name = "lblDatabase";
			this.lblDatabase.Size = new System.Drawing.Size(100, 16);
			this.lblDatabase.TabIndex = 7;
			this.lblDatabase.Text = "Database:";
			// 
			// lblDboLogin
			// 
			this.lblDboLogin.Location = new System.Drawing.Point(24, 224);
			this.lblDboLogin.Name = "lblDboLogin";
			this.lblDboLogin.Size = new System.Drawing.Size(100, 16);
			this.lblDboLogin.TabIndex = 8;
			this.lblDboLogin.Text = "Dbo Login:";
			// 
			// lblWebSQLLogin
			// 
			this.lblWebSQLLogin.Location = new System.Drawing.Point(24, 256);
			this.lblWebSQLLogin.Name = "lblWebSQLLogin";
			this.lblWebSQLLogin.Size = new System.Drawing.Size(100, 16);
			this.lblWebSQLLogin.TabIndex = 9;
			this.lblWebSQLLogin.Text = "Web SQL Login:";
			// 
			// lblAdministrator
			// 
			this.lblAdministrator.Location = new System.Drawing.Point(24, 288);
			this.lblAdministrator.Name = "lblAdministrator";
			this.lblAdministrator.TabIndex = 10;
			this.lblAdministrator.Text = "Administrator:";
			// 
			// lblSQLServerText
			// 
			this.lblSQLServerText.AutoSize = true;
			this.lblSQLServerText.Location = new System.Drawing.Point(160, 168);
			this.lblSQLServerText.Name = "lblSQLServerText";
			this.lblSQLServerText.Size = new System.Drawing.Size(38, 16);
			this.lblSQLServerText.TabIndex = 11;
			this.lblSQLServerText.Text = "Server";
			// 
			// lblDatabaseText
			// 
			this.lblDatabaseText.AutoSize = true;
			this.lblDatabaseText.Location = new System.Drawing.Point(160, 192);
			this.lblDatabaseText.Name = "lblDatabaseText";
			this.lblDatabaseText.Size = new System.Drawing.Size(53, 16);
			this.lblDatabaseText.TabIndex = 13;
			this.lblDatabaseText.Text = "Database";
			// 
			// lblDboLoginText
			// 
			this.lblDboLoginText.AutoSize = true;
			this.lblDboLoginText.Location = new System.Drawing.Point(160, 224);
			this.lblDboLoginText.Name = "lblDboLoginText";
			this.lblDboLoginText.Size = new System.Drawing.Size(52, 16);
			this.lblDboLoginText.TabIndex = 14;
			this.lblDboLoginText.Text = "Dbo login";
			// 
			// lblWebSQLLoginText
			// 
			this.lblWebSQLLoginText.AutoSize = true;
			this.lblWebSQLLoginText.Location = new System.Drawing.Point(160, 256);
			this.lblWebSQLLoginText.Name = "lblWebSQLLoginText";
			this.lblWebSQLLoginText.Size = new System.Drawing.Size(58, 16);
			this.lblWebSQLLoginText.TabIndex = 15;
			this.lblWebSQLLoginText.Text = "Web Login";
			// 
			// lblAdministratorText
			// 
			this.lblAdministratorText.AutoSize = true;
			this.lblAdministratorText.Location = new System.Drawing.Point(160, 288);
			this.lblAdministratorText.Name = "lblAdministratorText";
			this.lblAdministratorText.Size = new System.Drawing.Size(36, 16);
			this.lblAdministratorText.TabIndex = 16;
			this.lblAdministratorText.Text = "Admin";
			// 
			// FrmRptConfirm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.lblAdministratorText);
			this.Controls.Add(this.lblWebSQLLoginText);
			this.Controls.Add(this.lblDboLoginText);
			this.Controls.Add(this.lblDatabaseText);
			this.Controls.Add(this.lblSQLServerText);
			this.Controls.Add(this.lblAdministrator);
			this.Controls.Add(this.lblWebSQLLogin);
			this.Controls.Add(this.lblDboLogin);
			this.Controls.Add(this.lblDatabase);
			this.Controls.Add(this.lblSQLServer);
			this.Controls.Add(this.lblGuide2);
			this.Name = "FrmRptConfirm";
			this.Text = " Reporting Database Configuration";
			this.Activated += new System.EventHandler(this.FrmRptConfirm_Activated);
			this.Controls.SetChildIndex(this.lblGuide2, 0);
			this.Controls.SetChildIndex(this.lblSQLServer, 0);
			this.Controls.SetChildIndex(this.lblDatabase, 0);
			this.Controls.SetChildIndex(this.lblDboLogin, 0);
			this.Controls.SetChildIndex(this.lblWebSQLLogin, 0);
			this.Controls.SetChildIndex(this.lblAdministrator, 0);
			this.Controls.SetChildIndex(this.lblSQLServerText, 0);
			this.Controls.SetChildIndex(this.pnlTitle, 0);
			this.Controls.SetChildIndex(this.lblGuide, 0);
			this.Controls.SetChildIndex(this.btnBack, 0);
			this.Controls.SetChildIndex(this.btnCancel, 0);
			this.Controls.SetChildIndex(this.btnNext, 0);
			this.Controls.SetChildIndex(this.lblDatabaseText, 0);
			this.Controls.SetChildIndex(this.lblDboLoginText, 0);
			this.Controls.SetChildIndex(this.lblWebSQLLoginText, 0);
			this.Controls.SetChildIndex(this.lblAdministratorText, 0);
			this.pnlTitle.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void btnNext_Click(object sender, System.EventArgs e)
		{
			 FrmRptProgress.Form.ShowDialog();
		}

		private void FrmRptConfirm_Activated(object sender, System.EventArgs e)
		{
			GetConfiguration();
		}

		private void GetConfiguration()
		{
		
			string newVersion= ConfigurationSettings.AppSettings["NewVersionID"];

			this.lblSQLServerText.Text = ApplicationState.RptServerName;

			this.lblDatabaseText.Text = ApplicationState.RptDatabaseName;
			if (ApplicationState.RptInstallVersion == "-")  //Install new schema
			{
				this.lblDatabaseText.Text  += " (Empty database, install Schema)";
			}
			else if (ApplicationState.RptInstallVersion == "") //Use existng Database
			{
				this.lblDatabaseText.Text  +=  " (Use existng Database)";
			}
			else
			{
				this.lblDatabaseText.Text  +=  " (Upgrade to " + newVersion+ " )";
			}

            //MessageBox.Show("userType:" + ApplicationState.RptWebUserType.ToString());
            if (ApplicationState.RptDboUserType == SqlUserType.IntegratedUser)
			{
				this.lblDboLoginText.Text = "Login User in this machine (NT Intergrated Security)";
			}
			else
			{
				this.lblDboLoginText.Text = ApplicationState.RptDboUsername +" (SQL User)";
			}

			if (ApplicationState.RptWebUserType  == SqlUserType.IntegratedUser)
			{
				this.lblWebSQLLoginText.Text =ApplicationState.RptWebNTUsername + " (NT Intergrated Security)";
			}
			else
			{
				this.lblWebSQLLoginText.Text = ApplicationState.RptWebUsername +" (SQL User)";
			}
			
			if (ApplicationState.RptWebGrantPermission)
			{
				this.lblWebSQLLoginText.Text += " (Grant Access Permission)";
			}
			else
			{
				this.lblWebSQLLoginText.Text += " (Use existing Access Permission)";
			}
			
			if (ApplicationState.RptInstallVersion=="-")
			{
				this.lblAdministratorText.Text = ApplicationState.RptAdminUsername;
			}
			else
			{
				this.lblAdministratorText.Text = "N/A";
			}
		}

		private void btnBack_Click(object sender, System.EventArgs e)
		{
			if (ApplicationState.RptInstallVersion=="-")
			{
				FrmReportAdmin.Form.Show();
			}
			else
			{
				FrmSelectRptWebSQLUser.Form.Show();
			}

		}

	}
}

