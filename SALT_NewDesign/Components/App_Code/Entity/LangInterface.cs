using System;
using System.Xml.Serialization;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.App_Code.Entity
{
	/// <summary>
	/// Summary description for LangInterface.
	/// </summary>
	[Serializable]
	public class LangInterface : _BaseEntity
	{
		public LangInterface() { }

		private string interfaceType = string.Empty;
		public string InterfaceType
		{
			get
			{
				return interfaceType;
			}
			set
			{
				int limit = 20;
				if (value.Length > limit) 
					throw new ApplicationException("Type field exceeds " + limit + " character limit");
				
				interfaceType = value;
			}
		}
		private string pageTitle = string.Empty;
		public string PageTitle
		{
			get
			{
				return pageTitle;
			}
			set
			{
				pageTitle = value;
			}
		}



		private int committedCount = 0;
		public int CommittedCount
		{
			get
			{
				return committedCount;
			}
			set
			{
				committedCount = value;
			}
		}
	}
}
