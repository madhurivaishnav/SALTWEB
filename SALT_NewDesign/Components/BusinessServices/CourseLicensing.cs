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
	/// Summary description for CourseLicensing.
	/// </summary>
	public class CourseLicensing
	{
		#region "PROPERTIES"
		private int courseLicensingID = 0;
		public int CourseLicensingID
		{
			get { return courseLicensingID; }
			set { courseLicensingID = value; }
		}

		private int organisationID = 0;
		public int OrganisationID
		{
			get { return organisationID; }
			set { organisationID = value; }
		}

		private int courseID = 0;
		public int CourseID
		{
			get { return courseID; }
			set { courseID = value; }
		}

		private int licenseNumber = 0;
		public int LicenseNumber
		{
			get { return licenseNumber; }
			set { licenseNumber = value; }
		}

		private DateTime dateStart = DateTime.Parse("1/1/1900");
		public DateTime DateStart
		{
			get { return dateStart; }
			set { dateStart = value; }
		}

		private DateTime dateEnd = DateTime.Parse("1/1/1900");
		public DateTime DateEnd
		{
			get { return dateEnd; }
			set { dateEnd = value; }
		}

		private int licenseWarnNumber = 0;
		public int LicenseWarnNumber
		{
			get { return licenseWarnNumber; }
			set { licenseWarnNumber = value; }
		}

		private bool licenseWarnEmail = false;
		public bool LicenseWarnEmail
		{
			get { return licenseWarnEmail; }
			set { licenseWarnEmail = value; }
		}

		private DateTime dateLicenseWarnEmailSent = DateTime.Parse("1/1/1900");
		public DateTime DateLicenseWarnEmailSent
		{
			get { return dateLicenseWarnEmailSent; }
			set { dateLicenseWarnEmailSent = value; }
		}

		private DateTime dateWarn = DateTime.Parse("1/1/1900");
		public DateTime DateWarn
		{
			get { return dateWarn; }
			set { dateWarn = value; }
		}

		private bool expiryWarnEmail = false;
		public bool ExpiryWarnEmail
		{
			get { return expiryWarnEmail; }
			set { expiryWarnEmail = value; }
		}

		private DateTime dateExpiryWarnEmailSent = DateTime.Parse("1/1/1900");
		public DateTime DateExpiryWarnEmailSent
		{
			get { return dateExpiryWarnEmailSent; }
			set { dateExpiryWarnEmailSent = value; }
		}

		private string repNameSalt = string.Empty;
		public string RepNameSalt
		{
			get { return repNameSalt; }
			set { repNameSalt = value; }
		}

		private string repEmailSalt = string.Empty;
		public string RepEmailSalt
		{
			get { return repEmailSalt; }
			set { repEmailSalt = value; }
		}

		private string repNameOrg = string.Empty;
		public string RepNameOrg
		{
			get { return repNameOrg; }
			set { repNameOrg = value; }
		}

		private string repEmailOrg = string.Empty;
		public string RepEmailOrg
		{
			get { return repEmailOrg; }
			set { repEmailOrg = value; }
		}


		private string langCode = string.Empty;
		public string LangCode
		{
			get { return langCode; }
			set { langCode = value; }
		}

		#endregion
		
		public static DataTable GetPeriod(int courseLicensingID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@CourseLicensingID", courseLicensingID) };

			string sqlCurrent = @"SELECT [CourseLicensingID]     ,[OrganisationID]      ,[CourseID]      ,[LicenseNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateStart],OrganisationID) as DateStart      ,dbo.udfUTCtoDaylightSavingTime([DateEnd],OrganisationID) as DateEnd      ,[LicenseWarnEmail]      ,[LicenseWarnNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateLicenseWarnEmailSent],OrganisationID) as DateLicenseWarnEmailSent      ,[ExpiryWarnEmail]      ,[DateWarn] as DateWarn      ,dbo.udfUTCtoDaylightSavingTime([DateExpiryWarnEmailSent],OrganisationID) as DateExpiryWarnEmailSent      ,[RepNameSalt]      ,[RepEmailSalt]      ,[RepNameOrg]      ,[RepEmailOrg]      ,[LangCode]  FROM tblCourseLicensing WHERE CourseLicensingID = @courseLicensingID";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlCurrent, sqlParams).Tables[0];
			return dt;
		}
		public static DataTable GetCurrentPeriod(int organisationID, int courseID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", organisationID),new SqlParameter("@CourseID", courseID) };

			string sqlCurrent = @"SELECT [CourseLicensingID]     ,[OrganisationID]      ,[CourseID]      ,[LicenseNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateStart],OrganisationID) as DateStart      ,dbo.udfUTCtoDaylightSavingTime([DateEnd],OrganisationID) as DateEnd      ,[LicenseWarnEmail]      ,[LicenseWarnNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateLicenseWarnEmailSent],OrganisationID) as DateLicenseWarnEmailSent      ,[ExpiryWarnEmail]      ,[DateWarn] as DateWarn      ,dbo.udfUTCtoDaylightSavingTime([DateExpiryWarnEmailSent],OrganisationID) as DateExpiryWarnEmailSent      ,[RepNameSalt]      ,[RepEmailSalt]      ,[RepNameOrg]      ,[RepEmailOrg]      ,[LangCode]  FROM tblCourseLicensing WHERE OrganisationID = @OrganisationID AND CourseID = @CourseID AND DateStart <= getutcdate() AND dateadd(day,1,DateEnd) >= getutcdate()";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlCurrent, sqlParams).Tables[0];
			return dt;
		}

		public static DataTable GetFuturePeriod(int organisationID, int courseID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", organisationID), new SqlParameter("@CourseID", courseID) };

			string sqlCurrent = @"SELECT [CourseLicensingID]     ,[OrganisationID]      ,[CourseID]      ,[LicenseNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateStart],OrganisationID) as DateStart      ,dbo.udfUTCtoDaylightSavingTime([DateEnd],OrganisationID) as DateEnd      ,[LicenseWarnEmail]      ,[LicenseWarnNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateLicenseWarnEmailSent],OrganisationID) as DateLicenseWarnEmailSent      ,[ExpiryWarnEmail]      ,[DateWarn] as DateWarn      ,dbo.udfUTCtoDaylightSavingTime([DateExpiryWarnEmailSent],OrganisationID) as DateExpiryWarnEmailSent      ,[RepNameSalt]      ,[RepEmailSalt]      ,[RepNameOrg]      ,[RepEmailOrg]      ,[LangCode]  FROM tblCourseLicensing WHERE OrganisationID = @OrganisationID AND CourseID = @CourseID AND DateStart >= getutcdate()";

			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlCurrent, sqlParams).Tables[0];
			return dt;
		}

		public static DataTable GetCoursesWithPeriod(int organisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@OrganisationID", organisationID) };
			string sql = @"SELECT distinct tblCourse.CourseID, tblCourse.Name 
							FROM tblCourse 
							INNER JOIN tblCourseLicensing ON tblCourse.CourseID = tblCourseLicensing.CourseID 
							WHERE tblCourseLicensing.OrganisationID = @OrganisationID AND tblCourseLicensing.DateStart < GETUTCDATE() 
							ORDER BY Name";
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sql, sqlParams).Tables[0];
			return dt;
		}

		public static DataTable GetPeriodList(int courseID, int organisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@CourseID", courseID), new SqlParameter("@OrganisationID", organisationID) };
			string sql = @"SELECT [CourseLicensingID]     ,[OrganisationID]      ,[CourseID]      ,[LicenseNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateStart],OrganisationID) as DateStart      ,dbo.udfUTCtoDaylightSavingTime([DateEnd],OrganisationID) as DateEnd      ,[LicenseWarnEmail]      ,[LicenseWarnNumber]      ,dbo.udfUTCtoDaylightSavingTime([DateLicenseWarnEmailSent],OrganisationID) as DateLicenseWarnEmailSent      ,[ExpiryWarnEmail]      ,[DateWarn] as DateWarn      ,dbo.udfUTCtoDaylightSavingTime([DateExpiryWarnEmailSent],OrganisationID) as DateExpiryWarnEmailSent      ,[RepNameSalt]      ,[RepEmailSalt]      ,[RepNameOrg]      ,[RepEmailOrg]      ,[LangCode]  FROM tblCourseLicensing WHERE CourseID = @CourseID AND OrganisationID = @OrganisationID AND DateStart < GetutcDate() ORDER BY DateStart DESC";
			DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sql, sqlParams).Tables[0];
			return dt;
		}

		public static void Save(CourseLicensing cl)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			int i = 0;
			SqlParameter[] sqlParams = new SqlParameter[15];
			sqlParams[i++] = new SqlParameter("@CourseLicensingID", cl.CourseLicensingID);
			sqlParams[i++] = new SqlParameter("@OrganisationID", cl.OrganisationID);
			sqlParams[i++] = new SqlParameter("@CourseID", cl.CourseID);
			sqlParams[i++] = new SqlParameter("@LicenseNumber", cl.LicenseNumber);
			sqlParams[i++] = new SqlParameter("@DateStart", cl.DateStart);
			sqlParams[i++] = new SqlParameter("@DateEnd", cl.DateEnd);
			sqlParams[i++] = new SqlParameter("@LicenseWarnEmail", cl.LicenseWarnEmail);
			sqlParams[i++] = new SqlParameter("@LicenseWarnNumber", cl.LicenseWarnNumber);
			sqlParams[i++] = new SqlParameter("@ExpiryWarnEmail", cl.ExpiryWarnEmail);

			if (cl.DateWarn != DateTime.Parse("1/1/1900"))
				sqlParams[i++] = new SqlParameter("@DateWarn", cl.DateWarn);
			else
				sqlParams[i++] = new SqlParameter("@DateWarn", System.DBNull.Value);

			sqlParams[i++] = new SqlParameter("@RepNameSalt", cl.RepNameSalt);
			sqlParams[i++] = new SqlParameter("@RepEmailSalt", cl.RepEmailSalt);
			sqlParams[i++] = new SqlParameter("@RepNameOrg", cl.RepNameOrg);
			sqlParams[i++] = new SqlParameter("@RepEmailOrg", cl.RepEmailOrg);
			sqlParams[i++] = new SqlParameter("@LangCode", cl.LangCode);


			string sqlInsert = @"
								INSERT INTO tblCourseLicensing(OrganisationID, CourseID, LicenseNumber, DateStart, DateEnd, LicenseWarnEmail, LicenseWarnNumber, ExpiryWarnEmail, DateWarn, RepNameSalt, RepEmailSalt, RepNameOrg, RepEmailOrg, LangCode)
								VALUES(@OrganisationID, @CourseID, @LicenseNumber, dbo.udfDaylightSavingTimeToUTC(@DateStart,@OrganisationID), dbo.udfDaylightSavingTimeToUTC(@DateEnd,@OrganisationID), @LicenseWarnEmail, @LicenseWarnNumber, @ExpiryWarnEmail, @DateWarn, @RepNameSalt, @RepEmailSalt, @RepNameOrg, @RepEmailOrg, @LangCode);
								SELECT NEWID = SCOPE_IDENTITY();
								";

			string sqlUpdate = @"
								UPDATE tblCourseLicensing set OrganisationID = @OrganisationID, CourseID = @CourseID, LicenseNumber = @LicenseNumber, DateStart = dbo.udfDaylightSavingTimeToUTC(@DateStart,@OrganisationID), DateEnd = dbo.udfDaylightSavingTimeToUTC(@DateEnd,@OrganisationID), LicenseWarnEmail = @LicenseWarnEmail, LicenseWarnNumber = @LicenseWarnNumber, ExpiryWarnEmail = @ExpiryWarnEmail, DateWarn = @DateWarn, RepNameSalt = @RepNameSalt, RepEmailSalt = @RepEmailSalt, RepNameOrg = @RepNameOrg, RepEmailOrg = @RepEmailOrg, LangCode = @LangCode
								WHERE CourseLicensingID = @CourseLicensingID
								";

			if (cl.CourseLicensingID == 0)
				cl.CourseLicensingID = Int32.Parse(SqlHelper.ExecuteScalar(connectionString, CommandType.Text, sqlInsert, sqlParams).ToString());
			else
				SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlUpdate, sqlParams);

		}

		public static void Delete(int courseLicensingID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@CourseLicensingID", courseLicensingID) };

			string sqlDelete = "DELETE FROM tblCourseLicensing WHERE CourseLicensingID = @CourseLicensingID";

			SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, sqlDelete, sqlParams);
		}


		public static int GetUsage(int courseLicensingID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@CourseLicensingID", courseLicensingID) } ;

			string sqlCount = @"SELECT COUNT(*) AS Count 
								FROM tblCourseLicensingUser 
								WHERE tblCourseLicensingUser.CourseLicensingID = @CourseLicensingID ";

			int count = Int32.Parse(SqlHelper.ExecuteScalar(connectionString, CommandType.Text, sqlCount, sqlParams).ToString());
			return count;
			
		}

		public static int GetUsageArchived(int courseLicensingID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@CourseLicensingID", courseLicensingID) } ;

			string sqlCount = @"SELECT COUNT(*) AS Count 
								FROM tblCourseLicensingUser INNER JOIN tblUser ON tblCourseLicensingUser.UserID = tblUser.UserID 
								WHERE tblCourseLicensingUser.CourseLicensingID = @CourseLicensingID AND tblUser.Active = 0";

			int count = Int32.Parse(SqlHelper.ExecuteScalar(connectionString, CommandType.Text, sqlCount, sqlParams).ToString());
			return count;
		}


		//-- Base query for finding missing licenses and only for active users
		private static string sqlLicenseAudit = @"
					SELECT DISTINCT tblCourseLicensing.CourseLicensingID, vwUserModuleAccess.UserID, vwUserModuleAccess.CourseID, tblUser.Active, 
										tblCourseLicensingUser.CourseLicensingUserID
					FROM         tblCourseLicensing INNER JOIN
										vwUserModuleAccess ON tblCourseLicensing.CourseID = vwUserModuleAccess.CourseID AND 
										tblCourseLicensing.OrganisationID = vwUserModuleAccess.OrganisationID INNER JOIN
										tblUser ON vwUserModuleAccess.UserID = tblUser.UserID LEFT OUTER JOIN
										tblCourseLicensingUser ON tblUser.UserID = tblCourseLicensingUser.UserID AND 
										tblCourseLicensing.CourseLicensingID = tblCourseLicensingUser.CourseLicensingID
					WHERE tblCourseLicensing.DateStart <= GETUTCDATE() 
							AND tblCourseLicensing.DateEnd >= GETUTCDATE() 
							AND tblCourseLicensingUser.CourseLicensingID IS NULL 
							AND tblUser.Active = 1
					";

		//-- Checks if all courses for modules linked to the unit have licenses granted.
		public static void LicenseAuditByUnit(int unitID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@UnitID", unitID) } ;

			string sqlModuleAccess = sqlLicenseAudit + " AND vwUserModuleAccess.UnitID = @UnitID ";

			//-- Returns datatable of missing licenses.
			DataTable dtLicenseMissing = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlModuleAccess, sqlParams).Tables[0];

			foreach(DataRow dr in dtLicenseMissing.Rows)
			{
				int courseLicensingID = Int32.Parse(dr["CourseLicensingID"].ToString());
				int userID = Int32.Parse(dr["UserID"].ToString());

				AssignLicense(courseLicensingID, userID);
			}
	
		}

		//-- Checks if all courses for modulkes linked to the unit have licenses granted.
		public static void LicenseAuditByOrg(int organisationID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@OrganisationID", organisationID) } ;

			string sqlModuleAccess = sqlLicenseAudit + " AND vwUserModuleAccess.OrganisationID = @OrganisationID ";

			//-- Returns datatable of missing licenses.
			DataTable dtLicenseMissing = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlModuleAccess, sqlParams).Tables[0];

			foreach(DataRow dr in dtLicenseMissing.Rows)
			{
				int courseLicensingID = Int32.Parse(dr["CourseLicensingID"].ToString());
				int userID = Int32.Parse(dr["UserID"].ToString());

				AssignLicense(courseLicensingID, userID);
			}
	
		}

		//-- Checks if all courses for modulkes linked to the unit have licenses granted.
		public static void LicenseAudit(int userID, int unitID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@UserID", userID),  new SqlParameter("@UnitID", unitID) } ;

			string sqlModuleAccess = sqlLicenseAudit + " AND vwUserModuleAccess.UserID = @UserID AND vwUserModuleAccess.UnitID = @UnitID ";

			//-- Returns datatable of missing licenses.
			DataTable dtLicenseMissing = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlModuleAccess, sqlParams).Tables[0];

			foreach(DataRow dr in dtLicenseMissing.Rows)
			{
				int courseLicensingID = Int32.Parse(dr["CourseLicensingID"].ToString());

				AssignLicense(courseLicensingID, userID);
			}
	
		}


		public static void LicenseAuditByUserModule(int userID, int moduleID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@ModuleID", moduleID), new SqlParameter("@UserID", userID) } ;

			string sqlModuleAccess = sqlLicenseAudit + " AND vwUserModuleAccess.ModuleID = @ModuleID AND vwUserModuleAccess.UserID = @UserID ";

			//-- Returns datatable of missing licenses.
			DataTable dtLicenseMissing = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlModuleAccess, sqlParams).Tables[0];

			foreach(DataRow dr in dtLicenseMissing.Rows)
			{
				int courseLicensingID = Int32.Parse(dr["CourseLicensingID"].ToString());

				AssignLicense(courseLicensingID, userID);
			}
		}
		//-- Assigns user license
		private static void AssignLicense(int courseLicensingID, int userID)
		{
			string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

			SqlParameter[] sqlParams = new SqlParameter[]{ new SqlParameter("@CourseLicensingID", courseLicensingID),  new SqlParameter("@UserID", userID) } ;

			string sqlAssignLicense = @"
										IF NOT EXISTS(SELECT CourseLicensingID FROM tblCourseLicensingUser WHERE CourseLicensingID = @CourseLicensingID and UserID = @UserID)
											INSERT INTO tblCourseLicensingUser(CourseLicensingID, UserID) VALUES (@CourseLicensingID, @UserID)
										";

			SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlAssignLicense, sqlParams);
		}
		



		//-- License Exceed and Warn
		public static bool IsExceed(int courseLicensingID)
		{
			DataTable dt = GetPeriod(courseLicensingID);

			bool exceeded = false;
			if (dt != null && dt.Rows.Count > 0)
			{
				int licenseNumber = Int32.Parse(dt.Rows[0]["LicenseNumber"].ToString());
				int licensesUsed = BusinessServices.CourseLicensing.GetUsage(courseLicensingID);
					
				exceeded = (licensesUsed > licenseNumber);
			}

			return exceeded;

		}

		public static bool IsWarn(int courseLicensingID)
		{
			DataTable dt = GetPeriod(courseLicensingID);

			bool warning = false;
			if (dt != null && dt.Rows.Count > 0)
			{
				int licenseWarnNumber = Int32.Parse(dt.Rows[0]["LicenseWarnNumber"].ToString());
				int licensesUsed = BusinessServices.CourseLicensing.GetUsage(courseLicensingID);
				// bool expiryWarnEmail = (bool)dt.Rows[0]["ExpiryWarnEmail"];

				DateTime dateWarn = DateTime.Parse("1/1/1900");
				if (dt.Rows[0]["DateWarn"] != System.DBNull.Value)
					dateWarn = (DateTime)dt.Rows[0]["DateWarn"];

				warning = ((licensesUsed >= licenseWarnNumber && licenseWarnNumber > 0) 
					|| 
					(
						dateWarn.CompareTo(DateTime.Parse("1/1/1900")) > 0
						&& (dateWarn.CompareTo(DateTime.Today) <= 0)
					));
			}

			return warning;
		}
	}
}
