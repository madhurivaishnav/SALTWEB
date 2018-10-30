//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.Classification
//
//  Retrieve Classification Information
//
//===============================================================================

using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.Data;
using Localization;
namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Provide Data Access Services for the Classification Table
	/// </summary>
	/// <remarks>
	///	Assumptions: None
	/// Notes: 
	/// Author: John Crawford
	/// Date: 18/02/2004
	/// Changes:
	/// </remarks>
	public class Classification : Bdw.Application.Salt.Data.DatabaseService
	{
		#region Public Methods

		/// <summary>
		/// Gets the classification type based on the organisation ID
		/// </summary>
		/// <param name="organisationID">Value of the current organisation for the user</param>
		/// <returns>A Datatable with the rows (only one) from the ClassificationType table</returns>
		/// <remarks>
		///	Assumptions: There is currenlty only 1 classification Type per Organisation ID
		/// Notes: 
		/// Author: John Crawford
		/// Date: 18/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetClassificationType(int organisationID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcClassification_GetType",
					   StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
					   ))
			{
				return sp.ExecuteTable();
			}
		} // GetClassificationType

		/// <summary>
		/// Gets a list of active classification options based upon a classification ID.
		/// </summary>
		/// <param name="classificationTypeID"> The ID of the classification.</param>
		/// <returns> DataTable containing all the rows for a particular classification.</returns>
		/// <remarks>
		///	Assumptions: None
		/// Notes: 
		/// Author: John Crawford
		/// Date: 18/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetClassificationList(SqlInt32 classificationTypeID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcClassification_GetList",
					   StoredProcedure.CreateInputParam("@classificationTypeID", SqlDbType.Int, classificationTypeID)
					   ))
			{
				return sp.ExecuteTable();
			}
		} // GetClassificationList

		/// <summary>
		/// Gets a list of all classification options based upon a classification ID.
		/// </summary>
		/// <param name="classificationTypeID"> The ID of the classification.</param>
		/// <returns> DataTable containing all the rows for a particular classification.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Vranich
		/// Date: 19/02/0/2004
		/// Changes:
		/// </remarks>
		public DataTable GetClassificationListAll(SqlInt32 classificationTypeID)
		{
			using (StoredProcedure sp = new StoredProcedure("prcClassification_GetListAll",
					   StoredProcedure.CreateInputParam("@classificationTypeID", SqlDbType.Int, classificationTypeID)
					   ))
			{
				return sp.ExecuteTable();
			}
		} // GetClassificationListAll
		
		/// <summary>
		/// Adds a new classification type to the database.
		/// </summary>
		/// <param name="name"> The name of the classification type.</param>
		/// <param name="organisationID"> The ID of the organisation the the classification type belongs to.</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Vranich
		/// Date: 18/02/0/2004
		/// Changes:
		/// </remarks>
		public void AddClassificationType(SqlString name, SqlInt32 organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcClassification_AddType",
					StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 50, name),
					StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
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
						throw new RecordNotFoundException(strErrorMessage);
					}
					case 4: // Unique constraint.
					{
						throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcClassification_AddType.4"), name));
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
		} // AddClassificationType
		
		/// <summary>
		/// Updates a classification type for a specific organisation.
		/// </summary>
		/// <param name="name"> The name of the classification type.</param>
		/// <param name="classificationTypeID"> The ID of the classification type to be updated.</param>
		/// <param name="organisationID"> The ID of the organisation the the classification type belongs to.</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Vranich
		/// Date: 18/02/0/2004
		/// Changes:
		/// </remarks>
		public void UpdateClassificationType(SqlString name, SqlInt32 classificationTypeID, SqlInt32 organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcClassification_UpdateType",
					  StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 50, name),
					  StoredProcedure.CreateInputParam("@classificationTypeID", SqlDbType.Int, classificationTypeID),
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
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
						throw new RecordNotFoundException(strErrorMessage);
					}
					case 4: // Unique constraint.
					{
						throw new UniqueViolationException(ResourceManager.GetString("prcClassification_UpdateType.1"));
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
		} // UpdateClassificationType
		
		/// <summary>
		/// Updates a classification for a specific classification type.
		/// </summary>
		/// <param name="name"> The name of the classification.</param>
		/// <param name="active"> The status of the classification.</param>
		/// <param name="classificationID"> The ID of the classification to be updated.</param>
		/// <param name="classificationTypeID"> The ID of the classification type that the classification belongs to.</param>
		/// <returns> The ID of the classification type.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Vranich
		/// Date: 19/02/0/2004
		/// Changes:
		/// </remarks>
		public void UpdateClassification(SqlString name, SqlBoolean active, SqlInt32 classificationID, SqlInt32 classificationTypeID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcClassification_UpdateClassification",
					  StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 50, name),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
					  StoredProcedure.CreateInputParam("@classificationTypeID", SqlDbType.Int, classificationTypeID)
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
						throw new RecordNotFoundException(strErrorMessage);
					}
					case 4: // Unique constraint.
					{
						throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcClassification_UpdateClassification.4"), name));
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
		} // UpdateClassification
		
		/// <summary>
		/// Updates a classification for a specific classification type.
		/// </summary>
		/// <param name="name"> The name of the classification.</param>
		/// <param name="active"> The status of the classification.</param>
		/// <param name="classificationTypeID"> The ID of the classification type to be updated.</param>
		/// <returns> The ID of the classification type.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Vranich
		/// Date: 19/02/0/2004
		/// Changes:
		/// </remarks>
		public void AddClassification(SqlString name, SqlBoolean active, SqlInt32 classificationTypeID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcClassification_AddClassification",
					  StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 50, name),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@classificationTypeID", SqlDbType.Int, classificationTypeID)
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
						throw new UniqueViolationException(String.Format(ResourceManager.GetString("prcClassification_AddClassification.4"), name));
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
		} // AddClassification

		#endregion
	}
}