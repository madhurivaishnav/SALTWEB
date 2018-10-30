using System;
using System.Xml;

namespace Bdw.Application.Salt.Deployment.DatabaseConfiguration
{
	/// <summary>
	/// Summary description for ConfigureWebConfig.
	/// </summary>
	internal class ConfigureWebConfig
	{
		internal static void WebConfigConnectionString(string webConfigLocation, 
												string connKey, string connValue, 
												string pwdKey, string pwdValue)
		{
			// Load Web.Config
			XmlDocument configXmlDocument = new XmlDocument();
            
			configXmlDocument.Load(webConfigLocation);

			// Loop through all application settings until the correct one is found
			foreach (XmlNode node in configXmlDocument["configuration"]["appSettings"])
			{
				if (node.Name=="add")
				{
					if (node.Attributes.GetNamedItem("key").Value.ToLower() == connKey.ToLower())
					{
						// Change the value of the connection string
						node.Attributes["value"].Value = connValue.Replace("\"","");
					}
                    
					if (node.Attributes.GetNamedItem("key").Value.ToLower() == pwdKey.ToLower())
					{
						// Change the value of the connection string password
						node.Attributes["value"].Value = pwdValue.Replace("\"","");
					}
				}
			}
			configXmlDocument.Save(webConfigLocation);
		}
	}
}
