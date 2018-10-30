//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.Unit
//
//  Retrieve and update Unit information
//
//===============================================================================

using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using System.Xml;
using Bdw.Application.Salt.Data;
using System.Configuration;
using System.Web;
using Microsoft.ApplicationBlocks.Data;
using Localization;
namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Retrieves and updates unit information.
	/// </summary>
	/// <remarks>
	/// Assumptions: None
	/// Notes: 
	/// Author: Jack Liu
	/// Changes:
	/// </remarks>
	public class Unit : DatabaseService
	{		


		/// <summary>
		/// Gets one Unit Details.
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <returns>Returns a DataTable with the details of one Unit</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetUnit(int unitID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetOne",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID)
					  ))
			{
				return sp.ExecuteTable();
			}
		}

		/// <summary>
		/// Updates a unit details. If the status is changed, there will be several validation checking.
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="name">Name of the unit</param>
		/// <param name="active">Active/Inactive</param>
		/// <param name="updatedByUserID">Admin user ID that makes the update</param>
		/// <param name="originalDateUpdated">The original DateUpdated when the data is retrieved. It is for data integrity checking</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
        public void Update(int unitID, string name, bool active, int updatedByUserID, DateTime originalDateUpdated, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_Update",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar,100,name),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@updatedByUserID", SqlDbType.Int, updatedByUserID),
					  StoredProcedure.CreateInputParam("@originalDateUpdated", SqlDbType.DateTime, originalDateUpdated),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intErrorNumber;
				string strErrorMessage;
				rdr.Read();
				intErrorNumber = rdr.GetInt32(0);
				strErrorMessage = rdr.GetString(1);
				rdr.Close();

				//Throw the required exception if error number is not 0.
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
						throw new UniqueViolationException(strErrorMessage);
					}
					case 5: // Parameter Exception.
					{
						throw new ParameterException(strErrorMessage);
					}
					case 6: // Permission Denied.
					{
						throw new PermissionDeniedException(strErrorMessage);
					}
					case 7: // Integrity Violation.
					{
						throw new IntegrityViolationException(ResourceManager.GetString("prcUnit_Update.7"));
					}
					case 10:
					{
						throw new BusinessServiceException(ResourceManager.GetString("prcUnit_Update.10"));
					}
					case 101:
					{
						throw new BusinessServiceException(ResourceManager.GetString("prcUnit_Update.101"));
					}
					case 102:
					{
						throw new BusinessServiceException(ResourceManager.GetString("prcUnit_Update.102"));
					}
					default: // Whatever is left.
					{
						throw new BusinessServiceException(strErrorMessage);
					}
				} //Error Handler

			}
		}

		/// <summary>
		/// Add a unit
		/// </summary>
		/// <param name="organisationID"></param>
		/// <param name="parentUnitID">ID of the parent unit</param>
		/// <param name="name">Name of the unit</param>
		/// <param name="active">Active/Inactive</param>
		/// <param name="createdByUserID">Admin user ID that creates the unit</param>
		/// <returns>The new user ID</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public int Create(int organisationID,int parentUnitID, string name, bool active, int createdByUserID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_Create",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@parentUnitID", SqlDbType.Int, parentUnitID),
					  StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar,100,name),
					  StoredProcedure.CreateInputParam("@active", SqlDbType.Bit, active),
					  StoredProcedure.CreateInputParam("@createdByUserID", SqlDbType.Int, createdByUserID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				if (intError>0)
				{
					throw new BusinessServiceException(ResourceManager.GetString("prcUnit_Create"));
				}
				else
				{
					return int.Parse(strMessage);
				}
			}
		}

	
		/// <summary>
		/// Gets a list of users from a specific Unit.
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <returns>A list of users</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetUsers(int unitID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetUsers",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@includeInactiveUsers", SqlDbType.Bit, false)
					  ))
			{
				return sp.ExecuteTable();
			}
		}
		/// <summary>
		/// Gets a list of users from a specific Unit.
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="includeInactiveUsers">Include inactive users or not</param>
		/// <returns>A list of users</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetUsers(int unitID,bool includeInactiveUsers)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetUsers",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@includeInactiveUsers", SqlDbType.Bit, includeInactiveUsers)
					  ))
			{
				return sp.ExecuteTable();
			}
		}
		/// <summary>
		/// Gets a list of existing unit administrators from a specific Unit.
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <returns>A list of existing unit administrators</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetAdministrators(int unitID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetAdministrators",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID)
					  ))
			{
				return sp.ExecuteTable();
			}
		}

	
		/// <summary>
		/// Add a unit administrator to a unit
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="userID">The user who will become administrator</param>
		/// <param name="adminSubUnit">Whether the user has permission to administer all sub-units</param>
		/// <param name="adminUserID">The admin user who makes this action</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public  void AddAdministrator(int unitID, int userID, bool adminSubUnit, int adminUserID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_AddAdministrator",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@adminSubUnit", SqlDbType.Bit, adminSubUnit),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				if (intError>0)
				{
					throw new BusinessServiceException(ResourceManager.GetString("prcUnit_AddAdministrator"));
				}
			}
		}


		/// <summary>
		/// Remove a unit administrator from a unit
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="removedUserID">The user who will be removed as a unit administrator</param>
		/// <param name="adminUserID">The admin user who makes this action</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public  void RemoveAdministrator(int unitID, int removedUserID, int adminUserID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_RemoveAdministrator",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@removedUserID", SqlDbType.Int, removedUserID),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				if (intError>0)
				{
					throw new BusinessServiceException(ResourceManager.GetString("prcUnit_RemoveAdministrator"));
				}
			}
		}


		

		/// <summary>
		/// This method is for TreeView Control. 
		/// It gets all units in the specified organisation and manually set the unit node attributes.
		/// For admin user, GetUnitsTreeByUserID() is a better method
		/// </summary>
		/// <param name="organisationID">The organisation that units belong to</param>
		/// <param name="disabledUnitIDs">Units that will be disabled in the TreeView Control</param>
		/// <param name="selectedUnitIDs">Units that will be preselected in the TreeView Control</param>
		/// <param name="expandedUnitIDs">Units that will be expanded in the TreeView Control</param>
		/// <param name="parentUnitID">The Root Units that the whole tree starts from</param>
		/// <returns>Returns a dataset of units. Dataset is easy to convert to xml document</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public  DataSet GetUnitsByOrganisation(int organisationID, string disabledUnitIDs, string selectedUnitIDs, string expandedUnitIDs, int parentUnitID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetUnitsByOrganisation",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@disabledUnitIDs", SqlDbType.VarChar,4000,disabledUnitIDs),
					  StoredProcedure.CreateInputParam("@selectedUnitIDs", SqlDbType.VarChar,4000,selectedUnitIDs),
					  StoredProcedure.CreateInputParam("@expandedUnitIDs", SqlDbType.VarChar,4000,expandedUnitIDs),
					  StoredProcedure.CreateInputParam("@parentUnitID", SqlDbType.Int, parentUnitID)
					  ))
			{
				return sp.ExecuteDataSet();
			}
		}

	
		/// <summary>
		/// Get all units in the specified organisation and disable the units that the admin user don't have permission to admininster
		/// This method is for TreeView Control. This method only returns active units.
		/// </summary>
		/// <param name="organisationID">The organisation that units belong to</param>
		/// <param name="userID">Admin user that logins in</param>
		/// <param name="permission">
		///		A: [A]dministrator 
		///		P: Administrator with [P]ropagating right
		///		S: Administrator of the Unit and all of its [S]ub-units
		///</param>
		/// <returns>Returns a dataset of units. Dataset is easy to convert to xml document</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public  DataSet GetUnitsTreeByUserID(int organisationID, int userID, char permission)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetUnitsTreeByUserID",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@permission", SqlDbType.Char,1, permission)
					  ))
			{

				return sp.ExecuteDataSet();
			}
		}

		/// <summary>
		/// Get all units in the specified organisation and disable the units that the admin user don't have permission to admininster
		/// This method is for TreeView Control. 
		/// </summary>
		/// <param name="organisationID">The organisation that units belong to</param>
		/// <param name="userID">Admin user that logins in</param>
		/// <param name="permission">
		///		A: [A]dministrator 
		///		P: Administrator with [P]ropagating right
		///		S: Administrator of the Unit and all of its [S]ub-units
		///</param>
		/// <param name="includeInactiveUnits">True to return all units, False to return only active units</param>
		/// <returns>Returns a dataset of units. Dataset is easy to convert to xml document</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public  DataSet GetUnitsTreeByUserID(int organisationID, int userID, char permission, bool includeInactiveUnits)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetUnitsTreeByUserID",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@permission", SqlDbType.Char,1, permission),
					  StoredProcedure.CreateInputParam("@includingInactiveUnits", SqlDbType.Bit, includeInactiveUnits)
					  
					  ))
			{

				return sp.ExecuteDataSet();
			}
		}

		/// <summary>
		/// Get all units in the specified organisation and disable the units that the admin user don't have permission to admininster
		/// and select the unit that is passed in via the selected Unit parameter
		/// This method is for TreeView Control. 
		/// </summary>
		/// <param name="organisationID">The organisation that units belong to</param>
		/// <param name="userID">Admin user that logins in</param>
		/// <param name="permission">
		///		A: [A]dministrator 
		///		P: Administrator with [P]ropagating right
		///		S: Administrator of the Unit and all of its [S]ub-units
		/// </param>
		/// <param name="selectedUnitID">The selected unit, this will be both checked and expanded until it is visible</param>
		/// <returns>Returns a dataset of units. Dataset is easy to convert to xml document</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale, 2/03/2004
		/// Changes:
		/// </remarks>
		public  DataSet GetUnitsTreeByUserID(int organisationID, int userID, char permission,int selectedUnitID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetUnitsTreeByUserIDAndSelect",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@permission", SqlDbType.Char,1, permission),
					  StoredProcedure.CreateInputParam("@selectedUnitID", SqlDbType.Int, selectedUnitID)
					  ))
			{

				return sp.ExecuteDataSet();
			}
		} // GetUnitsTreeByUserID


		/* Denies access of module for all units on create of unit */
		public static void DenyAllForOrgCourse(int organisationID, int courseID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", organisationID)
															  , new SqlParameter("@CourseID", courseID) };

			string sqlCourseAccess = "SELECT GrantedCourseID FROM tblOrganisationCourseAccess WHERE OrganisationID = @OrganisationID and GrantedcourseID = @CourseID ";

			object result = SqlHelper.ExecuteScalar(connectionString, CommandType.Text, sqlCourseAccess, sqlParams);

			if (result == null)
			{
				//-- New relationship
				string sqlDelete = @"DELETE FROM tblUnitModuleAccess 
									WHERE UnitID IN (SELECT UnitID from tblUnit WHERE OrganisationID = @OrganisationID)
										AND DeniedModuleID IN (SELECT ModuleID from tblModule WHERE CourseID = @CourseID)
									";

				SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlDelete, sqlParams);

				BusinessServices.Module objModule = new BusinessServices.Module();
                DataTable dtModules = objModule.GetModuleListByCourse(courseID, organisationID);

				string sqlUnits = "SELECT UnitID FROM tblUnit WHERE OrganisationID = @OrganisationID";
				DataTable dtUnits = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlUnits, sqlParams).Tables[0];

				foreach (DataRow drUnit in dtUnits.Rows)
				{
					foreach(DataRow drModule in dtModules.Rows)
					{
						SqlParameter[] sqlParamDeny = new SqlParameter[] { new SqlParameter("@UnitID", drUnit["UnitID"].ToString())
																		  , new SqlParameter("@ModuleID", drModule["ModuleID"].ToString()) };

						string sqlDeny = @"
								INSERT INTO tblUnitModuleAccess(UnitID, DeniedModuleID)
									VALUES(@UnitID, @ModuleID)
								";

						SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlDeny, sqlParamDeny);
					}
				}
			}
		}

		/* Denies access of module for all units on create of unit */
		public static void DenyAllForUnit(int organisationID, int unitID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", organisationID), new SqlParameter("@UnitID", unitID) };

			string sqlDeny = @"
								INSERT INTO tblUnitModuleAccess(UnitID, DeniedModuleID)
								SELECT DISTINCT @UnitID, tblModule.ModuleID
									FROM tblOrganisationCourseAccess 
									INNER JOIN tblCourse ON tblOrganisationCourseAccess.GrantedCourseID = tblCourse.CourseID 
									INNER JOIN tblModule ON tblCourse.CourseID = tblModule.CourseID
									WHERE tblOrganisationCourseAccess.OrganisationID = @OrganisationID
								";
			
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlDeny, sqlParams);
		}

		/* Denies access of module for all units on create of module */
		public static void DenyAllForModule(int courseID, int moduleID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@CourseID", courseID),  new SqlParameter("@ModuleID", moduleID) };

			string sqlDeny = @"
								INSERT INTO tblUnitModuleAccess(UnitID, DeniedModuleID)
								SELECT DISTINCT tblUnit.UnitID, @ModuleID  
									FROM tblOrganisationCourseAccess 
									INNER JOIN tblCourse ON tblOrganisationCourseAccess.GrantedCourseID = tblCourse.CourseID 
									INNER JOIN tblUnit ON tblOrganisationCourseAccess.OrganisationID = tblUnit.OrganisationID
									WHERE tblCourse.CourseID = @CourseID
								";
			
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlDeny, sqlParams);
		}

		/// <summary>
		/// The method will search within the selected Parent Units for those Units whose name contains the entered text.  
		/// (If not Parent Units have been selected, the system will search across the whole organisation.)
		/// </summary>
		/// <param name="organisationID">The ID of the organisation to search</param>
		/// <param name="parentUnitIDs">The comma seperated parent unit IDs that the units belongs to</param>
		/// <param name="unitName">The text that the units contains </param>
		/// <param name="userID">The user that make the query</param>
		/// <returns>Returns a collection of units</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// Aaron		27/03/2007		@parentUnitIDs type modified from Varchar(500)
		/// </remarks>
		public  DataTable Search(int organisationID, string parentUnitIDs, string unitName, int userID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_Search",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@parentUnitIDs", SqlDbType.VarChar,8000, parentUnitIDs),
					  StoredProcedure.CreateInputParam("@unitName", SqlDbType.NVarChar,100, unitName),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID)
					  ))
			{
				return sp.ExecuteTable();
			}
		}

		/// <summary>
		/// The method will search within the selected Parent Units for those Units whose name contains the entered text.  
		/// (If not Parent Units have been selected, the system will search across the whole organisation.)
		/// </summary>
		/// <param name="organisationID">The ID of the organisation to search</param>
		/// <param name="parentUnitIDs">The comma seperated parent unit IDs that the units belongs to</param>
		/// <param name="unitName">The text that the units contains </param>
		/// <param name="userID">The user that make the query</param>
		/// <param name="includeInactiveUnits">Boolean value indicating whether to return inactive units.</param>
		/// <returns>Returns a collection of units</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// Aaron		27/03/2007		@parentUnitIDs type modified from Varchar(500)
		/// </remarks>
		public  DataTable Search(int organisationID, string parentUnitIDs, string unitName, int userID, int unitID, bool includeInactiveUnits)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_Search",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					  StoredProcedure.CreateInputParam("@parentUnitIDs", SqlDbType.VarChar,8000, parentUnitIDs),
                      StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@unitName", SqlDbType.NVarChar,100, unitName),
					  StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
					  StoredProcedure.CreateInputParam("@includingInactiveUnits", SqlDbType.Bit, includeInactiveUnits)
					  ))
			{
				return sp.ExecuteTable();
			}
		}

		/// <summary>
		/// Move a unit to a new parent
		/// </summary>
		/// <param name="fromUnitID">The ID of the unit that will be moved</param>
		/// <param name="toUnitID">The ID of the unit that will be moved to</param>
		/// <param name="adminUserID">The user who makes this action</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public  void Move(int fromUnitID, int toUnitID, int adminUserID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_Move",
					  StoredProcedure.CreateInputParam("@fromUnitID", SqlDbType.Int, fromUnitID),
					  StoredProcedure.CreateInputParam("@toUnitID", SqlDbType.Int, toUnitID),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
	
				if (intError>0)
				{
					throw new BusinessServiceException(ResourceManager.GetString("prcUnit_Move." + intError.ToString()));
				}
			}
		}

		/// <summary>
		/// Move a unit to top level.
		/// </summary>
		/// <param name="fromUnitID">The ID of the unit that will be moved</param>
		/// <param name="adminUserID">The user who makes this action</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public  void MoveToTopLevel(int fromUnitID, int adminUserID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_MoveToTopLevel",
					  StoredProcedure.CreateInputParam("@fromUnitID", SqlDbType.Int, fromUnitID),
					  StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID)
					  ))
			{
				SqlDataReader rdr = sp.ExecuteReader();
				int intError;
				string strMessage;
				rdr.Read();
				intError = rdr.GetInt32(0);
				strMessage = rdr.GetString(1);
				rdr.Close();
				if (intError>0)
				{
					throw new BusinessServiceException(ResourceManager.GetString("prcUnit_MoveToTopLevel." + intError.ToString()));
				}
			}
		}

		/// <summary>
		/// Gets unit module access settings
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="courseID">ID of the course</param>
		/// <returns>A list of module with access settings</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public DataTable GetModuleAccess(int unitID, int courseID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetModuleAccess",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID)
					  ))
			{
				return sp.ExecuteTable();
			}
		}
		/// <summary>
		/// Saves unit module access settings
		/// This will overwrite the module access settings of users (Remove individual settings)
		/// </summary>
		/// <param name="unitID">ID of the unit</param>
		/// <param name="courseID">ID of the course</param>
		/// <param name="grantedModuleIDs">The list of module that are granted to this unit</param>
		/// <returns></returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public void SaveModuleAccess(int unitID, int courseID, string grantedModuleIDs, bool cascadeToChildren)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_SaveModuleAccess",
					  StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
					  StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
					  StoredProcedure.CreateInputParam("@grantedModuleIDs", SqlDbType.VarChar, 500, grantedModuleIDs)
					  ))
			{
				sp.ExecuteNonQuery();
			}

			//-- LICENSING
			BusinessServices.CourseLicensing.LicenseAuditByUnit(unitID);

			if (cascadeToChildren) 
			{
				string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

				string sqlSelect = "SELECT UnitID FROM tblUnit WHERE ParentUnitID = @parentUnitID";
				System.Data.SqlClient.SqlParameter[] sqlParams = { new SqlParameter("@parentUnitID", unitID) };
				DataTable dtChildUnits = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];

				foreach (DataRow dr in dtChildUnits.Rows)
				{
					int childUnitID = (int)dr["UnitID"]; 
					SaveModuleAccess(childUnitID, courseID, grantedModuleIDs, true);

					//-- LICENSING
					BusinessServices.CourseLicensing.LicenseAuditByUnit(childUnitID);
				}
			}
			

		}

        /// <summary>
        /// Gets unit module compliance rules
        /// </summary>
        /// <param name="unitID">ID of the unit</param>
        /// <param name="courseID">ID of the course</param>
        /// <returns>A list of modules with compliance rules</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Jack Liu, 26/02/2004
        /// Changes:
        /// </remarks>
		public DataTable GetModuleRule(int unitID, int courseID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetModuleRule",
			StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
			StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID)
			))
			{
				return sp.ExecuteTable();
			}
		}

        /// <summary>
        /// Populate the compliance rules to an individual module
        /// </summary>
        /// <param name="unitID">ID of the unit</param>
        /// <param name="moduleID">ID of the module</param>
        /// <param name="usingDefault">Using the organisation's Compliance Rules defaults</param>
        /// <param name="lessonFrequency">The lesson frequency (month)</param>
        /// <param name="quizFrequency">The quiz frequency (month)</param>
        /// <param name="quizPassMark">quiz Pass Mark (percentage)</param>
        /// <param name="adminUserID">The user who makes this action</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Jack Liu, 26/02/2004
        /// Changes:
        /// </remarks>
		public void SaveModuleRule(int unitID, int moduleID, bool usingDefault, int lessonFrequency,int quizFrequency, int quizPassMark, DateTime lessonCompletionDate, DateTime quizCompletionDate, int adminUserID, int OrgID)
		{
			SqlParameter paramDateLesson = StoredProcedure.CreateInputParam("@lessonCompletionDate", SqlDbType.DateTime);
			if (lessonCompletionDate == DateTime.Parse("1/1/1900"))
				paramDateLesson.Value = SqlDateTime.Null;
			else
				paramDateLesson.Value = lessonCompletionDate;

			SqlParameter paramDateQuiz = StoredProcedure.CreateInputParam("@quizCompletionDate", SqlDbType.DateTime);
			if (quizCompletionDate == DateTime.Parse("1/1/1900"))
				paramDateQuiz.Value = SqlDateTime.Null;
			else
				paramDateQuiz.Value = quizCompletionDate;

			using(StoredProcedure sp = new StoredProcedure("prcUnit_SaveModuleRule",
			StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
			StoredProcedure.CreateInputParam("@moduleID", SqlDbType.Int, moduleID),
			StoredProcedure.CreateInputParam("@usingDefault", SqlDbType.Bit, usingDefault),
			StoredProcedure.CreateInputParam("@lessonFrequency", SqlDbType.Int, lessonFrequency),
			StoredProcedure.CreateInputParam("@quizFrequency", SqlDbType.Int, quizFrequency),
			StoredProcedure.CreateInputParam("@quizPassMark", SqlDbType.Int, quizPassMark),
			paramDateLesson, 
			paramDateQuiz, 
			StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
            StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, OrgID)
			))
			{
				sp.ExecuteNonQuery();
			}
		}

        /// <summary>
        /// Populate the compliance rules to all modules in the course
        /// </summary>
        /// <param name="unitID">ID of the unit</param>
        /// <param name="courseID">ID of the course</param>
        /// <param name="lessonFrequency">The lesson frequency (month)</param>
        /// <param name="quizFrequency">The quiz frequency (month)</param>
        /// <param name="quizPassMark">quiz Pass Mark (percentage)</param>
        /// <param name="adminUserID">The user who makes this action</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Jack Liu, 26/02/2004
        /// Changes:
        /// </remarks>
		public void SaveModuleRuleToAll(int unitID, int courseID, int lessonFrequency,int quizFrequency, int quizPassMark, DateTime lessonCompletionDate, DateTime quizCompletionDate, int adminUserID, int OrgID)
		{
			SqlParameter paramDateLesson = StoredProcedure.CreateInputParam("@lessonCompletionDate", SqlDbType.DateTime);
			if (lessonCompletionDate == DateTime.Parse("1/1/1900"))
				paramDateLesson.Value = SqlDateTime.Null;
			else
				paramDateLesson.Value = lessonCompletionDate;

			SqlParameter paramDateQuiz = StoredProcedure.CreateInputParam("@quizCompletionDate", SqlDbType.DateTime);
			if (quizCompletionDate == DateTime.Parse("1/1/1900"))
				paramDateQuiz.Value = SqlDateTime.Null;
			else
				paramDateQuiz.Value = quizCompletionDate;

			using(StoredProcedure sp = new StoredProcedure("prcUnit_SaveModuleRuleToAll",
				StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
				StoredProcedure.CreateInputParam("@courseID", SqlDbType.Int, courseID),
				StoredProcedure.CreateInputParam("@lessonFrequency", SqlDbType.Int, lessonFrequency),
				StoredProcedure.CreateInputParam("@quizFrequency", SqlDbType.Int, quizFrequency),
				StoredProcedure.CreateInputParam("@quizPassMark", SqlDbType.Int, quizPassMark),
				paramDateLesson,
				paramDateQuiz,
				StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
                StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, OrgID)

			))
			{
				sp.ExecuteNonQuery();
			}
		}

        /// <summary>
        /// Get the user permission to a specific unit
        /// </summary>
        /// <param name="unitID">ID of the unit</param>
        /// <param name="adminUserID">The user who is granted permission</param>
        /// <returns>Permission:
        ///		'F': Full permission
        ///		'A': Administer permission to this unit only
        ///		'P': Administer this unit and all sub-units (Populate all sub-units)
        ///		'' : No permission
        /// </returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Jack Liu, 26/02/2004
        /// Changes:
        /// </remarks>
		public string GetPermission(int unitID, int adminUserID)
		{
			string  strPermission;

			SqlParameter prmPermission = StoredProcedure.CreateOutputParam("@Permission",SqlDbType.Char, 1);

			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetPermission",
			StoredProcedure.CreateInputParam("@unitID", SqlDbType.Int, unitID),
			StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.Int, adminUserID),
			prmPermission
			))
			{
				sp.ExecuteNonQuery();
				strPermission = (string)prmPermission.Value ;
				return strPermission.Trim();
			}
		}

        /// <summary>
        /// Get the list of all the units that an administrator can access
        /// </summary>
        /// <param name="userID">ID of the user</param>
        /// <param name="organisationID">The organisation ID</param>
        /// <returns>Datatable:
        ///		
        /// </returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Clark, 26/08/2004
        /// Changes:
        /// </remarks>
		private DataTable GetAdministrableUnitsByUserID(int userID, int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcUnit_GetAdministrableUnitsByUserID",
			StoredProcedure.CreateInputParam("@userID", SqlDbType.Int, userID),
			StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)					  
			))
			{
				return sp.ExecuteTable();
			}
		}

        /// <summary>
        /// Get the list of all the units that an administrator can access
        /// </summary>
        /// <param name="userID">ID of the user</param>
        /// <param name="organisationID">The organisation ID</param>
        /// <param name="units">Comma seperated list of units</param>
        /// <returns>Bool
        /// </returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Clark, 26/08/2004
        /// Changes:
        /// </remarks>
