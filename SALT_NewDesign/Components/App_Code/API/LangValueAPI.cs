using System;
using System.Data;
using System.Collections;
using Bdw.Application.Salt.App_Code.Entity;
using Bdw.Application.Salt.App_Code.Business;

// TODO - remoave all data layer references from all APIs.
using Bdw.Application.Salt.App_Code.Data;

namespace Bdw.Application.Salt.App_Code.API
{
	public class LangValueAPI
	{
		public static LangValue GetEntity(int langValueID)
		{
			LangValue langValue = LangValueDB.Load(langValueID);
			return langValue;
		}

		public static void Save(LangValue langValue)
		{
			LangValueBUS.Save(langValue);	
		}

		/// <summary> Commit language values to active </summary>
		public static void Commit(int userID, int langID)
		{
			ArrayList list = LoadUnCommitList(langID);
			LangValueBUS.Commit(userID, list);
		}
		
		public static void Commit(int userID, int langID, int langInterfaceID)
		{
			ArrayList list = LoadUnCommitList(langID, langInterfaceID);
			LangValueBUS.Commit(userID, list);
		}
		
		public static void Commit(int userID, int langID, int langInterfaceID, int langResourceID)
		{
			LangValue unCommitted = LangValueDB.Load(langID, langInterfaceID, langResourceID, false);
			LangValueBUS.Commit(userID, unCommitted);
		}


		public static ArrayList LoadFlagList(bool active)
		{
			ArrayList list = LangValueDB.LoadFlagList(active);
			return list;
		}

		/// <summary> Get list of template resource / committed language value pairs </summary>
		public static DataTable Resourcelist(int langID, int langInterfaceID)
		{
			//-- Get the english version
			Lang english = LangDB.Load("en-AU");

			DataTable dt = LangResourceDB.LoadList(english.RecordID, langInterfaceID);

			return dt;
		}

		public static ArrayList LoadActiveList(int langID, int langInterfaceID)
		{
			return LangValueDB.LoadList(langID, langInterfaceID, true);
		}

		public static ArrayList LoadUnCommitList(int langID)
		{
			return LangValueDB.LoadList(langID, 0, false);
		}
		public static ArrayList LoadUnCommitList(int langID, int langInterfaceID)
		{
			return LangValueDB.LoadList(langID, langInterfaceID, false);
		}
	}
}