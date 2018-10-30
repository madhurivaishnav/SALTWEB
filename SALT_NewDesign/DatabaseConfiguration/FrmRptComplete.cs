using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
	/// <summary>
	/// 
	/// </summary>
	public class FrmRptComplete : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
		private System.ComponentModel.IContainer components = null;
		private System.Windows.Forms.Label lblGuide2;

		private static FrmRptComplete form;

		/// <summary>
		/// Static method to get complete form
		/// </summary>
		public static FrmRptComplete Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmRptComplete();
				}
				return form;
			}
		}

		/// <summary>
		/// This call is required by the Windows Form Designer.
		/// </summary>
		public FrmRptComplete()
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
			this.lblTitle.Size = new System.Drawing.Size(155, 19);
			this.lblTitle.Text = "Configuration Complete";
			// 
			// lblGuide
			// 
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(427, 16);
			this.lblGuide.Text = "You have successfully run the Reporting Server Database Configuration Application" +
				".";
			// 
			// btnBack
			// 
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
			// lblGuide2
			// 
			this.lblGuide2.Location = new System.Drawing.Point(24, 128);
			this.lblGuide2.Name = "lblGuide2";
			this.lblGuide2.Size = new System.Drawing.Size(184, 23);
			this.lblGuide2.TabIndex = 5;
			this.lblGuide2.Text = "Click \"Close\"  to exit.";
			// 
			// FrmRptComplete
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.lblGuide2);
			this.Name = "FrmRptComplete";
			this.Text = " Database Configuration";
			this.Load += new System.EventHandler(this.FrmRptComplete_Load);
			this.Controls.SetChildIndex(this.lblGuide2, 0);
			this.Controls.SetChildIndex(this.pnlTitle, 0);
			this.Controls.SetChildIndex(this.lblGuide, 0);
			this.Controls.SetChildIndex(this.btnBack, 0);
			this.Controls.SetChildIndex(this.btnCancel, 0);
			this.Controls.SetChildIndex(this.btnNext, 0);
			this.pnlTitle.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void btnNext_Click(object sender, System.EventArgs e)
		{
			System.Windows.Forms.Application.ExitThread();
			System.Windows.Forms.Application.Exit();
		}

		private void FrmRptComplete_Load(object sender, System.EventArgs e)
		{
			this.btnCancel.Enabled = false;
			this.btnBack.Enabled = false;
			this.btnNext.Text = "Close";

		}

	}
}