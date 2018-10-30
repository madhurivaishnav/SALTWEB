using System;
using System.Collections;
using System.Xml.Serialization;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// Summary description for ControlFile.
	/// </summary>
	[Serializable]
    [XmlInclude(typeof(ControlFilePage))]
	public class ControlFile 
	{
        private string m_strStyle;
        private string m_strDefaultLayout;
        private ControlFilePage[] am_Pages;
      
		public ControlFile(ArrayList pages)
		{
            // must be passed a populated arraylist of pages which is uses to populate its 
            // Control file page array
            am_Pages = (ControlFilePage[]) pages.ToArray ( typeof (ControlFilePage) );
		}
        public ControlFile ()
        {
        }
        
        public string Style
        {
            set { m_strStyle = value; }
            get { return m_strStyle; }
        }
        public string DefaultLayout
        {
            set { m_strDefaultLayout = value; }
            get { return m_strDefaultLayout; }
        }
        public ControlFilePage[] Pages
        {
            get {return am_Pages;}
            set {am_Pages = value;}
        }
        public int QuesionPages
        {
            get
            {
                int intPageCount=0;
                foreach(ControlFilePage objPage in am_Pages)
                {
                    if (objPage.PageType=="Questions")
                    {
                        intPageCount++;
                    }
                }
                return intPageCount;
            }
        }
	}

    public class ControlFilePage
    {
        private string m_strPageID;
        private string m_strLayout;

        private string m_strPageType;
        public ControlFilePage(string pageID, string layout, string pageType)
        {
            m_strPageID = pageID;
            m_strLayout = layout;
            m_strPageType = pageType;
        }
        public ControlFilePage()
        {
        }
        public string PageID
        {
            set { m_strPageID = value; }
            get { return m_strPageID; }
        }
        public string Layout
        {
            set { m_strLayout = value; }
            get { return m_strLayout; }
        }
        public string PageType
        {
            set { m_strPageType = value; }
            get { return m_strPageType; }
        }
    }
}