public bool ConfirmAdministrableUnitsByUserID(int userID, int organisationID, string units)
{             
DataTable dtblUnits;
bool bolReturnValue = true;
if(units.Length != 0)
{            
string strDelimStr = " ,.:";
char [] chrDelimiter = strDelimStr.ToCharArray();
string[] strAccessingUnits = units.Split(chrDelimiter);            
dtblUnits = this.GetAdministrableUnitsByUserID(userID, organisationID);
System.Collections.Hashtable htUnits = new System.Collections.Hashtable();
foreach(DataRow drw in dtblUnits.Rows)
{
htUnits.Add(drw[0], drw[0]);
}
                foreach (string strUnit in strAccessingUnits) 
                {                       
                    if (!htUnits.ContainsValue(      Int32.Parse(  strUnit.Trim() )      ))
                    {
                        bolReturnValue = false;
                    }
                }
            }
           return bolReturnValue;         
        }

        /// <summary>
        /// Given a commer seperated list of units returns the subset that the given user has access to 
        /// in the context of the given organisation
        /// </summary>
        /// <param name="userID">ID of the user</param>
        /// <param name="organisationID">The organisation ID</param>
        /// <param name="units">Commer seperated list of units</param>
        /// <returns>
        /// commer seperated string
        /// </returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Clark, 26/08/2004
        /// Changes:
        /// </remarks>
        public string ReturnAdministrableUnitsByUserID(int userID, int organisationID, string units)
        {
            string ReturnValue;

            if (    this.ConfirmAdministrableUnitsByUserID( userID,  organisationID,  units)    )
            {
                ReturnValue = units;
            }
            else
            {
                DataTable dtblUnits;
                string strDelimStr = " ,.:";
                // System.Collections.Specialized.StringCollection collnCheckedUnits;
                System.Collections.ArrayList collnCheckedUnits = new System.Collections.ArrayList();
                
                char [] chrDelimiter = strDelimStr.ToCharArray();
                string[] strAccessingUnits = units.Split(chrDelimiter);
                dtblUnits = this.GetAdministrableUnitsByUserID(userID, organisationID);
                System.Collections.Hashtable htUnits = new System.Collections.Hashtable();
                foreach(DataRow drw in dtblUnits.Rows)
                {
                    htUnits.Add(drw[0], drw[0]);
                }

                foreach (string strUnit in strAccessingUnits) 
                {                              
                    if (htUnits.ContainsValue(      Int32.Parse(  strUnit.Trim() )      ))
                    {
                        collnCheckedUnits.Add(strUnit);
                    }
                }
                string[] temp = (String[]) collnCheckedUnits.ToArray(System.Type.GetType("string"));

                ReturnValue = String.Join(",",temp);          
            }
            return ReturnValue;   
        } 
        /// <summary>
        /// Given a string array of units returns the subset that the given user has access to 
        /// in the context of the given organisation
        /// </summary>
        /// <param name="userID">ID of the user</param>
        /// <param name="organisationID">The organisation ID</param>
        /// <param name="units">Commer seperated list of units</param>
        /// <returns>
        /// commer seperated string
        /// </returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Clark, 26/08/2004
        /// Changes:
        /// </remarks>
        public string[] ReturnAdministrableUnitsByUserID(int userID, int organisationID, string[] units)
        {
            string[] strarrayTemp;
            string[] strarrayReturnValue;
            int intNumUnitsHasAccessTo = 0;
            DataTable dtblUnits;            
            dtblUnits = this.GetAdministrableUnitsByUserID(userID, organisationID);
            
            System.Collections.Hashtable htUnits = new System.Collections.Hashtable();

            // if no units were passed in then return all the units that the administrator can access
            if (units.Length == 0)
            {
                strarrayReturnValue = new string[dtblUnits.Rows.Count];
                int iCount = 0;
                foreach(DataRow drw in dtblUnits.Rows)
                {
                   strarrayReturnValue[iCount] =  drw[0].ToString();
                    ++iCount;
                }
            }
            else
            {
                // Fill the hashTable
                foreach(DataRow drw in dtblUnits.Rows)
                {
                    htUnits.Add(drw[0], drw[0]);
                }
                // instantiate a temp string array
                strarrayTemp = new string[htUnits.Count];

                // copy the units that the user does have access to that they want access to
                foreach (string strUnit in units) 
                {                              
                    if (htUnits.ContainsValue(      Int32.Parse(  strUnit.Trim() )      ))
                    {
                        strarrayTemp[intNumUnitsHasAccessTo] =  strUnit.Trim();
                    ++intNumUnitsHasAccessTo;
                    }
                }

                // ReDim 
                strarrayReturnValue = new string[intNumUnitsHasAccessTo];
                for(int i = 0; i < intNumUnitsHasAccessTo; i++)
                {                              
                    strarrayReturnValue[i] = strarrayTemp[i] ;
                }
            }


            return strarrayReturnValue;   
        } 


		/// <summary>
		/// The date or frequency months set on the organisation record is used to override all existing records
		/// </summary>
		/// <param name="organisationID"></param>
		/// <param name="lessonCompletionDate"></param>
		/// <param name="lessonFrequency"></param>
		public static void OverrideLessonCompliance(int organisationID, DateTime lessonCompletionDate, int lessonFrequency)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			if(lessonCompletionDate > DateTime.Parse("1/1/1900") && lessonFrequency > 0)
				throw new Exception("Cannot specify both Lesson completion date and frequency");

			SqlParameter paramLessonDate = new SqlParameter("@lessonCompletionDate", SqlDbType.DateTime);
			if (lessonCompletionDate == DateTime.Parse("1/1/1900"))
				paramLessonDate.Value = System.DBNull.Value;
			else
				paramLessonDate.Value = lessonCompletionDate.ToUniversalTime();


			SqlParameter[] sqlparams = { 
										   paramLessonDate, 
										   new SqlParameter("@LessonFrequency", lessonFrequency), 
										   new SqlParameter("@OrganisationID", organisationID)
									   };

			string sqlUpdate = @"UPDATE tblUnitRule SET 
								LessonCompletionDate = @LessonCompletionDate, 
								LessonFrequency = @LessonFrequency 
								FROM tblUnit INNER JOIN tblUnitRule ON tblUnit.UnitID = tblUnitRule.UnitID 
								WHERE (tblUnit.OrganisationID = @OrganisationID)";

			SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlUpdate, sqlparams);

		}


		/// <summary>
		/// The date or frequency months set on the organisation record is used to override all existing records
		/// </summary>
		/// <param name="organisationID"></param>
		/// <param name="lessonCompletionDate"></param>
		/// <param name="lessonFrequency"></param>
		public static void OverrideQuizCompliance(int organisationID, DateTime quizCompletionDate, int quizFrequency)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			if(quizCompletionDate > DateTime.Parse("1/1/1900") && quizFrequency > 0)
				throw new Exception("Cannot specify both Quiz completion date and frequency");

			SqlParameter paramQuizDate = new SqlParameter("@quizCompletionDate", SqlDbType.DateTime);
			if (quizCompletionDate == DateTime.Parse("1/1/1900"))
				paramQuizDate.Value = System.DBNull.Value;
			else
				paramQuizDate.Value = quizCompletionDate.ToUniversalTime();


			SqlParameter[] sqlparams = { 
										   paramQuizDate, 
										   new SqlParameter("@QuizFrequency", quizFrequency), 
										   new SqlParameter("@OrganisationID", organisationID)
									   };

			string sqlUpdate = @"UPDATE tblUnitRule SET 
								QuizCompletionDate = @QuizCompletionDate, 
								QuizFrequency = @QuizFrequency 
								FROM tblUnit INNER JOIN tblUnitRule ON tblUnit.UnitID = tblUnitRule.UnitID 
								WHERE (tblUnit.OrganisationID = @OrganisationID)";

			SqlHelper.ExecuteNonQuery(connectionString, System.Data.CommandType.Text, sqlUpdate, sqlparams);

		}
	}
}

