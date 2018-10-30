using System;
using System.Collections;
using Bdw.Application.Salt.App_Code.Data;
using Bdw.Application.Salt.App_Code.Entity;

namespace Bdw.Application.Salt.App_Code.API
{
	public class LangInterfaceAPI
	{
		/// <summary> Get list of interfaces </summary>
		public static ArrayList InterfaceList(int langID)
		{
			ArrayList list = LangInterfaceDB.LoadList(langID);
			return list;
		}


		/// <summary> Get interface record </summary>
		public static LangInterface GetEntity(int langInterfaceID)
		{
			LangInterface langInterface = LangInterfaceDB.Load(langInterfaceID);
			return langInterface;
		}
	}
}
