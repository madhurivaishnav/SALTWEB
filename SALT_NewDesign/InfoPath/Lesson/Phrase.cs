using System;
using Microsoft.Office.Interop.InfoPath.SemiTrust;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// Summary description for Phrase.
	/// </summary>
	public class Phrase
	{
		private static IXMLDOMDocument _PhraseDoc;

		public static IXMLDOMDocument PhraseDoc	
		{
			get
			{
				return _PhraseDoc;
			}
			set
			{
				_PhraseDoc = value;
			}

		}
		/// <summary>
		/// Insert phrase to the selected rich text box
		/// </summary>
		/// <param name="targetNode"></param>
		/// <param name="phraseID"></param>
		/// <param name="phraseDoc"></param>
		public static void InsertPhrase(IXMLDOMNode targetNode, string phraseID)
		{
			//1. Add an empty line	
			//Phrase can only be inserted into rich text box
			//If the node is not rich text box node, an exception will be thrown
			//There is no way to tell whether a node is rich text box (work around, try error)
			try
			{
				//<div xmlns="http://www.w3.org/1999/xhtml"></div>
				IXMLDOMNode emptyline = targetNode.ownerDocument.createNode(1,"div", "http://www.w3.org/1999/xhtml");
				targetNode.appendChild(emptyline);
			}
			catch(Exception)
			{
				//Ignore the error, 
				throw new Exception("Standard text can only be inserted into rich text box");
			}

			//Remove data from the target node
			targetNode.text = "";
			//2. Add the phrase to the selected rich text box
			// Example phrase entry, it is in the phrase xml file:
			//<Phrase ID="Text3">
			//		<Title>End Lesson</Title>
			//		<Text><div xmlns="http://www.w3.org/1999/xhtml">Congratulation! you have completed your lesson.</div>
			//									<div xmlns="http://www.w3.org/1999/xhtml">Click the <strong>End Lesson</strong> button to exit the lesson</div></Text>
			//</Phrase>

			IXMLDOMNode phrase =  _PhraseDoc.selectSingleNode("//Phrase[@ID='" +phraseID +"']");
			IXMLDOMNode text =  phrase.selectSingleNode("Text");
			
			//Add all child nodes	
			foreach(IXMLDOMNode child in text.childNodes)
			{
				targetNode.appendChild(child.cloneNode(true));
			}
		}
	}
}
