using System;
using System.Xml.Serialization;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.App_Code.Entity
{
	/// <summary>
	/// Summary description for LangValue.
	/// </summary>
	[Serializable]
	public class LangValue : _BaseEntity
	{
		public LangValue() { }

		private string langCode = string.Empty;
		public string LangCode
		{
			get
			{
				return langCode;
			}
			set
			{
				langCode = value;
			}
		}
		
		private string langEntryValue = string.Empty;
		public string LangEntryValue
		{
			get
			{
				return langEntryValue;
			}
			set
			{
				langEntryValue = value;
			}
		}



		private bool active = false;
		public bool Active
		{
			get
			{
				return active;
			}
			set
			{
				active = value;
			}
		}

		

		internal int langID = 0;
		public int LangID
		{
			get
			{
				return langID;
			}
			set
			{
				if (lang != null && lang.RecordID != value)
					lang = null;
				langID = value;
			}
		}

		private Lang lang = null;
		public Lang Lang
		{
			get
			{
				return lang;
			}
			set
			{
				lang = value;
				langID = value.RecordID;
			}
		}



		internal int langInterfaceID = 0;
		public int LangInterfaceID
		{
			get
			{
				return langInterfaceID;
			}
			set 
			{
				if (langInterface != null && langInterface.RecordID != value)
					langInterface = null;
				langInterfaceID = value;
			}

		}

		private LangInterface langInterface = null;
		public LangInterface LangInterface
		{
			get
			{
				return langInterface;
			}
			set
			{
				langInterface = value;
				langInterfaceID = value.RecordID;
			}
		}



		internal int langResourceID = 0;
		public int LangResourceID
		{
			get
			{
				return langResourceID;
			}
			set 
			{
				if (langResource != null && langResource.RecordID != value)
					langResource = null;
				langResourceID = value;
			}
		}

		private LangResource langResource = null;
		public LangResource LangResource
		{
			get
			{
				return langResource;
			}
			set
			{
				langResource = value;
				langResourceID = value.RecordID;
			}
		}
	}
}
