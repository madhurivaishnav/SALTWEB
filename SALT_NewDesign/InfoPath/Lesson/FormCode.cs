using System;
using Microsoft.Office.Interop.InfoPath.SemiTrust;
using Bdw.Application.Salt.InfoPath;

// Office integration attribute. Identifies the startup class for the form. Do not
// modify.
[assembly: System.ComponentModel.DescriptionAttribute("InfoPathStartupClass, Version=1.0, Class=Lesson.Lesson")]

namespace Lesson
{
	// The namespace prefixes defined in this attribute must remain synchronized with
	// those in the form definition file (.xsf).
	[InfoPathNamespace("xmlns:my=\"http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-15T06-33-01\" xmlns:xsf=\"http://schemas.microsoft.com/office/infopath/2003/solutionDefinition\" xmlns:msxsl=\"urn:schemas-microsoft-com:xslt\" xmlns:xdUtil=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Util\" xmlns:xdXDocument=\"http://schemas.microsoft.com/office/infopath/2003/xslt/xDocument\" xmlns:xdMath=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Math\" xmlns:xdDate=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Date\" xmlns:xd=\"http://schemas.microsoft.com/office/infopath/2003\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xhtml=\"http://www.w3.org/1999/xhtml\" xmlns:ns1=\"http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-17T22:48:56\"")]
	public class Lesson
	{
		private XDocument	thisXDocument;
		private Application	thisApplication;

