using System;
using System.Xml.Serialization;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.App_Code.Entity
{
	/// <summary>
	/// Summary description for _Base.
	/// </summary>
	[Serializable]
	public abstract class _BaseEntity
	{
		public _BaseEntity() {	}


		private int recordID = 0;
		public int RecordID
		{
			get
			{ 
				return recordID; 
			}
			set
			{
				recordID = value;
			}
		}

		
		private string recordName = string.Empty;
		public string RecordName
		{
			get
			{ 
				return recordName; 
			}
			set
			{
				int limit = 200;
				if (value.Length > limit) 
					throw new ApplicationException("Name field exceeds " + limit + " character limit");

				recordName = value;
			}
		}


		private int userid = 0;
		public int UserID
		{
			get
			{ 
				return userid; 
			}
			set
			{
				userid = value;
			}
		}


		//-- Created
		internal int userCreated = 0;
		public int UserCreated
		{
			get
			{
				return userCreated;
			}
		}


		internal DateTime dateCreated = DateTime.Parse("1/1/1900");
		public DateTime DateCreated
		{
			get
			{
				return dateCreated;
			}
		}



		//-- Modified
		internal int userModified = 0;
		public int UserModified
		{
			get
			{
				return userModified;
			}
		}


		internal DateTime dateModified = DateTime.Parse("1/1/1900");
		public DateTime DateModified
		{
			get
			{
				return dateModified;
			}
		}



		//-- Deleted
		internal int userDeleted = 0;
		public int UserDeleted
		{
			get
			{
				return userDeleted;
			}
		}


		internal DateTime dateDeleted = DateTime.Parse("1/1/1900");
		public DateTime DateDeleted
		{
			get
			{
				return dateDeleted;
			}
		}



		//-- RecordLock
		internal Guid recordLock = Guid.Empty;
		public Guid RecordLock
		{
			get
			{
				return recordLock;
			}
			set
			{
				recordLock = value;
			}
		}

	}
}
