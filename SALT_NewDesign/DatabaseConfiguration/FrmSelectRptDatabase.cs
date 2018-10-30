using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Threading;
using System.Configuration;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{

    /// <summary>
    /// FrmSelectDatabase
    /// </summary>
	public class FrmSelectRptDatabase : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
		private System.Windows.Forms.RadioButton rdoWindowsUser;
		private System.Windows.Forms.RadioButton rdoSQLUser;
		private System.Windows.Forms.Label lblUsername;
		private System.Windows.Forms.Label lblPassword;
		private System.Windows.Forms.TextBox txtUsername;
		private System.Windows.Forms.TextBox txtPassword;
		private System.Windows.Forms.ComboBox cboDatabase;
		private System.Windows.Forms.Label lblDatabase;
		private System.Windows.Forms.Label lblServer;
		private System.Windows.Forms.ComboBox cboServer;
		private System.Windows.Forms.Label lblDboUser;
		
		private System.ComponentModel.IContainer components = null;

		private static FrmSelectRptDatabase form;

        /// <summary>
        /// FrmSelectDatabase
        /// </summary>
		public static FrmSelectRptDatabase Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmSelectRptDatabase();
				}
				return form;
			}
		}

        /// <summary>
        /// FrmSelectDatabase
        /// </summary>
		public FrmSelectRptDatabase()
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
			this.rdoWindowsUser = new System.Windows.Forms.RadioButton();
			this.rdoSQLUser = new System.Windows.Forms.RadioButton();
			this.lblServer = new System.Windows.Forms.Label();
			this.lblUsername = new System.Windows.Forms.Label();
			this.lblPassword = new System.Windows.Forms.Label();
			this.txtUsername = new System.Windows.Forms.TextBox();
			this.txtPassword = new System.Windows.Forms.TextBox();
			this.cboDatabase = new System.Windows.Forms.ComboBox();
			this.lblDatabase = new System.Windows.Forms.Label();
			this.cboServer = new System.Windows.Forms.ComboBox();
			this.lblDboUser = new System.Windows.Forms.Label();
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
			this.lblTitle.Size = new System.Drawing.Size(176, 19);
			this.lblTitle.Text = "Select Reporting Database";
			// 
			// lblGuide
			// 
			this.lblGuide.AutoSize = false;
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(560, 32);
			this.lblGuide.Text = "You are required to have dbo privileges to create or upgrade Reporting database s" +
				"chema and set web site SQL user permission.";
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
			// rdoWindowsUser
			// 
			this.rdoWindowsUser.Checked = true;
			this.rdoWindowsUser.Location = new System.Drawing.Point(152, 168);
			this.rdoWindowsUser.Name = "rdoWindowsUser";
			this.rdoWindowsUser.Size = new System.Drawing.Size(368, 21);
			this.rdoWindowsUser.TabIndex = 0;
			this.rdoWindowsUser.TabStop = true;
			this.rdoWindowsUser.Text = "Use Windows NT Integrated Security (Login user in this machine)";
			this.rdoWindowsUser.CheckedChanged += new System.EventHandler(this.rdoWindowsUser_CheckedChanged);
			// 
			// rdoSQLUser
			// 
			this.rdoSQLUser.Location = new System.Drawing.Point(152, 192);
			this.rdoSQLUser.Name = "rdoSQLUser";
			this.rdoSQLUser.Size = new System.Drawing.Size(248, 21);
			this.rdoSQLUser.TabIndex = 1;
			this.rdoSQLUser.Text = "&Use a specific user name and password:";
			this.rdoSQLUser.CheckedChanged += new System.EventHandler(this.rdoSQLUser_CheckedChanged);
			// 
			// lblServer
			// 
			this.lblServer.Location = new System.Drawing.Point(24, 136);
			this.lblServer.Name = "lblServer";
			this.lblServer.Size = new System.Drawing.Size(72, 23);
			this.lblServer.TabIndex = 2;
			this.lblServer.Text = "Server:";
			// 
			// lblUsername
			// 
			this.lblUsername.Location = new System.Drawing.Point(152, 216);
			this.lblUsername.Name = "lblUsername";
			this.lblUsername.Size = new System.Drawing.Size(72, 21);
			this.lblUsername.TabIndex = 5;
			this.lblUsername.Text = "User &name:";
			// 
			// lblPassword
			// 
			this.lblPassword.Location = new System.Drawing.Point(152, 240);
			this.lblPassword.Name = "lblPassword";
			this.lblPassword.Size = new System.Drawing.Size(72, 21);
			this.lblPassword.TabIndex = 6;
			this.lblPassword.Text = "&Password:";
			// 
			// txtUsername
			// 
			this.txtUsername.Location = new System.Drawing.Point(224, 216);
			this.txtUsername.Name = "txtUsername";
			this.txtUsername.Size = new System.Drawing.Size(200, 20);
			this.txtUsername.TabIndex = 7;
			this.txtUsername.Text = "";
			// 
			// txtPassword
			// 
			this.txtPassword.Location = new System.Drawing.Point(224, 240);
			this.txtPassword.Name = "txtPassword";
			this.txtPassword.PasswordChar = '*';
			this.txtPassword.Size = new System.Drawing.Size(200, 20);
			this.txtPassword.TabIndex = 8;
			this.txtPassword.Text = "";
			// 
			// cboDatabase
			// 
			this.cboDatabase.Location = new System.Drawing.Point(152, 272);
			this.cboDatabase.Name = "cboDatabase";
			this.cboDatabase.Size = new System.Drawing.Size(272, 21);
			this.cboDatabase.TabIndex = 10;
			this.cboDatabase.DropDown += new System.EventHandler(this.cboDatabase_DropDown);
			// 
			// lblDatabase
			// 
			this.lblDatabase.Location = new System.Drawing.Point(24, 272);
			this.lblDatabase.Name = "lblDatabase";
			this.lblDatabase.Size = new System.Drawing.Size(56, 23);
			this.lblDatabase.TabIndex = 11;
			this.lblDatabase.Text = "Database:";
			// 
			// cboServer
			// 
			this.cboServer.Location = new System.Drawing.Point(152, 136);
			this.cboServer.Name = "cboServer";
			this.cboServer.Size = new System.Drawing.Size(272, 21);
			this.cboServer.TabIndex = 12;
			// 
			// lblDboUser
			// 
			this.lblDboUser.Location = new System.Drawing.Point(24, 176);
			this.lblDboUser.Name = "lblDboUser";
			this.lblDboUser.Size = new System.Drawing.Size(64, 23);
			this.lblDboUser.TabIndex = 13;
			this.lblDboUser.Text = "Dbo Login:";
			// 
			// FrmSelectRptDatabase
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.lblDboUser);
			this.Controls.Add(this.cboServer);
			this.Controls.Add(this.lblDatabase);
			this.Controls.Add(this.cboDatabase);
			this.Controls.Add(this.txtPassword);
			this.Controls.Add(this.txtUsername);
			this.Controls.Add(this.lblPassword);
			this.Controls.Add(this.lblUsername);
			this.Controls.Add(this.lblServer);
			this.Controls.Add(this.rdoSQLUser);
			this.Controls.Add(this.rdoWindowsUser);
			this.Name = "FrmSelectRptDatabase";
			this.Text = " Reporting Database Configuration";
			this.TopMost = true;
			this.Load += new System.EventHandler(this.FrmSelectDatabase_Load);
			this.Controls.SetChildIndex(this.rdoWindowsUser, 0);
			this.Controls.SetChildIndex(this.rdoSQLUser, 0);
			this.Controls.SetChildIndex(this.lblServer, 0);
			this.Controls.SetChildIndex(this.lblUsername, 0);
			this.Controls.SetChildIndex(this.lblPassword, 0);
			this.Controls.SetChildIndex(this.txtUsername, 0);
			this.Controls.SetChildIndex(this.txtPassword, 0);
			this.Controls.SetChildIndex(this.cboDatabase, 0);
			this.Controls.SetChildIndex(this.lblDatabase, 0);
			this.Controls.SetChildIndex(this.cboServer, 0);
			this.Controls.SetChildIndex(this.lblDboUser, 0);
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
			if (SaveState())
			{
				if (!IsSameDatabase())
				{
					FrmSelectRptWebSQLUser.Form.ShowDialog();
				}
				else
				{
                    ApplicationState.RptWebGrantPermission = false;
                    ApplicationState.RptWebUsername = ApplicationState.WebUsername;
                    ApplicationState.RptWebPassword = ApplicationState.WebPassword;
					FrmRptConfirm.Form.ShowDialog();
					//MessageBox.Show("Using same database for application adn reporting server");
				}
			}
			else
			{
				this.Show();
			}

		}

		private void FrmSelectDatabase_Load(object sender, System.EventArgs e)
		{
            try
            {
                this.cboServer.Items.Clear();
                //this.cboServer.Items.AddRange(ServerList.Get(ServerTypeEnum.SQLSERVER));
                DataTable servers = ((System.Data.Common.DbDataSourceEnumerator)SqlClientFactory.Instance.CreateDataSourceEnumerator()).GetDataSources(); servers.Columns.Add(new DataColumn("FullServerName", typeof(String), "ServerName + ISNULL(IIF(InstanceName <> \'\', (\'\\\' + InstanceName), InstanceName), \'\') "));
                foreach (DataRow dr in servers.Rows)
                {
                    this.cboServer.Items.Add((string)dr["FullServerName"]);
                }
            }
            catch
            {
                //user can see that the listbox is empty so no need to raise exception
            }
            try
            {
                this.cboServer.Text = ApplicationState.RptServerName;
            }
            catch
            {
                //ditto
            }
            try
            {
                this.cboDatabase.Text = ApplicationState.RptDatabaseName;
            }
            catch
            {
            }
			if (ApplicationState.RptDboUserType == SqlUserType.IntegratedUser)
			{
				this.rdoWindowsUser.Checked = true;
			}
			else
			{
				this.rdoSQLUser.Checked = true;
			}

			SetControlState();

			

			
		}

		private void cboDatabase_DropDown(object sender, System.EventArgs e)
		{
			this.cboDatabase.Items.Clear();
			this.cboDatabase.Text = "";
			
			//Populate database list	
			SqlDataReader reader = this.GetDatabaseList();
			if (reader!=null)
			{
				while(reader.Read())
				{
					cboDatabase.Items.Add(reader["name"].ToString());
				}
				reader.Close();
			}
		} 

		private SqlDataReader GetDatabaseList()
		{
			string serverName;
			SqlUserType userType;
			string userName, password;
			string connectionString;
			//bool connectionOK;
			string sql = "select name from master.dbo.sysdatabases where dbid>4";

			//Get Form data
			serverName = this.cboServer.Text;
			if (this.rdoWindowsUser.Checked)
			{
				userType = SqlUserType.IntegratedUser;
			}
			else
			{
				userType = SqlUserType.SQLUser;
			}
			userName = this.txtUsername.Text;
			password = this.txtPassword.Text;
			
			//Get database list
			connectionString = SqlTool.GetConnectionString(serverName, "Master",userType, userName, password);

			try
			{
				SqlDataReader reader = SqlTool.ExecuteReader(connectionString,sql);
				return reader;
			}
			catch(Exception exp)
			{
				MessageBox.Show("Connection failed.\n" + exp.Message);
				return null;
			}
		} // end of database list

		/// <summary>
		/// Check whether the form data are valid
		/// 1. Check whether the user is db_owner
		/// 2. Check the database schema
		///		2.1 Check whether the database is empty
		///			2.1.1 Yes. 
		///				2.1.1.1 If the existing schema is the same version as new version, Whether we use this exiting schema?
		///				2.1.1.2 If the existing schema is the old version, whether upgrade this old schema
		///			2.1.2 No. go to step 2.2
		///		2.2 Check whether the database contains right schema
		///			2.1.1 Yes. Whether we use this exiting schema?
		///			2.1.2 No.  Can't use this database
		/// </summary>
		/// <returns></returns>
		private bool SaveState()
		{
			string serverName,databaseName;
			SqlUserType userType;
			string userName, password;
			string connectionString;
			DialogResult r;

			bool isDBOwner;

			string version;
			
			bool emptyDatabase;

			string dbVersionContains= ConfigurationSettings.AppSettings["VersionContains"];
			string newVersion= ConfigurationSettings.AppSettings["NewVersionID"];
			string newVersionType= ConfigurationSettings.AppSettings["NewVersionType"];
	
			
			//A) Get Form data
			serverName = this.cboServer.Text;
			databaseName = this.cboDatabase.Text;

			if (this.rdoWindowsUser.Checked)
			{
				userType = SqlUserType.IntegratedUser;
			}
			else
			{
				userType = SqlUserType.SQLUser;
			}
			userName = this.txtUsername.Text;
			password = this.txtPassword.Text;

			emptyDatabase = false;
			
			connectionString = SqlTool.GetConnectionString(serverName, databaseName,userType, userName, password);

			//else
			try 
			{
				// 1. Check whether the user is db_owner
				isDBOwner = this.IsDBOwner(connectionString);
				if (!isDBOwner)
				{
					MessageBox.Show("The selected login does not have dbo privileges");
					return false;
				}

				// 2. Check the database schema
				//		2.1 Check whether the database is empty
				//			2.1.1 Yes. Whether install schema to this empty database?
				//			2.1.2 No. go to step 2.2
				emptyDatabase = this.IsEmptyDatabase(connectionString);
				if (emptyDatabase)
				{
					//"Upgrade" only upgrade existing database
					if (newVersionType=="Upgrade") 
					{
						MessageBox.Show("The selected database is empty, this application only upgrades existing database.", "Empty Database", MessageBoxButtons.OK);	
						return false;
					}

					version = "-"; //Install new schema
					r= MessageBox.Show("The selected database is empty. Do you wish to install the database schema into this empty database?","Empty Database", MessageBoxButtons.YesNo);
							
					if (r==DialogResult.No)
					{
						return false;
					}
				}
				//		2.2 Check whether the database contains right schema
				//			2.1.1 Yes. 
				//				2.1.1.1 If the existing schema is the same version as new version, Whether we use this exiting schema?
				//				2.1.1.2 If the existing schema is the old version, whether upgrade this old schema
				//			2.1.2 No.  Can't use this database
				else
				{

					version = this.GetVersionID(connectionString);
					if (version.IndexOf(dbVersionContains)>=0)
					{
						if (newVersion==version)
						{
							version = ""; //use existing database
							r= MessageBox.Show("The selected database already contains the schema for " + newVersion +". Do you wish to continue with this existing database?","Use Existing Database", MessageBoxButtons.YesNo);
							if (r==DialogResult.No)
							{
								return false;
							}
						}
						else
						{
							//"New" only install new database schema in empty database 
							if (newVersionType=="New") 
							{
								MessageBox.Show("The selected database is not empty, this application only installs new database schema in empty database.", "Invalid Database", MessageBoxButtons.OK);	
								return false;
							}

							r= MessageBox.Show("The selected database contains the schema for " + version +". Do you wish to upgrade to "+ newVersion +"?","Upgrade Existing Database", MessageBoxButtons.YesNo);
							if (r==DialogResult.No)
							{
								return false;
							}
						}
					}
					else
					{
						MessageBox.Show("The selected database is not empty, it contains other system schema.", "Invalid Data", MessageBoxButtons.OK);
						return false;
					}
				}//end of schema checking
			}
			catch(Exception exp)
			{
				MessageBox.Show("Connection failed.\n" + exp.Message);
				return false;
			}

				//C) If the data are valid, save data
				ApplicationState.RptServerName = serverName;
				ApplicationState.RptDatabaseName =databaseName;
				ApplicationState.RptDboUserType = userType;
                //MessageBox.Show("userType:" + userType.ToString());

				ApplicationState.RptDboUsername = userName;
				ApplicationState.RptDboPassword = password;

				ApplicationState.RptInstallVersion  = version; 
			return true;

			} //end of checking

		/// <summary>
		/// Check the authentication user is db owner
		/// </summary>
		/// <param name="connectionString"></param>
		/// <returns></returns>
		private bool IsDBOwner(string connectionString)
		{
			string dbOwnerCheckingSql = "select is_member('db_owner')";
			int owner;
			bool isDbOwner;
			
			owner =(int)SqlTool.ExecuteScalar(connectionString,dbOwnerCheckingSql);
			
			isDbOwner = (owner==1);
 
			return isDbOwner;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="connectionString"></param>
		/// <returns></returns>
		private bool IsSameDatabase()
		{
			bool isSameDatabase;
			string serverName = this.cboServer.Text;
			string databaseName = this.cboDatabase.Text;
			string mainServerName = ApplicationState.ServerName;
			string mainDatabaseName = ApplicationState.DatabaseName;

			if (serverName.Equals(mainServerName) && databaseName.Equals(mainDatabaseName))
			{
				isSameDatabase = true;
			}
			else
			{
				isSameDatabase = false;
			}

			return isSameDatabase;
			
		}

		/// <summary>
		/// Check whether the selected database is empty
		/// </summary>
		/// <param name="connectionString"></param>
		/// <returns></returns>
		private bool IsEmptyDatabase(string connectionString)
		{
			bool isEmptyDatabase;
			DataTable dt;

			string emptyDBCheckingSql = "select name from sysobjects where xtype = 'U' and status>=0";

			dt = SqlTool.ExecuteDataTable(connectionString, emptyDBCheckingSql);

			isEmptyDatabase =(dt.Rows.Count==0);

			return isEmptyDatabase;
		}
		
		private string GetVersionID(string connectionString)
		{
			string dbVersionCheckingSql = ConfigurationSettings.AppSettings["GetVersionScript"];

			string version;
			try
			{
				version=(string)SqlTool.ExecuteScalar(connectionString, dbVersionCheckingSql);
			}
			//If the get version script doesn't exist, it means wrong schema
			catch
			{
				version="";
			}
					
			return version;

		}


		private void rdoWindowsUser_CheckedChanged(object sender, System.EventArgs e)
		{
			SetControlState();
		} 

		private void rdoSQLUser_CheckedChanged(object sender, System.EventArgs e)
		{
			SetControlState();
		}

		private void SetControlState()
		{
			if (this.rdoWindowsUser.Checked)
			{
				this.txtUsername.Enabled = false;
				this.txtPassword.Enabled = false;
			}
			else if (this.rdoSQLUser.Checked)
			{
				this.txtUsername.Enabled = true;
				this.txtPassword.Enabled = true;
			}
		}

	}
}
