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
	public class FrmProgress : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
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

		private static FrmProgress form;

        /// <summary>
        /// FrmProgress
        /// </summary>
		public static FrmProgress Form
		{
			get
			{
				
				if (form==null)
				{
					form = new FrmProgress();
				}
				return form;
			}
		}

        /// <summary>
        /// FrmProgress
        /// </summary>
		public FrmProgress()
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
            this.pnlTitle.Size = new System.Drawing.Size(720, 92);
            // 
            // lblTitle
            // 
            this.lblTitle.Location = new System.Drawing.Point(29, 28);
            this.lblTitle.Size = new System.Drawing.Size(106, 20);
            this.lblTitle.Text = "In Progress";
            // 
            // lblGuide
            // 
            this.lblGuide.Location = new System.Drawing.Point(29, 102);
            this.lblGuide.Size = new System.Drawing.Size(197, 17);
            this.lblGuide.Text = "Database is being configured.";
            // 
            // btnBack
            // 
            this.btnBack.Location = new System.Drawing.Point(490, 397);
            this.btnBack.Size = new System.Drawing.Size(90, 26);
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(374, 397);
            this.btnCancel.Size = new System.Drawing.Size(90, 26);
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnNext
            // 
            this.btnNext.Location = new System.Drawing.Point(595, 397);
            this.btnNext.Size = new System.Drawing.Size(90, 26);
            this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
            // 
            // lblSQLServer
            // 
            this.lblSQLServer.Location = new System.Drawing.Point(29, 129);
            this.lblSQLServer.Name = "lblSQLServer";
            this.lblSQLServer.Size = new System.Drawing.Size(120, 27);
            this.lblSQLServer.TabIndex = 5;
            this.lblSQLServer.Text = "SQL Server:";
            // 
            // lblDatabase
            // 
            this.lblDatabase.Location = new System.Drawing.Point(422, 129);
            this.lblDatabase.Name = "lblDatabase";
            this.lblDatabase.Size = new System.Drawing.Size(120, 27);
            this.lblDatabase.TabIndex = 6;
            this.lblDatabase.Text = "Database:";
            // 
            // txtSQLServer
            // 
            this.txtSQLServer.Enabled = false;
            this.txtSQLServer.Location = new System.Drawing.Point(29, 166);
            this.txtSQLServer.Name = "txtSQLServer";
            this.txtSQLServer.Size = new System.Drawing.Size(120, 22);
            this.txtSQLServer.TabIndex = 7;
            // 
            // txtDatabase
            // 
            this.txtDatabase.Enabled = false;
            this.txtDatabase.Location = new System.Drawing.Point(422, 166);
            this.txtDatabase.Name = "txtDatabase";
            this.txtDatabase.Size = new System.Drawing.Size(120, 22);
            this.txtDatabase.TabIndex = 7;
            // 
            // prgStatus
            // 
            this.prgStatus.Location = new System.Drawing.Point(29, 268);
            this.prgStatus.Name = "prgStatus";
            this.prgStatus.Size = new System.Drawing.Size(532, 26);
            this.prgStatus.TabIndex = 8;
            // 
            // lblStatus
            // 
            this.lblStatus.AutoSize = true;
            this.lblStatus.Location = new System.Drawing.Point(29, 231);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(91, 17);
            this.lblStatus.TabIndex = 9;
            this.lblStatus.Text = "Please wait...";
            // 
            // lblError
            // 
            this.lblError.Location = new System.Drawing.Point(29, 314);
            this.lblError.Name = "lblError";
            this.lblError.Size = new System.Drawing.Size(633, 55);
            this.lblError.TabIndex = 10;
            // 
            // FrmProgress
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(6, 15);
            this.ClientSize = new System.Drawing.Size(592, 373);
            this.Controls.Add(this.prgStatus);
            this.Controls.Add(this.lblError);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.txtSQLServer);
            this.Controls.Add(this.lblDatabase);
            this.Controls.Add(this.lblSQLServer);
            this.Controls.Add(this.txtDatabase);
            this.Name = "FrmProgress";
            this.Text = " Database Configuration";
            this.Load += new System.EventHandler(this.FrmProgress_Load);
            this.Controls.SetChildIndex(this.txtDatabase, 0);
            this.Controls.SetChildIndex(this.lblSQLServer, 0);
            this.Controls.SetChildIndex(this.lblDatabase, 0);
            this.Controls.SetChildIndex(this.txtSQLServer, 0);
            this.Controls.SetChildIndex(this.lblStatus, 0);
            this.Controls.SetChildIndex(this.lblError, 0);
            this.Controls.SetChildIndex(this.pnlTitle, 0);
            this.Controls.SetChildIndex(this.lblGuide, 0);
            this.Controls.SetChildIndex(this.btnBack, 0);
            this.Controls.SetChildIndex(this.btnCancel, 0);
            this.Controls.SetChildIndex(this.btnNext, 0);
            this.Controls.SetChildIndex(this.prgStatus, 0);
            this.pnlTitle.ResumeLayout(false);
            this.pnlTitle.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion


		private void FrmProgress_Load(object sender, System.EventArgs e)
		{
			this.txtSQLServer.Text = ApplicationState.ServerName;
			this.txtDatabase.Text = ApplicationState.DatabaseName;

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
			string containsSQLJob;

			if (ApplicationState.WebUserType  == SqlUserType.IntegratedUser)
			{
				webUserName = ApplicationState.WebNTUsername;
			}
			else
			{
				webUserName =  ApplicationState.WebUsername;
			}

			containsSQLJob =  ConfigurationSettings.AppSettings["ContainsSQLJob"];

			try
			{
				connectionString = SqlTool.GetConnectionString(ApplicationState.ServerName,ApplicationState.DatabaseName,ApplicationState.DboUserType,ApplicationState.DboUsername, ApplicationState.DboPassword);
                 
				//1. Install schema
				if (ApplicationState.InstallVersion!="")
				{
					MigrationSettings settings= (MigrationSettings) ConfigurationSettings.GetConfig("MigrationSettings");
					VersionSetting versionSetting = settings.GetVersion(ApplicationState.InstallVersion);
					NameValueCollection  steps =  versionSetting.Steps;
					
					int stepsCount, step;
					step = 0;
					stepsCount = steps.Count;

					foreach(string description in steps.AllKeys)
					{
						step++;
						if (! description.Equals("Optimising Reports"))
						{
							try
							{
								if (this.cancel)
								{
									System.Windows.Forms.Application.Exit();
								}
								// Skip the OptimizedScripts

								this.lblStatus.Text = description + "...";

								sql = SqlTool.ReadScript(steps[description]);
								/*
								* -- Parameters: 
								-- This values will be set in the deployment process
								-- {0} Databasename
								-- {1} WEB SQL Login
								-- {2} Salt Administrator username
								-- {3} Salt Administrator password
								*/
								
								//-- We don't want language translation {0} type place holders to be replaced.
                                if (description == "Optimising Reports" || description == "Creating SQL server Job" || description == "Load Data")
                                {
                                    sql = String.Format(sql,
                                        ApplicationState.DatabaseName.Replace("'", "''"),
                                        webUserName.Replace("'", "''"),
                                        ApplicationState.AdminUsername.Replace("'", "''"),
                                        ApplicationState.AdminPassword.Replace("'", "''")
                                        );
                                }
                                else if (description == "Set DB Server Time Zone")
                                {
                                    sql = sql.Replace("@@@VVV@@@", ApplicationState.DBServerTZ);
                                }
							

								sql = sql.Replace("{databaseUser}", webUserName.Replace("'","''"));
								sql = sql.Replace("{database}", ApplicationState.DatabaseName.Replace("'","''"));
								if (this.cancel)
								{
									System.Windows.Forms.Application.Exit();
								}
								

								SqlTool.Execute(connectionString,sql);
						
								this.prgStatus.Value=Convert.ToInt16((step*1.0 /stepsCount) * 90.00);
							}
							catch(Exception ex)
							{
								this.lblError.Text +=ex.Message +"\n";
								MessageBox.Show("Error:" + ex.Message + Environment.NewLine + ex.StackTrace);	

							}
						}
					}
					
					//Update Version
					this.lblStatus.Text = "Set Application Version" + "...";

					sql = ConfigurationSettings.AppSettings["SetVersionScript"];
					newVersion= ConfigurationSettings.AppSettings["NewVersionID"];

					sql = String.Format(sql,newVersion.Replace("'","''"));

					SqlTool.Execute(connectionString,sql);

				}


				//2. Grant Web SQL Login access permission
				if (ApplicationState.WebGrantPermission)
				{
					this.lblStatus.Text = "Grant Web SQL Login access permission" + "...";

					sql = ConfigurationSettings.AppSettings["GrantPermissionScript"];


					sql = String.Format(sql,webUserName.Replace("'","''"));

					SqlTool.Execute(connectionString,sql);

					this.prgStatus.Value =90;

				}

				//3. Set database connection
				this.lblStatus.Text = "Set database connection" + "...";
                string strWebConnectionString = SqlTool.GetConnectionString(
                        ApplicationState.ServerName,
                        ApplicationState.DatabaseName,
                        ApplicationState.WebUserType,    
                        ApplicationState.WebUsername,
                        ApplicationState.WebPassword);

                this.UpdateWebConfig(strWebConnectionString, ApplicationState.WebPassword);
                //this.UpdateCPDWebConfig(strWebConnectionString, ApplicationState.WebPassword);
                this.prgStatus.Value = 100;

				Thread.Sleep(1000);

				this.Hide();
				
				if (containsSQLJob.ToLower()=="yes")
				{
					MessageBox.Show("Please notify the database administrator that SQL Server Agent must be running in order to do background processing");	
				}

				//Thread.CurrentThread.Abort();
				FrmComplete.Form.ShowDialog();
			}
			catch(Exception ex)
			{
                MessageBox.Show("Error:" + ex.Message + Environment.NewLine + ex.StackTrace);	
                System.Windows.Forms.Application.Exit();
			}
            
		}

        /// <summary>
        /// Updates the installed web.config file with the new connection string.
        /// </summary>
        /// <param name="connectionString">connectionString to be placed in web.config</param>
        /// <param name="password">password in unencrypted form</param>
        private void UpdateWebConfig(string connectionString, string password)
        {
            string strWebConfig;

            // holds just the password
            string strConnecitonStringPassword = "";

            // holds the rest of hte connection string
            string strConnectionStringNoPassword = "";

            // get the connection string and remove the password
            string[] strParts = connectionString.Split(';');
            foreach (string strPart in strParts)
            {
                if (strPart.ToLower().IndexOf("password=") == -1)
                {
                    // build up a string that doesnt contain the password.
                    strConnectionStringNoPassword += strPart + ";";
                }
            }

            SecurityHandler objSecurity = new SecurityHandler();
            strConnecitonStringPassword = objSecurity.Encrypt(password);

            // Get the installation diretory 
            // its the first parameter off the command line arguments
            string strInstallDirectory = "";
            try
            {
                strInstallDirectory = Environment.GetCommandLineArgs()[1];
            }
            catch (Exception ex)
            {
                MessageBox.Show(" This application requires arguements - first arguement is the install directory, message relating to arguements:" + ex.Message + Environment.NewLine + ex.StackTrace);
            }

            // string strInstallDirectory = Environment.GetCommandLineArgs()[0];
            // Above directory is web directory
            DirectoryInfo dirSaltApplication = new DirectoryInfo(strInstallDirectory);

            // Full path and filename to the web.config file.
            strWebConfig = dirSaltApplication.FullName + "\\Web.Config";
            Bdw.Application.Salt.Deployment.DatabaseConfiguration.ConfigureWebConfig.WebConfigConnectionString
                (strWebConfig,
                "connectionstring", strConnectionStringNoPassword.Replace("\"", ""),
                "connectionstringpassword", strConnecitonStringPassword.Replace("\"", ""));


            strWebConfig = dirSaltApplication.FullName + "\\Reporting\\Email\\Web.Config";
            Bdw.Application.Salt.Deployment.DatabaseConfiguration.ConfigureWebConfig.WebConfigConnectionString
                (strWebConfig,
                "logconnectionstring", strConnectionStringNoPassword.Replace("\"", ""),
                "connectionstringpassword", strConnecitonStringPassword.Replace("\"", ""));

            // Full path and filename to the web.config file.
            strWebConfig = dirSaltApplication.FullName + "\\Reporting\\CPD\\Web.Config";
            Bdw.Application.Salt.Deployment.DatabaseConfiguration.ConfigureWebConfig.WebConfigConnectionString
                (strWebConfig,
                "logconnectionstring", strConnectionStringNoPassword.Replace("\"", ""),
                "connectionstringpassword", strConnecitonStringPassword.Replace("\"", ""));

        }

    
        private void UpdateCPDWebConfig(string connectionString,string password)
        {
            string strWebConfig;

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
            string strInstallDirectory = "";
            try
            {
                strInstallDirectory = Environment.GetCommandLineArgs()[1];
            }
            catch (Exception ex)
            {
                MessageBox.Show(" This application requires arguements - first arguement is the install directory, message relating to arguements:" + ex.Message + Environment.NewLine + ex.StackTrace);
            }

            // string strInstallDirectory = Environment.GetCommandLineArgs()[0];
             // Above directory is web directory
            DirectoryInfo dirSaltApplication = new DirectoryInfo(strInstallDirectory);
            
            // Full path and filename to the web.config file.
            strWebConfig = dirSaltApplication.FullName + "\\Reporting\\CPD\\Web.Config";
			Bdw.Application.Salt.Deployment.DatabaseConfiguration.ConfigureWebConfig.WebConfigConnectionString
				(strWebConfig,
                "logconnectionstring", strConnectionStringNoPassword.Replace("\"", ""),
				"connectionstringpassword", strConnecitonStringPassword.Replace("\"",""));

        }
		
	}
}

