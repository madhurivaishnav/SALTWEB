using System;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// Summary description for LessonPageContext.
	/// </summary>
	[Serializable()]
	public class LessonPageContext  : PageContext
	{
		#region Fields
        private int m_intBookmarkPageID;
		#endregion
	
		#region properties
		/// <summary>
		/// Gets or sets the bookmark page ID
		/// </summary>
        public int BookmarkPageID
        {
            get
            {
                return m_intBookmarkPageID;
            }
            set
            {
                m_intBookmarkPageID = value;
            }
        }
		#endregion
	
		#region public methods
		#endregion

		#region private methods

		/// <summary>
		/// Gets a list of Page to  be shown to the user. it maps to ControlFile.Pages;
		/// It is stored in ViewState, and used for navigation control.
		/// </summary>
		protected override void OrderPages()
		{
			//   For Lesson, the number of pages and order are the same as pages in control file.
			base.am_intPagesShown = new int[ControlFile.Pages.Length];
			for(int i=0;i<ControlFile.Pages.Length;i++)
			{
				base.am_intPagesShown[i]=i;
			}
		}
		#endregion
	}
}
