//===============================================================================
//
//	Salt Business Service Layer
//
//	Bdw.Application.Salt.Data.TimeZone
//
//  Retrieves and updates TimeZone information
//
//===============================================================================
using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.Data;
using System.Configuration;
using System.Web;
using Localization;
using Microsoft.ApplicationBlocks.Data;
using System.Collections.ObjectModel;
using System.Globalization;

namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// Retrieves and updates timezone information.
	/// </summary>
	/// <remarks>
	/// Assumptions: None
	/// Notes: 
	/// Changes:
	/// </remarks>
	public class ESTimeZone : Bdw.Application.Salt.Data.DatabaseService
	{	
		/// <summary>
		/// Gets a list of TimeZones.
		/// </summary>
		/// <returns>Returns a DataTable with the details of all TimeZones in the SALT database.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Changes:
		/// </remarks>
		public DataTable GetTimeZoneList()
		{
			using(StoredProcedure sp = new StoredProcedure("prcTimeZone_GetList"))
			{
				return sp.ExecuteTable();
			}
		} 

		




		/// <summary>
		/// Updates the TimeZone list with new TimeZones from the registry of the WebServer
		/// </summary>
		/// <returns>.</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Changes:
		/// </remarks>
		public void AddNewTimeZones()
		{
            DateTimeFormatInfo dateFormats = CultureInfo.CurrentCulture.DateTimeFormat;
            ReadOnlyCollection<TimeZoneInfo> timeZones = TimeZoneInfo.GetSystemTimeZones();

			DataTable dtbTimeZone;  
			// Get a list of all existing TimeZones
			dtbTimeZone = GetTimeZoneList();
            int i = 0;
            bool notFound;
            foreach (TimeZoneInfo timeZone in timeZones)
            {
                i = 0;
                notFound = true;
                while ((i < dtbTimeZone.Rows.Count) && (notFound)) //check in tblTimeZone.Rows[] for it
                {
                    if (timeZone.StandardName == (string)dtbTimeZone.Rows[i]["WrittenName"]) notFound = false;
                    i++;
                }
                TimeSpan offsetFromUtc = timeZone.BaseUtcOffset;
                if (notFound)
                {
                    AddTimeZone(timeZone.StandardName, offsetFromUtc.Hours * 60 + offsetFromUtc.Minutes, timeZone.DisplayName);
                    if (timeZone.SupportsDaylightSavingTime)
                    {
                        TimeZoneInfo.AdjustmentRule[] adjustRules = timeZone.GetAdjustmentRules();
                        if (adjustRules.Length > 0)
                        {
                            bool error = false;
                            foreach (TimeZoneInfo.AdjustmentRule rule in adjustRules)
                            {
                                TimeZoneInfo.TransitionTime transTimeStart = rule.DaylightTransitionStart;
                                TimeZoneInfo.TransitionTime transTimeEnd = rule.DaylightTransitionEnd;
                                AddTimeZoneRule(timeZone.StandardName,
                                                rule.DaylightDelta.Hours * 60 + rule.DaylightDelta.Minutes,
                                                rule.DateStart.Year,
                                                rule.DateEnd.Year,
                                                transTimeStart.TimeOfDay.Hour * 60 + transTimeStart.TimeOfDay.Minute,
                                                (int)transTimeStart.DayOfWeek + 1,
                                                transTimeStart.Week,
                                                transTimeStart.Month,
                                                transTimeEnd.TimeOfDay.Hour * 60 + transTimeEnd.TimeOfDay.Minute,
                                                (int)transTimeEnd.DayOfWeek + 1,
                                                transTimeEnd.Week,
                                                transTimeEnd.Month,
                                                out error);
                            }
                        }
                    }
                }
            }

		}




        /// <summary>
        /// Adds a single TimeZone to the TimeZone list 
        /// </summary>
        /// <returns>.</returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Changes:
        /// </remarks>
        public void AddTimeZone(SqlString WrittenName, int offsetmins, SqlString FLB_Name)
        {
			using(StoredProcedure sp = new StoredProcedure("prcTimeZone_add",
                      StoredProcedure.CreateInputParam("@WrittenName", SqlDbType.NVarChar, 60, WrittenName),
                      StoredProcedure.CreateInputParam("@OffsetUTC", SqlDbType.Int, offsetmins),
                      StoredProcedure.CreateInputParam("@FLB_Name", SqlDbType.NVarChar, 60, FLB_Name) 
					  ))
			{
				sp.ExecuteNonQuery();


			}
        }


        public void AddTimeZoneRule(SqlString WrittenName, int offsetmins, int year_start, int year_end,

                                           int StartTimeOfDay, int StartDayOfWeek, int StartWeek, int StartMonth,
                                           int EndTimeOfDay, int EndDayOfWeek, int EndWeek, int EndMonth, out bool error                       
            
            )
        {
            error = false;

            SqlParameter prmError = StoredProcedure.CreateOutputParam("@Error", SqlDbType.Bit);
            prmError.Direction = ParameterDirection.Output;

            using (StoredProcedure sp = new StoredProcedure("prcTimeZoneRule_add",
                      StoredProcedure.CreateInputParam("@WrittenName", SqlDbType.NVarChar, 60, WrittenName),
                      StoredProcedure.CreateInputParam("@OffsetDaylight", SqlDbType.Int, offsetmins),
                      StoredProcedure.CreateInputParam("@year_start", SqlDbType.Int, year_start),
                      StoredProcedure.CreateInputParam("@year_end", SqlDbType.Int, year_end),
                      StoredProcedure.CreateInputParam("@StartTimeOfDay", SqlDbType.Int, StartTimeOfDay),
                      StoredProcedure.CreateInputParam("@day_start", SqlDbType.Int, StartDayOfWeek),
                      StoredProcedure.CreateInputParam("@week_start", SqlDbType.Int, StartWeek),
                      StoredProcedure.CreateInputParam("@StartMonth", SqlDbType.Int, StartMonth),
                      StoredProcedure.CreateInputParam("@EndTimeOfDay", SqlDbType.Int, EndTimeOfDay),
                      StoredProcedure.CreateInputParam("@EndDayOfWeek", SqlDbType.Int, EndDayOfWeek),
                      StoredProcedure.CreateInputParam("@EndWeek", SqlDbType.Int, EndWeek),
                      StoredProcedure.CreateInputParam("@EndMonth", SqlDbType.Int, EndMonth),
                      prmError
                      )
                  )
            {
                sp.ExecuteNonQuery();
                error = (bool)prmError.Value;
            }
        }


        public DataTable TimeZoneList()
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "select TimeZoneID, WrittenName from tblTimeZone where active=1 order by WrittenName";

            DataTable dtbTimeZone = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect).Tables[0];
            return dtbTimeZone;
        }


        public void UpdateTimeZoneRule(int ruleID, SqlString WrittenName, int offsetmins, int year_start, int year_end,

                                                   int StartTimeOfDay, int StartDayOfWeek, int StartWeek, int StartMonth,
                                                   int EndTimeOfDay, int EndDayOfWeek, int EndWeek, int EndMonth, out bool error

                    )
        {
            error = false;

            SqlParameter prmError = StoredProcedure.CreateOutputParam("@Error", SqlDbType.Bit);
            prmError.Direction = ParameterDirection.Output;

            using (StoredProcedure sp = new StoredProcedure("prcTimeZoneRule_update",
                    StoredProcedure.CreateInputParam("@RuleID", SqlDbType.Int, ruleID),
                    StoredProcedure.CreateInputParam("@WrittenName", SqlDbType.NVarChar, 60, WrittenName),
                    StoredProcedure.CreateInputParam("@OffsetDaylight", SqlDbType.Int, offsetmins),
                    StoredProcedure.CreateInputParam("@year_start", SqlDbType.Int, year_start),
                    StoredProcedure.CreateInputParam("@year_end", SqlDbType.Int, year_end),
                    StoredProcedure.CreateInputParam("@StartTimeOfDay", SqlDbType.Int, StartTimeOfDay),
                    StoredProcedure.CreateInputParam("@day_start", SqlDbType.Int, StartDayOfWeek),
                    StoredProcedure.CreateInputParam("@week_start", SqlDbType.Int, StartWeek),
                    StoredProcedure.CreateInputParam("@StartMonth", SqlDbType.Int, StartMonth),
                    StoredProcedure.CreateInputParam("@EndTimeOfDay", SqlDbType.Int, EndTimeOfDay),
                    StoredProcedure.CreateInputParam("@EndDayOfWeek", SqlDbType.Int, EndDayOfWeek),
                    StoredProcedure.CreateInputParam("@EndWeek", SqlDbType.Int, EndWeek),
                    StoredProcedure.CreateInputParam("@EndMonth", SqlDbType.Int, EndMonth),
                    prmError
                    )
                )
            {
                sp.ExecuteNonQuery();
                error = (bool) prmError.Value;

            }
        } 


	}
} 



