using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
    /// <summary>
    /// FrmSelectWebSQLUser
    /// </summary>
	public class FrmSelectWebSQLUser : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
		private System.Windows.Forms.Label lblNote;
		private System.Windows.Forms.TextBox txtPassword;
		private System.Windows.Forms.TextBox txtUsername;
		private System.Windows.Forms.Label lblPassword;
		private System.Windows.Forms.Label lblUsername;
		private System.Windows.Forms.RadioButton rdoSQLUser;
		private System.Windows.Forms.RadioButton rdoWindowsUser;
		private System.ComponentModel.IContainer components = null;
		private System.Windows.Forms.Label lblNTUser;
		private System.Windows.Forms.TextBox txtNTUser;
		private System.Windows.Forms.Label lblWebSQLUser;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.RadioButton rdoGrantPermissionYes;
		private System.Windows.Forms.RadioButton rdoGrantPermissionNo;
		private System.Windows.Forms.Label lblGrantPermission;

		private static FrmSelectWebSQLUser form;

        /// <summary>
        /// FrmSelectWebSQLUser
        /// </summary>
		public static FrmSelectWebSQLUser Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmSelectWebSQLUser();
				}
				return form;
			}
		}

        /// <summary>
        /// This call is required by the Windows Form Designer.
        /// </summary>
		public FrmSelectWebSQLUser()
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
			this.lblNote = new System.Windows.Forms.Label();
			this.txtPassword = new System.Windows.Forms.TextBox();
			this.txtUsername = new System.Windows.Forms.TextBox();
			this.lblPassword = new System.Windows.Forms.Label();
			this.lblUsername = new System.Windows.Forms.Label();
			this.rdoSQLUser = new System.Windows.Forms.RadioButton();
			this.rdoWindowsUser = new System.Windows.Forms.RadioButton();
			this.lblNTUser = new System.Windows.Forms.Label();
			this.txtNTUser = new System.Windows.Forms.TextBox();
			this.lblWebSQLUser = new System.Windows.Forms.Label();
			this.lblGrantPermission = new System.Windows.Forms.Label();
			this.rdoGrantPermissionYes = new System.Windows.Forms.RadioButton();
			this.rdoGrantPermissionNo = new System.Windows.Forms.RadioButton();
			this.panel1 = new System.Windows.Forms.Panel();
			this.panel1.SuspendLayout();
			this.SuspendLayout();
			// 
			// pnlTitle
			// 
			this.pnlTitle.Name = "pnlTitle";
			// 
			// lblTitle
			// 
			this.lblTitle.Name = "lblTitle";
			this.lblTitle.Size = new System.Drawing.Size(149, 19);
			this.lblTitle.Text = "Select Web SQL Login";
			// 
			// lblGuide
			// 
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(362, 16);
			this.lblGuide.Text = "This SQL Server Login will be used by the web site to access database.";
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
			// lblNote
			// 
			this.lblNote.AutoSize = true;
			this.lblNote.Location = new System.Drawing.Point(24, 112);
			this.lblNote.Name = "lblNote";
			this.lblNote.Size = new System.Drawing.Size(554, 16);
			this.lblNote.TabIndex = 5;
			this.lblNote.Text = "Note: If you are running a web farm, you will have to configure each web server t" +
				"o use the same user account.";
			// 
			// txtPassword
			// 
			this.txtPassword.Location = new System.Drawing.Point(296, 240);
			this.txtPassword.Name = "txtPassword";
			this.txtPassword.PasswordChar = '*';
			this.txtPassword.Size = new System.Drawing.Size(200, 20);
			this.txtPassword.TabIndex = 14;
			this.txtPassword.Text = "";
			// 
			// txtUsername
			// 
			this.txtUsername.Location = new System.Drawing.Point(296, 208);
			this.txtUsername.Name = "txtUsername";
			this.txtUsername.Size = new System.Drawing.Size(200, 20);
			this.txtUsername.TabIndex = 13;
			this.txtUsername.Text = "";
			// 
			// lblPassword
			// 
			this.lblPassword.Location = new System.Drawing.Point(168, 240);
			this.lblPassword.Name = "lblPassword";
			this.lblPassword.Size = new System.Drawing.Size(72, 21);
			this.lblPassword.TabIndex = 12;
			this.lblPassword.Text = "&Password:";
			// 
			// lblUsername
			// 
			this.lblUsername.Location = new System.Drawing.Point(168, 208);
			this.lblUsername.Name = "lblUsername";
			this.lblUsername.Size = new System.Drawing.Size(72, 21);
			this.lblUsername.TabIndex = 11;
			this.lblUsername.Text = "User &name:";
			// 
			// rdoSQLUser
			// 
			this.rdoSQLUser.Checked = true;
			this.rdoSQLUser.Location = new System.Drawing.Point(152, 184);
			this.rdoSQLUser.Name = "rdoSQLUser";
			this.rdoSQLUser.Size = new System.Drawing.Size(248, 21);
			this.rdoSQLUser.TabIndex = 10;
			this.rdoSQLUser.TabStop = true;
			this.rdoSQLUser.Text = "&Use a specific user name and password:";
			this.rdoSQLUser.CheckedChanged += new System.EventHandler(this.rdoSQLUser_CheckedChanged);
			// 
			// rdoWindowsUser
			// 
			this.rdoWindowsUser.Location = new System.Drawing.Point(152, 136);
			this.rdoWindowsUser.Name = "rdoWindowsUser";
			this.rdoWindowsUser.Size = new System.Drawing.Size(344, 21);
			this.rdoWindowsUser.TabIndex = 9;
			this.rdoWindowsUser.Text = "Use Windows NT Integrated Security (Web Process User)";
			this.rdoWindowsUser.CheckedChanged += new System.EventHandler(this.rdoWindowsUser_CheckedChanged);
			// 
			// lblNTUser
			// 
			this.lblNTUser.Location = new System.Drawing.Point(168, 160);
			this.lblNTUser.Name = "lblNTUser";
			this.lblNTUser.Size = new System.Drawing.Size(128, 21);
			this.lblNTUser.TabIndex = 17;
			this.lblNTUser.Text = "NT User (Domain\\User):";
			// 
			// txtNTUser
			// 
			this.txtNTUser.Location = new System.Drawing.Point(296, 160);
			this.txtNTUser.Name = "txtNTUser";
			this.txtNTUser.Size = new System.Drawing.Size(200, 20);
			this.txtNTUser.TabIndex = 18;
			this.txtNTUser.Text = "";
			// 
			// lblWebSQLUser
			// 
			this.lblWebSQLUser.Location = new System.Drawing.Point(24, 136);
			this.lblWebSQLUser.Name = "lblWebSQLUser";
			this.lblWebSQLUser.TabIndex = 19;
			this.lblWebSQLUser.Text = "Web SQL Login:";
			// 
			// lblGrantPermission
			// 
			this.lblGrantPermission.Location = new System.Drawing.Point(24, 272);
			this.lblGrantPermission.Name = "lblGrantPermission";
			this.lblGrantPermission.TabIndex = 20;
			this.lblGrantPermission.Text = "Grant Permission:";
			// 
			// rdoGrantPermissionYes
			// 
			this.rdoGrantPermissionYes.Checked = true;
			this.rdoGrantPermissionYes.Location = new System.Drawing.Point(16, 8);
			this.rdoGrantPermissionYes.Name = "rdoGrantPermissionYes";
			this.rdoGrantPermissionYes.Size = new System.Drawing.Size(280, 24);
			this.rdoGrantPermissionYes.TabIndex = 21;
			this.rdoGrantPermissionYes.TabStop = true;
			this.rdoGrantPermissionYes.Text = "Yes. Grant access permissions to this user";
			this.rdoGrantPermissionYes.CheckedChanged += new System.EventHandler(this.rdoGrantPermissionYes_CheckedChanged);
			// 
			// rdoGrantPermissionNo
			// 
			this.rdoGrantPermissionNo.Location = new System.Drawing.Point(16, 32);
			this.rdoGrantPermissionNo.Name = "rdoGrantPermissionNo";
			this.rdoGrantPermissionNo.Size = new System.Drawing.Size(312, 24);
			this.rdoGrantPermissionNo.TabIndex = 22;
			this.rdoGrantPermissionNo.Text = "No. The access permissions have already been granted.";
			this.rdoGrantPermissionNo.CheckedChanged += new System.EventHandler(this.rdoGrantPermissionNo_CheckedChanged);
			// 
			// panel1
			// 
			this.panel1.Controls.Add(this.rdoGrantPermissionYes);
			this.panel1.Controls.Add(this.rdoGrantPermissionNo);
			this.panel1.Location = new System.Drawing.Point(136, 264);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(352, 64);
			this.panel1.TabIndex = 23;
			// 
			// FrmSelectWebSQLUser
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.lblGrantPermission);
			this.Controls.Add(this.lblWebSQLUser);
			this.Controls.Add(this.txtNTUser);
			this.Controls.Add(this.lblNTUser);
			this.Controls.Add(this.txtPassword);
			this.Controls.Add(this.txtUsername);
			this.Controls.Add(this.lblPassword);
			this.Controls.Add(this.lblUsername);
			this.Controls.Add(this.rdoSQLUser);
			this.Controls.Add(this.rdoWindowsUser);
			this.Controls.Add(this.lblNote);
			this.Name = "FrmSelectWebSQLUser";
			this.Load += new System.EventHandler(this.FrmSelectWebSQLUser_Load);
			this.Controls.SetChildIndex(this.lblNote, 0);
			this.Controls.SetChildIndex(this.pnlTitle, 0);
			this.Controls.SetChildIndex(this.lblGuide, 0);
			this.Controls.SetChildIndex(this.btnBack, 0);
			this.Controls.SetChildIndex(this.btnCancel, 0);
			this.Controls.SetChildIndex(this.btnNext, 0);
			this.Controls.SetChildIndex(this.rdoWindowsUser, 0);
			this.Controls.SetChildIndex(this.rdoSQLUser, 0);
			this.Controls.SetChildIndex(this.lblUsername, 0);
			this.Controls.SetChildIndex(this.lblPassword, 0);
			this.Controls.SetChildIndex(this.txtUsername, 0);
			this.Controls.SetChildIndex(this.txtPassword, 0);
			this.Controls.SetChildIndex(this.lblNTUser, 0);
			this.Controls.SetChildIndex(this.txtNTUser, 0);
			this.Controls.SetChildIndex(this.lblWebSQLUser, 0);
			this.Controls.SetChildIndex(this.lblGrantPermission, 0);
			this.Controls.SetChildIndex(this.panel1, 0);
			this.panel1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void btnNext_Click(object sender, System.EventArgs e)
		{
			if (SaveState())
			{
                FrmDBTimeZone.Form.Show();
				/*if (ApplicationState.InstallVersion=="-") //Install new schema
				{
					FrmApplicationAdmin.Form.ShowDialog();
				}
				else
				{
					FrmConfirm.Form.ShowDialog();
				}*/
				
			}
			else
			{
				this.ShowDialog();
			}
		}

		private void btnBack_Click(object sender, System.EventArgs e)
		{
			FrmSelectDatabase.Form.ShowDialog();
		}

		private void SetControlState()
		{
			if (this.rdoWindowsUser.Checked)
			{
				this.txtNTUser.Enabled = true;
				this.txtUsername.Enabled = false;
				this.txtPassword.Enabled = false;
			}
			else if (this.rdoSQLUser.Checked)
			{
				this.txtNTUser.Enabled = false;
				this.txtUsername.Enabled = true;
				this.txtPassword.Enabled = true;
			}

			if (this.rdoGrantPermissionNo.Checked)
			{
				this.txtNTUser.Enabled = false;
			}
			
		}

		private void FrmSelectWebSQLUser_Load(object sender, System.EventArgs e)
		{
			string webSQLLogin;
			webSQLLogin =  ConfigurationSettings.AppSettings["WebSQLLogin"].ToLower();
			/*  WEBSQLLOGIN 
			This section sets the authentication policies of the Web Site database access. Possible modes are "Windows", 
			"Windows", "SQLServer" and "All"
			
			"Windows" only allow Integrated windows user authentication, that will use the web site process windows user account. 
			If the website is impersonated,  it is used the impersonated user account.
			"SQLServer" only allow a named SQL server login ID and Password.
			"All" allow either of the above authentication method.
			*/
			if (webSQLLogin =="windows")
			{
				this.rdoWindowsUser.Checked = true;
				this.rdoSQLUser.Enabled = false;
			}
			else if (webSQLLogin =="sqlserver")
			{
				this.rdoWindowsUser.Enabled = false;
				this.rdoSQLUser.Checked = true;
			}
			else
			{
				if (ApplicationState.WebUserType ==SqlUserType.IntegratedUser)
				{
					this.rdoWindowsUser.Checked = true;
				}
				else
				{
					this.rdoSQLUser.Checked = true;
				}
			}

			if (this.rdoSQLUser.Checked)
			{
				this.txtUsername.Text = ApplicationState.WebUsername;
				this.txtPassword.Text = ApplicationState.WebPassword;
			}

			this.rdoGrantPermissionYes.Checked = true;


			SetControlState();
		}

		private void rdoWindowsUser_CheckedChanged(object sender, System.EventArgs e)
		{
			SetControlState();
		}

		private void rdoSQLUser_CheckedChanged(object sender, System.EventArgs e)
		{
			SetControlState();
		}

		private void rdoGrantPermissionYes_CheckedChanged(object sender, System.EventArgs e)
		{
			SetControlState();
		}

		private void rdoGrantPermissionNo_CheckedChanged(object sender, System.EventArgs e)
		{
			SetControlState();
		}

		/// <summary>
		/// Check whether the form data are valid
		/// 1. If web SQL login is NT User
		///    and need to be granted access permission
		///    1.1 NT user name is required
		///    1.2 This user must be SQL server login
		/// 2. If the login is SQL user 
		///		2.1 User name and password are required
		///		2.2 This login must be valid
		/// </summary>
		/// <returns></returns>
		private bool SaveState()
		{
			SqlUserType userType;
			string ntUserName;
			string userName, password;
			string connectionString;
			bool grantPermission;
			DataTable dt;
			string ntUserCheckingSql = "select * from master.dbo.syslogins where name='{0}'";

			bool isValid;
			
			//Get Form data
			if (this.rdoWindowsUser.Checked)
			{
				userType = SqlUserType.IntegratedUser;
			}
			else
			{
				userType = SqlUserType.SQLUser;
			}

			ntUserName = this.txtNTUser.Text;

			userName = this.txtUsername.Text;
			password = this.txtPassword.Text;

			grantPermission = this.rdoGrantPermissionYes.Checked;
			
			isValid = true;

			//    1. If web SQL login is NT User
			//    and need to be granted access permission
			//    1.1 NT user name is required
			//    1.2 This user must be SQL server login
			if (userType == SqlUserType.IntegratedUser && grantPermission)
			{
				connectionString = SqlTool.GetConnectionString(ApplicationState.ServerName,"Master",ApplicationState.DboUserType,ApplicationState.DboUsername,ApplicationState.DboPassword);
				try
				{
					dt = SqlTool.ExecuteDataTable(connectionString, string.Format(ntUserCheckingSql,ntUserName.Replace("'","''")));

					if (dt.Rows.Count==0)
					{
						MessageBox.Show("The selected NT login doesn't exist in the SQL server " + ApplicationState.ServerName,"Invalid Login", MessageBoxButtons.OK);
						isValid = false;
					}
					else
					{
						isValid = true;
					}
				}
				catch(Exception exp)
				{
					MessageBox.Show("Connection failed.\n" + exp.Message);
					isValid = false;
				}
			}
			// 2. If the login is SQL user 
			//		2.1 User name and password are required
			//		2.2 This login must be valid
			if (userType == SqlUserType.SQLUser)
			{
				connectionString = SqlTool.GetConnectionString(ApplicationState.ServerName,"Master",userType,userName,password);
				isValid = SqlTool.CheckConnection(connectionString);
			}

			//If the data are valid, save data
			if (isValid)
			{
				ApplicationState.WebUserType = userType;
				ApplicationState.WebNTUsername  = ntUserName;
				ApplicationState.WebUsername  = userName;
				ApplicationState.WebPassword = password;
				ApplicationState.WebGrantPermission = grantPermission;
			}
			return isValid;
		} //end of checking


	}
}

