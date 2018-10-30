using System;
using System.Collections;
using Bdw.Application.Salt.App_Code.Data;
using Bdw.Application.Salt.App_Code.Entity;

namespace Bdw.Application.Salt.App_Code.API
{
	public class LangAPI
	{
		// <summary> List of languages not on Admin list</summary>
		public static ArrayList LanguageList()
		{
			ArrayList list = LangDB.LoadAdminList(false);
			return list;
		}

		/// <summary> List of languages on Admin list</summary>
		public static ArrayList LanguageAdminList()
		{
			ArrayList list = LangDB.LoadAdminList(true);
			return list;
		}

		/// <summary> List of languages available to user</summary>
		public static ArrayList LanguageUserList()
		{
			ArrayList list = LangDB.LoadUserList();
			return list;
		}

		/// <summary> Add language to Admin list</summary>
		public static void SaveShowAdmin(int langID, bool active, int userID)
		{
			Lang lang = LangDB.Load(langID);
			lang.ShowAdmin = active;
			lang.UserID = userID;

			LangDB.Save(lang);
		}
		
		/// <summary> Add language to User list</summary>
		public static void SaveShowUser(int langID, bool active, int userID)
		{
			Lang lang = LangDB.Load(langID);
			lang.ShowUser = active;
			lang.UserID = userID;

			LangDB.Save(lang);
		}

		/// <summary> Get Language record </summary>
		public static Lang GetEntity(int langID)
		{
			Lang lang = LangDB.Load(langID);
			return lang;
		}

	}
}
