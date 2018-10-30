/*=====================================================================
Generic Configuration Handler
		 
 This class get from the famous article published by Craig Andera's 
  or see this article 
  Creating a Flexible Configuration Section Handler
  http://www.15seconds.com/issue/040504.htm
  
  Another best option is the Microsoft Configuration application block.
  
  Usage:
  
  1. Put this in the configuration file (app.config or web.config)
  	<configSections>
 		<section name="ReportSettings" 
 			type="Bdw.SqlServer.Reporting.XmlSerializerSectionHandler, Bdw.SqlServer.Reporting"/>
 	</configSections>

	<ReportSettings type="Bdw.SqlServer.Reporting.ReportSettings, Bdw.SqlServer.Reporting">
			<ReportServer>http://localhost/reportserver</ReportServer>
			<SystemFolder>/reportviewerTest/reportviewer</SystemFolder>
			<CredentialUserName></CredentialUserName>
			<CredentialPassword></CredentialPassword>
	</ReportSettings>
 2. use it in applicaion
			ReportSettings settings = (ReportSettings)System.Configuration.ConfigurationSettings.GetConfig("ReportSettings");

=====================================================================*/
using System;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.XPath;


namespace Bdw.SqlServer.Reporting
{
	/// <summary>
	/// Summary description for XmlSerializerSectionHandler.
	/// </summary>
	public sealed class XmlSerializerSectionHandler : System.Configuration.IConfigurationSectionHandler
	{
		public XmlSerializerSectionHandler()
		{
		}
		/// <summary>
		/// Implement IConfigurationSectionHandler Create interface
		/// </summary>
		/// <remarks>
		/// Implemented by all configuration section handlers to parse the XML of the configuration section. 
		/// The returned object is added to the configuration collection and is accessed by System.Configuration.ConfigurationSettings.GetConfig(System.String).
		/// </remarks>
		/// <param name="parent"></param>
		/// <param name="configContext"></param>
		/// <param name="section"></param>
		/// <returns></returns>
		public object Create(object parent, object configContext, System.Xml.XmlNode section)
		{
			Object settings = null;

			if (section == null) { return settings; }

			XPathNavigator navigator = section.CreateNavigator();
			String typeName = (string)navigator.Evaluate("string(@type)");
			Type sectionType = Type.GetType(typeName);

			XmlSerializer xs = new XmlSerializer(sectionType);
			XmlNodeReader reader = new XmlNodeReader(section);

			try
			{
				settings = xs.Deserialize(reader);
			}
			catch(Exception ex)
			{
				System.Diagnostics.Debug.WriteLine(ex.Message);
			}
			finally
			{
				xs = null;
			}

			return settings;
		}
	}
}
