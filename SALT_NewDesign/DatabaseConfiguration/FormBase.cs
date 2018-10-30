using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Configuration;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
	/// <summary>
	/// Summary description for FrmBase.
	/// </summary>
	public class FrmBase : System.Windows.Forms.Form
	{
        /// <summary>
        /// Panel
        /// </summary>
		public System.Windows.Forms.Panel pnlTitle;
        /// <summary>
        /// Title
        /// </summary>
		public System.Windows.Forms.Label lblTitle;
        /// <summary>
        /// Guide
        /// </summary>
		public System.Windows.Forms.Label lblGuide;
        /// <summary>
        /// Bakc button
        /// </summary>
		public System.Windows.Forms.Button btnBack;
        /// <summary>
        /// Cancel button
        /// </summary>
		public System.Windows.Forms.Button btnCancel;
        /// <summary>
        /// Next button
        /// </summary>
		public System.Windows.Forms.Button btnNext;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;


        /// <summary>
        /// Required for Windows Form Designer support
        /// </summary>
		public FrmBase()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.pnlTitle = new System.Windows.Forms.Panel();
			this.lblTitle = new System.Windows.Forms.Label();
			this.lblGuide = new System.Windows.Forms.Label();
			this.btnBack = new System.Windows.Forms.Button();
			this.btnCancel = new System.Windows.Forms.Button();
			this.btnNext = new System.Windows.Forms.Button();
			this.pnlTitle.SuspendLayout();
			this.SuspendLayout();
			// 
			// pnlTitle
			// 
			this.pnlTitle.BackColor = System.Drawing.Color.White;
			this.pnlTitle.Controls.Add(this.lblTitle);
			this.pnlTitle.Location = new System.Drawing.Point(0, 0);
			this.pnlTitle.Name = "pnlTitle";
			this.pnlTitle.Size = new System.Drawing.Size(600, 80);
			this.pnlTitle.TabIndex = 0;
			// 
			// lblTitle
			// 
			this.lblTitle.AutoSize = true;
			this.lblTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.lblTitle.ForeColor = System.Drawing.Color.Black;
			this.lblTitle.Location = new System.Drawing.Point(24, 24);
			this.lblTitle.Name = "lblTitle";
			this.lblTitle.Size = new System.Drawing.Size(32, 19);
			this.lblTitle.TabIndex = 0;
			this.lblTitle.Text = "Title";
			// 
			// lblGuide
			// 
			this.lblGuide.AutoSize = true;
			this.lblGuide.Location = new System.Drawing.Point(24, 88);
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(34, 16);
			this.lblGuide.TabIndex = 1;
			this.lblGuide.Text = "Guide";
			this.lblGuide.Click += new System.EventHandler(this.lblGuide_Click);
			// 
			// btnBack
			// 
			this.btnBack.Location = new System.Drawing.Point(408, 344);
			this.btnBack.Name = "btnBack";
			this.btnBack.TabIndex = 2;
			this.btnBack.Text = "< Back";
			this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.btnCancel.Location = new System.Drawing.Point(312, 344);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.TabIndex = 3;
			this.btnCancel.Text = "Cancel";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// btnNext
			// 
			this.btnNext.Location = new System.Drawing.Point(496, 344);
			this.btnNext.Name = "btnNext";
			this.btnNext.TabIndex = 4;
			this.btnNext.Text = "Next >";
			this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
			// 
			// FrmBase
			// 
			this.AcceptButton = this.btnNext;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.btnCancel;
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.btnNext);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.btnBack);
			this.Controls.Add(this.lblGuide);
			this.Controls.Add(this.pnlTitle);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.Name = "FrmBase";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "ApplicationName Database Configuration";
			this.Load += new System.EventHandler(this.FrmBase_Load);
			this.Paint += new System.Windows.Forms.PaintEventHandler(this.FrmBase_Paint);
			this.pnlTitle.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion


		private void FrmBase_Load(object sender, System.EventArgs e)
		{
			this.Text = this.Text.Replace("ApplicationName", ConfigurationSettings.AppSettings["ApplicationName"]);
		}


		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			System.Windows.Forms.Application.Exit();
		}

		private void btnNext_Click(object sender, System.EventArgs e)
		{
			this.Hide();
		}

		private void btnBack_Click(object sender, System.EventArgs e)
		{
			this.Hide();
		}

		private void lblGuide_Click(object sender, System.EventArgs e)
		{
		
		}

		private void FrmBase_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
		{
			Graphics g = e.Graphics; 
			
			this.DrawHorizontalLine(g,80,598);

			this.DrawHorizontalLine(g, 332,598);

		}
		private void DrawHorizontalLine(Graphics graphics, int y, int width)
		{
			Pen pen; 
			Point pointStart;
			Point pointEnd;

			pen= new Pen(Color.Black);
			pointStart = new Point( 0, y); 
			pointEnd = new Point( width, y); 
			graphics.DrawLine( pen, pointStart, pointEnd); 

			pen= new Pen(Color.White);
			pointStart = new Point( 0, y+1); 
			pointEnd = new Point( width, y+1); 
			graphics.DrawLine( pen, pointStart, pointEnd); 
		}
	}

}
