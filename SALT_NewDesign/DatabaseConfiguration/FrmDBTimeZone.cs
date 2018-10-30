using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Configuration;
using System.Data;


namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
	/// <summary>
	/// Summary description for FrmBase.
	/// </summary>
	public class FrmDBTimeZone : Bdw.Framework.Deployment.DatabaseConfiguration.FrmBase
	{
       
		/*public System.Windows.Forms.Panel pnlTitle;
       	public System.Windows.Forms.Label lblTitle;
        public System.Windows.Forms.Label lblGuide;
        public System.Windows.Forms.Button btnBack;
        public System.Windows.Forms.Button btnCancel;*/
        private System.ComponentModel.IContainer components = null;
        private ComboBox comboBox1;
        
        
        private static FrmDBTimeZone form;



        public static FrmDBTimeZone Form
        {
            get
            {
                if (form == null)
                {
                    form = new FrmDBTimeZone();
                }
                return form;
            }
        }


        public FrmDBTimeZone()
		{
			InitializeComponent();
            LoadTimeZones();
		}


        public class tz
        {
            public tz(String strNormalName, String strWinname)
            {
                winname = strWinname;
                normalName = strNormalName;
            }

            string normalName;
            public String NiceTZName
            {
                get { return normalName; }
                set { normalName = value; }
            }


            String winname;
            public String WindowsTzName
            { 
                get {return winname;}
                set { winname = value; }
            }
        }


        private void LoadTimeZones()
        {
            ArrayList arrTz = new ArrayList();

            arrTz = Loadtz();

            comboBox1.DataSource = arrTz;
            comboBox1.DisplayMember = "WindowsTzName";
            comboBox1.ValueMember = "NiceTZName";
            //comboBox1.SelectedItem = "AUS Eastern Standard Time";
        }

        private ArrayList Loadtz()
        { 
            ArrayList atz = new ArrayList();
            tz t = new tz("Morocco Standard Time", "(UTC) Casablanca");
            atz.Add(t);
            
            t = new tz("Coordinated Universal Time","(UTC) Coordinated Universal Time");
            atz.Add(t);

            t = new tz("GMT Standard Time", "(UTC) Dublin Edinburgh Lisbon London");
            atz.Add(t);

            t = new tz("Greenwich Standard Time","(UTC) Monrovia Reykjavik");
            atz.Add(t);
             
            t = new tz("W. Europe Standard Time","(UTC+01:00) Amsterdam Berlin Bern Rome Stockholm Vienna");
            atz.Add(t);
            
            t = new tz("Central Europe Standard Time","(UTC+01:00) Belgrade Bratislava Budapest Ljubljana Prague");
            atz.Add(t);
            
            t = new tz("Romance Standard Time","(UTC+01:00) Brussels Copenhagen Madrid Paris");
            atz.Add(t);
            
            t = new tz("Central European Standard Time","(UTC+01:00) Sarajevo Skopje Warsaw Zagreb");
            atz.Add(t);
            
            t = new tz("W. Central Africa Standard Time","(UTC+01:00) West Central Africa");
            atz.Add(t);
            
            t = new tz("Jordan Standard Time","(UTC+02:00) Amman");
            atz.Add(t);
            
            t = new tz("GTB Standard Time","(UTC+02:00) Athens Bucharest Istanbul");
            atz.Add(t);
            
            t = new tz("Middle East Standard Time","(UTC+02:00) Beirut");
            atz.Add(t);
            
            t = new tz("Egypt Standard Time","(UTC+02:00) Cairo");
            atz.Add(t);
            
            t = new tz("South Africa Standard Time","(UTC+02:00) Harare Pretoria");
            atz.Add(t);
            
            t = new tz("FLE Standard Time","(UTC+02:00) Helsinki Kyiv Riga Sofia Tallinn Vilnius");
            atz.Add(t);
            
            t = new tz("Jerusalem Standard Time","(UTC+02:00) Jerusalem");
            atz.Add(t);
            
            t = new tz("E. Europe Standard Time","(UTC+02:00) Minsk");
            atz.Add(t);
            
            t = new tz("Namibia Standard Time","(UTC+02:00) Windhoek");
            atz.Add(t);
            
            t = new tz("Arabic Standard Time","(UTC+03:00) Baghdad");
            atz.Add(t);
            
            t = new tz("Arab Standard Time","(UTC+03:00) Kuwait Riyadh");
            atz.Add(t);
            
            t = new tz("Russian Standard Time","(UTC+03:00) Moscow St. Petersburg Volgograd");
            atz.Add(t);
            
            t = new tz("E. Africa Standard Time","(UTC+03:00) Nairobi");
            atz.Add(t);
            
            t = new tz("Georgian Standard Time","(UTC+03:00) Tbilisi");
            atz.Add(t);
            
            t = new tz("Iran Standard Time","(UTC+03:30) Tehran");
            atz.Add(t);
            
            t = new tz("Arabian Standard Time","(UTC+04:00) Abu Dhabi Muscat");
            atz.Add(t);
            
            t = new tz("Azerbaijan Standard Time","(UTC+04:00) Baku");
            atz.Add(t);
            
            t = new tz("Mauritius Standard Time","(UTC+04:00) Port Louis");
            atz.Add(t);
            
            t = new tz("Caucasus Standard Time","(UTC+04:00) Yerevan");
            atz.Add(t);
            
            t = new tz("Afghanistan Standard Time","(UTC+04:30) Kabul");
            atz.Add(t);
            
            t = new tz("Ekaterinburg Standard Time","(UTC+05:00) Ekaterinburg");
            atz.Add(t);
            
            t = new tz("Pakistan Standard Time","(UTC+05:00) Islamabad Karachi");
            atz.Add(t);
            
            t = new tz("West Asia Standard Time","(UTC+05:00) Tashkent");
            atz.Add(t);
            
            t = new tz("India Standard Time","(UTC+05:30) Chennai Kolkata Mumbai New Delhi");
            atz.Add(t);
            
            t = new tz("Sri Lanka Standard Time","(UTC+05:30) Sri Jayawardenepura");
            atz.Add(t);
            
            t = new tz("Nepal Standard Time","(UTC+05:45) Kathmandu");
            atz.Add(t);
            
            t = new tz("N. Central Asia Standard Time","(UTC+06:00) Almaty Novosibirsk");
            atz.Add(t);
            
            t = new tz("Central Asia Standard Time","(UTC+06:00) Astana Dhaka");
            atz.Add(t);
            
            t = new tz("Myanmar Standard Time","(UTC+06:30) Yangon (Rangoon)");
            atz.Add(t);
            
            t = new tz("SE Asia Standard Time","(UTC+07:00) Bangkok Hanoi Jakarta");
            atz.Add(t);
            
            t = new tz("North Asia Standard Time","(UTC+07:00) Krasnoyarsk");
            atz.Add(t);
            
            t = new tz("China Standard Time","(UTC+08:00) Beijing Chongqing Hong Kong Urumqi");
            atz.Add(t);
            
            t = new tz("North Asia East Standard Time","(UTC+08:00) Irkutsk Ulaan Bataar");
            atz.Add(t);
            
            t = new tz("Malay Peninsula Standard Time","(UTC+08:00) Kuala Lumpur Singapore");
            atz.Add(t);
            
            t = new tz("W. Australia Standard Time","(UTC+08:00) Perth");
            atz.Add(t);
            
            t = new tz("Taipei Standard Time","(UTC+08:00) Taipei");
            atz.Add(t);
            
            t = new tz("Tokyo Standard Time","(UTC+09:00) Osaka Sapporo Tokyo");
            atz.Add(t);
            
            t = new tz("Korea Standard Time","(UTC+09:00) Seoul");
            atz.Add(t);
            
            t = new tz("Yakutsk Standard Time","(UTC+09:00) Yakutsk");
            atz.Add(t);
            
            t = new tz("Cen. Australia Standard Time","(UTC+09:30) Adelaide");
            atz.Add(t);
            
            t = new tz("AUS Central Standard Time","(UTC+09:30) Darwin");
            atz.Add(t);
            
            t = new tz("E. Australia Standard Time","(UTC+10:00) Brisbane");
            atz.Add(t);
            
            t = new tz("AUS Eastern Standard Time","(UTC+10:00) Canberra Melbourne Sydney");
            atz.Add(t);
            
            t = new tz("West Pacific Standard Time","(UTC+10:00) Guam Port Moresby");
            atz.Add(t);
            
            t = new tz("Tasmania Standard Time","(UTC+10:00) Hobart");
            atz.Add(t);
            
            t = new tz("Vladivostok Standard Time","(UTC+10:00) Vladivostok");
            atz.Add(t);
            
            t = new tz("Central Pacific Standard Time","(UTC+11:00) Magadan Solomon Is. New Caledonia");
            atz.Add(t);
            
            t = new tz("New Zealand Standard Time","(UTC+12:00) Auckland Wellington");
            atz.Add(t);
            
            t = new tz("Fiji Standard Time","(UTC+12:00) Fiji Marshall Is.");
            atz.Add(t);
            
            t = new tz("Kamchatka Standard Time","(UTC+12:00) Petropavlovsk-Kamchatsky");
            atz.Add(t);
            
            t = new tz("Tonga Standard Time","(UTC+13:00) Nukualofa");
            atz.Add(t);
            
            t = new tz("Azores Standard Time","(UTC-01:00) Azores");
            atz.Add(t);
            
            t = new tz("Cape Verde Standard Time","(UTC-01:00) Cape Verde Is.");
            atz.Add(t);
            
            t = new tz(" Mid-Atlantic Standard Time","(UTC-02:00) Mid-Atlantic");
            atz.Add(t);
            
            t = new tz("E. South America Standard Time","(UTC-03:00) Brasilia");
            atz.Add(t);
            
            t = new tz("Argentina Standard Time","(UTC-03:00) Buenos Aires");
            atz.Add(t);
            
            t = new tz("SA Eastern Standard Time","(UTC-03:00) Cayenne");
            atz.Add(t);
            
            t = new tz("Greenland Standard Time","(UTC-03:00) Greenland");
            atz.Add(t);
            
            t = new tz("Montevideo Standard Time","(UTC-03:00) Montevideo");
            atz.Add(t);
            
            t = new tz("Newfoundland Standard Time","(UTC-03:30) Newfoundland");
            atz.Add(t);
            
            t = new tz("Paraguay Standard Time","(UTC-04:00) Asuncion");
            atz.Add(t);
            
            t = new tz("Atlantic Standard Time","(UTC-04:00) Atlantic Time (Canada)");
            atz.Add(t);
            
            t = new tz("SA Western Standard Time","(UTC-04:00) Georgetown La Paz San Juan");
            atz.Add(t);
            
            t = new tz("Central Brazilian Standard Time","(UTC-04:00) Manaus");
            atz.Add(t);
            
            t = new tz("Pacific SA Standard Time","(UTC-04:00) Santiago");
            atz.Add(t);
            
            t = new tz("Venezuela Standard Time","(UTC-04:30) Caracas");
            atz.Add(t);
            
            t = new tz("SA Pacific Standard Time","(UTC-05:00) Bogota Lima Quito");
            atz.Add(t);
            
            t = new tz("Eastern Standard Time","(UTC-05:00) Eastern Time (US & Canada)");
            atz.Add(t);
            
            
            t = new tz("US Eastern Standard Time","(UTC-05:00) Indiana (East)");
            atz.Add(t);
            
            t = new tz("Central America Standard Time", "(UTC-06:00) Central America");
            atz.Add(t);

            t = new tz("Central Standard Time", "(UTC-06:00) Central Time (US & Canada)");
            atz.Add(t);

            t = new tz("Central Standard Time (Mexico)", "(UTC-06:00) Guadalajara Mexico City Monterrey");
            atz.Add(t);

            t = new tz("Canada Central Standard Time", "(UTC-06:00) Saskatchewan");
            atz.Add(t);

            t = new tz("US Mountain Standard Time", "(UTC-07:00) Arizona");
            atz.Add(t);

            t = new tz("Mountain Standard Time (Mexico)", "(UTC-07:00) Chihuahua La Paz Mazatlan");
            atz.Add(t);

            t = new tz("Mountain Standard Time", "(UTC-07:00) Mountain Time (US & Canada)");
            atz.Add(t);

            t = new tz("Pacific Standard Time", "(UTC-08:00) Pacific Time (US & Canada)");
            atz.Add(t);

            t = new tz("Pacific Standard Time (Mexico)", "(UTC-08:00) Tijuana Baja California");
            atz.Add(t);

            t = new tz("Alaskan Standard Time", "(UTC-09:00) Alaska");
            atz.Add(t);

            t = new tz("Hawaiian Standard Time", "(UTC-10:00) Hawaii");
            atz.Add(t);

            t = new tz("Samoa Standard Time", "(UTC-11:00) Midway Island Samoa");
            atz.Add(t);

            t = new tz("Dateline Standard Time", "(UTC-12:00) International Date Line West");
            atz.Add(t);

            t = new tz("Syria Standard Time", "(UTC+02:00) Damascus");
            atz.Add(t);

            t = new tz("Bangladesh Standard Time", "(UTC+06:00) Dhaka");
            atz.Add(t);

            t = new tz("Ulaanbaatar Standard Time", "(UTC+08:00) Ulaanbaatar");
            atz.Add(t);

            t = new tz("Magadan Standard Time", "(UTC+11:00) Magadan");
            atz.Add(t);

            t = new tz("UTC+12  (UTC+12:00)", "Coordinated Universal Time+12");
            atz.Add(t);

            t = new tz("UTC-02 - (UTC-02:00)", "Coordinated Universal Time-02");
            atz.Add(t);

            t = new tz("UTC-11 - (UTC-11:00)", "Coordinated Universal Time-11");
            atz.Add(t);
            
            
            return atz;

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
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.pnlTitle.SuspendLayout();
            this.SuspendLayout();
            // 
            // lblGuide
            // 
            this.lblGuide.Size = new System.Drawing.Size(225, 13);
            this.lblGuide.Text = "Please select the Database Server Time Zone";
            // 
            // btnBack
            // 
            this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
            // 
            // btnNext
            // 
            this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(27, 135);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(508, 21);
            this.comboBox1.TabIndex = 5;
            // 
            // FrmDBTimeZone
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(592, 373);
            this.Controls.Add(this.comboBox1);
            this.Name = "FrmDBTimeZone";
            this.Text = " Time Zone Selection";
            this.Load += new System.EventHandler(this.FrmDBTimeZone_Load);
            this.Paint += new System.Windows.Forms.PaintEventHandler(this.FrmDBTimeZone_Paint);
            this.Controls.SetChildIndex(this.comboBox1, 0);
            this.Controls.SetChildIndex(this.pnlTitle, 0);
            this.Controls.SetChildIndex(this.lblGuide, 0);
            this.Controls.SetChildIndex(this.btnBack, 0);
            this.Controls.SetChildIndex(this.btnCancel, 0);
            this.Controls.SetChildIndex(this.btnNext, 0);
            this.pnlTitle.ResumeLayout(false);
            this.pnlTitle.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion


		private void FrmDBTimeZone_Load(object sender, System.EventArgs e)
		{
			this.Text = this.Text.Replace("ApplicationName", ConfigurationSettings.AppSettings["ApplicationName"]);
		}


		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			System.Windows.Forms.Application.Exit();
		}

		
		private void FrmDBTimeZone_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
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

        

        private void btnNext_Click(object sender, EventArgs e)
        {
            if (SaveState())
            {
                if (ApplicationState.InstallVersion=="-") //Install new schema
				{
					FrmApplicationAdmin.Form.ShowDialog();
				}
				else
				{
					FrmConfirm.Form.ShowDialog();
				}
            }
            else
            {
                this.Show();
            }
        }

        /*private bool saveTz()
        {
            string connectionString;
            string sql;

            try
            {
                connectionString = SqlTool.GetConnectionString(ApplicationState.ServerName, ApplicationState.DatabaseName, ApplicationState.DboUserType, ApplicationState.DboUsername, ApplicationState.DboPassword);
                sql = "if not exists (select * from tblAppConfig where Name = 'TimeZone')" +
                "  begin " +
                "      insert into tblAppConfig values('TimeZone','" + comboBox1.SelectedValue + "') " +
                "  end";

                SqlTool.Execute(connectionString, sql);
                
                return true;
            }
            catch (Exception e)
            {
                MessageBox.Show (e.Message);
                return false;
            }

        }*/

        private bool SaveState()
        {
          
            if (comboBox1.SelectedIndex != -1)
            {
                MessageBox.Show(comboBox1.SelectedValue.ToString());
                ApplicationState.DBServerTZ = comboBox1.SelectedValue.ToString();
                return true;
            }
            else
            {
                MessageBox.Show("Please select the timezone for the database server");
                return false;
            }
        }

        private void btnBack_Click(object sender, EventArgs e)
        {

        }

	}

}
