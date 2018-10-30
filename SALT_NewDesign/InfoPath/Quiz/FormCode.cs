using System;
using Microsoft.Office.Interop.InfoPath.SemiTrust;
using Bdw.Application.Salt.InfoPath;

// Office integration attribute. Identifies the startup class for the form. Do not
// modify.
[assembly: System.ComponentModel.DescriptionAttribute("InfoPathStartupClass, Version=1.0, Class=Quiz.Quiz")]

namespace Quiz
{
	// The namespace prefixes defined in this attribute must remain synchronized with
	// those in the form definition file (.xsf).
	[InfoPathNamespace("xmlns:my=\"http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-22T04-03-10\" xmlns:xsf=\"http://schemas.microsoft.com/office/infopath/2003/solutionDefinition\" xmlns:msxsl=\"urn:schemas-microsoft-com:xslt\" xmlns:xdUtil=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Util\" xmlns:xdXDocument=\"http://schemas.microsoft.com/office/infopath/2003/xslt/xDocument\" xmlns:xdMath=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Math\" xmlns:xdDate=\"http://schemas.microsoft.com/office/infopath/2003/xslt/Date\" xmlns:xd=\"http://schemas.microsoft.com/office/infopath/2003\" xmlns:ns1=\"http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-17T05:07:10\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xhtml=\"http://www.w3.org/1999/xhtml\" xmlns:ns2=\"http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-17T22:48:56\"")]
	public class Quiz
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
			//Most of  validations are completed by the validation rule in design mode
			//a. Validate the SubmitAnswers button
			//1)There is one SubmitAnswers button on the active pages
			//2)There is only one SubmitAnswers button on the active pages
			//3)That page must be the last page
			IXMLDOMNodeList endQuizPages = this.thisXDocument.DOM.selectNodes("//Complete/Page[@IsActive='true' and .//SubmitAnswers]");
			//1) no SubmitAnswers control
			if (endQuizPages.length==0)
			{
				this.thisXDocument.UI.Alert("This form contains the following validation errors:\n\nThere is no SubmitAnswers control, this control must be on the last active page.\n");
				e.ReturnStatus = true;
				return;
			}
			//2) More that 1 SubmitAnswers control
			else if (endQuizPages.length>1)
			{
				this.thisXDocument.UI.Alert("This form contains the following validation errors:\n\nSubmitAnswers control is on more than one active pages, this control can only be on the last active page.\n");
				e.ReturnStatus = true;
				return;
			}
				//One SubmitAnswers control
			else 
			{
				IXMLDOMNode endControlPage = endQuizPages[0];
				//3) Is this page the last active page?
				IXMLDOMNodeList followingSiblingPages = endControlPage.selectNodes("following-sibling::Page[@IsActive='true']");
				if (followingSiblingPages.length>0)
				{
					this.thisXDocument.UI.Alert("This form contains the following validation errors:\n\nSubmitAnswers control is on other active page, this control can only be on the last active page.\n");
					e.ReturnStatus = true;
					return;
				}
			}
		
			//2. Set the quiz ID as the default new file name
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
		[InfoPathEventHandler(MatchPath="btnIntroductionPageElement_MoveDown", EventType=InfoPathEventType.OnClick)]
		public void btnIntroductionPageElement_MoveDown_OnClick(DocActionEvent e)
		{
			MoveDown(e);
			
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnIntroductionPageElement_MoveUp", EventType=InfoPathEventType.OnClick)]
		public void btnIntroductionPageElement_MoveUp_OnClick(DocActionEvent e)
		{
			MoveUp(e);
			
		}


		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnQuestion_MoveUp", EventType=InfoPathEventType.OnClick)]
		public void btnQuestion_MoveUp_OnClick(DocActionEvent e)
		{
			MoveUp(e);
			
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnQuestion_MoveDown", EventType=InfoPathEventType.OnClick)]
		public void btnQuestion_MoveDown_OnClick(DocActionEvent e)
		{
			MoveDown(e);
			
		}


		/// <summary>
		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnIntroductionPageElement_Delete", EventType=InfoPathEventType.OnClick)]
		public void btnIntroductionPageElement_Delete_OnClick(DocActionEvent e)
		{
			Delete(e);
		}


		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnCompletePageElement_MoveDown", EventType=InfoPathEventType.OnClick)]
		public void btnCompletePageElement_MoveDown_OnClick(DocActionEvent e)
		{
			MoveDown(e);
			
		}

		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnCompletePageElement_MoveUp", EventType=InfoPathEventType.OnClick)]
		public void btnCompletePageElement_MoveUp_OnClick(DocActionEvent e)
		{
			MoveUp(e);
			
		}



		// The following function handler is created by Microsoft Office InfoPath. Do not
		// modify the type or number of arguments.
		[InfoPathEventHandler(MatchPath="btnCompletePageElement_Delete", EventType=InfoPathEventType.OnClick)]
		public void btnCompletePageElement_Delete_OnClick(DocActionEvent e)
		{
			Delete(e);
		}

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
