using System;
using System.IO;
using System.Xml.Serialization;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// This class is used as the base class for all other pages. 
	/// It contains the common functions.
	/// The main functionality of this class is to keep the page context when a page is posted back transferred to another page.
	/// </summary>
	public class PageBase : System.Web.UI.Page
	{
		/// <summary>
		/// This method override the default implementation of the LoadViewState method. 
		/// It gets the PageContext from ViewState and save it in current request context.
		/// </summary>
		/// <param name="savedState"></param>
		override protected void LoadViewState(object savedState)
		{
			base.LoadViewState(savedState);
			if (this.ViewState["__PageContext"]!=null)
				PageContext.Current = (PageContext)this.ViewState["__PageContext"];
		}
		/// <summary>
		/// This method override the default implementation of the SaveViewState method. 
		/// It gets the Page Mode from current request context and save it in ViewState.
		/// </summary>
		/// <returns></returns>
		override protected object SaveViewState()
		{
			if (PageContext.Current!=null)
				this.ViewState["__PageContext"] = PageContext.Current;
			return base.SaveViewState();				
		}

	}
}