		private IXMLDOMNode _ContextNode;


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
		[InfoPathEventHandler(EventType=InfoPathEventType.OnLoad)]
		public void OnLoad(DocReturnEvent e)
		{
			
			//Get author name and date
			if (this.thisXDocument.IsNew)
			{
				IXMLDOMNode createdBy = this.thisXDocument.DOM.selectSingleNode("//Summary/CreatedBy");
				IXMLDOMNode createdDate = this.thisXDocument.DOM.selectSingleNode("//Summary/CreatedDate");

				createdBy.text=System.Environment.UserName;
				createdDate.text  = DateTime.Now.ToString("s");
			}

			//Load the phrase dictionary
			Phrase.PhraseDoc = this.thisXDocument.GetDOM("Phrases");
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(EventType=InfoPathEventType.OnSaveRequest)]
		public void OnSaveRequest(SaveEvent e)
		{
			
			//1. Validation
			//Most of  validations are completed by the validation rule in design
			//a. Validate the EndLesson button
			//1)There is one EndLesson button on the active pages
			//2)There is only one EndLesson button on the active pages
			//3)That page must be the last page
			
			IXMLDOMNodeList endLessonPages = this.thisXDocument.DOM.selectNodes("//Page[@IsActive='true' and .//EndLesson]");
			//1) no end lesson control
			if (endLessonPages.length==0)
			{
				this.thisXDocument.UI.Alert("This form contains the following validation errors:\n\nThere is no EndLesson control, this control must be on the last active page.\n");
				e.ReturnStatus = true;
				return;
			}
			//2) More that 1 end lesson control
			else if (endLessonPages.length>1)
			{
				this.thisXDocument.UI.Alert("This form contains the following validation errors:\n\nEndLesson control is on more than one active pages, this control can only be on the last active page.\n");
				e.ReturnStatus = true;
				return;
			}
			//One end lesson control
			else 
			{
				IXMLDOMNode endControlPage = endLessonPages[0];
				//3) Is this page the last active page?
				IXMLDOMNodeList followingSiblingPages = endControlPage.selectNodes("following-sibling::Page[@IsActive='true']");
				if (followingSiblingPages.length>0)
				{
					this.thisXDocument.UI.Alert("This form contains the following validation errors:\n\nEndLesson control is on other active page, this control can only be on the last active page.\n");
					e.ReturnStatus = true;
					return;
				}
			}
			
			
			//2. Set the lesson ID as the default new file name
			if (e.IsSaveAs || this.thisXDocument.IsNew)
			{
				IXMLDOMNode node = this.thisXDocument.DOM.selectSingleNode("//Summary/@ID");
				this.thisXDocument.UI.SetSaveAsDialogFileName(node.text);
			}

			//3. If the form is modified, set the last modified data	
			if (!this.thisXDocument.IsNew)
			{
				IXMLDOMNode lastModifiedBy = this.thisXDocument.DOM.selectSingleNode("//Summary/LastModifiedBy");
				IXMLDOMNode lastModifiedDate = this.thisXDocument.DOM.selectSingleNode("//Summary/LastModifiedDate");

				lastModifiedBy.text=System.Environment.UserName;

				//Determine whether the xsi:nil attribute is set for this
				//element. If so, remove the xsi:nil attributes so that
				//the value can be set.
				if (lastModifiedDate.attributes.getNamedItem("xsi:nil")!=null)
				{
					lastModifiedDate.attributes.removeNamedItem("xsi:nil");
				}
				lastModifiedDate.text  = DateTime.Now.ToString("s");
			}
			
			
			e.IsCancelled = e.PerformSaveOperation();

			// Write the code to be run after saving here.
			e.ReturnStatus = true;
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(EventType=InfoPathEventType.OnContextChange)]
		public void OnContextChange(DocContextChangeEvent e)
		{

			if (e.Type == "ContextNode")
			{
				// XML Selection or Context has changed. Write code here to respond to the changes.
				_ContextNode = e.Context;
				return;
			}

		}
		/// <summary>
		/// This method is callled by standard text task panel 
		/// </summary>
		/// <param name="phraseID"></param>
		public void TaskPanelInsertPhrase(string phraseID)
		{
			try
			{
				Phrase.InsertPhrase(this._ContextNode, phraseID);
			}
			catch(Exception ex) 
			{
				this.thisXDocument.UI.Alert(ex.Message);
			}
		}



		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="/BDWInfoPathLesson/Players/Player", EventType=InfoPathEventType.OnBeforeChange)]
		public void Player_OnBeforeChange(DataDOMEvent e)
		{
			//Validation
			//If a player is used by a Page, this player can't be deleted
			if (e.Operation=="Delete" && e.Source.nodeName == "Player")
			{
				string playerID = e.Source.attributes.getNamedItem("ID").text;
				IXMLDOMNode node = this.thisXDocument.DOM.selectSingleNode("//MeetThePlayer[@ID='" + playerID+"']");
				if (node!=null)
				{
					string detailedMessage = "This player cannot be deleted because it is used by some Pages";
					
					e.ReturnMessage = detailedMessage;
					
					e.ReturnStatus = false;
				}
			}
			e.ReturnStatus = true;
		}



		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnPageElement_MoveUp", EventType=InfoPathEventType.OnClick)]
		public void btnPageElement_MoveUp_OnClick(DocActionEvent e)
		{
			MoveUp(e);
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnPageElement_MoveDown", EventType=InfoPathEventType.OnClick)]
		public void btnPageElement_MoveDown_OnClick(DocActionEvent e)
		{
			MoveDown(e);
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnPageElement_Delete", EventType=InfoPathEventType.OnClick)]
		public void btnPageElement_Delete_OnClick(DocActionEvent e)
		{
			Delete(e);
			
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnPage_MoveUp", EventType=InfoPathEventType.OnClick)]
		public void btnPage_MoveUp_OnClick(DocActionEvent e)
		{
			MoveUp(e);
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnPage_MoveDown", EventType=InfoPathEventType.OnClick)]
		public void btnPage_MoveDown_OnClick(DocActionEvent e)
		{
			MoveDown(e);
		}


		/// <summary>
		/// Move the group up 
		/// </summary>
		/// <param name="e"></param>
		private void MoveUp(DocActionEvent e)
		{
			IXMLDOMNode currentRow = e.Source;
			IXMLDOMNode rows = currentRow.parentNode;
			IXMLDOMNode previousRow = currentRow.selectSingleNode("preceding-sibling::" + currentRow.nodeName + "[1]");
			rows.insertBefore(currentRow, previousRow);
		}
		/// <summary>
		/// Move the group down
		/// </summary>
		/// <param name="e"></param>
		private void MoveDown(DocActionEvent e)
		{
			IXMLDOMNode currentRow = e.Source;
			IXMLDOMNode rows = currentRow.parentNode;
			IXMLDOMNode nextRow = currentRow.selectSingleNode("following-sibling::"+ currentRow.nodeName);
			rows.insertBefore(nextRow, currentRow);
		}
		
		/// <summary>
		/// Delete the current node
		/// </summary>
		/// <param name="e"></param>
		private void Delete(DocActionEvent e)
		{
			IXMLDOMNode currentRow = e.Source;
			IXMLDOMNode rows = currentRow.parentNode;
			rows.removeChild(currentRow);
		}

	}
}
