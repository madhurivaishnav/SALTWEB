using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.Data;
using System.Configuration;
using System.Web;
using Localization;
using Microsoft.ApplicationBlocks.Data;

using System.Diagnostics;

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Summary description for Profile.
	/// </summary>
	public class Profile : Bdw.Application.Salt.Data.DatabaseService
	{
//		private string userDisplay = String.Empty;
//		public string UserDisplay
//		{
//			get {return userDisplay;}
//			set {userDisplay = value;}
//		}

		private int profileID = 0;
		public int ProfileID
		{
			get {return profileID;}
			set {profileID = value;}
		}

		private int profilePeriodID = 0;
		public int ProfilePeriodID
		{
			get {return profilePeriodID;}
			set {profilePeriodID = value;}
		}

		private string profileName = String.Empty;
		public string ProfileName
		{
			get {return profileName;}
			set {profileName = value;}
		}

		private int organisationID = 0;
		public int OrganisationID
		{
			get {return organisationID;}
			set {organisationID = value;}
		}

		private DateTime dateStart = DateTime.Parse("1/1/1900");
		public DateTime DateStart
		{
			get {return dateStart;}
			set {dateStart = value;}
		}

		private DateTime dateEnd = DateTime.Parse("1/1/1900");
		public DateTime DateEnd
		{
			get {return dateEnd;}
			set {dateEnd = value;}
		}

		private double points = 0.0;
		public double Points
		{
			get {return points;}
			set {points = value;}
		}

		private string endOfPeriodAction = "1";
		public string EndOfPeriodAction
		{
			get {return endOfPeriodAction;}
			set {endOfPeriodAction = value;}
		}

		private int monthIncrement = 0;
		public int MonthIncrement
		{
			get {return monthIncrement;}
			set {monthIncrement = value;}
		}

		private DateTime futureDateStart = DateTime.Parse("1/1/1900");
		public DateTime FutureDateStart
		{
			get {return futureDateStart;}
			set {futureDateStart = value;}
		}

		private DateTime futureDateEnd = DateTime.Parse("1/1/1900");
		public DateTime FutureDateEnd
		{
			get {return futureDateEnd;}
			set {futureDateEnd = value;}
		}

		private double futurePoints = 0.0;
		public double FuturePoints
		{
			get {return futurePoints;}
			set {futurePoints = value;}
		}

		public void UpdateProfile(Profile pro)
		{
			using(StoredProcedure spUpdateProfile = new StoredProcedure("prcProfile_Update",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, pro.ProfileID),
					  StoredProcedure.CreateInputParam("@ProfileName", SqlDbType.NVarChar, pro.ProfileName),
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, pro.OrganisationID),
					  StoredProcedure.CreateInputParam("@DateStart", SqlDbType.DateTime, ((pro.DateStart==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.DateStart)),
					  StoredProcedure.CreateInputParam("@DateEnd", SqlDbType.DateTime, ((pro.DateEnd==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.DateEnd)),
					  StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, ((pro.Points==0.0 ? (object)System.DBNull.Value  : pro.Points))),
					  StoredProcedure.CreateInputParam("@EndOfPeriodAction", SqlDbType.Char, pro.EndOfPeriodAction),
					  StoredProcedure.CreateInputParam("@MonthIncrement", SqlDbType.Int, ((pro.MonthIncrement==0 ? (object)System.DBNull.Value  : pro.MonthIncrement))),
					  StoredProcedure.CreateInputParam("@FutureDateStart", SqlDbType.DateTime, ((pro.FutureDateStart==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.FutureDateStart)),
					  StoredProcedure.CreateInputParam("@FutureDateEnd", SqlDbType.DateTime, ((pro.FutureDateEnd==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.FutureDateEnd)),
					  StoredProcedure.CreateInputParam("@FuturePoints", SqlDbType.Float, ((pro.FuturePoints==0.0 ? (object)System.DBNull.Value  : pro.FuturePoints)))))
			{
				spUpdateProfile.ExecuteNonQuery();
			}
						
		}

		public void UpdateProfilePeriodAccess(int OrganisiationID, int ProfilePeriodID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
			string strSQL = @"select * from tblUserProfilePeriodAccess ";
			strSQL = strSQL + @"where ProfilePeriodID = " + ProfilePeriodID;
			DataTable dtUsersExist = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			
			if (dtUsersExist.Rows.Count == 0)
			{
				strSQL = @"insert into tblUserProfilePeriodAccess ";
				strSQL = strSQL + @"(ProfilePeriodID, UserID, Granted) ";
				strSQL = strSQL + @"select " + ProfilePeriodID + ", UserID, 0 ";
				strSQL = strSQL + @"from tblUser where OrganisationID = " + OrganisationID;

				SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
			}
		}


		public void InitialiseProfilePeriodAccess(int OrganisationID, int ProfileID, int ProfilePeriodID)
		{
			using(StoredProcedure spInit = new StoredProcedure("prcOrganisation_InitialiseProfilePeriodAccess",
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
					  StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID)))
			{
				spInit.ExecuteNonQuery();
			}

		}

		public DataTable GetProfileUnitAccess(int ProfilePeriodID)
		{
			using(StoredProcedure spGetProfileUnitAccess = new StoredProcedure("prcProfile_GetUnitAccess",
					 StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID)))
			{
				DataTable dtGetProfileUnitAccess = spGetProfileUnitAccess.ExecuteTable();
				return dtGetProfileUnitAccess;
			}
		}

		public void SetProfileUnitAccess(int ProfileID, int UnitID)
		{
			using(StoredProcedure spSetProfileUnitAccess = new StoredProcedure("prcProfile_SetUnitAccess",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
					  StoredProcedure.CreateInputParam("@UnitID", SqlDbType.Int, UnitID)))
			{
				spSetProfileUnitAccess.ExecuteNonQuery();
			}
		}

		public void ResetProfileUnitAccess(int ProfileID)
		{
			using(StoredProcedure spResetProfileUnitAccess = new StoredProcedure("prcProfile_ResetUnitAccess",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID)))
			{
				spResetProfileUnitAccess.ExecuteNonQuery();
			}
		}

		public void ResetProfileUserAccess(int ProfileID)
		{
			using(StoredProcedure spResetProfileUserAccess = new StoredProcedure("prcProfile_ResetUserAccess",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID)))
			{
				spResetProfileUserAccess.ExecuteNonQuery();
			}
		}

		public void SetProfileUserAccessByUnit(int ProfileID, int UnitID)
		{
			using(StoredProcedure spSetProfileUserAccessByUnit = new StoredProcedure("prcProfile_SetUserAccessByUnit",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
					  StoredProcedure.CreateInputParam("@UnitID", SqlDbType.Int, UnitID)))
			{
				spSetProfileUserAccessByUnit.ExecuteNonQuery();
			}
		}

		public void SetProfileUserAccessByUser(int ProfileID, int UserID, int Granted)
		{
			using(StoredProcedure spSetProfileUserAccessByUser = new StoredProcedure("prcProfile_SetUserAccessByUser",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
					  StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
					  StoredProcedure.CreateInputParam("@Granted", SqlDbType.Bit, Granted)))
			{
				spSetProfileUserAccessByUser.ExecuteNonQuery();
			}
		}

		public int AddProfile(Profile pro)
		{
			int intProfileID = 0;
			using(StoredProcedure spAddProfile = new StoredProcedure("prcProfile_Add", 
					  StoredProcedure.CreateInputParam("@ProfileName", SqlDbType.NVarChar, pro.ProfileName),
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, pro.OrganisationID),
					  StoredProcedure.CreateInputParam("@DateStart", SqlDbType.DateTime, ((pro.DateStart==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.DateStart)),
					  StoredProcedure.CreateInputParam("@DateEnd", SqlDbType.DateTime, ((pro.DateEnd==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.DateEnd)),
					  StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, ((pro.Points==0.0 ? (object)System.DBNull.Value  : pro.Points))),
					  StoredProcedure.CreateInputParam("@EndOfPeriodAction", SqlDbType.Char, pro.EndOfPeriodAction),
					  StoredProcedure.CreateInputParam("@MonthIncrement", SqlDbType.Int, ((pro.MonthIncrement==0 ? (object)System.DBNull.Value  : pro.MonthIncrement))),
					  StoredProcedure.CreateInputParam("@FutureDateStart", SqlDbType.DateTime, ((pro.FutureDateStart==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.FutureDateStart)),
					  StoredProcedure.CreateInputParam("@FutureDateEnd", SqlDbType.DateTime, ((pro.FutureDateEnd==DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value  : pro.FutureDateEnd)),
					  StoredProcedure.CreateInputParam("@FuturePoints", SqlDbType.Float, ((pro.FuturePoints==0.0 ? (object)System.DBNull.Value  : pro.FuturePoints)))))
			{
				spAddProfile.Parameters.Add("@ProfileID", SqlDbType.Int);
				spAddProfile.Parameters["@ProfileID"].Direction = ParameterDirection.Output;
				spAddProfile.Parameters.Add("@ProfilePeriodID", SqlDbType.Int);
				spAddProfile.Parameters["@ProfilePeriodID"].Direction = ParameterDirection.Output;
                spAddProfile.ExecuteNonQuery();
				intProfileID = Int32.Parse(spAddProfile.Parameters["@ProfileID"].Value.ToString());
				this.profilePeriodID = Int32.Parse(spAddProfile.Parameters["@ProfilePeriodID"].Value.ToString());
				return intProfileID;
			}
		}

        public void AddProfilePoints(string ProfilePointsType, int TypeID, int ProfilePeriodID, double Points, int Active, int organisationID)
		{
			using(StoredProcedure spAddProfilePoints = new StoredProcedure("prcProfilePoints_Add",
					  StoredProcedure.CreateInputParam("@ProfilePointsType", SqlDbType.NVarChar, ProfilePointsType),
					  StoredProcedure.CreateInputParam("@TypeID", SqlDbType.Int, TypeID),
					  StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID),
					  StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, Points),
					  StoredProcedure.CreateInputParam("@Active", SqlDbType.Int, Active),
					  StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
			{
				spAddProfilePoints.ExecuteNonQuery();
			}
		}

        public void UpdateProfilePoints(int ProfilePointsID, string ProfilePointsType, int TypeID, int ProfilePeriodID, double Points, int Active, int organisationID)
		{
			using(StoredProcedure spUpdateProfilePoints = new StoredProcedure("prcProfilePoints_Update",
					  StoredProcedure.CreateInputParam("@ProfilePointsID", SqlDbType.Int, ProfilePointsID),
					  StoredProcedure.CreateInputParam("@ProfilePointsType", SqlDbType.NVarChar, ProfilePointsType),
					  StoredProcedure.CreateInputParam("@TypeID", SqlDbType.Int, TypeID),
					  StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID),
					  StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, Points),
					  StoredProcedure.CreateInputParam("@Active", SqlDbType.Int, Active),
					  StoredProcedure.CreateInputParam("@DateAssigned", SqlDbType.DateTime, DateTime.Now),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
			{
				spUpdateProfilePoints.ExecuteNonQuery();
			}
		}

		public DataTable CheckProfileName(string ProfileName, int OrganisationID)
		{
			using(StoredProcedure spCheckProfileName = new StoredProcedure("prcProfile_CheckProfileName",
					  StoredProcedure.CreateInputParam("@ProfileName", SqlDbType.NVarChar, ProfileName),
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
			{
				DataTable CheckProfileName = spCheckProfileName.ExecuteTable();
				return CheckProfileName;
			}
		}

		public DataTable GetProfilePolicyPoints(int OrganisationID, int ProfilePeriodID)
		{
			using(StoredProcedure spGetProfilePolicyPoints = new StoredProcedure("prcProfile_GetPolicyPoints",
					  StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
					  StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID)))
			{
				DataTable dtGetProfilePolicyPoints = spGetProfilePolicyPoints.ExecuteTable();
				return dtGetProfilePolicyPoints;
			}
		}

        public DataTable GetProfile(int ProfileID, int ProfilePeriodID, int organisationID)
		{
			using(StoredProcedure spGetProfile = new StoredProcedure("prcProfile_Get",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
					  StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
			{
				DataTable dtGetProfile = spGetProfile.ExecuteTable();
				return dtGetProfile;
			}
		}

		public string GetProfileName(int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string ProfileNameSelect = @"select ProfileName from tblProfile where ProfileID=" + ProfileID;
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@ProfileID", ProfileID) };
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, ProfileNameSelect, sqlParams).Tables[0];
			string ProfileName = dt.Rows[0]["ProfileName"].ToString();
			return ProfileName;
		}

		public int GetProfilePeriodID(int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string ProfileIDSelect = @"select ProfilePeriodID from tblProfilePeriod where ProfileID=" + ProfileID + " ";
			ProfileIDSelect = ProfileIDSelect + @"and profileperiodactive = 1";

			SqlParameter[] sqlParams = new SqlParameter[] {new SqlParameter("@ProfileID", ProfileID) };
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, ProfileIDSelect, sqlParams).Tables[0];
			int ProfilePeriodID;
			if(dt.Rows.Count > 0)
			{
				ProfilePeriodID = Int32.Parse(dt.Rows[0]["ProfilePeriodID"].ToString());
			}
			else
			{
				ProfilePeriodID = -1;
			}
			return ProfilePeriodID;
		}

		public bool CheckProfilePointsExist(int ProfilePeriodID, int ModuleID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
	
			string strSQL = @"select * from tblProfilePoints where profileperiodid=" + ProfilePeriodID + " ";
			strSQL += @" and profilepointstype='M' and typeid=" + ModuleID + " ";
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if (dt.Rows.Count > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public int CheckPeriodOverlap(Profile pro )
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string ProfileIDSelect = @"select count(*) as countr FROM tblProfilePeriod   inner join tblProfile on tblProfile.ProfileID = tblProfilePeriod.ProfileID where tblProfile.ProfileID=@ProfileID  and profileperiodid <> @profilePeriodID";
            ProfileIDSelect = ProfileIDSelect + @" and ((dbo.udfDaylightSavingTimeToUTC(@datestart,organisationID) between datestart  and  dateend) ";
            ProfileIDSelect = ProfileIDSelect + @" or (dbo.udfDaylightSavingTimeToUTC(@dateend,organisationID) between datestart and dateend) ";
            ProfileIDSelect = ProfileIDSelect + @" or (dbo.udfDaylightSavingTimeToUTC(@datestart,organisationID) <= datestart and dbo.udfDaylightSavingTimeToUTC(@dateend,organisationID) >= dateadd (d,1,dateend)))";

			SqlParameter[] sqlParams = new SqlParameter[] {new SqlParameter("@ProfileID", pro.ProfileID) 
															  ,new SqlParameter("@ProfilePeriodID", pro.ProfilePeriodID)
															  ,new SqlParameter("@datestart", pro.DateStart) 
															  ,new SqlParameter("@dateend", pro.DateEnd) };
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, ProfileIDSelect, sqlParams).Tables[0];
			return  Int32.Parse(dt.Rows[0]["countr"].ToString());
			
		}


		public string getCPDReportTitle(int OrganisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string GetCPDTitle = @"select cpdReportName from tblorganisation where OrganisationID=" + OrganisationID;
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text,GetCPDTitle ).Tables[0];
			string strCPDRptTitle =  dt.Rows[0]["cpdReportName"].ToString();
			if (strCPDRptTitle == "")
			{
				strCPDRptTitle = "Continuing Professional Development";
			}
			return strCPDRptTitle;
		}
        
		public DataTable GetProfilesForCurrentOrg(int OrganisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string GetProfiles = @"select ProfileID, ProfileName from tblProfile where OrganisationID=" + OrganisationID + "order by ProfileName";
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", OrganisationID) };
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, GetProfiles, sqlParams).Tables[0];
			return dt;
		}

		public DataTable GetPeriodsForProfile(int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string GetProfiles = @"select tblProfilePeriod.ProfilePeriodID, convert (varchar(11),dbo.udfUTCtoDaylightSavingTime(DateStart,OrganisationID),113) + ' - ' + convert (varchar(11),dbo.udfUTCtoDaylightSavingTime(DateEnd,OrganisationID),113)  as PeriodName 
									from tblProfilePeriod   inner join tblProfile on tblProfile.ProfileID = tblProfilePeriod.ProfileID where tblProfile.ProfileID=" + ProfileID + " and (GETUTCDATE() > DateEnd or GETUTCDATE() between DateStart and dateadd(d,1,DateEnd)) ";									
			//SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@ProfileID", ProfileID) };
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, GetProfiles).Tables[0];
			return dt;
		}

		

		public DataView GetCPDEmailData(int ProfileID, string UnitIDs)
		{
			using(StoredProcedure sp = new StoredProcedure("prcCPDEmail_Report",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
					  StoredProcedure.CreateInputParam ("@UnitIDs", SqlDbType.VarChar,-1, UnitIDs)
					   ))
			{
				return sp.ExecuteTable().DefaultView;
			}
		}

		public DataTable ProfileUserSearch(int OrganisationID, int ProfileID, int ProfilePeriodID,  string ParentUnitIDs, string FirstName, string LastName,
			string UserName, string Email, string ExternalID, int UserID, string DisplayType)
		{
			using (StoredProcedure spProfileUserSearch = new StoredProcedure("prcProfile_UserSearch",
					   StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, OrganisationID),
					   StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
					   StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID),
					   StoredProcedure.CreateInputParam("@parentUnitIDs", SqlDbType.NVarChar, ParentUnitIDs),
					   StoredProcedure.CreateInputParam("@firstName", SqlDbType.NVarChar, FirstName),
					   StoredProcedure.CreateInputParam("@lastName", SqlDbType.NVarChar, LastName),
					   StoredProcedure.CreateInputParam("@userName", SqlDbType.NVarChar, UserName),
					   StoredProcedure.CreateInputParam("@Email", SqlDbType.NVarChar, Email),
					   StoredProcedure.CreateInputParam("@ExternalID", SqlDbType.NVarChar, ExternalID),
					   StoredProcedure.CreateInputParam("@adminUserID", SqlDbType.NVarChar, UserID),
					   StoredProcedure.CreateInputParam("@Type", SqlDbType.NVarChar, DisplayType)))
			{
				DataTable dtProfileUserSearch = spProfileUserSearch.ExecuteTable();
				return dtProfileUserSearch;
			}
		}

        public void UpdateUserCPDPoints(int ProfileID, int UserID, int organisationID)
		{
			using (StoredProcedure spUpdateUserCPDPoints = new StoredProcedure("prcCPDPoints_UpdateUser",
					   StoredProcedure.CreateInputParam("@profileid", SqlDbType.Int, ProfileID),
					   StoredProcedure.CreateInputParam("@userid", SqlDbType.Int, UserID),
                       StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                       ))
			{
				spUpdateUserCPDPoints.ExecuteNonQuery();
			}
		}

		public DataTable ProfileGetModulePoints(int CourseID, int ProfilePeriodID,int OrgID)
		{
			using (StoredProcedure spGetModulePoints = new StoredProcedure("prcProfile_GetModulePointsByCourse",
					   StoredProcedure.CreateInputParam("@CourseID", SqlDbType.Int, CourseID),
					   StoredProcedure.CreateInputParam("@ProfilePeriodID", SqlDbType.Int, ProfilePeriodID),
                       StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, OrgID)))
			{
				DataTable dtGetModulePoints = spGetModulePoints.ExecuteTable();
				return dtGetModulePoints;
			}
		}

        public void ProfileAssignModulePoints(int ProfileID, int organisationID)
		{
			using(StoredProcedure spUpdateProfilePoints = new StoredProcedure("prcCPDPoints_Update",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
			{
				spUpdateProfilePoints.ExecuteNonQuery();
			}
			
		}
		
		public void ProfileExclude(int ProfilePeriodID)
		{
			// Get users in the profile and set exclude bit to 1 in tblUserQuizStatus and tblUserLessonStatus
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"update tblUserQuizStatus set excluded = 1 where userid in ";
			strSQL = strSQL + @"(select UserID from tblUserProfilePeriodAccess ";			
			strSQL = strSQL + @"where profileperiodid = " + ProfilePeriodID + " and granted = 1)";

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);

			strSQL = @"update tblUserLessonStatus set excluded = 1 where userid in ";
			strSQL = strSQL + @"(select UserID from tblUserProfilePeriodAccess ";
			strSQL = strSQL + @"where profileperiodid = " + ProfilePeriodID + " and granted = 1)";

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		private DataTable GetUserProfilesForCurrPeriod (int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string GetProfiles = @"select 
										distinct p.profileid, profilename 
									from 
										tblprofile p
									join tblprofileperiod pp 
										on pp.profileid = p.profileid and pp.profileperiodactive = 1  
									join tbluserprofileperiodaccess upa 
										on upa.profileperiodid = pp.profileperiodid 
									where upa.userid =" + UserID + "and upa.granted=1 and pp.ProfilePeriodActive=1 and getutcdate() between pp.DateStart and dateadd(d,1,pp.dateend)";
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@userid", UserID) };
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, GetProfiles, sqlParams).Tables[0];
			return dt;
		}
				
		public DataTable GetIndividualReportData (int UserID)
		{
			string strSQL;
			string strProfileName;

			strSQL = " create table #tmptable(";
			strSQL += " userid int, ";
			strSQL += " courseid int, ";
			strSQL += " coursename nvarchar(100), ";
			strSQL += " moduleid int, ";
			strSQL += " modulename nvarchar(100), ";
			strSQL += " lessonid int, ";
			strSQL += " lessonstatus varchar(50), ";
			strSQL += " quizstatus varchar(50), ";
			strSQL += " quizscore int, ";
			strSQL += " quizpassmark int, ";
			strSQL += " [sequence] int	) ";

			strSQL += " insert #tmptable (userid,courseid,coursename ";
			strSQL += " 			,moduleid,modulename,lessonid,lessonstatus ";
			strSQL += " 			,quizstatus,quizscore,quizpassmark,[sequence]) ( ";
			strSQL += " Select ";			
			strSQL += "		tID.UserID		 ";
			strSQL += "		, tid.CourseID	 ";
			strSQL += "		, CourseName	 ";
			strSQL += "		, tID.ModuleID	 ";
			strSQL += "		, ModuleName	 ";
			strSQL += "		, LessonID	 ";
			strSQL += "		, tLS.Status as 'LessonStatus' ";
			strSQL += "		, tQS.Status as 'QuizStatus' ";
			strSQL += "		, QuizScore 	 ";
			strSQL += "		, QuizPassMark	 ";
			strSQL += "		, tid.[Sequence] 	 ";
			strSQL += "	From ";
			strSQL += "		udfReport_IndividualDetails("+ UserID +") tID ";
			strSQL += "		inner join tblLessonStatus tLS ";
			strSQL += "			on tLS.LessonStatusID = tID.LessonStatus ";
			strSQL += "		 inner join tblQuizStatus tQS ";
			strSQL += "			on tQS.QuizStatusID =  tID.QuizStatus )";

			DataTable dt =	GetUserProfilesForCurrPeriod (UserID);

			foreach (DataRow drwProfile in dt.Rows)
			{
				// get the profile name
				strProfileName = drwProfile.ItemArray[1].ToString();

				// add the columnsat the end
				strSQL += " alter table #tmptable add [" +  strProfileName + "] float "; 
				strSQL += " alter table #tmptable add [" +  strProfileName + "ID~] int "; 
				strSQL += " update #tmptable set [" +  strProfileName + "ID~] =" + drwProfile.ItemArray[0].ToString() + " ";
				// update the points
				strSQL += " update #tmptable set [" +  strProfileName + "] = Pts ";
				strSQL += " from #tmptable t2 ";
				strSQL += "		join  ";
				strSQL += "			(	select  ";
				strSQL += "					t3.ModuleID, ";
				strSQL += "					t3.[" +  strProfileName + "ID~], ";
				strSQL += "					t3.UserID, ";
				strSQL += "					sum(upt.Points) as Pts ";
				strSQL += "				from  ";
				strSQL += "					#tmptable t3 ";
				strSQL += "					join tblProfilePeriod pp ";
				strSQL += " 					on pp.profileid = t3.[" +  strProfileName + "ID~] ";
				strSQL += "					join tblProfilePoints pt  ";
				strSQL += " 					on pt.profileperiodid =pp.profileperiodid ";
				strSQL += "					join tbluserCPDPoints upt  ";
				strSQL += " 					on upt.profilepointsID = pt.profilepointsid ";
				strSQL += "				where  ";
				strSQL += "					pt.profilepointstype ='M'  ";
				strSQL += "					and pt.typeid = t3.ModuleID ";
				strSQL += "					and pp.profileid =t3.[" +  strProfileName + "ID~] ";
				strSQL += "					and upt.userid =t3.UserID ";
				strSQL += "					and pp.profileperiodactive = 1 ";
				strSQL += "				group by  ";
				strSQL += "					t3.ModuleID, ";
				strSQL += "					t3.[" +  strProfileName + "ID~], ";
				strSQL += "					t3.UserID ";
				strSQL += "			) as dev   ";
				strSQL += "		on t2.moduleid = dev.moduleid  "; 
				strSQL += "			and t2.[" +  strProfileName + "ID~] = dev.[" +  strProfileName + "ID~]  ";
				strSQL += "			and t2.userid = dev.userid ";
				// update the null points to indicate history or not
				strSQL += " update #tmptable set [" +  strProfileName + "] = coalesce([" +  strProfileName + "],Pts, 0) ";
				strSQL += " from #tmptable t2 ";
				strSQL += "		left join  ";
				strSQL += "			(	select  ";
				strSQL += "					t3.ModuleID, ";
				strSQL += "					t3.[" +  strProfileName + "ID~], ";
				strSQL += "					t3.UserID, ";
				strSQL += "					case when sum(upt.Points)>0 then -1 else 0 end  as Pts ";
				strSQL += "				from  ";
				strSQL += "					#tmptable t3 ";
				strSQL += "					join tblProfilePeriod pp ";
				strSQL += " 					on pp.profileid = t3.[" +  strProfileName + "ID~] ";
				strSQL += "					join tblProfilePoints pt  ";
				strSQL += " 					on pt.profileperiodid =pp.profileperiodid ";
				strSQL += "					join tbluserCPDPoints upt  ";
				strSQL += " 					on upt.profilepointsID = pt.profilepointsid ";
				strSQL += "				where  ";
				strSQL += "					pt.profilepointstype ='M'  ";
				strSQL += "					and pt.typeid = t3.ModuleID ";
				strSQL += "					and pp.profileid =t3.[" +  strProfileName + "ID~] ";
				strSQL += "					and upt.userid =t3.UserID ";				
				strSQL += "				group by  ";
				strSQL += "					t3.ModuleID, ";
				strSQL += "					t3.[" +  strProfileName + "ID~], ";
				strSQL += "					t3.UserID ";
				strSQL += "			) as dev   ";
				strSQL += "		on t2.moduleid = dev.moduleid  "; 
				strSQL += "			and t2.[" +  strProfileName + "ID~] = dev.[" +  strProfileName + "ID~]  ";
				strSQL += "			and t2.userid = dev.userid ";
				strSQL += "			and t2.[" +  strProfileName + "] is null	";

			}

			strSQL +=" select * from #tmptable order by coursename, [sequence] ";
			strSQL +=" drop table #tmptable ";
			
			Debug.WriteLine (strSQL);

			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

			return dt;
		}

		public DataTable GetProfileList(int OrganisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"select ProfileID, ProfileName from tblProfile where OrganisationID=" + OrganisationID;
			DataTable dtProfileList = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtProfileList;
		}

        public DataView GetCPDModuleHistory(int ProfileID, int ModuleID, int UserID, int organisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			using(StoredProcedure sp = new StoredProcedure("prcCPDModuleHistory_Report",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.VarChar, ProfileID),
					  StoredProcedure.CreateInputParam("@ModuleID", SqlDbType.VarChar, ModuleID),
					  StoredProcedure.CreateInputParam("@UserID", SqlDbType.VarChar, UserID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
					  ))
			{
				return sp.ExecuteTable().DefaultView;
			}
		}

		public DataView GetCPDProfileHistory(int ProfileID, int UserID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			using(StoredProcedure sp = new StoredProcedure("prcCPDProfileHistory_Report",
					  StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.VarChar, ProfileID),					  
					  StoredProcedure.CreateInputParam("@UserID", SqlDbType.VarChar, UserID)
					  ))
			{
				return sp.ExecuteTable().DefaultView;
			}
		}
		
		public DataView GetTotalCurrentPointsForProfile(int UserID)
		{
			string strSQL;
			string strProfileName;

			strSQL = " create table #tmptable( Summ varchar(50))";
			strSQL += " insert into #tmptable values ('Total:') ";

			strSQL += " declare @userpoints numeric(10,1) ";
			strSQL += " declare @totalpoints numeric (10,1) ";
			strSQL += " declare @shortfall numeric(10,1) ";

			DataTable dt =	GetUserProfilesForCurrPeriod (UserID);

			foreach (DataRow drwProfile in dt.Rows)
			{
				// get the profile name
				strProfileName = drwProfile.ItemArray[1].ToString();
				int intProfileID = int.Parse(drwProfile.ItemArray[0].ToString());

				// add the columnsat the end
				strSQL += " select @userpoints = 0, @totalpoints = 0, @shortfall = 0 ";// reset
				strSQL += " alter table #tmptable add [" +  strProfileName + "] numeric(10,1) "; 
				strSQL += " alter table #tmptable add [" +  strProfileName + "ID~] numeric(10) ";
				strSQL += " alter table #tmptable add [" +  strProfileName + "ShrtFall~] numeric(10,1) ";
				strSQL += " update #tmptable set [" +  strProfileName + "ID~] =" + intProfileID.ToString() + " ";
				strSQL += " set @userpoints =  ";
				strSQL += " (select case when sum(upt.points) is null then 0 else sum(upt.points) end from ";
				strSQL += " tblProfilePeriod pp ";
				strSQL += " left join tblProfilePoints pt ";
				strSQL += " on pt.profileperiodid = pp.profileperiodid ";
				strSQL += " and pt.profilepointstype = 'M' ";
				strSQL += " left join tbluserCPDPoints upt ";
				strSQL += " on upt.profilepointsid = pt.profilepointsid ";
				strSQL += " where upt.userid = " + UserID + " ";
				strSQL += " and pp.profileperiodactive = 1 ";
				strSQL += " and pp.profileid = " + intProfileID.ToString() + ") ";
				strSQL += " set @totalpoints = ";
				strSQL += " (select distinct(points) from ";
				strSQL += " tblProfilePeriod pp ";
				strSQL += " where pp.profileid = " + intProfileID.ToString() + " ";
				strSQL += " and pp.profileperiodactive = 1) ";
				strSQL += " set @shortfall = @totalpoints - @userpoints ";
				strSQL += " if @shortfall < 0 set @shortfall = 0 ";
				strSQL += " update #tmptable set [" +  strProfileName + "] = @userpoints,  [" +  strProfileName + "ShrtFall~] = @shortfall ";
			}
			strSQL +=" select * from #tmptable ";
			strSQL +=" drop table #tmptable ";
			
			Debug.WriteLine (strSQL);

			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

			return dt.DefaultView;

		}

		public void DeleteFuturePeriod(int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL;
			//Delete Profile Points for Profile
			strSQL = @"update tblProfilePoints set active = 0 where ProfilePeriodID = ";
			strSQL = strSQL + "(select ProfilePeriodID from tblProfilePeriod where ProfileID = " + ProfileID + " ";
			strSQL = strSQL + "and profileperiodactive = 1)";
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
			//Update Profile Period for Profile
			strSQL = @"update tblProfilePeriod set ";
			strSQL = strSQL + @"datestart =  case when datestart > GETUTCDATE() then null else datestart end, ";
			strSQL = strSQL + @"dateend = case when datestart > GETUTCDATE() then null else dateend end, ";
			strSQL = strSQL + @"points = case when datestart > GETUTCDATE() then null else points end, ";
			strSQL = strSQL + @"futuredatestart = case when futuredatestart > GETUTCDATE() then null else futuredatestart end, ";
			strSQL = strSQL + @"futuredateend = case when futuredatestart > GETUTCDATE() then null else futuredateend end, ";
			strSQL = strSQL + @"futurepoints = case when futuredatestart > GETUTCDATE() then null else futurepoints end  ";
			strSQL = strSQL + @"where ProfileID = " + ProfileID + "and profileperiodactive = 1 ";

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public void UpdateProfilePeriodQuizLessonStatus(int ProfilePeriodID, int ApplyToQuiz, int ApplyToLesson)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"update tblProfilePeriod set ";
			strSQL = strSQL + @"ApplyToQuiz = " + ApplyToQuiz + ", ";
			strSQL = strSQL + @"ApplyToLesson = " + ApplyToLesson + " ";
			strSQL = strSQL + @"where ProfilePeriodID = " + ProfilePeriodID;
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public DataTable GetLessonQuizStatus(int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"select coalesce(ApplyToQuiz,'False') as ApplyToQuiz, coalesce(ApplyToLesson,'False') as ApplyToLesson ";
			strSQL = strSQL + @"from tblProfilePeriod where ProfileID = " + ProfileID + " ";
			strSQL = strSQL + @"and profileperiodactive = 1";
			DataTable dtLessonQuizStatus = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtLessonQuizStatus;
			
		}

		public bool QuizRequiredForPoints(int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"select ApplyToQuiz from tblProfilePeriod where ProfileID = " + ProfileID + " ";
			strSQL = strSQL + @"and profileperiodactive = 1";
			DataTable dtQuizRequired = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if (dtQuizRequired.Rows.Count == 0)
			{
				return false;
			}
			else
			{
				bool QuizRequired = bool.Parse(dtQuizRequired.Rows[0]["ApplyToQuiz"].ToString());
				return QuizRequired;
			}
		}

		public bool LessonRequiredForPoints(int ProfileID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = @"select ApplyToLesson from tblProfilePeriod where ProfileID = " + ProfileID + " ";
			strSQL = strSQL + @"and profileperiodactive = 1";
			DataTable dtLessonRequired = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if (dtLessonRequired.Rows.Count == 0)
			{
				return false;
			}
			else
			{
				bool LessonRequired = bool.Parse(dtLessonRequired.Rows[0]["ApplyToLesson"].ToString());
				return LessonRequired;
			}
		}

		public bool CheckLessonComplete(int UserID, int ProfileID, int ModuleID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
			// Get the last completed lesson from tblUserLessonStatus
            string strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserLessonStatus on tblUser.UserID = tblUserLessonStatus.UserID where tblUserLessonStatus.UserID = " + UserID + " ";
			strSQL = strSQL + @"and ModuleID = " + ModuleID + " ";
            strSQL = strSQL + @"and LessonStatusID = 3 order by dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) desc";
			
			DataTable dtLessonComplete = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			
			if (dtLessonComplete.Rows.Count == 0 || dtLessonComplete.Rows[0].Equals(System.DBNull.Value))
			{
				return false;
			}
			else
			{
                strSQL = @"select dbo.udfUTCtoDaylightSavingTime(tblProfilePeriod.DateStart,OrganisationID) as DateStart, dbo.udfUTCtoDaylightSavingTime(tblProfilePeriod.DateEnd,OrganisationID) as DateEnd from tblProfilePeriod   inner join tblProfile on tblProfile.ProfileID = tblProfilePeriod.ProfileID where tblProfilePeriod.ProfileID = " + ProfileID + " ";
				strSQL = strSQL + @"and profileperiodactive = 1";
				
				DataTable dtProfileDates = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
				DateTime Datestart = DateTime.Parse(dtProfileDates.Rows[0]["DateStart"].ToString());
				DateTime Dateend = DateTime.Parse(dtProfileDates.Rows[0]["DateEnd"].ToString());
				DateTime DateLessonComplete = DateTime.Parse(dtLessonComplete.Rows[0]["DateCreated"].ToString());
				if((DateLessonComplete > Datestart) && (DateLessonComplete < Dateend.AddDays(1)))
				{
                    strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserLessonStatus on tblUser.UserID = tblUserLessonStatus.UserID where tblUserLessonStatus.UserID = " + UserID + " ";
					strSQL += @"and ModuleID = " + ModuleID + " ";
					strSQL += @"and LessonStatusID = 5 order by DateCreated desc";
					DataTable dtLessonReset = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
					if(dtLessonReset.Rows.Count == 0 || dtLessonReset.Rows[0].Equals(System.DBNull.Value))
					{
						return true;
					}
					else if (DateLessonComplete > (DateTime)dtLessonReset.Rows[0]["DateCreated"])
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else
				{
					return false;
				}

			}
		}

		public bool CheckQuizComplete(int UserID, int ProfileID, int ModuleID)
		{	
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            string strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserQuizStatus on tblUser.UserID = tblUserQuizStatus.UserID where tblUserQuizStatus.UserID = " + UserID + " ";
			strSQL = strSQL + @"and ModuleID = " + ModuleID + " ";
            strSQL = strSQL + @"and QuizStatusID = 2 order by dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) desc";
			
			DataTable dtQuizComplete = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			if (dtQuizComplete.Rows.Count == 0 || dtQuizComplete.Rows[0].Equals(System.DBNull.Value))
			{
				return false;
			}
			else
			{
                strSQL = @"select dbo.udfUTCtoDaylightSavingTime(tblProfilePeriod.DateStart,OrganisationID) as DateStart, dbo.udfUTCtoDaylightSavingTime(tblProfilePeriod.DateEnd,OrganisationID) as DateEnd from tblProfilePeriod inner join tblProfile on tblProfile.ProfileID = tblProfilePeriod.ProfileID where tblProfilePeriod.ProfileID = " + ProfileID + " ";
                strSQL = strSQL + @"and profileperiodactive = 1";
				DataTable dtProfileDates = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
				DateTime Datestart = DateTime.Parse(dtProfileDates.Rows[0]["DateStart"].ToString());
				DateTime Dateend = DateTime.Parse(dtProfileDates.Rows[0]["DateEnd"].ToString());
				DateTime DateQuizComplete = DateTime.Parse(dtQuizComplete.Rows[0]["DateCreated"].ToString());
				if((DateQuizComplete > Datestart) && (DateQuizComplete < Dateend.AddDays(1)))
				{
                    strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserQuizStatus on tblUser.UserID = tblUserQuizStatus.UserID where tblUserQuizStatus.UserID = " + UserID + " ";
                    strSQL = strSQL + @"and QuizStatusID = 5 order by DateCreated desc";
					DataTable dtQuizReset = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
					if(dtQuizReset.Rows.Count == 0 || dtQuizReset.Rows[0].Equals(System.DBNull.Value))
					{
						return true;
					}
					else if (DateQuizComplete > (DateTime)dtQuizReset.Rows[0]["DateCreated"])
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else
				{
					return false;
				}
			}
		}

		public void ApplyCPDPoints(int ProfileID, int UserID, int ModuleID, int LessonQuizStatus)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			
		
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			int ProfilePeriodID = objProfile.GetProfilePeriodID(ProfileID);

			string strSQL = @"select ProfilePointsID, Points from tblProfilePoints where ProfilePeriodID = " + ProfilePeriodID + " ";
			strSQL = strSQL + @"and ProfilePointsType = 'M' and TypeID = " + ModuleID;
			DataTable dtProfileIDPoints = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			int ProfilePointsID = Int32.Parse(dtProfileIDPoints.Rows[0]["ProfilePointsID"].ToString());
			double Points = double.Parse(dtProfileIDPoints.Rows[0]["Points"].ToString());

			strSQL = @"insert into tblUserCPDPoints (ProfilePointsID, UserID, Points, DateAssigned, LessonQuizStatus) values ";
			strSQL = strSQL + @"(" + ProfilePointsID + @"," + UserID + @"," + Points + @", getutcDate()," + LessonQuizStatus + ")";
			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, strSQL);
		}

		public bool CheckLessonPointsAlreadyGivenForPeriod(int ProfileID, int UserID, int ModuleID, int LessonQuizStatus)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			// Date points assigned to user
			DataTable dtUserPointsAssigned = this.GetDatePointsAssignedToUser(ProfileID, UserID, ModuleID, LessonQuizStatus);

            string strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserLessonStatus on tblUser.UserID = tblUserLessonStatus.UserID where tblUserLessonStatus.UserID = " + UserID + " ";
            strSQL = strSQL + @" and ModuleID = " + ModuleID + " ";
            strSQL = strSQL + @" and tblUserLessonStatus.LessonStatusID = 5 order by dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) desc";

			DataTable dtDateReset = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

			// No record of lesson being reset
			if(dtDateReset.Rows.Count == 0)
			{
				// Now check to see if lesson completed
                strSQL = @"select dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserLessonStatus on tblUser.UserID = tblUserLessonStatus.UserID where tblUserLessonStatus.UserID = " + UserID + " ";
                //strSQL = @"select DateCreated from tblUserLessonStatus ";
                //strSQL = strSQL + @"and tblUserLessonStatus.userid = " + UserID + " ";
                strSQL = strSQL + @"and tblUserLessonStatus.moduleID = " + ModuleID + " ";
                strSQL = strSQL + @"and tblUserLessonStatus.LessonStatusID = 3 ";
                strSQL = strSQL + @"order by dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) desc";

				DataTable dtLessonCompleted = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

				// If there are lesson completed records
				if(dtLessonCompleted.Rows.Count > 0)
				{
					// Check to see if points already assigned
					if(dtUserPointsAssigned.Rows.Count > 0)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else //no lesson completed yet - return true
				{
					return true;
				}
			}
			else // Lesson has been reset
			{
				DateTime DateReset = (DateTime)dtDateReset.Rows[0]["DateCreated"];

				// Here we are getting the last Date when the Lesson was completed
                strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserLessonStatus on tblUser.UserID = tblUserLessonStatus.UserID ";
                strSQL = strSQL + @"where tblUserLessonStatus.userid = " + UserID + " ";
                strSQL = strSQL + @"and tblUserLessonStatus.moduleID = " + ModuleID + " ";
                strSQL = strSQL + @"and tblUserLessonStatus.LessonStatusID = 3 ";
                strSQL = strSQL + @"and dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) >= '" + DateReset.ToString("yyyy-MM-dd HH:mm:ss") + "' ";

				DataTable dtUserLessonCompleted = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];

				// If there are lesson completed records
				if(dtUserLessonCompleted.Rows.Count > 0)
				{
					if(dtUserPointsAssigned.Rows.Count > 0)
					{
						if((DateTime)dtUserPointsAssigned.Rows[0]["DateAssigned"] > (DateTime)dtDateReset.Rows[0]["DateCreated"])
						{
							return true;
						}
						else
						{
							return false;
						}
					}
					else
					{
						return false;
					}
				}
				else
				{
					return true;
				}
			}
			
		}

		public bool CheckQuizPointsAlreadyGivenForPeriod(int ProfileID, int UserID, int ModuleID, int LessonQuizStatus)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			// Date points assigned to user
			DataTable dtUserPointsAssigned = this.GetDatePointsAssignedToUser(ProfileID, UserID, ModuleID, LessonQuizStatus);

            string strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserQuizStatus on tblUser.UserID = tblUserQuizStatus.UserID where tblUserQuizStatus.UserID = " + UserID + " ";
            strSQL = strSQL + @" and ModuleID = " + ModuleID + " ";
            strSQL = strSQL + @" and QuizStatusID = 5 order by dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) desc";
			
			DataTable dtDateReset = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			
			// No record of quiz reset
			if(dtDateReset.Rows.Count == 0)
			{
				// Now check to see if quiz passed
				//strSQL = @"select DateCreated from tblUserQuizStatus where userID = " + UserID + " ";
                strSQL = @"select  dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserQuizStatus on tblUser.UserID = tblUserQuizStatus.UserID where tblUserQuizStatus.UserID = " + UserID + " ";
                strSQL = strSQL + @" and ModuleID = " + ModuleID + " ";
                strSQL = strSQL + @" and QuizStatusID = 2 order by dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) desc";
				
				DataTable dtQuizPassed = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
				// if there are quiz passed records
				if(dtQuizPassed.Rows.Count > 0)
				{
					// Check to see if points already assigned
					if(dtUserPointsAssigned.Rows.Count > 0)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
				else //no quiz completed yet - return true
				{
					return true;
				}
			}
			else // Quiz has been reset
			{
				// Now check to see if quiz passed since reset
				DateTime DateReset = (DateTime)dtDateReset.Rows[0]["DateCreated"];
				//strSQL = @"select DateCreated from tblUserQuizStatus where userID = " + UserID + " ";
                strSQL = @"select  dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserQuizStatus on tblUser.UserID = tblUserQuizStatus.UserID where tblUserQuizStatus.UserID = " + UserID + " ";

				strSQL = strSQL + @" and ModuleID = " + ModuleID + " ";
                strSQL = strSQL + @" and QuizStatusID = 2 and dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) >= '" + DateReset.ToString("yyyy-MM-dd HH:mm:ss") + "' ";

				DataTable dtQuizPassed = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
				// If there are quiz passed records
				if(dtQuizPassed.Rows.Count > 0)
				{
					if(dtUserPointsAssigned.Rows.Count > 0)
					{
						if((DateTime)dtUserPointsAssigned.Rows[0]["DateAssigned"] > (DateTime)dtDateReset.Rows[0]["DateCreated"])
						{
							return true;
						}
						else
						{
							return false;
						}
					}
					else
					{
						return false;
					}

				}
				else // quiz has not been passed since reset so return true so points not assigned
				{
					return true;
				}
			}
		}

		public bool ShowModulePoints(int ProfileID, int UserID, int ModuleID, int QuizLesson, int LessonQuizStatus)
		{
			bool ShowPoints = false;
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			string strSQL = string.Empty;
			// Date points assigned to user
			DataTable dtUserPointsAssigned = this.GetDatePointsAssignedToUser(ProfileID, UserID, ModuleID, LessonQuizStatus);

			switch (QuizLesson)
			{
				case 0: //Lesson
					//strSQL = @"select top 1 DateCreated from tblUserLessonStatus where userID = " + UserID + " ";
                    strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserLessonStatus on tblUser.UserID = tblUserLessonStatus.UserID where tblUserLessonStatus.UserID = " + UserID + " ";
                    strSQL = strSQL + @"and ModuleID = " + ModuleID + " ";
                    strSQL = strSQL + @"and tblUserLessonStatus.LessonStatusID = 5 order by dbo.udfUTCtoDaylightSavingTime(tblUserLessonStatus.DateCreated,OrganisationID) desc";
					DataTable dtLessonResetDate = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
					if(dtLessonResetDate.Rows.Count > 0)
					{
						if(dtUserPointsAssigned.Rows.Count > 0)
						{
							if((DateTime)dtUserPointsAssigned.Rows[0]["DateAssigned"] >= (DateTime)dtLessonResetDate.Rows[0]["DateCreated"])
							{
								ShowPoints = false;
							}
							else
							{
								ShowPoints = true;
							}
						}
						else
						{
							ShowPoints = true;
						}
					}
					else
					{
						if(dtUserPointsAssigned.Rows.Count > 0) // Points assigned, Lesson not reset
						{
							ShowPoints = false;
						}
						else
						{
							ShowPoints = true;
						}
					}
					break;
				case 1: //Quiz
					//strSQL = @"select top 1 DateCreated from tblUserQuizStatus where userID = " + UserID + " ";
                    strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) as DateCreated from tblUser inner join tblUserQuizStatus on tblUser.UserID = tblUserQuizStatus.UserID where tblUserQuizStatus.UserID = " + UserID + " ";

					strSQL = strSQL + @"and ModuleID = " + ModuleID + " ";
                    strSQL = strSQL + @"and QuizStatusID = 5 order by dbo.udfUTCtoDaylightSavingTime(tblUserQuizStatus.DateCreated,OrganisationID) desc";
					DataTable dtQuizResetDate = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
					if(dtQuizResetDate.Rows.Count > 0)
					{
						if(dtUserPointsAssigned.Rows.Count > 0)
						{
							if((DateTime)dtUserPointsAssigned.Rows[0]["DateAssigned"] >= (DateTime)dtQuizResetDate.Rows[0]["DateCreated"])
							{
								ShowPoints = false;
							}
							else
							{
								ShowPoints = true;
							}
						}
						else
						{
							ShowPoints = true;
						}
					}
					else
					{
						if(dtUserPointsAssigned.Rows.Count > 0) // Points assigned, Lesson not reset
						{
							ShowPoints = false;
						}
						else
						{
							ShowPoints = true;
						}
					}
					break;
			}

			return ShowPoints;
		}

		public DataTable GetDatePointsAssignedToUser(int ProfileID, int UserID, int ModuleID, int LessonQuizStatus)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			// Here we are getting the Date points assigned to the user
            string strSQL = @"select top 1 dbo.udfUTCtoDaylightSavingTime(ucp.DateAssigned,OrganisationID) as DateAssigned, dbo.udfUTCtoDaylightSavingTime(pp.DateEnd,OrganisationID) as DateEnd  FROM tblProfilePeriod pp  inner join tblProfile on tblProfile.ProfileID = pp.ProfileID ";
            //string strSQL = @"select top 1 ucp.DateAssigned from ";
			//strSQL = strSQL + @"tblProfilePeriod pp ";
			strSQL = strSQL + @"join tblProfilePoints ppts ";
			strSQL = strSQL + @"on pp.ProfilePeriodID = ppts.ProfilePeriodID ";
			strSQL = strSQL + @"join tblUserCPDPoints ucp ";
			strSQL = strSQL + @"on ppts.ProfilePointsID = ucp.ProfilePointsID ";
			strSQL = strSQL + @"where ppts.ProfilePointsType = 'M' ";
			strSQL = strSQL + @"and ppts.TypeID = " + ModuleID + " ";
			strSQL = strSQL + @"and ucp.UserID = " + UserID + " ";
			strSQL = strSQL + @"and pp.ProfileID = " + ProfileID + " ";
			strSQL = strSQL + @"and ucp.LessonQuizStatus = " + LessonQuizStatus + " ";
			strSQL = strSQL + @"and profileperiodactive = 1 ";
            strSQL = strSQL + @"order by dbo.udfUTCtoDaylightSavingTime(ucp.DateAssigned,OrganisationID) desc";

			DataTable dtUserPointsAssigned = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
			return dtUserPointsAssigned;

		}

		public DataTable ProfilesWithModuleAccess(int UserID, int ModuleID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			string strSQL = @"select distinct p.profileid ";
			strSQL += @"from tblProfile p ";
			strSQL += @"join tblProfilePeriod pp ";
			strSQL += @"on p.profileid = pp.profileid ";
			strSQL += @"join tblProfilePoints ppts ";
			strSQL += @"on pp.profileperiodid = ppts.profileperiodid ";
			strSQL += @"join tblUserProfilePeriodAccess uppa ";
			strSQL += @"on pp.profileperiodid = uppa.profileperiodid ";
			strSQL += @"where ppts.profilepointstype = 'M' ";
			strSQL += @"and ppts.typeid = " + ModuleID + " ";
			strSQL += @"and uppa.granted = 1 ";
			strSQL += @"and uppa.userid = " + UserID + " ";
			strSQL += @"and pp.profileperiodactive=1 ";
			strSQL += @"and getutcdate() between pp.datestart and dateadd(d,1,pp.dateend)";

			DataTable dtProfilesWithModuleAccess = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0]; 
			return dtProfilesWithModuleAccess;
		}
	}
}
