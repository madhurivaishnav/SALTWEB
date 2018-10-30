using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using System.Configuration;
using System.Reflection;
using System.IO;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
    /// <summary>
    /// FrmWelcome
    /// </summary>
	public class FrmWelcome : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
        /// <summary>
        /// Components 
        /// </summary>
		private System.ComponentModel.IContainer components = null;
        /// <summary>
        /// Action label
        /// </summary>
        private System.Windows.Forms.Label lblAction;
        /// <summary>
        /// Web farm label
        /// </summary>
        private System.Windows.Forms.Label lblWebFarm;
        /// <summary>
        /// Cancel label
        /// </summary>
        private System.Windows.Forms.Label lblCancelOption;
        /// <summary>
        /// Form 
        /// </summary>
        private static FrmWelcome form;

        /// <summary>
        /// form constructor
        /// </summary>
		public static FrmWelcome Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmWelcome();
				}
				return form;
			}
		}

        /// <summary>
        /// Main form method
        /// </summary>
		public FrmWelcome()
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
			this.lblAction = new System.Windows.Forms.Label();
			this.lblWebFarm = new System.Windows.Forms.Label();
			this.lblCancelOption = new System.Windows.Forms.Label();
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
			this.lblTitle.Size = new System.Drawing.Size(426, 19);
			this.lblTitle.Text = "Welcome to the [ApplicationName] Database Configuration Wizard";
			// 
			// lblGuide
			// 
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(550, 16);
			this.lblGuide.Text = "This wizard will guide you through the steps required to configure the database c" +
				"onnection on your computer.";
			// 
			// btnBack
			// 
			this.btnBack.Enabled = false;
			this.btnBack.Name = "btnBack";
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
			// lblAction
			// 
			this.lblAction.Location = new System.Drawing.Point(24, 136);
			this.lblAction.Name = "lblAction";
			this.lblAction.Size = new System.Drawing.Size(552, 40);
			this.lblAction.TabIndex = 5;
			this.lblAction.Text = "It will create or upgrade the selected database and grant access permissions to t" +
				"he selected Web SQL User.";
			// 
			// lblWebFarm
			// 
			this.lblWebFarm.Location = new System.Drawing.Point(24, 176);
			this.lblWebFarm.Name = "lblWebFarm";
			this.lblWebFarm.Size = new System.Drawing.Size(552, 40);
			this.lblWebFarm.TabIndex = 6;
			this.lblWebFarm.Text = "If you are running a web farm, you will have to configure each web server individ" +
				"ually to use the same database connection.";
			// 
			// lblCancelOption
			// 
			this.lblCancelOption.Location = new System.Drawing.Point(24, 216);
			this.lblCancelOption.Name = "lblCancelOption";
			this.lblCancelOption.Size = new System.Drawing.Size(552, 40);
			this.lblCancelOption.TabIndex = 7;
			this.lblCancelOption.Text = "Select Cancel if you do not wish to create or upgrade the database at his stage.";
			// 
			// FrmWelcome
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.lblCancelOption);
			this.Controls.Add(this.lblWebFarm);
			this.Controls.Add(this.lblAction);
			this.Name = "FrmWelcome";
			this.Text = " Database Configuration";
			this.TopMost = true;
			this.Load += new System.EventHandler(this.FrmWelcome_Load);
			this.Controls.SetChildIndex(this.lblAction, 0);
			this.Controls.SetChildIndex(this.pnlTitle, 0);
			this.Controls.SetChildIndex(this.lblGuide, 0);
			this.Controls.SetChildIndex(this.btnBack, 0);
			this.Controls.SetChildIndex(this.btnCancel, 0);
			this.Controls.SetChildIndex(this.btnNext, 0);
			this.Controls.SetChildIndex(this.lblWebFarm, 0);
			this.Controls.SetChildIndex(this.lblCancelOption, 0);
			this.pnlTitle.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

        /// <summary>
        /// Next form
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		private void btnNext_Click(object sender, System.EventArgs e)
		{
			FrmSelectDatabase.Form.Show();
		}

        /// <summary>
        /// Form load event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		private void FrmWelcome_Load(object sender, System.EventArgs e)
		{
			this.lblTitle.Text = this.lblTitle.Text.Replace("[ApplicationName]", ConfigurationSettings.AppSettings["ApplicationName"]);
		}
	}
}

