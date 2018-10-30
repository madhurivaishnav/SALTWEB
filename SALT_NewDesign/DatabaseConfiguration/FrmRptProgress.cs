using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;
using System.Configuration;
using System.Collections.Specialized;
using System.Xml;
using System.IO;

using Bdw.Application.Salt.Data;
namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
    /// <summary>
    /// FrmProgress
    /// </summary>
	public class FrmRptProgress : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
		private System.Windows.Forms.Label lblSQLServer;
		private System.Windows.Forms.Label lblDatabase;
		private System.Windows.Forms.TextBox txtSQLServer;
		private System.Windows.Forms.TextBox txtDatabase;
		private System.Windows.Forms.ProgressBar prgStatus;
		private System.Windows.Forms.Label lblStatus;
		private System.ComponentModel.IContainer components = null;

		private bool cancel = false;
		private System.Windows.Forms.Label lblError;

		private static FrmRptProgress form;

        /// <summary>
        /// FrmProgress
        /// </summary>
		public static FrmRptProgress Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmRptProgress();
				}
				return form;
			}
		}

        /// <summary>
        /// FrmProgress
        /// </summary>
		public FrmRptProgress()
		{
			// This call is required by the Windows Form Designer.
			InitializeComponent();

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
			this.lblSQLServer = new System.Windows.Forms.Label();
			this.lblDatabase = new System.Windows.Forms.Label();
			this.txtSQLServer = new System.Windows.Forms.TextBox();
			this.txtDatabase = new System.Windows.Forms.TextBox();
			this.prgStatus = new System.Windows.Forms.ProgressBar();
			this.lblStatus = new System.Windows.Forms.Label();
			this.lblError = new System.Windows.Forms.Label();
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
			this.lblTitle.Size = new System.Drawing.Size(78, 19);
			this.lblTitle.Text = "In Progress";
			// 
			// lblGuide
			// 
			this.lblGuide.Name = "lblGuide";
			this.lblGuide.Size = new System.Drawing.Size(154, 16);
			this.lblGuide.Text = "Database is being configured.";
			// 
			// btnBack
			// 
			this.btnBack.Name = "btnBack";
			// 
			// btnCancel
			// 
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// btnNext
			// 
			this.btnNext.Name = "btnNext";
			this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
			// 
			// lblSQLServer
			// 
			this.lblSQLServer.Location = new System.Drawing.Point(24, 112);
			this.lblSQLServer.Name = "lblSQLServer";
			this.lblSQLServer.Size = new System.Drawing.Size(128, 23);
			this.lblSQLServer.TabIndex = 5;
			this.lblSQLServer.Text = "Reporting SQL Server:";
			// 
			// lblDatabase
			// 
			this.lblDatabase.Location = new System.Drawing.Point(352, 112);
			this.lblDatabase.Name = "lblDatabase";
			this.lblDatabase.Size = new System.Drawing.Size(112, 23);
			this.lblDatabase.TabIndex = 6;
			this.lblDatabase.Text = "Reporting Database:";
			// 
			// txtSQLServer
			// 
			this.txtSQLServer.Enabled = false;
			this.txtSQLServer.Location = new System.Drawing.Point(24, 144);
			this.txtSQLServer.Name = "txtSQLServer";
			this.txtSQLServer.TabIndex = 7;
			this.txtSQLServer.Text = "";
			// 
			// txtDatabase
			// 
			this.txtDatabase.Enabled = false;
			this.txtDatabase.Location = new System.Drawing.Point(352, 144);
			this.txtDatabase.Name = "txtDatabase";
			this.txtDatabase.TabIndex = 7;
			this.txtDatabase.Text = "";
			// 
			// prgStatus
			// 
			this.prgStatus.Location = new System.Drawing.Point(24, 232);
			this.prgStatus.Name = "prgStatus";
			this.prgStatus.Size = new System.Drawing.Size(512, 23);
			this.prgStatus.TabIndex = 8;
			// 
			// lblStatus
			// 
			this.lblStatus.AutoSize = true;
			this.lblStatus.Location = new System.Drawing.Point(24, 200);
			this.lblStatus.Name = "lblStatus";
			this.lblStatus.Size = new System.Drawing.Size(72, 16);
			this.lblStatus.TabIndex = 9;
			this.lblStatus.Text = "Please wait...";
			// 
			// lblError
			// 
			this.lblError.Location = new System.Drawing.Point(24, 272);
			this.lblError.Name = "lblError";
			this.lblError.Size = new System.Drawing.Size(528, 48);
			this.lblError.TabIndex = 10;
			// 
			// FrmRptProgress
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(592, 373);
			this.Controls.Add(this.lblError);
			this.Controls.Add(this.lblStatus);
			this.Controls.Add(this.prgStatus);
			this.Controls.Add(this.txtSQLServer);
			this.Controls.Add(this.lblDatabase);
			this.Controls.Add(this.lblSQLServer);
			this.Controls.Add(this.txtDatabase);
			this.Name = "FrmRptProgress";
			this.Text = " Reporting Database Configuration";
			this.Load += new System.EventHandler(this.FrmRptProgress_Load);
			this.Controls.SetChildIndex(this.txtDatabase, 0);
			this.Controls.SetChildIndex(this.lblSQLServer, 0);
			this.Controls.SetChildIndex(this.lblDatabase, 0);
			this.Controls.SetChildIndex(this.txtSQLServer, 0);
			this.Controls.SetChildIndex(this.prgStatus, 0);
			this.Controls.SetChildIndex(this.lblStatus, 0);
			this.Controls.SetChildIndex(this.lblError, 0);
			this.Controls.SetChildIndex(this.pnlTitle, 0);
			this.Controls.SetChildIndex(this.lblGuide, 0);
			this.Controls.SetChildIndex(this.btnBack, 0);
			this.Controls.SetChildIndex(this.btnCancel, 0);
			this.Controls.SetChildIndex(this.btnNext, 0);
			this.pnlTitle.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion


		private void FrmRptProgress_Load(object sender, System.EventArgs e)
		{
			this.txtSQLServer.Text = ApplicationState.RptServerName;
			this.txtDatabase.Text = ApplicationState.RptDatabaseName;

			this.btnNext.Enabled = false;
			this.btnBack.Enabled = false;

			this.btnCancel.Enabled = true;

			ThreadStart threadDelegate = new ThreadStart(InstallDatabase);
			Thread newThread = new Thread(threadDelegate);
			
			newThread.Start();


		}



		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			DialogResult r= MessageBox.Show("Are you sure you wish to cancel the installation","Warning", MessageBoxButtons.YesNo);
							
			cancel = (r==DialogResult.Yes);
			if (cancel)
			{
				System.Windows.Forms.Application.Exit();
			}
		}

		private void btnNext_Click(object sender, System.EventArgs e)
		{

		}


        /// <summary>
        /// Installs the database
        /// </summary>
		public void InstallDatabase()
		{
			string connectionString;
			string sql;
			string webUserName;
			string newVersion;
			string containsRptSQLJob;
            containsRptSQLJob = "yes";
            connectionString = "";
            webUserName = "";
            try
            {
                if (ApplicationState.RptWebUsername != null)
                {
                    if (ApplicationState.RptWebUserType.Equals(SqlUserType.IntegratedUser))
                    {
                        webUserName = ApplicationState.RptWebNTUsername;
                    }
                }

                if ((webUserName == "")||(webUserName == null))
                {
                    webUserName = ApplicationState.RptWebUsername;
                }
            }
            catch
            {
                DialogResult r = MessageBox.Show("ApplicationState.Exception trying to read UserName", "info", MessageBoxButtons.OK);
            }

            try
            {
                containsRptSQLJob = ConfigurationSettings.AppSettings["ContainsRptSQLJob"];
            }
            catch
            {
                DialogResult r = MessageBox.Show("ConfigurationSettings.AppSettings.Exception trying to read ContainsRptSQLJob", "info", MessageBoxButtons.OK);
            } 

            try
			{
                try
                {
                    connectionString = SqlTool.GetConnectionString(ApplicationState.RptServerName, ApplicationState.RptDatabaseName, ApplicationState.RptDboUserType, ApplicationState.RptDboUsername, ApplicationState.RptDboPassword);
                }
                catch
                {
                    DialogResult r = MessageBox.Show("ConfigurationSettings.AppSettings.Exception trying to build connectionstring", "info", MessageBoxButtons.OK);
                }
                //DialogResult r2 = MessageBox.Show("connectionString=" + connectionString, "info", MessageBoxButtons.YesNo);
                 
				//1. Install schema
                String ErrorNum = "0";
				if (ApplicationState.RptInstallVersion!="")
				{
                    try
                    {
                        MigrationSettings settingsa = (MigrationSettings)ConfigurationSettings.GetConfig("MigrationSettings");
                        ErrorNum = "1";
                    }
                    catch
                    {
                        DialogResult r = MessageBox.Show("ConfigurationSettings.GetConfig.Exception trying to read MigrationSettings", "info", MessageBoxButtons.OK);
                    }

                    try
                    {
                        MigrationSettings settingsb = (MigrationSettings)ConfigurationSettings.GetConfig("MigrationSettings");
                        VersionSetting versionSettingb = settingsb.GetVersion(ApplicationState.RptInstallVersion);
                        ErrorNum = "2";
                    }
                    catch
                    {
                        DialogResult r = MessageBox.Show("settings.GetVersion.Exception trying to read RptInstallVersion", "info", MessageBoxButtons.OK);
                    }
                    try
                    {
                        MigrationSettings settingsc = (MigrationSettings)ConfigurationSettings.GetConfig("MigrationSettings");
                        VersionSetting versionSettingc = settingsc.GetVersion(ApplicationState.RptInstallVersion);
                        NameValueCollection stepsc = versionSettingc.Steps;
                        ErrorNum = "3";
                    }
                    catch
                    {
                        DialogResult r = MessageBox.Show("NameValueCollection.Exception trying to read versionSettingc.Steps", "info", MessageBoxButtons.OK);
                    }

                    MigrationSettings settings = (MigrationSettings)ConfigurationSettings.GetConfig("MigrationSettings");

                    VersionSetting versionSetting = settings.GetVersion(ApplicationState.RptInstallVersion);
                    NameValueCollection steps = versionSetting.Steps;
                    ErrorNum = "4";
					
					int stepsCount, step;
					step = 0;
					stepsCount = steps.Count;

					foreach(string description in steps.AllKeys)
					{
						try
						{
							step++;
							if (this.cancel)
							{
								System.Windows.Forms.Application.Exit();
							}
                            sql = "";
                            ErrorNum = "5";
                            try
                            {
                                sql = SqlTool.ReadScript(steps[description]);
                            }
                            catch
                            {
                                DialogResult r = MessageBox.Show("Null NAME in NAME-VALUE collection", "info", MessageBoxButtons.OK);
                            }
							/*
							* -- Parameters: 
							-- This values will be set in the deployment process
							-- {0} Databasename
							-- {1} WEB SQL Login
							-- {2} Salt Administrator username
							-- {3} Salt Administrator password
							*/

							//-- We don't want language translation {0} type place holders to be replaced.
							if (description == "Optimising Reports" || description == "Creating SQL server Job")
								sql = String.Format(sql,
									ApplicationState.RptDatabaseName.Replace("'","''"),
									webUserName.Replace("'","''"),
									ApplicationState.RptAdminUsername.Replace("'","''"),
									ApplicationState.RptAdminPassword.Replace("'","''")
									);
                            ErrorNum = "6";
							
							if (this.cancel)
							{
								System.Windows.Forms.Application.Exit();
							}
							this.lblStatus.Text = description + "...";

							SqlTool.Execute(connectionString,sql);
						
							this.prgStatus.Value=Convert.ToInt16((step*1.0 /stepsCount) * 90.00);
						}
						catch(Exception ex)
						{
							this.lblError.Text +=ex.Message +"\n";
							MessageBox.Show( " Error " +ErrorNum  + ex.Message + Environment.NewLine + ex.StackTrace);
                            Thread.Sleep(1000);

						}
					}
					
					//Update Version
                    try
                    {
                        this.lblStatus.Text = "Set Application Version" + "...";

                        sql = ConfigurationSettings.AppSettings["SetVersionScript"];
                        newVersion = ConfigurationSettings.AppSettings["NewVersionID"];

                        sql = String.Format(sql, newVersion.Replace("'", "''"));

                        SqlTool.Execute(connectionString, sql);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(" Error 77 " + ex.Message + Environment.NewLine + ex.StackTrace);
                        Thread.Sleep(1000);

                    }

				}


				//2. Grant Web SQL Login access permission
                try
                {
                    if (ApplicationState.RptWebGrantPermission)
                    {
                        this.lblStatus.Text = "Grant Web SQL Login access permission" + "...";

                        sql = ConfigurationSettings.AppSettings["GrantPermissionScript"];
                        DialogResult r = MessageBox.Show("Are you sure you wish to Grant permissions to " + webUserName, "Confirm", MessageBoxButtons.YesNo);

                        bool ok = (r == DialogResult.Yes);
                        if (ok)
                        {
                            sql = String.Format(sql, webUserName.Replace("'", "''"));
                            SqlTool.Execute(connectionString, sql);
                       }

                        
                        //sql = String.Format(sql, webUserName.Replace("'", "''"));


                        this.prgStatus.Value = 90;

                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(" The stored procedure that Grants Web SQL Login access permission failed with error:" + ex.Message + Environment.NewLine + ex.StackTrace);

                    Thread.Sleep(1000);
                    this.prgStatus.Value = 90;
                }


				//3. Set database connection
                try
                {
                    String strRptServer = "";
                    String strRptDatabase = "";
                    SqlUserType strRptWebUserType = SqlUserType.IntegratedUser;
                    String strRptWebUserName = "";
                    String strPassword = "";

                    this.lblStatus.Text = "Set database connection" + "...";
                    try
                    {
                        strRptServer = ApplicationState.RptServerName;
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(" Error 80: ApplicationState.RptServerName is null" + ex.Message + Environment.NewLine + ex.StackTrace);
                    }
                    if (strRptServer == null) MessageBox.Show(" Error 81: ApplicationState.RptServerName is null" );
                    try
                    {
                         strRptDatabase = ApplicationState.RptDatabaseName;
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(" Error 80: ApplicationState.RptDatabaseName is null" + ex.Message + Environment.NewLine + ex.StackTrace);
                    }
                    if (strRptDatabase == null) MessageBox.Show(" Error 81: ApplicationState.RptDatabaseName is null" );
                    try
                    {
                         strRptWebUserType = ApplicationState.RptWebUserType;
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(" Error 80: ApplicationState.RptWebUserType is null" + ex.Message + Environment.NewLine + ex.StackTrace);
                    }
                    if (strRptWebUserType == null) MessageBox.Show(" Error 81: ApplicationState.RptWebUserType is null" );
                    try
                    {
                        strRptWebUserName = ApplicationState.RptWebUsername;
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(" Error 80: ApplicationState.RptWebUsername is null" + ex.Message + Environment.NewLine + ex.StackTrace);
                    }
                    if (strRptWebUserName == null) MessageBox.Show(" Error 81: ApplicationState.RptWebUsername is null" );
                    try
                    {
                         strPassword = ApplicationState.RptWebPassword;
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(" Error 80: ApplicationState.RptWebPassword is null" + ex.Message + Environment.NewLine + ex.StackTrace);
                    }
                    if (strPassword == null) MessageBox.Show(" Error 81: ApplicationState.RptWebPassword is null" );
                    string strWebConnectionString = "";
                    try
                    {
                       strWebConnectionString = SqlTool.GetConnectionString(
                            strRptServer,
                            strRptDatabase,
                            strRptWebUserType,
                            strRptWebUserName,
                            strPassword);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(" Error 80: strWebConnectionString is null" + ex.Message + Environment.NewLine + ex.StackTrace);
                    }

                    this.UpdateWebConfig(strWebConnectionString, ApplicationState.RptWebPassword);
                    this.prgStatus.Value = 100;
                }
                catch (Exception ex)
                {
                    MessageBox.Show(" Error 80 " + ex.Message + Environment.NewLine + ex.StackTrace);
                    Thread.Sleep(1000);
                    this.prgStatus.Value = 100;
                }


				Thread.Sleep(1000);

				this.Hide();
	
				if (containsRptSQLJob.ToLower()=="yes")
				{
					MessageBox.Show("Please notify the database administrator that SQL Server Agent must be running in order to do background processing");	
				}

				

				FrmRptComplete.Form.ShowDialog();
			}
			catch(Exception ex)
			{
                MessageBox.Show("Error 78:" + ex.Message + Environment.NewLine + ex.StackTrace);
                Thread.Sleep(1000);
                System.Windows.Forms.Application.Exit();
			}
            
		}

        /// <summary>
        /// Updates the installed web.config file with the new connection string.
        /// </summary>
        /// <param name="connectionString">connectionString to be placed in web.config</param>
        /// <param name="password">password in unencrypted form</param>
        private void UpdateWebConfig(string connectionString,string password)
        {
            string strWebConfig;
			string strEmailRptWebConfig;
			string strAdminRptWebConfig;

            // holds just the password
            string strConnecitonStringPassword="";

            // holds the rest of hte connection string
            string strConnectionStringNoPassword="";
            
            // get the connection string and remove the password
            string[] strParts = connectionString.Split(';');
            foreach (string strPart in strParts)
            {
                if (strPart.ToLower().IndexOf("password=")==-1)
                {
                    // build up a string that doesnt contain the password.
                    strConnectionStringNoPassword+=strPart + ";";
                }
            }

            SecurityHandler objSecurity = new SecurityHandler();
            strConnecitonStringPassword  = objSecurity.Encrypt(password);

            // Get the installation diretory 
            // its the first parameter off the command line arguments
            string strInstallDirectory = Environment.GetCommandLineArgs()[1];
            
             // Above directory is web directory
            DirectoryInfo dirSaltApplication = new DirectoryInfo(strInstallDirectory);
            
            // Full path and filename to the web.config file.
            strWebConfig = dirSaltApplication.FullName + "\\Web.Config";

            // Load Web.Config
            XmlDocument configXmlDocument = new XmlDocument();
            
            configXmlDocument.Load(strWebConfig);

            // Loop through all application settings until the correct one is found
            foreach (XmlNode node in configXmlDocument["configuration"]["appSettings"])
            {
                if (node.Name=="add")
                {
                    if (node.Attributes.GetNamedItem("key").Value.ToLower() == "rptconnectionstring")
                    {
                        // Change the value of the connection string
                        node.Attributes["value"].Value = strConnectionStringNoPassword.Replace("\"","");
                        //form.lblSQLServer.Text = strConnectionStringNoPassword.Replace("\"", "");
                    }
                    
                    if (node.Attributes.GetNamedItem("key").Value.ToLower() == "rptconnectionstringpassword")
                    {
                        // Change the value of the connection string password
                        node.Attributes["value"].Value = strConnecitonStringPassword.Replace("\"","");
                    }
                }
            }
            configXmlDocument.Save(strWebConfig);

			// Full path and filename to the BuildEmailReport report  web.config file
			strEmailRptWebConfig = dirSaltApplication.FullName + "\\Reporting\\Email\\Web.Config";
            
			// Load Web.Config
			XmlDocument EmailConfigXmlDocument = new XmlDocument();
            
			EmailConfigXmlDocument.Load(strEmailRptWebConfig);

			// Loop through all application settings until the correct one is found
			foreach (XmlNode node in EmailConfigXmlDocument["configuration"]["appSettings"])
			{
				if (node.Name=="add")
				{
					if (node.Attributes.GetNamedItem("key").Value.ToLower() == "connectionstring")
					{
						// Change the value of the connection string
						node.Attributes["value"].Value = strConnectionStringNoPassword.Replace("\"","");
					}
                    
					if (node.Attributes.GetNamedItem("key").Value.ToLower() == "connectionstringpassword")
					{
						// Change the value of the connection string password
						node.Attributes["value"].Value = strConnecitonStringPassword.Replace("\"","");
					}
				}
			}
			EmailConfigXmlDocument.Save(strEmailRptWebConfig);

			// Full path and filename to the AdministrationReport report web.config file
			strAdminRptWebConfig = dirSaltApplication.FullName + "\\Reporting\\Admin\\Web.Config";

			// Load Admin Web.Config
			XmlDocument AdminConfigXmlDocument = new XmlDocument();
            
			AdminConfigXmlDocument.Load(strAdminRptWebConfig);

			// Loop through all application settings until the correct one is found
			foreach (XmlNode node in AdminConfigXmlDocument["configuration"]["appSettings"])
			{
				if (node.Name=="add")
				{
					if (node.Attributes.GetNamedItem("key").Value.ToLower() == "connectionstring")
					{
						// Change the value of the connection string
						node.Attributes["value"].Value = strConnectionStringNoPassword.Replace("\"","");
					}
                    
					if (node.Attributes.GetNamedItem("key").Value.ToLower() == "connectionstringpassword")
					{
						// Change the value of the connection string password
						node.Attributes["value"].Value = strConnecitonStringPassword.Replace("\"","");
					}
				}
			}
			AdminConfigXmlDocument.Save(strAdminRptWebConfig);
        }

        
		
	}
}

