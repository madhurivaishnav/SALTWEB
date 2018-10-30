using System;
using System.Collections;
using System.Web;
using System.Collections.Specialized;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// Summary description for QuizPageContext.
	/// </summary>
	[Serializable()]
	public class QuizPageContext: PageContext
	{
		#region Fields        
		private NameValueCollection m_strAnswers;
		#endregion

		#region Contructors
		public QuizPageContext():base()
		{
			m_strAnswers = new NameValueCollection();
		}
		#endregion

		#region Module level Properties
		/// <summary>
		/// Get the number of questions to be shown to the user
		/// </summary>
		public int QuestionCount
		{
			get
			{
				int questionCount=0;
				int controlFilePageIndex;
				for(int i=0;i<base.am_intPagesShown.Length;i++)
				{
					controlFilePageIndex = base.am_intPagesShown[i];
					if (ControlFile.Pages[controlFilePageIndex].PageType  == "Questions")
					{
						questionCount++;
					}
				}
				return questionCount;
			}
		}

		/// <summary>
		/// Gets a list of answer ID that the student has selected.
		///	The value is stored in ViewState.
		/// </summary>
		public NameValueCollection Answers
		{
			get
			{
				return m_strAnswers;
			}
		}
		#endregion

		#region Page level Properties
		/// <summary>
		/// Get the currrent question index
		/// </summary>
		public int QuestionIndex
		{
			get
			{
				if (this.PageType != "Questions")
				{
					return 0;
				}

				int questionIndex=0;
				int controlFilePageIndex;
				for(int i=0; i< base.am_intPagesShown.Length;i++)
				{
					controlFilePageIndex = base.am_intPagesShown[i];
					if (ControlFile.Pages[controlFilePageIndex].PageType  == "Questions")
					{
						questionIndex++;
					}

					if (i == this.PageIndex)
					{
						break;
					}
				}

				return questionIndex;
			}
		}

        /// <summary>
        /// Gets or sets the answer ID of the current question
        /// </summary>
        public string Answer
        {
            get
            {
                if (m_strAnswers[PageID]!=null)
                {
                    return m_strAnswers[PageID].ToString();
                } 
                else
                {
                    return "";
                }
            }    
            set
            {
                m_strAnswers.Remove(PageID);
                m_strAnswers.Add(PageID,value);
            }
        }


		#endregion

		#region public methods
		#endregion

		#region private methods

		/// <summary>
		/// Gets a list of Page to  be shown to the user. it maps to ControlFile.Pages;
		/// It is stored in ViewState, and used for navigation control.
		/// When a quiz is loaded, the list of page index will include:
		///		.All introduction pages
		///		.The number of question pages that are randomly selected (specified by querystring)
		///		.All Complete pages
		/// </summary>
		/// <example>
		/// A Quiz contains 2 introduction pages, 10 questions, 1 complete page
		/// The page index will be:  (Introduction)1,2,(Questions)3,4,5,6,7,8,9,10,11,12,(Complete)13 
		/// If the number of questions requested is 4, the pages selected may be: (Introduction)1,2, (Questions) 7,11,3,10, (Complete) 13
		///</example>
		protected override void OrderPages()
		{
			ArrayList objPageList = new ArrayList();
			int intNumberOfQuestionsReqeust;
			int intTotalQuestionsAvailable;

			//1. Get the number of question requested
			//If the request number is greater than the question available, set the request number to available number
			intTotalQuestionsAvailable  = ControlFile.QuesionPages;
			try
			{
				intNumberOfQuestionsReqeust = Int32.Parse(HttpContext.Current.Request.QueryString["noq"]);
				if (intNumberOfQuestionsReqeust>intTotalQuestionsAvailable ||intNumberOfQuestionsReqeust<1)
				{
					intNumberOfQuestionsReqeust = intTotalQuestionsAvailable;
				}
			}
			catch
			{
				intNumberOfQuestionsReqeust = intTotalQuestionsAvailable;

			}

			//2. Get a list of pages that will be shown to the user
			///		.All introduction pages
			///		.The number of question pages that are randomly selected (specified by querystring)
			///		.All Complete pages
			//2.1 All introduction pages
			int pageIndex=0;
			foreach (ControlFilePage objPage in ControlFile.Pages)
			{
				if (objPage.PageType == "Introduction")
				{
					objPageList.Add(pageIndex);
				}
				pageIndex++;
			}

			//2.2 The number of question pages that are randomly selected (specified by querystring)
			//Get a list of questions, the value is page index
			ArrayList questions = new ArrayList();
			pageIndex=0;
			foreach (ControlFilePage objPage in ControlFile.Pages)
			{
				if (objPage.PageType == "Questions")
				{
					questions.Add(pageIndex);
				}
				pageIndex++;
			}
			//Get random number of question from the question list
			Random objRandom = new Random();
			int intRandom;
			for(int i=1;i<=intNumberOfQuestionsReqeust;i++)
			{
				intRandom =objRandom.Next(questions.Count); 
				objPageList.Add(questions[intRandom]);
				questions.RemoveAt(intRandom);
			}

			//2.3 All Complete pages
			pageIndex=0;
			foreach (ControlFilePage objPage in ControlFile.Pages)
			{
				if (objPage.PageType == "Complete")
				{
					objPageList.Add(pageIndex);
				}
				pageIndex++;
			}

			//3. Set the list of page shown
			base.am_intPagesShown  = (int[]) objPageList.ToArray(typeof(int));
		}
		#endregion
	}
}
