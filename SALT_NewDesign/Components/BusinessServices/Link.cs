using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Bdw.Application.Salt.Data;
using System.Configuration;
using Microsoft.ApplicationBlocks.Data;
using Localization;
using System.Web;
namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// This class handles the maintenance of links within the system
	/// </summary>
	public class Link : DatabaseService
	{
		/// <summary>
		/// Method returns a datatable containing links that exist within a single organisation
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 03/03/04
		/// Changes:
		/// </remarks>
		/// <param name="organisationID">The organisation from which the links are to be returned.</param>
		/// <returns>DataTable containing information relating to the links that exist.</returns>
		public static DataTable GetLinksByOrganisation(SqlInt32 organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLink_GetListByOrganisation",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			} 
		} //GetLinksByOrganisation
		
		/// <summary>
		/// Adds a Link to the tblLink table.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale,03/03/04
		/// Changes:
		/// </remarks>
		/// <param name="organisationID"> The ID of the  organisation to add the link to.</param>
		/// <param name="caption"> The caption of the link.</param>
		/// <param name="url"> The Url of the Link.</param>
		/// <param name="showDisclaimer"> Flag to indicate whether or not to show the disclaimer.</param>
		/// <param name="userID"> The ID of the user adding this link.</param>
		public void Add(SqlInt32 organisationID, SqlString caption, SqlString url, SqlBoolean showDisclaimer, SqlInt32 userID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLink_Add",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@caption", SqlDbType.NVarChar, 100, caption),
					  StoredProcedure.CreateInputParam("@url", SqlDbType.NVarChar, 200, url),
					  StoredProcedure.CreateInputParam("@showDisclaimer", SqlDbType.Bit, showDisclaimer),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID), 
					  StoredProcedure.CreateInputParam("@LinkOrder", SqlDbType.Int, 999)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intErrorNumber; // Holds the error number return from the stored procedure.
				string strErrorMessage; // Holds the error message return from the stored procedure.

				//1. Get the response.
				rdr.Read();
				intErrorNumber = rdr.GetInt32(0);
				strErrorMessage =  rdr.GetString(1);
				
				//2. Close the reader.
				rdr.Close();
				
				//4. Throw the required exception if error number is not 0.
				switch(intErrorNumber)
				{
					case 0: // Succeeded.
					{
						break;
					}
					case 4: // Unique constraint.
					{
						throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcLink_Add.4"), caption));
					}
					case 5: // Missing parameter.
					{
						throw new ParameterException(strErrorMessage);
					}
					default: // Whatever is left.
					{
						throw new BusinessServiceException(strErrorMessage);
					}
				}
			}
		} // Add
		
		/// <summary>
		/// This method updates an existing link within the salt database.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 03/03/04
		/// Changes:
		/// </remarks>
		/// <param name="linkID">The id of the existing link</param>
		/// <param name="caption">The updated caption.</param>
		/// <param name="url">The updated URL.</param>
		/// <param name="showDisclaimer">Whether to show the disclaimed or not.</param>
		/// <param name="userID">The user ID of the user performing the update.</param>
		public void Update(SqlInt32 linkID, SqlString caption, SqlString url, SqlBoolean showDisclaimer, SqlInt32 userID, int linkOrder)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLink_Update",
					  StoredProcedure.CreateInputParam("@linkID", SqlDbType.Int, linkID),
					  StoredProcedure.CreateInputParam("@caption", SqlDbType.NVarChar, 100, caption),
					  StoredProcedure.CreateInputParam("@url", SqlDbType.NVarChar, 200, url),
					  StoredProcedure.CreateInputParam("@showDisclaimer", SqlDbType.Bit, showDisclaimer),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@LinkOrder", SqlDbType.Int, linkOrder)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intErrorNumber; // Holds the error number return from the stored procedure.
				string strErrorMessage; // Holds the error message return from the stored procedure.

				//1. Get the response.
				rdr.Read();
				intErrorNumber = rdr.GetInt32(0);
				strErrorMessage =  rdr.GetString(1);
				
				//2. Close the reader.
				rdr.Close();
				
				//4. Throw the required exception if error number is not 0.
				switch(intErrorNumber)
				{
					case 0: // Succeeded.
					{
						break;
					}
					case 1:
					{
						throw new RecordNotFoundException(ResourceManager.GetString("cmnRecordNotExist"));
					}
					case 4: // Unique constraint.
					{
						throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcLink_Update.4"), caption));
					}
					case 5: // Parameter Exception.
					{
						throw new ParameterException(strErrorMessage);
					}
					default: // Whatever is left.
					{
						throw new BusinessServiceException(strErrorMessage);
					}
				}
			}
		} // Update
		
		/// <summary>
		/// This method deletes an existing link within the salt database.
		/// </summary>
		/// <remarks>
		/// Assumptions:None
		/// Notes:
		/// Author: Peter Kneale, 03/03/04
		/// Changes:
		/// </remarks>
		/// <param name="linkID">The ID of the link to delete</param>
		public void Delete(SqlInt32 linkID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcLink_Delete",
					  StoredProcedure.CreateInputParam("@linkID", SqlDbType.Int, linkID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intErrorNumber; // Holds the error number return from the stored procedure.
				string strErrorMessage; // Holds the error message return from the stored procedure.

				//1. Get the response.
				rdr.Read();
				intErrorNumber = rdr.GetInt32(0);
				strErrorMessage =  rdr.GetString(1);
				
				//2. Close the reader.
				rdr.Close();
				
				//4. Throw the required exception if error number is not 0.
				switch(intErrorNumber)
				{
					case 0: // Succeeded.
					{
						break;
					}
					case 1:
					{
						throw new RecordNotFoundException(ResourceManager.GetString("prcLink_Delete.1"));
					}
					case 5: // Parameter Exception.
					{
						throw new ParameterException(strErrorMessage);
					}
					default: // Whatever is left.
					{
						throw new BusinessServiceException(strErrorMessage);
					}
				}
			}
		} // Delete


		public static void UpdateOrder(int linkID, int newIndex)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
			string sqlUpdate = "UPDATE tblLink set LinkOrder = " + newIndex.ToString() + " WHERE LinkID = " + linkID.ToString();
			
			SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlUpdate);
		}
		public static void ResetOrder(int organisationID)
		{
			BusinessServices.Link objLink = new BusinessServices.Link();

			DataTable dt = GetLinksByOrganisation(organisationID);

			int order = 0;
			foreach (DataRow dr in dt.Rows)
			{
				objLink.Update(Int32.Parse(dr["LinkID"].ToString()), dr["Caption"].ToString(), dr["Url"].ToString(), Convert.ToBoolean(dr["ShowDisclaimer"].ToString()), 1, order);
				order+=10;
			}
		}
	}
}