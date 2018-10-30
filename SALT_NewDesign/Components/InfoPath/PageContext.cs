using System;
using System.Web;
using System.Web.Caching;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using Localization;
namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// The base class of current page context
	/// </summary>
	[Serializable()]
	public abstract class PageContext
	{
		
		/// <summary>
		/// The private fields will be serialized and saved in the ViewState
		/// For perfomance purpose, minimize the information to be stored
		/// </summary>
		#region Fields
		private string m_strPath;
		private DateTime m_dtStartTime;
		/// <summary>
		/// This is the index of the current page, the value is the index of am_intPagesShown
		/// For Lesson, the page index is the same as page index in control file
		/// For Quiz, the page index is different from page index in control file
		///		For example: If a page index is 5, the actual page index in control file may be 10
		/// </summary>
		private int m_intPageIndex;
		/// <summary>
		/// This is the list of pages that will be shown to the user. The value is page index in the control file.
		///  For Lesson, the number of pages and orders are the same as pages in control file.
		///	 For Quiz, the number of questions will be randomly selected. the number of pages and order are different from pages in control file.
		/// </summary>
		/// <example>
		/// 1) Lesson:
		/// A Lesson contains 13 Pages
		/// The page index will be:  0,1,2,3,4,5,6,7,8,9,10,11,12 
		/// The am_intPagesShown will be: 0,1,2,3,4,5,6,7,8,9,10,11,12
		/// 2) Quiz:
		/// A Quiz contains 2 introduction pages, 10 questions, 1 complete page
		/// The page index will be:  (Introduction)0,1,(Questions)2,3,4,5,6,7,8,9,10,11,(Complete)12 
		/// If the number of questions requested is 4, the value of am_intPagesShown may be: (Introduction)0,1, (Questions) 7,11,3,10, (Complete) 12
		///</example>
		protected int[] am_intPagesShown;

		#endregion
		
		#region Contructors
		public PageContext()
		{
           
		}
		#endregion

		#region Module level Properties
		/// <summary>
		/// Gets or sets the current page context.
		/// Page context is set when the Lesson.aspx or Quiz.aspx is loaded. It is stored in the ViewState.
		/// It can be used to organize and share data between page and user controls during an HTTP request.
		/// </summary>
        public static PageContext Current
        {
            get
            {
                return (PageContext) HttpContext.Current.Items["__PageContext"];
            }
            set
            {
                HttpContext.Current.Items["__PageContext"] = value;
            }
        }

        /// <summary>
        /// Get the current session ID
        /// </summary>
        public string SessionID
        {
            get
            {
                return HttpContext.Current.Request.QueryString["SessionData"];
            }
        }
		/// <summary>
		/// Gets or sets the path of the lesson or quiz.
		/// It is stored in the ViewState
		/// </summary>
		public string Path
		{
			get
			{
				return m_strPath;
			}
			set
			{
				m_strPath = value;
			}
		}



		/// <summary>
		/// Is the current mode preview
		/// </summary>
		///<remarks>
		/// If true then no events fire.
		/// If false then events fire.
		///</remarks>
		public bool IsPreviewMode
		{
			get
			{
				// If there is no session id, it is in preview mode
				if (this.SessionID==null ||this.SessionID.Length<5)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		/// <summary>
		/// Gets or set the time that the lesson or quiz was started.
		///	It is stored in the ViewState,
		/// </summary>
		public DateTime StartTime
		{
			get
			{
				return m_dtStartTime;
			}
			set
			{
				m_dtStartTime = value;
			}
		}


		/// <summary>
		/// Get the Title of the current module
		/// </summary>
        public string Title
        {
            get 
            {
					string strXpath = "Summary/Title";
                    XmlNode objTitleNode = DataFile.DocumentElement.SelectSingleNode(strXpath);
                    return objTitleNode.InnerText;
            }
        }
		/// <summary>
		/// Get the page count of the current module
		/// </summary>
		public int PageCount
		{
			get
			{
				return this.am_intPagesShown.Length;
			}
		}

		/// <summary>
		/// Get the presentation style of the current module
		/// </summary>
		public string Style
		{
			get
			{
				return this.ControlFile.Style;
			}
		}
		/// <summary>
		/// Gets the current control file
		/// It is stored in the Cache
		/// </summary>
		public XmlDocument DataFile
		{
			get
			{
				string cacheKey;
				cacheKey = this.Path+"/DataFile";
				if (HttpContext.Current.Cache[cacheKey]==null)
				{
					this.LoadFiles();
				}

				return (XmlDocument)HttpContext.Current.Cache[cacheKey];
			}
		}

		/// <summary>
		/// Gets the current control file
		/// It is stored in the Cache
		/// </summary>
		protected ControlFile ControlFile
		{
			get
			{
				string cacheKey;
				cacheKey = this.Path+"/ControlFile";
				if (HttpContext.Current.Cache[cacheKey]==null)
				{
					this.LoadFiles();
				}
				return (ControlFile)HttpContext.Current.Cache[cacheKey];
			}
		}
		#endregion

		#region Page level Properties

		/// <summary>
		/// Gets or set the current page ID. 
		///</summary>
		///<remarks>
		/// This is the index of the pages collection
		/// It is set by navigation controls.
		/// For Lesson,It is the index of Current.ControlFile.Pages collection
		/// For Quiz, it is the index of Current.ControlFIlePages collection
		///</remarks>
		/// </summary>
		public int PageIndex
		{
			get
			{
				return m_intPageIndex;
			}
			set
			{
				m_intPageIndex = value;
			}
		}

		/// <summary>
		/// Gets the current page id
		/// </summary>
		public string PageID
		{
			get
			{
				return this.ControlFilePage.PageID;
			}
		}
//		/// <summary>
//		/// Gets the current page title
//		/// </summary>
//		public string PageTitle
//        {
//            get
//            {
//					// For Lesson, Path: /BDWInfoPathLesson/Pages/Page/Title
//					// For Quiz, Path: 
//					//		/BDWInfoPathQuiz/Introduction/Page/Title
//					//		/BDWInfoPathQuiz/Questions/Page/Title
//					//		/BDWInfoPathQuiz/Complete/Page/Title
//					string strXpath = "*/Page[@ID='" + PageID + "']/Title";
//                    XmlNode objTitleNode = DataFile.DocumentElement.SelectSingleNode(strXpath);
//                    return objTitleNode.InnerText;
//            }
//        }
		/// <summary>
		/// Gets the current page layout
		/// </summary>
		public string Layout
		{
			get
			{
				return this.ControlFilePage.Layout;
			}
		}

		/// <summary>
		/// Gets the current page type
		/// </summary>
		public string PageType
		{
			get
			{
				return this.ControlFilePage.PageType;
			}
		}

		/// <summary>
		/// Is the current page the first page
		/// </summary>
		public bool IsFirstPage
		{
			get
			{
				if (PageIndex == 0)
				{
					// This must be the first page
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		/// <summary>
		/// Is the current page the last page
		/// </summary>
        public bool IsLastPage
        {
            get
            {
                if (PageIndex == this.am_intPagesShown.Length  - 1 )
                {
                    // This must be the last page
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
		/// <summary>
		/// Get the current page control data, including pageID, layout and page type
		/// </summary>
		protected ControlFilePage ControlFilePage
		{
			get
			{
				int controlFilePageIndex = this.am_intPagesShown[this.PageIndex];

				return this.ControlFile.Pages[controlFilePageIndex];
			}
		}

		#endregion
		
		#region public methods

		public void Initialize()
		{
			//1. Load data file
			this.LoadFiles();

			//2. Order pages
			// Get a list of pages to be shown to the user
			this.OrderPages();
		}


		public int FindPageIndex(string pageID)
		{
			int controlFilePageIndex;
			for(int i=0;i<am_intPagesShown.Length;i++)
			{
				controlFilePageIndex = am_intPagesShown[i];
				if (ControlFile.Pages[controlFilePageIndex].PageID == pageID)
				{
					return i;
				}
			}
			throw new ApplicationException(String.Format(ResourceManager.GetString("PageContext.cs.FindPageIndex"), pageID));
		}

		#endregion

		#region private methods

		private void LoadFiles()
		{
			string cacheKey;
			cacheKey = this.Path+"/DataFile";
			//if the DataFile is not cached or expired, load and cache the data object
			if (HttpContext.Current.Cache[cacheKey]==null)
			{
				this.CacheDataFile();
			}

			//2. Load control file
			cacheKey = this.Path+"/ControlFile";
			//if the controlFile is not cached or expired, load and cache the control object
			if (HttpContext.Current.Cache[cacheKey]==null)
			{
				this.CacheControlFile();
			}

		}
		private void CacheControlFile()
		{
			string path = this.Path;
			//1. Load the xml file
			// A FileStream is needed to read the XML document.
			string fileName = HttpContext.Current.Server.MapPath(this.Path+"/Control.xml");
			if (!File.Exists(fileName))
			{
				throw new FileNotFoundException(ResourceManager.GetString("PageContext.cs.CacheControlFile"));
			}
			FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
			XmlReader reader = new XmlTextReader(fs);
          
			//2. Deserialize the object
			// Create an instance of the XmlSerializer specifying type and namespace.
			XmlSerializer serializer = new XmlSerializer(typeof(ControlFile), new Type[]{typeof(ControlFilePage)});
			// Declare an object variable of the type to be deserialized.
			ControlFile controlFile;
			// Use the Deserialize method to restore the object's state.
			controlFile = (ControlFile) serializer.Deserialize(reader);

            fs.Close();
            fs=null;
			
			//3. Cache the control object with a dependency on control.xml XML file
			HttpContext.Current.Cache.Insert(path + "/ControlFile", controlFile, new CacheDependency(fileName));
		}

		private void CacheDataFile()
		{
			string path = this.m_strPath;
			//1. Load the xml file
			// A FileStream is needed to read the XML document.
			string fileName = HttpContext.Current.Server.MapPath(path+"/Data.xml");
			if (!File.Exists(fileName))
			{
				throw new FileNotFoundException(ResourceManager.GetString("PageContext.cs.CacheDataFile"));
			}
			XmlDocument dataDoc= new XmlDocument();
			dataDoc.Load(fileName);
			
			//2. Cache the data object with a dependency on data.xml XML file
			HttpContext.Current.Cache.Insert(path + "/DataFile", dataDoc, new CacheDependency(fileName));
		}

		protected abstract void OrderPages();

		#endregion
	}
}

