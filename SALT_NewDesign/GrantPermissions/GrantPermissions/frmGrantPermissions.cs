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








        private void ReplaceAllDescendantPermissionsFromObject(
            DirectoryInfo dInfo, String username)
        {
            // Copy the DirectorySecurity to the current directory 
            DirectorySecurity accessList = dInfo.GetAccessControl();
            accessList.AddAccessRule(new FileSystemAccessRule(username, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
            try
            {

                dInfo.SetAccessControl(accessList);
            }
            catch (Exception ex)
            {
                label2.Text = "Error setting permissions to " + dInfo.FullName;
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + "Error = " + ex.Message;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(1000);
            }


            foreach (FileInfo fi in dInfo.GetFiles())
            {
                // Get the file's FileSecurity 
                try
                {
                    var ac = fi.GetAccessControl();

                    // inherit from the directory 
                    ac.SetAccessRuleProtection(false, false);
                    FileSystemAccessRule accrule = new FileSystemAccessRule(username, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow);

                    ac.AddAccessRule(accrule);
                    // apply change 
                    fi.SetAccessControl(ac);
                }
                catch (Exception ex)
                {
                    label2.Text = "Error setting permissions to " + fi.FullName;
                    textBox2.BackColor = Color.OrangeRed;
                    textBox2.Text = textBox2.Text + Environment.NewLine + "Error = " + ex.Message;
                    textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                    Application.DoEvents();
                    System.Threading.Thread.Sleep(1000);
                }

            }
            // Recurse into Directories 
            dInfo.GetDirectories().ToList()
                .ForEach(d =>
                    {
                        textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + d.FullName;
                        label2.Text = "Setting permissions for " + d.FullName;
                        Application.DoEvents();
                        ReplaceAllDescendantPermissionsFromObject(d, username);
                    });
        }



        private void button1_Click(object sender, EventArgs e)
        {
            textBox2.BackColor = Color.AntiqueWhite;
            textBox2.ScrollBars = ScrollBars.Vertical;
            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Images\\Header";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Images\\Header");
                DirectorySecurity accessList = dir.GetAccessControl();
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);

                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for "+ label2.Text;
                label2.Text = "";
                Application.DoEvents();                
            }
            catch (Exception ex)
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Images\\Header";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + "Error = "+ex.Message;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }


            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\ToolBook\\Content";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\ToolBook\\Content");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);
                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\ToolBook\\Content";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }

            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\UploadedFile";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\UploadedFile");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);
                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\UploadedFile";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }

            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Errors";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Errors");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);
                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Errors";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }


            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\InfoPath\\Publishing";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\InfoPath\\Publishing");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);

                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\InfoPath\\Publishing";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }
            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Scorm\\Publishing";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Scorm\\Publishing");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);

                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Scorm\\Publishing";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }
            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Scorm\\content";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Scorm\\content");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);

                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Scorm\\content";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }

            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Policy ";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Policy");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);

                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Policy";
                textBox2.BackColor = Color.OrangeRed;
                textBox2.Text = textBox2.Text + Environment.NewLine + label2.Text;
                Application.DoEvents();
                System.Threading.Thread.Sleep(2000);
            }

            try
            {
                label2.Text = Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Ebook\\Content ";
                DirectoryInfo dir = new DirectoryInfo(Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Ebook\\Content");
                DirectorySecurity accessList = dir.GetAccessControl();
                accessList.AddAccessRule(new FileSystemAccessRule(textBox1.Text, FileSystemRights.FullControl, System.Security.AccessControl.AccessControlType.Allow));
                ReplaceAllDescendantPermissionsFromObject(dir, textBox1.Text);

                textBox2.Text = textBox2.Text + Environment.NewLine + "Set permissions for " + label2.Text;
                label2.Text = "";
            }
            catch
            {
                label2.Text = "Error setting permissions to " + Path.GetDirectoryName(Application.ExecutablePath) + "\\..\\General\\Ebook\\Content";
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
