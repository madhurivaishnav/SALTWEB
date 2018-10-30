using System;
using Microsoft.Office.Interop.InfoPath.SemiTrust;

// Office integration attribute. Identifies the startup class for the form. Do not
// modify.
[assembly: System.ComponentModel.DescriptionAttribute("InfoPathStartupClass, Version=1.0, Class=Phrases.Phrases")]

namespace Phrases
{
	// The namespace prefixes defined in this attribute must remain synchronized with
	// those in the form definition file (.xsf).
	[InfoPathNamespace("xmlns:my=\"http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-20T23-45-49\" xmlns:xsf=\"http://schemas.microsoft.com/office/infopath/2003/solutionDefinition\" xmlns:msxsl=\"urn:schemas-microsoft-com:xslt\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xdUtil=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Util\" xmlns:xdXDocument=\"http://schemas.microsoft.com/office/infopath/2003/xslt/xDocument\" xmlns:xdMath=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Math\" xmlns:xdDate=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Date\" xmlns:xd=\"http://schemas.microsoft.com/office/infopath/2003\" xmlns:xhtml=\"http://www.w3.org/1999/xhtml\"")]
	public class Phrases
	{
		private XDocument	thisXDocument;
		private Application	thisApplication;

		public void _Startup(Application app, XDocument doc)
		{
			thisXDocument = doc;
			thisApplication = app;

			// You can add additional initialization code here.
		}

		public void _Shutdown()
		{
		}

		

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(EventType=InfoPathEventType.OnSaveRequest)]
		public void OnSaveRequest(SaveEvent e)
		{
			//2. Set the lesson name as the default new file name
			if (e.IsSaveAs || this.thisXDocument.IsNew)
			{
				//IXMLDOMNode node = this.thisXDocument.DOM.selectSingleNode("//ContentType");
				this.thisXDocument.UI.SetSaveAsDialogFileName("phrases");
			}

			e.IsCancelled = e.PerformSaveOperation();

			// Write the code to be run after saving here.

			e.ReturnStatus = true;
		}
	}
}
