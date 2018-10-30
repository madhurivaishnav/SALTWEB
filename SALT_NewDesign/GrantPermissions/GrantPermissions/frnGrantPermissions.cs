using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Security.AccessControl;


namespace GrantPermissions
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            label1.Text = "Granting permissions to the SALT Website installed at "
                + Path.GetDirectoryName(Application.ExecutablePath);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            textBox2.BackColor = Color.AntiqueWhite;
            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\Images\\Header";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\Images\\Header");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                dir.SetAccessControl(accessList);
                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for "+ label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\Images\\Header";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }


            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\ToolBook\\Content";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\ToolBook\\Content");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                dir.SetAccessControl(accessList);
                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\ToolBook\\Content";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }

            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\UploadedFile";
            DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\UploadedFile");
            DirectorySecurity accessList = dir.GetAccessControl();
            accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
            dir.SetAccessControl(accessList);
            textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
            label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\UploadedFile";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }

            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\Errors";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\Errors");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                dir.SetAccessControl(accessList);
                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\Errors";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }


            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\InfoPath\\Publishing";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\InfoPath\\Publishing");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                dir.SetAccessControl(accessList);
                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\General\\InfoPath\\Publishing";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }
            button2.Text = "Exit";
            label2.Text = "";
            Application.DoEvents();


        }
    }
}
