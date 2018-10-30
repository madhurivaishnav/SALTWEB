using System;
using System.Xml.Serialization;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.App_Code.Entity
{
	/// <summary>
	/// Summary description for LangResource.
	/// </summary>
	[Serializable]
	public class LangResource : _BaseEntity
	{
		public LangResource() { }

		private string resourceType = string.Empty;
		public string ResourceType
		{
			get
			{
				return resourceType;
			}
			set
			{
				int limit = 20;
				if (value.Length > limit) 
					throw new ApplicationException("Type field exceeds " + limit + " character limit");
				
				resourceType = value;
			}
		}


		private string comment = string.Empty;
		public string Comment
		{
			get
			{
				return comment;
			}
			set
			{
				int limit = 200;
				if (value.Length > limit) 
					throw new ApplicationException("Comment field exceeds " + limit + " character limit");
				
				comment = value;
			}
		}

	}
}
