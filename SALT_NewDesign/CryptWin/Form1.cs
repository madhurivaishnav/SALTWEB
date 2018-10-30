using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

using Bdw.Application.Salt.Data;

namespace CryptWin
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class frmMain : System.Windows.Forms.Form
	{
        private System.Windows.Forms.TextBox txtUnencrypted;
        private System.Windows.Forms.TextBox txtDecrypted;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtEncrypted;
        private System.Windows.Forms.Button btnEncrypt;
        private System.Windows.Forms.Button btnDecrypt;
        
		public frmMain()
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
				if (components != null) 
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
            this.txtUnencrypted = new System.Windows.Forms.TextBox();
            this.txtDecrypted = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.btnDecrypt = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtEncrypted = new System.Windows.Forms.TextBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.btnEncrypt = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.label3 = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // txtUnencrypted
            // 
            this.txtUnencrypted.Location = new System.Drawing.Point(136, 24);
            this.txtUnencrypted.MaxLength = 40;
            this.txtUnencrypted.Name = "txtUnencrypted";
            this.txtUnencrypted.PasswordChar = '*';
            this.txtUnencrypted.Size = new System.Drawing.Size(296, 20);
            this.txtUnencrypted.TabIndex = 4;
            this.txtUnencrypted.Text = "";
            // 
            // txtDecrypted
            // 
            this.txtDecrypted.Enabled = false;
            this.txtDecrypted.Location = new System.Drawing.Point(136, 16);
            this.txtDecrypted.Name = "txtDecrypted";
            this.txtDecrypted.ReadOnly = true;
            this.txtDecrypted.Size = new System.Drawing.Size(296, 20);
            this.txtDecrypted.TabIndex = 7;
            this.txtDecrypted.Text = "";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.groupBox4);
            this.groupBox1.Controls.Add(this.groupBox3);
            this.groupBox1.Controls.Add(this.groupBox2);
            this.groupBox1.Location = new System.Drawing.Point(0, 0);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(544, 248);
            this.groupBox1.TabIndex = 8;
            this.groupBox1.TabStop = false;
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.btnDecrypt);
            this.groupBox4.Controls.Add(this.label4);
            this.groupBox4.Controls.Add(this.label2);
            this.groupBox4.Controls.Add(this.txtEncrypted);
            this.groupBox4.Location = new System.Drawing.Point(8, 64);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(528, 128);
            this.groupBox4.TabIndex = 15;
            this.groupBox4.TabStop = false;
            this.groupBox4.Enter += new System.EventHandler(this.groupBox4_Enter);
            // 
            // btnDecrypt
            // 
            this.btnDecrypt.Location = new System.Drawing.Point(440, 16);
            this.btnDecrypt.Name = "btnDecrypt";
            this.btnDecrypt.Size = new System.Drawing.Size(80, 24);
            this.btnDecrypt.TabIndex = 16;
            this.btnDecrypt.Text = "Decrypt";
            this.btnDecrypt.Click += new System.EventHandler(this.btnDecrypt_Click);
            // 
            // label4
            // 
            this.label4.ForeColor = System.Drawing.Color.FromArgb(((System.Byte)(64)), ((System.Byte)(64)), ((System.Byte)(64)));
            this.label4.Location = new System.Drawing.Point(8, 32);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(120, 64);
            this.label4.TabIndex = 15;
            this.label4.Text = "This is the value that needs to be placed in Web.Config in the installation direc" +
                "tory.";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(8, 16);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(108, 16);
            this.label2.TabIndex = 14;
            this.label2.Text = "Encrypted Password";
            // 
            // txtEncrypted
            // 
            this.txtEncrypted.Location = new System.Drawing.Point(136, 16);
            this.txtEncrypted.Multiline = true;
            this.txtEncrypted.Name = "txtEncrypted";
            this.txtEncrypted.Size = new System.Drawing.Size(296, 78);
            this.txtEncrypted.TabIndex = 13;
            this.txtEncrypted.Text = "";
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.btnEncrypt);
            this.groupBox3.Controls.Add(this.label1);
            this.groupBox3.Controls.Add(this.txtUnencrypted);
            this.groupBox3.Location = new System.Drawing.Point(8, 8);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(528, 56);
            this.groupBox3.TabIndex = 14;
            this.groupBox3.TabStop = false;
            // 
            // btnEncrypt
            // 
            this.btnEncrypt.Location = new System.Drawing.Point(440, 24);
            this.btnEncrypt.Name = "btnEncrypt";
            this.btnEncrypt.Size = new System.Drawing.Size(80, 24);
            this.btnEncrypt.TabIndex = 10;
            this.btnEncrypt.Text = "Encrypt";
            this.btnEncrypt.Click += new System.EventHandler(this.btnEncrypt_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(8, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(121, 16);
            this.label1.TabIndex = 9;
            this.label1.Text = "Unencrypted Password";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Controls.Add(this.txtDecrypted);
            this.groupBox2.Location = new System.Drawing.Point(8, 192);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(528, 48);
            this.groupBox2.TabIndex = 13;
            this.groupBox2.TabStop = false;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(8, 18);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(109, 16);
            this.label3.TabIndex = 11;
            this.label3.Text = "Decrypted Password";
            // 
            // frmMain
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(544, 253);
            this.Controls.Add(this.groupBox1);
            this.MaximizeBox = false;
            this.Name = "frmMain";
            this.Text = "Password Generator";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox4.ResumeLayout(false);
            this.groupBox3.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.ResumeLayout(false);

        }
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new frmMain());
		}
            
        private void Form1_Load(object sender, System.EventArgs e)
        {
            
        }

        

        private void btnEncrypt_Click(object sender, System.EventArgs e)
        {
            try
            {
                if (txtUnencrypted.Text.Length>0)
                {
                    SecurityHandler objSecurityHandler = new SecurityHandler();
                    
                    this.txtEncrypted.Text = objSecurityHandler.Encrypt(this.txtUnencrypted.Text);
                    //this.txtEncrypted.Enabled=true;
                }
                else
                {
                    MessageBox.Show("Enter the password to encrypt");
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show("Error Encrypting Text" + Environment.NewLine  + ex.Message);
            }
        }

        private void btnDecrypt_Click(object sender, System.EventArgs e)
        {
            try
            {
                SecurityHandler objSecurityHandler = new SecurityHandler();

                this.txtDecrypted.Text = objSecurityHandler.Decrypt(this.txtEncrypted.Text);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error Decrypting Text" + Environment.NewLine + ex.Message);
            }
        }

        private void groupBox4_Enter(object sender, System.EventArgs e)
        {
        
        }

	}
}
