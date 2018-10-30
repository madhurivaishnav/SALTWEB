using System;
using System.Xml.Serialization;

using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.App_Code.Entity
{
	[Serializable]
	public class Lang : _BaseEntity
	{
		public Lang() { }

		private string langCode = string.Empty;
		public string LangCode
		{
			get
			{
				return langCode;
			}
			set
			{
				int limit = 20;
				if (value.Length > limit) 
					throw new ApplicationException("LangCode field exceeds " + limit + " character limit");

				langCode = value;
			}
		}


		private bool showAdmin = false;
		public bool ShowAdmin
		{
			get
			{
				return showAdmin;
			}
			set
			{
				showAdmin = value;
				//-- If it is not to show in ADMIN, it is not to show in USER
				if (value == false) 
					showUser = false;
			}
		}

	
		private bool showUser = false;
		public bool ShowUser
		{
			get
			{
				return showUser;
			}
			set
			{
				if (value == true)
					showAdmin = true;

				showUser = value;
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
