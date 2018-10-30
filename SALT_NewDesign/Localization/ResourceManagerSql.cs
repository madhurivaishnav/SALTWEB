using System;
using System.Collections;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Caching;
using System.Configuration;
using Microsoft.ApplicationBlocks.Data;

namespace Localization
{	
	/// <summary>
	/// The ResourceManagerSql is an implementation of the ResourceManager driven by SQL server
	/// </summary>
	public class ResourceManagerSql : ResourceManager
	{
		#region Fields and Properties
		private string connectionString;
		private int cacheDuration;
		#endregion

		#region Constructors
		public ResourceManagerSql(NameValueCollection parameters)
		{
			if (parameters == null || parameters["connectionString"] == null)
			{
				throw new ApplicationException("ResourceManagerSql requires connectionString attribute in configuraiton.");
			}
			string strEncPassword = ConfigurationSettings.AppSettings["ConnectionStringPassword"];
			string strDecPassword = HttpContext.Current.Application["password"].ToString();
			connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + strDecPassword + ";";
			//connectionString = parameters["connectionString"];

			//load the optional cacheDuration parameter, else we'll cache for 30 minutes
			if (parameters["cacheDuration"] != null)
			{
				cacheDuration = Convert.ToInt32(parameters["cacheDuration"]);
			}
			else
			{
				cacheDuration = 30;
			}
		}
		#endregion

		#region Provider API
		protected override string RetrieveString(string key)
		{
			NameValueCollection messages = GetResources();
			if (messages[key] == null)
			{
				messages[key] = string.Empty;
#if DEBUG
				//throw new ApplicationException("Resource value not found for key: " + key);
#endif
			}
			return messages[key];
		}
		protected override LocalizedImageData RetrieveImage(string key)
		{
			Hashtable imageData = GetImages();
			if (imageData[key] == null)
			{
				imageData[key] = new LocalizedImageData(0, 0, string.Empty);
#if DEBUG
				//throw new ApplicationException("Resource value not found for key: " + key);
#endif						
			}
			return (LocalizedImageData) imageData[key];
		}
		#endregion

		#region Private Methods
		private NameValueCollection GetResources()
		{
			string currentCulture = ResourceManager.CurrentCultureName;
			string defaultCulture = LocalizationConfiguration.GetConfig().DefaultCultureName;
			string userInterface = HttpContext.Current.Request.ServerVariables["URL"];
			
			bool languagePreviewMode = false;

			if (HttpContext.Current.Request.Cookies["LanguagePreviewMode"] != null)
				languagePreviewMode = (HttpContext.Current.Request.Cookies["LanguagePreviewMode"].Value.ToString() == "1");

			string cacheKey = string.Empty;
			NameValueCollection resources = new NameValueCollection();

			string sqlSelect = @"SELECT LangInterfaceName from tblLangInterface 
									WHERE LangInterfaceName = @LangInterfaceName OR LangInterfaceName LIKE 'GLOBAL.%'
								";

			SqlParameter[] sqlParams = { new SqlParameter("@LangInterfaceName", userInterface) };

			DataTable dtInterface = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];

			foreach(DataRow drInterface in dtInterface.Rows)
			{
				string interfaceToLoad = drInterface["LangInterfaceName"].ToString();
				cacheKey = "SQLLocalization:" + defaultCulture + ':' + currentCulture + ':' + interfaceToLoad + ":" + languagePreviewMode.ToString();
				NameValueCollection currentResource = (NameValueCollection) HttpRuntime.Cache[cacheKey];
				if (currentResource == null)
				{
					currentResource = LoadResources(defaultCulture, currentCulture, interfaceToLoad, languagePreviewMode);
					//-- Both committed and uncommited are cached here
					HttpRuntime.Cache.Insert(cacheKey, resources, null, DateTime.Now.AddMinutes(cacheDuration), Cache.NoSlidingExpiration);
				}

				foreach (string name in currentResource.AllKeys)
				{
					//-- Because we may have uncommitted values, the sql is sorted to load those up first, if a committed version comes along, to not load it.
					if (resources[name] == null)
					resources.Add(name, currentResource[name].ToString());
				}
			}
			return resources;
		}

