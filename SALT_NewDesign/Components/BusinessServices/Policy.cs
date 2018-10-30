using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.Data;
using System.Configuration;
using System.Web;
using Localization;
using Microsoft.ApplicationBlocks.Data;

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Summary description for Policy.
	/// </summary>
	public class Policy : Bdw.Application.Salt.Data.DatabaseService
	{
		public DataTable CheckFileName(int OrganisationID, string PolicyFileName)
		{
			using(StoredProcedure spCheckFile = new StoredProcedure("prcPolicy_CheckFileName", 
				StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
				StoredProcedure.CreateInputParam("@PolicyFileName", SqlDbType.NVarChar, 255, PolicyFileName)))
			{
				DataTable dtCheckFileName = spCheckFile.ExecuteTable();
				return dtCheckFileName;
			}
		}

		public DataTable CheckPolicyName(int OrganisationID, string PolicyName)
		{
			using(StoredProcedure spCheckFile = new StoredProcedure("prcPolicy_CheckPolicyName", 
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
					  StoredProcedure.CreateInputParam("@PolicyName", SqlDbType.NVarChar, 255, PolicyName)))
			{
				DataTable dtCheckPolicyName = spCheckFile.ExecuteTable();
				return dtCheckPolicyName;
			}
		}

        public int NewFileUpload(int PolicyID, string NewFileName, long NewFileLength, int organisationID)
		{
			//Get existing policy
            DataTable dtPolicy = GetPolicy(PolicyID, organisationID);
			//Mark the existing Policy as deleted
			using (StoredProcedure spUpdatePolicy = new StoredProcedure("prcPolicy_Update",
					   StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
					   StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, SqlInt32.Null),
					   StoredProcedure.CreateInputParam("@PolicyName", SqlDbType.NVarChar, SqlString.Null),
					   StoredProcedure.CreateInputParam("@Active", SqlDbType.Bit, SqlBoolean.Null),
					   StoredProcedure.CreateInputParam("@Deleted", SqlDbType.Bit, 1),
					   StoredProcedure.CreateInputParam("@PolicyFileName", SqlDbType.NVarChar, SqlString.Null),
					   StoredProcedure.CreateInputParam("@PolicyFileSize", SqlDbType.BigInt, SqlInt64.Null),
					   StoredProcedure.CreateInputParam("@UploadDate", SqlDbType.DateTime, SqlDateTime.Null),
					   StoredProcedure.CreateInputParam("@ConfirmationMessage", SqlDbType.NVarChar, SqlString.Null)))
			{
				spUpdatePolicy.ExecuteNonQuery();
			}
			//Copy this record to a new policy record and mark as not deleted, update with new file details
			int NewPolicyID = AddPolicy(Int32.Parse(dtPolicy.Rows[0]["OrganisationID"].ToString()),
				dtPolicy.Rows[0]["PolicyName"].ToString(),
				Convert.ToBoolean(dtPolicy.Rows[0]["Active"].ToString()),
				Convert.ToBoolean(dtPolicy.Rows[0]["Deleted"].ToString()),
				dtPolicy.Rows[0]["PolicyFileName"].ToString(),
				Int64.Parse(dtPolicy.Rows[0]["PolicyFileSize"].ToString()),
				dtPolicy.Rows[0]["ConfirmationMessage"].ToString());
			using (StoredProcedure spUpdatePolicy = new StoredProcedure("prcPolicy_Update",
					   StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, NewPolicyID),
					   StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, SqlInt32.Null),
					   StoredProcedure.CreateInputParam("@PolicyName", SqlDbType.NVarChar, SqlString.Null),
					   StoredProcedure.CreateInputParam("@Active", SqlDbType.Bit, SqlBoolean.Null),
					   StoredProcedure.CreateInputParam("@Deleted", SqlDbType.Bit, 0),
					   StoredProcedure.CreateInputParam("@PolicyFileName", SqlDbType.NVarChar, NewFileName),
					   StoredProcedure.CreateInputParam("@PolicyFileSize", SqlDbType.BigInt, NewFileLength),
					   StoredProcedure.CreateInputParam("@UploadDate", SqlDbType.DateTime, DateTime.Now),
					   StoredProcedure.CreateInputParam("@ConfirmationMessage", SqlDbType.NVarChar, SqlString.Null)))
			{
				spUpdatePolicy.ExecuteNonQuery();
			}

			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"insert into tblUnitPolicyAccess ";
			strSQL += @" select " + NewPolicyID + ", unitid, granted ";
			strSQL += @" from tblUnitPolicyAccess where policyid = " + PolicyID + " ";
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
			strSQL = @"insert into tblUserPolicyAccess ";
			strSQL += @" select " + NewPolicyID + ", userid, granted ";
			strSQL += @" from tblUserPolicyAccess where policyid = " + PolicyID + " ";
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
			return NewPolicyID;
		}

        public string GetPolicyFileName(int PolicyID, int organisationID)
		{
			using(StoredProcedure spGetPolicyFileName = new StoredProcedure("prcPolicy_Get",
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
			{
				DataTable dtGetPolicyFileName = spGetPolicyFileName.ExecuteTable();
				string PolicyFileName = dtGetPolicyFileName.Rows[0]["PolicyFileName"].ToString();
				return PolicyFileName;
			}
		}

		public int GetTotalUsers(int OrganisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			// Get the ProfilePointsID
			string strSQL = @"select count(*) as UserCount From tblUser ";
			strSQL = strSQL + @"where ((OrganisationID = " + OrganisationID + ") ";
			strSQL = strSQL + @"and (unitID is not null)) "; //and (Active = 1))";

			DataTable dtGetTotalUsers = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return int.Parse(dtGetTotalUsers.Rows[0]["UserCount"].ToString());
	
		}

		public int GetTotalUsersAssignedToPolicy(int PolicyID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			// Get the ProfilePointsID
			string strSQL = @"select count(*) as [count] from tbluser u, tblUserPolicyAccess a, tblPolicy p ";
			strSQL = strSQL + @"where p.policyid = a.policyid and a.userid = u.userid ";
			strSQL = strSQL + @"and unitid is not null and granted = 1 and p.PolicyID = " + PolicyID;

			DataTable dtGetAssignedUsers = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return int.Parse(dtGetAssignedUsers.Rows[0]["Count"].ToString());
	
		}

		public int GetAcceptedUsers(int OrganisationID, int PolicyID)
		{
			using(StoredProcedure spGetAcceptedUsers = new StoredProcedure("prcPolicy_GetAcceptedUsers",
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID)))
			{
				return Int32.Parse(spGetAcceptedUsers.ExecuteScalar().ToString());
			}
		}

		public DataTable GetPolicy(int PolicyID, int organisationID)
		{
			using(StoredProcedure spGetPolicy = new StoredProcedure("prcPolicy_Get",
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
			{
				DataTable dtGetPolicy = spGetPolicy.ExecuteTable();
				return dtGetPolicy;
			}
		}

		public long GetAllocatedDiskSpace(int OrganisationID)
		{
			using (StoredProcedure spGetAllocatedDiskSpace = new StoredProcedure("prcOrganisation_GetAllocatedDiskSpace",
					   StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
			{
				string strAllocatedDiskSpace = spGetAllocatedDiskSpace.ExecuteScalar().ToString();
				if (strAllocatedDiskSpace.Length == 0)
				{
					return 0;
				}
				else
				{					
					return long.Parse(strAllocatedDiskSpace);
				}
			}
		}

		public long GetUsedPolicyDiskSpace(int OrganisationID)
		{
			using (StoredProcedure spGetUsedPolicyDiskSpace = new StoredProcedure("prcOrganisation_GetPolicyUsedSpace",
					   StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
			{
				string strUsedPolicyDiskSpace = spGetUsedPolicyDiskSpace.ExecuteScalar().ToString();
				if (strUsedPolicyDiskSpace.Length == 0)
				{
					return 0;
				}
				else
				{
					return long.Parse(strUsedPolicyDiskSpace);
				}
			}
		}

		public bool CheckCanUpload(long OrgAllocatedSize, long OrgUsedSize)
		{
			if (OrgUsedSize < OrgAllocatedSize)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public int AddPolicy(int OrganisationID, string PolicyName, bool Active, bool Deleted, string PolicyFileName, long PolicyFileSize, string ConfirmationMessage)
		{
			int intPolicyId = 0;
			using(StoredProcedure spAddPolicy = new StoredProcedure("prcPolicy_Add",
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
					  StoredProcedure.CreateInputParam("@PolicyName", SqlDbType.NVarChar, PolicyName),
					  StoredProcedure.CreateInputParam("@Active", SqlDbType.Bit, Active),
					  StoredProcedure.CreateInputParam("@Deleted", SqlDbType.Bit, Deleted),
					  StoredProcedure.CreateInputParam("@PolicyFileName", SqlDbType.NVarChar, PolicyFileName),
					  StoredProcedure.CreateInputParam("@PolicyFileSize", SqlDbType.BigInt, PolicyFileSize),
					  StoredProcedure.CreateInputParam("@ConfirmationMessage", SqlDbType.NVarChar, ConfirmationMessage)))
			{
				spAddPolicy.Parameters.Add("@PolicyID", SqlDbType.Int);
				spAddPolicy.Parameters["@PolicyID"].Direction = ParameterDirection.Output;
				spAddPolicy.ExecuteNonQuery();
				intPolicyId = Int32.Parse(spAddPolicy.Parameters["@PolicyID"].Value.ToString());
				return intPolicyId;
			}
		}

		public void UpdatePolicy(int PolicyID, int OrganisationID, string PolicyName, bool Active, string ConfirmationMessage)
		{
			using (StoredProcedure spUpdatePolicy = new StoredProcedure("prcPolicy_Update",
					   StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
					   StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
					   StoredProcedure.CreateInputParam("@PolicyName", SqlDbType.NVarChar, PolicyName),
					   StoredProcedure.CreateInputParam("@Active", SqlDbType.Bit, Active),
					   StoredProcedure.CreateInputParam("@Deleted", SqlDbType.Bit, SqlBoolean.Null),
					   StoredProcedure.CreateInputParam("@PolicyFileName", SqlDbType.NVarChar, SqlString.Null),
					   StoredProcedure.CreateInputParam("@PolicyFileSize", SqlDbType.BigInt, SqlInt64.Null),
					   StoredProcedure.CreateInputParam("@UploadDate", SqlDbType.DateTime, SqlDateTime.Null),
					   StoredProcedure.CreateInputParam("@ConfirmationMessage", SqlDbType.NVarChar, ConfirmationMessage)))
			{
				spUpdatePolicy.ExecuteNonQuery();
			}
		}

        public void DeletePolicy(int PolicyID, string OrganisationID)
        {
            using (StoredProcedure spUpdatePolicy = new StoredProcedure("prcPolicy_Update",
                       StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
                       StoredProcedure.CreateInputParam("@PolicyName", SqlDbType.NVarChar, "deleted"),
                       StoredProcedure.CreateInputParam("@Active", SqlDbType.Bit, false),
                       StoredProcedure.CreateInputParam("@Deleted", SqlDbType.Bit, true),
                       StoredProcedure.CreateInputParam("@PolicyFileName", SqlDbType.NVarChar, SqlString.Null),
                       StoredProcedure.CreateInputParam("@PolicyFileSize", SqlDbType.BigInt, SqlInt64.Null),
                       StoredProcedure.CreateInputParam("@UploadDate", SqlDbType.DateTime, SqlDateTime.Null),
                       StoredProcedure.CreateInputParam("@ConfirmationMessage", SqlDbType.NVarChar, SqlString.Null)))
            {
                spUpdatePolicy.ExecuteNonQuery();
            }
        }
		public bool CheckPointsAssigned(int PolicyID, int UserID, int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			
			string strSQL = @"select * from tblUserCPDPoints ucp ";
			strSQL = strSQL + @"join tblProfilePoints ppts on ucp.ProfilePointsID = ppts.ProfilePointsID ";
			strSQL = strSQL + @"join tblProfilePeriod pp on pp.ProfilePeriodID = ppts.ProfilePeriodID ";
			strSQL = strSQL + @"where ucp.UserID = " + UserID + " ";
			strSQL = strSQL + @"and ppts.TypeID = " + PolicyID + " ";
			strSQL = strSQL + @"and pp.profileID = " + ProfileID + " and pp.profileperiodactive = 1 ";
			strSQL = strSQL + @" and ProfilePointsType = 'P' and Active = 1";

			DataTable dtCheckPolicy = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if(dtCheckPolicy.Rows.Count > 0)
			{
				return true;
			}
			else
			{
				return false;
			}

		}

		public bool CheckAccepted(int PolicyID, int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			
			string strSQL = @"select * from tblUserPolicyAccepted ";
			strSQL = strSQL + @"where UserID = " + UserID + " ";
			strSQL = strSQL + @"and PolicyID = " + PolicyID + " ";
			strSQL = strSQL + @" and Accepted = 1";

			DataTable dtCheckPolicy = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if(dtCheckPolicy.Rows.Count > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public void Accept(int PolicyID, int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = string.Empty;
			strSQL = @"select * from tblUserPolicyAccepted where PolicyID = " + PolicyID + " and UserID = " + UserID;
			DataTable dtPointsAlreadyExist = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if(dtPointsAlreadyExist.Rows.Count == 0)
			{
				// insert into tblUserPolicyAccepted table
				strSQL = @"insert into tblUserPolicyAccepted ";
				strSQL = strSQL + @"(PolicyID, UserID, Accepted, DateAccepted) ";
				strSQL = strSQL + @"values (" + PolicyID + ", " + UserID + ", ";
				strSQL = strSQL + @"1, GETUTCDATE())";
				SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
			}
			else
			{
				// update tblUserPolicyAccepted table
				strSQL = @"update tblUserPolicyAccepted ";
				strSQL = strSQL + @"set Accepted = 1, DateAccepted = GETUTCDATE() ";
				strSQL = strSQL + @"where UserPolicyAcceptedID = " + dtPointsAlreadyExist.Rows[0]["UserPolicyAcceptedID"].ToString();
				SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
			}
		}

		public bool CheckProfileExists(int PolicyID, int UserID, int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			// Get the ProfilePointsID
			string strSQL = @"select ppts.ProfilePointsID, ppts.Points from tblProfilePoints ppts ";
			strSQL = strSQL + @"join tblProfilePeriod pp on pp.ProfilePeriodID = ppts.ProfilePeriodID ";
			strSQL = strSQL + @"and pp.ProfileID = " + ProfileID + " ";
			strSQL = strSQL + @"where TypeID = " + PolicyID + " ";
			strSQL = strSQL + @"and ProfilePointsType = 'P' ";
			strSQL = strSQL + @"and Active = 1 and profileperiodactive = 1";

			DataTable dtProfilePoints = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			// If profile exists 
			if(dtProfilePoints.Rows.Count > 0)
			{
				return true;
			}
			else
			{
				return false;
			}


		}		

		public void AssignPoints(int PolicyID, int UserID, int ProfileID)
		{
			double lPoints;
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
			// Get the ProfilePointsID
			string strSQL = @"select ppts.ProfilePointsID, ppts.Points from tblProfilePoints ppts ";
			strSQL = strSQL + @"join tblProfilePeriod pp on pp.ProfilePeriodID = ppts.ProfilePeriodID ";
			strSQL = strSQL + @"and pp.ProfileID = " + ProfileID + " ";
			strSQL = strSQL + @"where TypeID = " + PolicyID + " ";
			strSQL = strSQL + @"and ProfilePointsType = 'P' ";
			strSQL = strSQL + @"and Active = 1 and profileperiodactive = 1";

			DataTable dtProfilePoints = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

			// CheckProfileExists ensures that there is a record in here
			string Points = dtProfilePoints.Rows[0]["Points"].ToString();
			string ProfilePointsID = dtProfilePoints.Rows[0]["ProfilePointsID"].ToString();
			try
			{
				lPoints = double.Parse(Points);
			}
			catch
			{
				lPoints = 0.0;
			}
			// update tblUserCPDPoints

			// only insert points that aren't 0
			if (!(lPoints == 0.0))
			{
				strSQL = @"insert into tblUserCPDPoints ";
				strSQL = strSQL + @"(UserID, Points, DateAssigned, ProfilePointsID)";
				strSQL = strSQL + @"values (" + UserID + ", " + Points + ", GETUTCDATE(), " + ProfilePointsID + ")";

				SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
			}
		}

		public void ResetUsers(int OrganisationID, int PolicyID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"update tblUserPolicyAccepted set Accepted = 0 where UserID in ( ";
			strSQL = strSQL + @"select UserID from tblUser where OrganisationID = " + OrganisationID + ") ";
			strSQL = strSQL + @"and PolicyID = " + PolicyID + " ";
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public void RemovePolicy(int PolicyID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
		
			string strSQL = @"update tblPolicy set deleted = 1 where PolicyID=" + PolicyID;

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public string GetConfirmationMessage(int PolicyID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
		
			string strSQL = @"select ConfirmationMessage from tblPolicy where deleted = 0 and ";
			strSQL = strSQL + @"PolicyID=" + PolicyID;

			DataTable dtConfirmationMessage = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

			return dtConfirmationMessage.Rows[0]["ConfirmationMessage"].ToString();
		}


        public string GetLastAccepted(int UserID, int OrganisationID, int PolicyID)
        {
            using (StoredProcedure spPolicyUserSearch = new StoredProcedure("prcPolicy_GetUserLastAccepted",
                        StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
                       StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, OrganisationID),
                       StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID)
                      ))
            {
                DataTable dtPolicyUserSearch = spPolicyUserSearch.ExecuteTable();
                return dtPolicyUserSearch.Rows[0]["dateaccepted"].ToString(); ;
            }
        }

		public void ResetPolicyUnitAccess(int PolicyID)
		{
			using(StoredProcedure spResetPolicyUnitAccess = new StoredProcedure("prcPolicy_ResetUnitAccess",
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID)))
			{
				spResetPolicyUnitAccess.ExecuteNonQuery();
			}
		}

		public void SetPolicyUnitAccess(int PolicyID, int UnitID)
		{
			using(StoredProcedure spSetPolicyUnitAccess = new StoredProcedure("prcPolicy_SetUnitAccess",
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
					  StoredProcedure.CreateInputParam("@UnitID", SqlDbType.Int, UnitID)))
			{
				spSetPolicyUnitAccess.ExecuteNonQuery();
			}
		}

		public void SetPolicyUserAccessByUnit(int PolicyID, int UnitID)
		{
			using(StoredProcedure spSetPolicyUserAccessByUnit = new StoredProcedure("prcPolicy_SetUserAccessByUnit",
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
					  StoredProcedure.CreateInputParam("@UnitID", SqlDbType.Int, UnitID)))
			{
				spSetPolicyUserAccessByUnit.ExecuteNonQuery();
			}
		}

		public void InitialisePolicyAccess(int OrganisationID, int PolicyID, bool granted)
		{
			using(StoredProcedure spInit = new StoredProcedure("prcOrganisation_InitialisePolicyAccess",
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
					  StoredProcedure.CreateInputParam("@granted", SqlDbType.Bit, granted)))
			{
				spInit.ExecuteNonQuery();
			}

		}

		public DataTable GetPolicyUnitAccess(int PolicyID)
		{
			using(StoredProcedure spGetPolicyUnitAccess = new StoredProcedure("prcPolicy_GetUnitAccess",
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID)))
			{
				DataTable dtGetPolicyUnitAccess = spGetPolicyUnitAccess.ExecuteTable();
				return dtGetPolicyUnitAccess;
			}
		}

		public DataTable PolicyUserSearch(int OrganisationID, int PolicyID, string ParentUnitIDs, string FirstName, string LastName,	string UserName, string Email, string ExternalID, int UserID, string DisplayType)
		{
			using (StoredProcedure spPolicyUserSearch = new StoredProcedure("prcPolicy_UserSearch",
					   StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, OrganisationID),
					   StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
					   StoredProcedure.CreateInputParam("@parentUnitIDs", SqlDbType.NVarChar, ParentUnitIDs),
					   StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar, FirstName),
					   StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar, LastName),
					   StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar, UserName),
					   StoredProcedure.CreateInputParam("@Email", SqlDbType.NVarChar, Email),
					   StoredProcedure.CreateInputParam("@ExternalID", SqlDbType.NVarChar, ExternalID),
					   StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.NVarChar, UserID),
					   StoredProcedure.CreateInputParam("@Type", SqlDbType.NVarChar, DisplayType)))
			{
				DataTable dtPolicyUserSearch = spPolicyUserSearch.ExecuteTable();
				return dtPolicyUserSearch;
			}
		}

		public void SetPolicyUserAccessByUser(int PolicyID, int UserID, int Granted)
		{
			using(StoredProcedure spSetPolicyUserAccessByUser = new StoredProcedure("prcPolicy_SetUserAccessByUser",
					  StoredProcedure.CreateInputParam("@PolicyID", SqlDbType.Int, PolicyID),
					  StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
					  StoredProcedure.CreateInputParam("@Granted", SqlDbType.Bit, Granted)))
			{
				spSetPolicyUserAccessByUser.ExecuteNonQuery();
			}
		}

		public DataTable GetPolicyListAccessableToOrg(int organisationID)
		{
			using(StoredProcedure sp = new StoredProcedure("prcPolicy_GetListByOrganisation",
					  StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}
		}// GetPolicyListAccessableToOrg



		public DataTable GetPoliciesAssignedToUsers(string policyIDs, string UserIDs, string strAccepted, DateTime acceptedDateFrom, DateTime acceptedDateTo, int organisationID)
		{

			using(StoredProcedure sp = new StoredProcedure("prcPolicy_GetPoliciesAssignedToUsers",
					  StoredProcedure.CreateInputParam("@policy_ids", SqlDbType.VarChar, 8000,  policyIDs),
					  StoredProcedure.CreateInputParam("@user_ids", SqlDbType.VarChar, 8000,  UserIDs),
					  StoredProcedure.CreateInputParam("@accepted", SqlDbType.VarChar, 20,  strAccepted),
					  StoredProcedure.CreateInputParam("@acceptedDateFrom", SqlDbType.DateTime, acceptedDateFrom),
					  StoredProcedure.CreateInputParam("@acceptedDateTo", SqlDbType.DateTime, acceptedDateTo),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}
		}// GetUsersAssignedToPolicy	



        public DataTable GetUserAndPoliciesForAdmins(string AdminIDs, string PolicyIDs, string UnitIDs, string strAccepted, DateTime acceptedDateFrom, DateTime acceptedDateTo, int organisationID)
	{

		using(StoredProcedure sp = new StoredProcedure("prcPolicy_GetUserAndPoliciesForAdmins",
				  StoredProcedure.CreateInputParam("@admin_ids", SqlDbType.VarChar, 8000,  AdminIDs),
				  StoredProcedure.CreateInputParam("@policy_ids", SqlDbType.VarChar, 8000,  PolicyIDs),
				  StoredProcedure.CreateInputParam("@unit_ids", SqlDbType.VarChar, -1,  UnitIDs),
				  StoredProcedure.CreateInputParam("@accepted", SqlDbType.VarChar, 20,  strAccepted),
				  StoredProcedure.CreateInputParam("@acceptedDateFrom", SqlDbType.DateTime, acceptedDateFrom),
				  StoredProcedure.CreateInputParam("@acceptedDateTo", SqlDbType.DateTime, acceptedDateTo),
                  StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)

				  ))
		{
			return sp.ExecuteTable();
		}
	}// GetUserAndPoliciesForAdmins	



    public DataTable GetAdminsInOrgPendingPolicy(string PolicyIDs, string UnitIDs, string strAccepted, DateTime acceptedDateFrom, DateTime acceptedDateTo, int organisationID)
		{

			using(StoredProcedure sp = new StoredProcedure("prcPolicy_GetAdminsInOrgPendingPolicy",
					  StoredProcedure.CreateInputParam("@policy_ids", SqlDbType.VarChar, 8000,  PolicyIDs),
					  StoredProcedure.CreateInputParam("@unit_ids", SqlDbType.VarChar, -1,  UnitIDs),
					  StoredProcedure.CreateInputParam("@accepted", SqlDbType.VarChar, 20,  strAccepted),
					  StoredProcedure.CreateInputParam("@acceptedDateFrom", SqlDbType.DateTime, acceptedDateFrom),
					 StoredProcedure.CreateInputParam("@acceptedDateTo", SqlDbType.DateTime, acceptedDateTo)))
			{
				return sp.ExecuteTable();
			}
		}// GetAdminsInOrgPendingPolicy	
	
	

		
		public DataTable GetUsersAssignedToPolicy(string PolicyIDs, string UnitIDs, string strAccepted, DateTime acceptedDateFrom, DateTime acceptedDateTo)
		{

			using(StoredProcedure sp = new StoredProcedure("prcPolicy_GetUsersByPolicyAndUnit",
					  StoredProcedure.CreateInputParam("@policy_ids", SqlDbType.VarChar, 8000,  PolicyIDs),
					  StoredProcedure.CreateInputParam("@unit_ids", SqlDbType.VarChar, -1,  UnitIDs),
					  StoredProcedure.CreateInputParam("@accepted", SqlDbType.VarChar, 20,  strAccepted),
					  StoredProcedure.CreateInputParam("@acceptedDateFrom", SqlDbType.DateTime, acceptedDateFrom),
					 StoredProcedure.CreateInputParam("@acceptedDateTo", SqlDbType.DateTime, acceptedDateTo)
																																																		))
			{
				return sp.ExecuteTable();
			}
		}// GetUsersAssignedToPolicy	


        public DataTable GetPoliciesInUnit(string PolicyIDs, string UnitIDs, string strAccepted, DateTime acceptedDateFrom, DateTime acceptedDateTo, int organisationID)
		{

			using(StoredProcedure sp = new StoredProcedure("prcPolicy_GetPoliciesInUnit",
					  StoredProcedure.CreateInputParam("@policy_ids", SqlDbType.VarChar, 8000,  PolicyIDs),
					  StoredProcedure.CreateInputParam("@unit_ids", SqlDbType.VarChar, -1,  UnitIDs),
					  StoredProcedure.CreateInputParam("@accepted", SqlDbType.VarChar, 20,  strAccepted),
					  StoredProcedure.CreateInputParam("@acceptedDateFrom", SqlDbType.DateTime, acceptedDateFrom),
					  StoredProcedure.CreateInputParam("@acceptedDateTo", SqlDbType.DateTime, acceptedDateTo),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable();
			}
		}// GetUsersAssignedToPolicy	
	

		public DataTable GetAdminMashup(int organisationID, string unitIDs, string policyIDs, string userPolicyCsv, string adminIDs, int classificationID, int PolicyStatus, DateTime acceptedDateFrom, DateTime acceptedDateTo, int inclInactive)
		{
			using (StoredProcedure sp = new StoredProcedure("prcPolicy_AdminMashup",
					   StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, organisationID),
					   StoredProcedure.CreateInputParam("@unitIDs", SqlDbType.VarChar,-1, unitIDs),
					   StoredProcedure.CreateInputParam("@policyIDs", SqlDbType.VarChar,8000, policyIDs),
					   StoredProcedure.CreateInputParam("@input_csv", SqlDbType.VarChar, 8000, userPolicyCsv),
					   StoredProcedure.CreateInputParam("@adminids", SqlDbType.VarChar, 8000, adminIDs),
					   StoredProcedure.CreateInputParam("@classificationID", SqlDbType.Int, classificationID),
					   StoredProcedure.CreateInputParam("@policyStatus", SqlDbType.Int, PolicyStatus),
					   StoredProcedure.CreateInputParam("@acceptedDateFrom", SqlDbType.DateTime, acceptedDateFrom),
					   StoredProcedure.CreateInputParam("@acceptedDateTo", SqlDbType.DateTime, acceptedDateTo),
					   StoredProcedure.CreateInputParam("@includeInactive",SqlDbType.Int, inclInactive)
					   ))
			{
				return sp.ExecuteTable();
			}

		} // GetUserMashup







	}
}
