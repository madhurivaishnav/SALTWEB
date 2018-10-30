using System;
using System.IO;
using System.Xml;
using System.Reflection;
using System.Collections;
using System.Globalization;
using System.Configuration;
using System.Collections.Specialized;


namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
	/// <summary>
	/// This is the configuration handler for MigrationSettings section
	/// It must be defined in the App.Config under <configSections></configSections>
	/// </summary>
	public class MigrationSettingsSectionHandler : IConfigurationSectionHandler
	{
        /// <summary>
        /// Constructor
        /// </summary>
		public MigrationSettingsSectionHandler(){}
		/// <summary>
		/// Creates a new configuration handler and adds it to the section handler collection.
		/// </summary>
		/// <param name="parent">The configuration settings in a corresponding parent configuration section. </param>
		/// <param name="configContext">The virtual path for which the configuration section handler computes configuration values. Normally this parameter is reserved and is a null reference </param>
		/// <param name="section">The XmlNode that contains the configuration information to be handled. Provides direct access to the XML contents of the configuration section. </param>
		/// <returns></returns>
		public object Create(object parent, object configContext, System.Xml.XmlNode section)
		{
			MigrationSettings settings = new MigrationSettings();
			string ID;
			VersionSetting setting;


			foreach(XmlNode version in section.ChildNodes)
			{
				if (version.Name == "CurrentVersion")
				{
					ID = version.Attributes["ID"].Value.Trim();
					if (ID=="")
					{
						throw new ApplicationException("CurrentVersion ID can not be empty");
					}

					setting = new VersionSetting(ID);

					foreach(XmlNode step in version.ChildNodes)
					{
						if (step.Name == "Step")
						{		
							setting.AddStep(step.Attributes["Description"].Value,step.Attributes["Script"].Value);
						}
					}
					settings.AddVersion(ID,setting);
				}
			}
			return settings;
		}
	}
	/// <summary>
	/// A collection of Migration script settings for different version
	/// </summary>
	public class MigrationSettings
	{
		private Hashtable _Versions;
	
        /// <summary>
        /// Hashtable of settings
        /// </summary>
		public MigrationSettings()
		{
			_Versions = new Hashtable();
			
		}

        /// <summary>
        /// Adds a version
        /// </summary>
        /// <param name="ID"></param>
        /// <param name="version"></param>
		public void AddVersion(string ID, VersionSetting version)
		{
				this._Versions.Add(ID, version);
		}
        
        /// <summary>
        /// Gets a version
        /// </summary>
        /// <param name="ID">version to get</param>
        /// <returns>A version setting</returns>
		public VersionSetting GetVersion(string ID)
		{
			return (VersionSetting)this._Versions[ID];
		}
	}
	/// <summary>
	/// Script setting for a specific version
	/// </summary>
	public class VersionSetting
	{
		private string _ID;
		private NameValueCollection _Steps;

        /// <summary>
        /// returns the id
        /// </summary>
		public string ID
		{
			get
			{
				return this._ID;
			}
		}
        /// <summary>
        /// Returns the name vlaue collection of steps
        /// </summary>
		public NameValueCollection Steps
		{
			get
			{
				return this._Steps;
			}
		}


        /// <summary>
        /// Sets the version
        /// </summary>
        /// <param name="ID">ID of the version</param>
		public VersionSetting(string ID)
		{
			this._ID = ID;
			this._Steps = new NameValueCollection();
		}
        /// <summary>
        /// Adds a step to the procedure
        /// </summary>
        /// <param name="description">description</param>
        /// <param name="script">script</param>
		public void AddStep(string description, string script)
		{
			this._Steps.Add(description, script);
		}

	}
}
