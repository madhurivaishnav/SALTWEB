using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using Bdw.Application.Salt.App_Code.Data;
using Bdw.Application.Salt.App_Code.Entity;

using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.App_Code.Business
{
	/// <summary>
	/// Summary description for LangValueBUS.
	/// </summary>
	public class LangValueBUS
	{
		/// <summary> Save the LangValue, if the object is active, make it inactive and set ID to zero, a new record will be created.</summary>
		internal static void Save(LangValue langValue)
		{
			//-- if the current one is active, we will create a new record.
			if (langValue.Active)
			{
				langValue.RecordID = 0;
				langValue.Active = false;
			}

			try
			{
				LangValueDB.Save(langValue);	
			}
			catch (SqlException ex)
			{
				if (ex.Number == 2627)
					throw new ApplicationException("This record has already been edited. Ensure the record was not edited by another person or yourself in another browser. Please try again.");
			}
		}


		
		internal static void Commit(int userID, ArrayList list)
		{
			foreach (LangValue langValueUnCommited in list)
			{
				Commit(userID, langValueUnCommited);
			}
		}
		internal static void Commit(int userID, LangValue langValueUnCommitted)
		{
			langValueUnCommitted.UserID = userID;

			//-- Find committed version if it exists.
			LangValue langValueActive = LangValueDB.Load(langValueUnCommitted.LangID, langValueUnCommitted.LangInterfaceID, langValueUnCommitted.LangResourceID, true);
			langValueActive.UserID = userID;

			LangValueDB.Commit(langValueActive, langValueUnCommitted);
		}
	}
}