		private NameValueCollection LoadResources(string defaultCulture, string currentCulture, string userInterface, bool languagePreviewMode)
		{
			string sqlSelect = @"SELECT     tblLangResource.LangResourceName, tblLangValue.LangEntryValue
									FROM         tblLang INNER JOIN
														tblLangValue ON tblLang.LangID = tblLangValue.LangID INNER JOIN
														tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID INNER JOIN
														tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID
									WHERE     (tblLang.LangCode = @CurrentCulture) AND (tblLangInterface.LangInterfaceName = @UserInterface)
								";

			if (!languagePreviewMode)
				sqlSelect += " AND (Active = 1)";

			sqlSelect += " ORDER BY Active";

			NameValueCollection resources = new NameValueCollection();
			try
			{
				SqlParameter[] sqlParams = {
											   new SqlParameter("@CurrentCulture", currentCulture), 
											   new SqlParameter("@UserInterface", userInterface)
										   };

				DataTable dtNameValue = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlSelect, sqlParams).Tables[0];
				foreach(DataRow dr in dtNameValue.Rows)
				{
					//-- Because we may have uncommitted values, the sql is sorted to load those up first, if a committed version comes along, to not load it.
					if (resources[dr["LangResourceName"].ToString()] == null)
					{
						string langValue = dr["LangEntryValue"].ToString();
						resources.Add(dr["LangResourceName"].ToString(), langValue);
					}
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}
			return resources;
		}
		private Hashtable GetImages()
		{
			string currentCulture = ResourceManager.CurrentCultureName;
			string defaultCulture = LocalizationConfiguration.GetConfig().DefaultCultureName;
			string cacheKey = "SQLLocalizationImages:" + defaultCulture + ':' + currentCulture;
			Hashtable resources = (Hashtable) HttpRuntime.Cache[cacheKey];
			if (resources == null)
			{
				resources = LoadImages(defaultCulture, currentCulture);
				HttpRuntime.Cache.Insert(cacheKey, resources, null, DateTime.Now.AddMinutes(cacheDuration), Cache.NoSlidingExpiration);
			}
			return resources;
		}
		private Hashtable LoadImages(string defaultCulture, string currentCulture)
		{
			SqlConnection connection = null;
			SqlCommand command = null;
			SqlDataReader reader = null;
			Hashtable resources = new Hashtable();
			try
			{
				connection = new SqlConnection(connectionString);
				command = new SqlCommand("LoadImages", connection);
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.Add("@DefaultCulture", SqlDbType.Char, 5).Value = defaultCulture;
				command.Parameters.Add("@CurrentCulture", SqlDbType.Char, 5).Value = currentCulture;
				connection.Open();
				reader = command.ExecuteReader(CommandBehavior.SingleResult);
				int nameOrdinal = reader.GetOrdinal("Name");
				int heightOrdinal = reader.GetOrdinal("Height");
				int widthOrdinal = reader.GetOrdinal("Width");
				int altOrdinal = reader.GetOrdinal("Alt");
				while (reader.Read())
				{
					LocalizedImageData data = new LocalizedImageData();
					data.Height = reader.GetInt32(heightOrdinal);
					data.Width = reader.GetInt32(widthOrdinal);
					data.Alt = reader.GetString(altOrdinal);
					resources.Add(reader.GetString(nameOrdinal), data);
				}
			}
			finally
			{
				if (connection != null)
				{
					connection.Dispose();
				}
				if (command != null)
				{
					command.Dispose();
				}
				if (reader != null && !reader.IsClosed)
				{
					reader.Close();
				}
			}
			return resources;
		}
		#endregion
	}
}