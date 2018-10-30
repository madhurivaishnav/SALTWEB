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
    public class Event : Bdw.Application.Salt.Data.DatabaseService
    {
        #region Variable
        private int eventID = 0;
        public int EventID
        {
            get { return eventID; }
            set { eventID = value; }
        }
        private int profileID = 0;
        public int ProfileID
        {
            get { return profileID; }
            set { profileID = value; }
        }
        private int eventPeriodID = 0;
        public int EventPeriodID
        {
            get { return eventPeriodID; }
            set { eventPeriodID = value; }
        }

        private string eventName = String.Empty;
        public string EventName
        {
            get { return eventName; }
            set { eventName = value; }
        }
        private string eventItem = String.Empty;
        public string EventItem
        {
            get { return eventItem; }
            set { eventItem = value; }
        }




        private int organisationID = 0;
        public int OrganisationID
        {
            get { return organisationID; }
            set { organisationID = value; }
        }

		private int userID = 0;
        public int UserID
        {
            get { return userID; }
            set { userID = value; }
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

        private double points = 0.0;
        public double Points
        {
            get { return points; }
            set { points = value; }
        }

        private string endOfPeriodAction = "1";
        public string EndOfPeriodAction
        {
            get { return endOfPeriodAction; }
            set { endOfPeriodAction = value; }
        }

        private int monthIncrement = 0;
        public int MonthIncrement
        {
            get { return monthIncrement; }
            set { monthIncrement = value; }
        }

        private DateTime futureDateStart = DateTime.Parse("1/1/1900");
        public DateTime FutureDateStart
        {
            get { return futureDateStart; }
            set { futureDateStart = value; }
        }

        private DateTime futureDateEnd = DateTime.Parse("1/1/1900");
        public DateTime FutureDateEnd
        {
            get { return futureDateEnd; }
            set { futureDateEnd = value; }
        }

        private double futurePoints = 0.0;
        public double FuturePoints
        {
            get { return futurePoints; }
            set { futurePoints = value; }
        }

        private string eventProvider;
        public string EventProvider
        {
            get { return eventProvider; }
            set { eventProvider = value; }
        }
        private int eventType = 0;
        public int EventType
        {
            get { return eventType; }
            set { eventType = value; }
        }
        private string eventLocation;
        public string EventLocation
        {
            get { return eventLocation; }
            set { eventLocation = value; }
        }

        private string fileName;
        public string FileName
        {
            get { return fileName; }
            set { fileName = value; }
        }
        private int fileID;
        public int FileID
        {
            get { return fileID; }
            set { fileID = value; }
        }
        private Boolean active;
        public Boolean Active
        {
            get { return active; }
            set { active = value; }
        }


        private DateTime dateCreated;
        public DateTime DateCreated
        {
            get { return dateCreated; }
            set { dateCreated = value; }
        }


        private DateTime uploadedDate;
        public DateTime UploadedDate
        {
            get { return uploadedDate; }
            set { uploadedDate = value; }
        }

        private Boolean registerPoint;
        public Boolean RegisterPoint
        {
            get { return registerPoint; }
            set { registerPoint = value; }
        }

        private Boolean allowUser;
        public Boolean AllowUser
        {
            get { return allowUser; }
            set { allowUser = value; }
        }
        private int eventTypeId;
        public int EventTypeId
        {
            get { return eventTypeId; }
            set { eventTypeId = value; }
        }

        private string eventTypeName;
        public string EventTypeName
        {
            get { return eventTypeName; }
            set { eventTypeName = value; }
        }
		private int userType;
        public int UserType
        {
            get { return userType; }
            set { userType = value; }
        }
        #endregion

        #region EventPeriod
        public DataTable GetEvent(int EventID, int EventPeriodID, int organisationID)
        {
            using (StoredProcedure spGetProfile = new StoredProcedure("prcEvent_Get",
                      StoredProcedure.CreateInputParam("@EventID", SqlDbType.Int, EventID),
                      StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, EventPeriodID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID)
                      ))
            {
                DataTable dtGetProfile = spGetProfile.ExecuteTable();
                return dtGetProfile;
            }
        }
        public DataTable CheckEventName(string ProfileName, int OrganisationID, int ProfileID, int EventPeriodID)
        {
            using (StoredProcedure spCheckProfileName = new StoredProcedure("prcEvent_CheckEventName",
                      StoredProcedure.CreateInputParam("@EventName", SqlDbType.NVarChar, ProfileName),
                       StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
                        StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, EventPeriodID),
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
            {
                DataTable CheckProfileName = spCheckProfileName.ExecuteTable();
                return CheckProfileName;
            }
        }
		public DataTable CheckUserEventName(string ProfileName, int OrganisationID, int ProfileID, int EventPeriodID, int UserID)
        {
            using (StoredProcedure spCheckProfileName = new StoredProcedure("prcEvent_CheckUserEventName",
                      StoredProcedure.CreateInputParam("@EventName", SqlDbType.NVarChar, ProfileName),
                       StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
                        StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, EventPeriodID),
                        StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, @UserID),
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
            {
                DataTable CheckProfileName = spCheckProfileName.ExecuteTable();
                return CheckProfileName;
            }
        }
		public DataTable CheckEventItem(string EventItem, int EventID, int EventPeriodID, int UserID)
        {
            using (StoredProcedure spCheckProfileName = new StoredProcedure("prcEvent_CheckEventItem",
                      StoredProcedure.CreateInputParam("@EventItem", SqlDbType.NVarChar, EventItem),
                       StoredProcedure.CreateInputParam("@EventID", SqlDbType.Int, EventID),
                        StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, EventPeriodID),
                      StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID)))
            {
                DataTable CheckProfileName = spCheckProfileName.ExecuteTable();
                return CheckProfileName;
            }
        }
       
        public int CheckPeriodOverlap(Event pro)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string ProfileIDSelect = @"select count(*) as countr FROM tblEventPeriod   inner join tblEvent on tblEvent.EventID = tblEventPeriod.EventID where tblEvent.EventID=@EventID  and Eventperiodid <> @eventePeriodID";
            ProfileIDSelect = ProfileIDSelect + @" and ((dbo.udfDaylightSavingTimeToUTC(@datestart,organisationID) between datestart  and  dateend) ";
            ProfileIDSelect = ProfileIDSelect + @" or (dbo.udfDaylightSavingTimeToUTC(@dateend,organisationID) between datestart and dateend) ";
            ProfileIDSelect = ProfileIDSelect + @" or (dbo.udfDaylightSavingTimeToUTC(@datestart,organisationID) <= datestart and dbo.udfDaylightSavingTimeToUTC(@dateend,organisationID) >= dateadd (d,1,dateend)))";

            SqlParameter[] sqlParams = new SqlParameter[] {new SqlParameter("@EventID", pro.EventID) 
															  ,new SqlParameter("@eventePeriodID", pro.EventPeriodID)
															  ,new SqlParameter("@datestart", pro.DateStart) 
															  ,new SqlParameter("@dateend", pro.DateEnd) };
            DataTable dt = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, ProfileIDSelect, sqlParams).Tables[0];
            return Int32.Parse(dt.Rows[0]["countr"].ToString());

        }

        public int AddEvent(Event pro)
        {
            int intProfileID = 0;
            using (StoredProcedure spAddProfile = new StoredProcedure("prcEvent_Add",
                      StoredProcedure.CreateInputParam("@EventName", SqlDbType.NVarChar, pro.EventName),
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, pro.OrganisationID),
                       StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, pro.ProfileID),
                      StoredProcedure.CreateInputParam("@DateStart", SqlDbType.DateTime, ((pro.DateStart == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateStart)),
                      StoredProcedure.CreateInputParam("@DateEnd", SqlDbType.DateTime, ((pro.DateEnd == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateEnd)),
                      StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, ((pro.Points == 0.0 ? (object)System.DBNull.Value : pro.Points))),
                      StoredProcedure.CreateInputParam("@EndOfPeriodAction", SqlDbType.Char, pro.EndOfPeriodAction),
                      StoredProcedure.CreateInputParam("@MonthIncrement", SqlDbType.Int, ((pro.MonthIncrement == 0 ? (object)System.DBNull.Value : pro.MonthIncrement))),
                      StoredProcedure.CreateInputParam("@FutureDateStart", SqlDbType.DateTime, ((pro.FutureDateStart == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.FutureDateStart)),
                      StoredProcedure.CreateInputParam("@FutureDateEnd", SqlDbType.DateTime, ((pro.FutureDateEnd == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.FutureDateEnd)),

                      StoredProcedure.CreateInputParam("@EventProvider", SqlDbType.NVarChar, pro.EventProvider),
                      StoredProcedure.CreateInputParam("@EventType", SqlDbType.Int, pro.EventType),
                      StoredProcedure.CreateInputParam("@EventLocation", SqlDbType.NVarChar, pro.EventLocation),
                       StoredProcedure.CreateInputParam("@RegisterPoint", SqlDbType.Bit, pro.RegisterPoint),
                        StoredProcedure.CreateInputParam("@AllowUser", SqlDbType.Bit, pro.AllowUser),
						StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int, pro.UserID),
				StoredProcedure.CreateInputParam("@EventItem", SqlDbType.NVarChar, pro.EventItem),
                         StoredProcedure.CreateInputParam("@UserType", SqlDbType.NVarChar, pro.UserType),


                      StoredProcedure.CreateInputParam("@FuturePoints", SqlDbType.Float, ((pro.FuturePoints == 0.0 ? (object)System.DBNull.Value : pro.FuturePoints)))))
            {
                spAddProfile.Parameters.Add("@EventID", SqlDbType.Int);
                spAddProfile.Parameters["@EventID"].Direction = ParameterDirection.Output;
                spAddProfile.Parameters.Add("@EventPeriodID", SqlDbType.Int);
                spAddProfile.Parameters["@EventPeriodID"].Direction = ParameterDirection.Output;
                spAddProfile.ExecuteNonQuery();
                intProfileID = Int32.Parse(spAddProfile.Parameters["@EventID"].Value.ToString());
                this.EventPeriodID = Int32.Parse(spAddProfile.Parameters["@EventPeriodID"].Value.ToString());
                return intProfileID;
            }
        }
        public void UpdateEvent(Event pro)
        {
            using (StoredProcedure spUpdateProfile = new StoredProcedure("prcEvent_Update",
                      StoredProcedure.CreateInputParam("@EventID", SqlDbType.Int, pro.EventID),
                      StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, pro.EventPeriodID),
                      StoredProcedure.CreateInputParam("@EventName", SqlDbType.NVarChar, pro.EventName),
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, pro.OrganisationID),
                      StoredProcedure.CreateInputParam("@DateStart", SqlDbType.DateTime, ((pro.DateStart == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateStart)),
                      StoredProcedure.CreateInputParam("@DateEnd", SqlDbType.DateTime, ((pro.DateEnd == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateEnd)),
                      StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, ((pro.Points == 0.0 ? (object)System.DBNull.Value : pro.Points))),
                      StoredProcedure.CreateInputParam("@EndOfPeriodAction", SqlDbType.Char, pro.EndOfPeriodAction),
                      StoredProcedure.CreateInputParam("@MonthIncrement", SqlDbType.Int, ((pro.MonthIncrement == 0 ? (object)System.DBNull.Value : pro.MonthIncrement))),
                      StoredProcedure.CreateInputParam("@FutureDateStart", SqlDbType.DateTime, ((pro.FutureDateStart == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.FutureDateStart)),
                      StoredProcedure.CreateInputParam("@FutureDateEnd", SqlDbType.DateTime, ((pro.FutureDateEnd == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.FutureDateEnd)),
                     StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, pro.ProfileID),
                      StoredProcedure.CreateInputParam("@EventProvider", SqlDbType.NVarChar, pro.EventProvider),
                      StoredProcedure.CreateInputParam("@EventType", SqlDbType.Int, pro.EventType),
                      StoredProcedure.CreateInputParam("@EventLocation", SqlDbType.NVarChar, pro.EventLocation),
                         StoredProcedure.CreateInputParam("@RegisterPoint", SqlDbType.Bit, pro.RegisterPoint),
                             StoredProcedure.CreateInputParam("@AllowUser", SqlDbType.Bit, pro.AllowUser),
                      StoredProcedure.CreateInputParam("@FuturePoints", SqlDbType.Float, ((pro.FuturePoints == 0.0 ? (object)System.DBNull.Value : pro.FuturePoints)))))
            {
                spUpdateProfile.ExecuteNonQuery();
            }

        }
        public void DeleteEventPeriod(int EventPeriodID)
        {
            using (StoredProcedure spDeleteEventPeriod = new StoredProcedure("prcEventPeriod_Delete",
                      StoredProcedure.CreateInputParam("@eventPeriodId", SqlDbType.Int, EventPeriodID)
                    ))
            {
                spDeleteEventPeriod.ExecuteNonQuery();
            }
        }

        public void InitialiseEventPeriodAccess(int OrganisationID, int ProfileID, int EventPeriodID)
        {
            using (StoredProcedure spInit = new StoredProcedure("prcEvent_InitialiseEventPeriodAccess",
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
                      StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
                      StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, EventPeriodID)))
            {
                spInit.ExecuteNonQuery();
            }

        }
        public void DeleteFuturePeriod(int EventID)
        {
            using (StoredProcedure spInit = new StoredProcedure("prcEventPeriod_DeleteFuturePeriod",

                      StoredProcedure.CreateInputParam("@EventID", SqlDbType.Int, EventID)))
            {
                spInit.ExecuteNonQuery();
            }
        }
        public DataTable GetOrganisationEvents(int OrganisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcEvent_OrganisationEvents",
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)))
            {
                return sp.ExecuteTable();
            }
        }

         public DataTable GetUserEventStatus(int UserID, int OrganisationID, int ProfileId)
        {

            using (StoredProcedure sp = new StoredProcedure("prcEvent_UserEvents",
                      StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
						StoredProcedure.CreateInputParam("@ProfileId", SqlDbType.Int, ProfileId),
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)
                      ))
            {
                DataTable dtUserEventStatus = sp.ExecuteTable();
                return dtUserEventStatus;
            }

        }

        #endregion

        #region Event File
        public int AddEventFile(Event pro)
        {
            int intFileId = 0;
            using (StoredProcedure spAddProfile = new StoredProcedure("prcEventFile_Add",
                      StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, pro.EventPeriodID),
                      StoredProcedure.CreateInputParam("@FileName", SqlDbType.NVarChar, pro.FileName)
                       ))
            {
                spAddProfile.Parameters.Add("@FileId", SqlDbType.Int);
                spAddProfile.Parameters["@FileId"].Direction = ParameterDirection.Output;

                spAddProfile.ExecuteNonQuery();
                intFileId = Int32.Parse(spAddProfile.Parameters["@FileId"].Value.ToString());

                return intFileId;
            }
        }
        public void UpdateEventFile(Event pro)
        {

            using (StoredProcedure spUpdateProfile = new StoredProcedure("prcEventFile_Update",
                     StoredProcedure.CreateInputParam("@FileID", SqlDbType.Int, pro.FileID),
                     StoredProcedure.CreateInputParam("@FileName", SqlDbType.NVarChar, pro.FileName)
                 ))
            {
                spUpdateProfile.ExecuteNonQuery();
            }
        }
        public void DeleteEventFile(Event pro)
        {

            using (StoredProcedure spUpdateProfile = new StoredProcedure("prcEventFile_Delete",
                     StoredProcedure.CreateInputParam("@FileID", SqlDbType.Int, pro.FileID)

                 ))
            {
                spUpdateProfile.ExecuteNonQuery();
            }
        }
        public DataTable GetFileName(int FileID)
        {
            using (StoredProcedure spGetPolicyFileName = new StoredProcedure("prcEventFile_GetFile",
                      StoredProcedure.CreateInputParam("@FileID", SqlDbType.Int, FileID)
                      ))
            {
                DataTable dtGetPolicyFileName = spGetPolicyFileName.ExecuteTable();

                return dtGetPolicyFileName;
            }
        }
        public DataTable GetEventFileName(int EventID, int EventPeriodID)
        {
            using (StoredProcedure spGetPolicyFileName = new StoredProcedure("prcEventFile_Get",
                      StoredProcedure.CreateInputParam("@EventPeriodId", SqlDbType.Int, EventPeriodID)
                      ))
            {
                DataTable dtGetPolicyFileName = spGetPolicyFileName.ExecuteTable();
                // string PolicyFileName = dtGetPolicyFileName.Rows[0]["FileName"].ToString();
                return dtGetPolicyFileName;
            }
        }
        public DataTable CheckFileName(int OrganisationID, string FileName)
        {
            using (StoredProcedure spCheckFile = new StoredProcedure("prcEvent_CheckFileName",
                StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
                StoredProcedure.CreateInputParam("@FileName", SqlDbType.NVarChar, 255, FileName)))
            {
                DataTable dtCheckFileName = spCheckFile.ExecuteTable();
                return dtCheckFileName;
            }
        }
        public void AcceptFile(int FileID, int UserID)
        {

            using (StoredProcedure spCheckFile = new StoredProcedure("prcEventFiles_Accepted",
              StoredProcedure.CreateInputParam("@FileID", SqlDbType.Int, FileID),
              StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID)))
            {
                spCheckFile.ExecuteNonQuery();
            }
        }


        public string GetLastAccepted(int UserID, int OrganisationID, int FileID)
        {
            using (StoredProcedure spPolicyUserSearch = new StoredProcedure("prcEventFile_GetUserLastAccepted",
                        StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
                       StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, OrganisationID),
                       StoredProcedure.CreateInputParam("@FileID", SqlDbType.Int, FileID)
                      ))
            {
                DataTable dtPolicyUserSearch = spPolicyUserSearch.ExecuteTable();
                return dtPolicyUserSearch.Rows[0]["dateaccepted"].ToString(); ;
            }
        }
        public bool CheckFileAccepted(int FileID, int UserID)
        {
            //string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            //string strSQL = @"select * from tblUserEventFilesAccepted ";
            //strSQL = strSQL + @"where UserID = " + UserID + " ";
            //strSQL = strSQL + @"and FileID = " + FileID + " ";
            //strSQL = strSQL + @" and Accepted = 1";

            using (StoredProcedure spGetProfile = new StoredProcedure("prcEventFile_CheckFileAccepted",

                      StoredProcedure.CreateInputParam("@FileID", SqlDbType.Int, FileID),
                       StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID)
                      ))
            {
                DataTable dtCheckPolicy = spGetProfile.ExecuteTable();

                if (dtCheckPolicy.Rows.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        #endregion

        #region EventType
        public DataTable GetEventType(int organisationID)
        {
            using (StoredProcedure spGetProfile = new StoredProcedure("prcEventType_Get",

                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, organisationID)
                      ))
            {
                DataTable dtGetProfile = spGetProfile.ExecuteTable();
                return dtGetProfile;
            }
        }

        public void AddEventType(string eventTypeName, int organisationID, int Active)
        {
            using (StoredProcedure spAddEventType = new StoredProcedure("prcEventType_Add",
                      StoredProcedure.CreateInputParam("@EventTypeName", SqlDbType.NVarChar, eventTypeName),
                          StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, organisationID),
                              StoredProcedure.CreateInputParam("@Active", SqlDbType.Int, Active)
                       ))
            {
                spAddEventType.ExecuteNonQuery();
            }
        }

        public DataTable GetEventType(string EventTypeName, int organisationID)
        {
            using (StoredProcedure sp = new StoredProcedure("prcEventTypeName_GetSelected",
                       StoredProcedure.CreateInputParam("@EventTypeName", SqlDbType.VarChar, 8000, EventTypeName),
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, 8000, organisationID)
                       ))
            {
                return sp.ExecuteTable();
            }

        }  

        #endregion            

        //public DataTable GetEventPoints(int OrganisationID, int EventPeriodID)
        //{
        //    using (StoredProcedure spGetProfilePolicyPoints = new StoredProcedure("prcEvent_GetEventFilePoints",
        //              StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
        //              StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, EventPeriodID)))
        //    {
        //        DataTable dtGetProfilePolicyPoints = spGetProfilePolicyPoints.ExecuteTable();
        //        return dtGetProfilePolicyPoints;
        //    }
        //}
        public void UpdateEventType(Event pro)
        {

            using (StoredProcedure spUpdateProfile = new StoredProcedure("prcEventType_Update",
                     StoredProcedure.CreateInputParam("@EventTypeId", SqlDbType.Int, pro.EventTypeId),
                     StoredProcedure.CreateInputParam("@EventTypeName", SqlDbType.NVarChar, pro.EventTypeName)
                 ))
            {
                spUpdateProfile.ExecuteNonQuery();
            }
        }
        public void DeleteEventType(Event pro)
        {

            using (StoredProcedure spUpdateProfile = new StoredProcedure("prcEventType_Delete",
                     StoredProcedure.CreateInputParam("@EventTypeId", SqlDbType.Int, pro.EventTypeId)

                 ))
            {
                spUpdateProfile.ExecuteNonQuery();
            }
        }
        #region UserEvent

        //public int AddUserEvent(Event pro)
        //{
        //    int intProfileID = 0;
        //    using (StoredProcedure spAddProfile = new StoredProcedure("prcEventUser_Add",
        //              StoredProcedure.CreateInputParam("@EventName", SqlDbType.NVarChar, pro.EventName),
        //              StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, pro.OrganisationID),
        //                 StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int, pro.UserID),
        //               StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, pro.ProfileID),
        //              StoredProcedure.CreateInputParam("@DateStart", SqlDbType.DateTime, ((pro.DateStart == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateStart)),
        //              StoredProcedure.CreateInputParam("@DateEnd", SqlDbType.DateTime, ((pro.DateEnd == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateEnd)),
        //              StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, ((pro.Points == 0.0 ? (object)System.DBNull.Value : pro.Points))),               
        //              StoredProcedure.CreateInputParam("@EventProvider", SqlDbType.NVarChar, pro.EventProvider),
        //              StoredProcedure.CreateInputParam("@EventType", SqlDbType.Int, pro.EventType),
        //              StoredProcedure.CreateInputParam("@EventLocation", SqlDbType.NVarChar, pro.EventLocation)))
        //    {
        //        spAddProfile.Parameters.Add("@EventID", SqlDbType.Int);
        //        spAddProfile.Parameters["@EventID"].Direction = ParameterDirection.Output;
        //        spAddProfile.Parameters.Add("@EventPeriodID", SqlDbType.Int);
        //        spAddProfile.Parameters["@EventPeriodID"].Direction = ParameterDirection.Output;
        //        spAddProfile.ExecuteNonQuery();
        //        intProfileID = Int32.Parse(spAddProfile.Parameters["@EventID"].Value.ToString());
        //        this.EventPeriodID = Int32.Parse(spAddProfile.Parameters["@EventPeriodID"].Value.ToString());
        //        return intProfileID;
        //    }
        //}
        public DataTable CheckUserFileName(int OrganisationID, string FileName)
        {
            using (StoredProcedure spCheckFile = new StoredProcedure("prcEvent_CheckFileName",
                StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID),
                StoredProcedure.CreateInputParam("@FileName", SqlDbType.NVarChar, 255, FileName)))
            {
                DataTable dtCheckFileName = spCheckFile.ExecuteTable();
                return dtCheckFileName;
            }
        }


        public int AddUserEvent(Event pro)
        {
            int intProfileID = 0;
            using (StoredProcedure spAddProfile = new StoredProcedure("prcEvent_AddUserEvent",
                  StoredProcedure.CreateInputParam("@EventID", SqlDbType.Int, pro.EventID),
                      StoredProcedure.CreateInputParam("@EventName", SqlDbType.NVarChar, pro.EventName),
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, pro.OrganisationID),
                       StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, pro.ProfileID),
                      StoredProcedure.CreateInputParam("@DateStart", SqlDbType.DateTime, ((pro.DateStart == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateStart)),
                      StoredProcedure.CreateInputParam("@DateEnd", SqlDbType.DateTime, ((pro.DateEnd == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateEnd)),
                      StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, ((pro.Points == 0.0 ? (object)System.DBNull.Value : pro.Points))),
                      StoredProcedure.CreateInputParam("@EndOfPeriodAction", SqlDbType.Char, pro.EndOfPeriodAction),
                      StoredProcedure.CreateInputParam("@EventProvider", SqlDbType.NVarChar, pro.EventProvider),
                      StoredProcedure.CreateInputParam("@EventType", SqlDbType.Int, pro.EventType),
                      StoredProcedure.CreateInputParam("@EventLocation", SqlDbType.NVarChar, pro.EventLocation),
                       StoredProcedure.CreateInputParam("@EventItem", SqlDbType.NVarChar, pro.EventItem),
						StoredProcedure.CreateInputParam("@UserType", SqlDbType.NVarChar, pro.UserType),

                      StoredProcedure.CreateInputParam("@UserId", SqlDbType.Int, pro.UserID)))
            {


                spAddProfile.Parameters.Add("@EventPeriodID", SqlDbType.Int);
                spAddProfile.Parameters["@EventPeriodID"].Direction = ParameterDirection.Output;
                spAddProfile.ExecuteNonQuery();
                intProfileID = Int32.Parse(spAddProfile.Parameters["@EventID"].Value.ToString());
                this.EventPeriodID = Int32.Parse(spAddProfile.Parameters["@EventPeriodID"].Value.ToString());
                return intProfileID;
            }
        }


        public void UpdateUserEvent(Event pro)
        {
            using (StoredProcedure spUpdateProfile = new StoredProcedure("prcEvent_UpdateUserEvent",
                      StoredProcedure.CreateInputParam("@EventID", SqlDbType.Int, pro.EventID),
                       StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, pro.EventPeriodID),
                      StoredProcedure.CreateInputParam("@EventName", SqlDbType.NVarChar, pro.EventName),
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, pro.OrganisationID),
                      StoredProcedure.CreateInputParam("@DateStart", SqlDbType.DateTime, ((pro.DateStart == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateStart)),
                      StoredProcedure.CreateInputParam("@DateEnd", SqlDbType.DateTime, ((pro.DateEnd == DateTime.Parse("1/1/1900")) ? (object)System.DBNull.Value : pro.DateEnd)),
                      StoredProcedure.CreateInputParam("@Points", SqlDbType.Float, ((pro.Points == 0.0 ? (object)System.DBNull.Value : pro.Points))),
                      StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, pro.ProfileID),
                      StoredProcedure.CreateInputParam("@EventProvider", SqlDbType.NVarChar, pro.EventProvider),
                      StoredProcedure.CreateInputParam("@EventType", SqlDbType.Int, pro.EventType),
                       StoredProcedure.CreateInputParam("@EventItem", SqlDbType.NVarChar, pro.EventItem),
                      StoredProcedure.CreateInputParam("@EventLocation", SqlDbType.NVarChar, pro.EventLocation)))
            {
                spUpdateProfile.ExecuteNonQuery();
            }

        }
        public DataTable CheckAvilableEventpoint(int EventID, int EventPeriodID, int organisationID, int UserID)
        {
            using (StoredProcedure spGetProfile = new StoredProcedure("prcEvent_CheckAvilablePoint",
                      StoredProcedure.CreateInputParam("@EventID", SqlDbType.Int, EventID),
                      StoredProcedure.CreateInputParam("@EventPeriodID", SqlDbType.Int, EventPeriodID),
                      StoredProcedure.CreateInputParam("@OrgID", SqlDbType.Int, 8000, organisationID),
                       StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, 8000, UserID)
                      ))
            {
                DataTable dtGetProfile = spGetProfile.ExecuteTable();
                return dtGetProfile;
            }
        }
        #endregion
        public DataSet GetUserEventReport(int UserID, int OrganisationID)
        {

            using (StoredProcedure sp = new StoredProcedure("prcEvent_UserReport",           
                      StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)
                      ))
            {
                return sp.ExecuteDataSet();
            }
        }
        public DataSet GetUserEventReportNew(int UserID, int OrganisationID)
        {

           
            using (StoredProcedure sp = new StoredProcedure("prcEvent_UserEventReport",
                      StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)
                      ))
            {
                return sp.ExecuteDataSet();
            }
        }
        public DataSet GetUserEventPointsEarned(int UserID, int OrganisationID  ,int ProfileID)
        {

            using (StoredProcedure sp = new StoredProcedure("prcEvent_UserPoints",
                      StoredProcedure.CreateInputParam("@UserID", SqlDbType.Int, UserID),
                      StoredProcedure.CreateInputParam("@ProfileID", SqlDbType.Int, ProfileID),
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)
                      ))
            {
                return sp.ExecuteDataSet();
            }
        }
       public DataTable GetProfileList(int OrganisationID)
        {
            //string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            //string strSQL = @"select ProfileID, ProfileName from tblProfile where OrganisationID=" + OrganisationID;
            //DataTable dtProfileList = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strSQL).Tables[0];
            //return dtProfileList;

            using (StoredProcedure sp = new StoredProcedure("prcEvent_GetProfileList",                      
                       StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, OrganisationID)
                      ))
            {
                DataTable dt = sp.ExecuteTable();
                return dt;
            }

        }
        
    }
}
