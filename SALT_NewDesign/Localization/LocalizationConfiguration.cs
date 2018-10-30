using System;
using System.Configuration;
using System.Xml;

namespace Localization
{
	 /// <summary>
	 ///		 Strongly-typed configuration settings
	 /// </summary>
	 /// <remarks>
	 ///		 Loads the Localization section of the configuration file (web.config), 
	 ///		 and makes the settings globally accessible.
	 /// </remarks>
	 public class LocalizationConfiguration
	 {
			#region fields and properties
			private string defaultCultureName;
			private string imagePath;
			private Provider provider;
			/// <summary>
			///		 Default culture to use
			/// </summary>
			public string DefaultCultureName
			{
				 get { return defaultCultureName; }
			}
			/// <summary>
			///	 The path from the root of the application to the localized images
			/// </summary>
			public string ImagePath
			{
				 get { return imagePath; }
			}
			/// <summary>
			///	 The provider that's the actual implementation which will access our localized data
			/// </summary>
			public Provider Provider
			{
				 get { return provider; }
			}
			#endregion

			#region Public functions
			/// <summary>
			///	 Gets a PortalConfiguration object
			/// </summary>
			/// <returns>
			///		PortalConfiguration
			/// </returns>
			public static LocalizationConfiguration GetConfig()
			{
				 return (LocalizationConfiguration) ConfigurationSettings.GetConfig("Localization/Localization");
			}
			#endregion

			internal void LoadConfigValues(XmlNode node)
			{
				 XmlAttributeCollection attributeCollection = node.Attributes;
				 defaultCultureName = attributeCollection["defaultCulture"].Value;
				 imagePath = attributeCollection["imagePath"].Value;
				 string providerName = attributeCollection["providerName"].Value;

				 //strip out any trailing slash
				 if (imagePath.EndsWith("/"))
				 {
						imagePath = imagePath.Substring(0, imagePath.Length - 1);
				 }
				 foreach (XmlNode child in node.ChildNodes)
				 {
						switch (child.Name)
						{
						case "Provider":
							 LoadProvider(child, providerName);
							 if (provider == null)
							 {
									throw new ApplicationException(string.Format("Couldn't find localized Provider {0}", providerName));
							 }
							 break;
						}
				 }
			}
			private void LoadProvider(XmlNode node, string providerName)
			{
				 string xpath = string.Format("//add[@name='{0}']", providerName);
				 XmlNode providerNode = node.SelectSingleNode(xpath);
				 if (providerNode != null)
				 {
						provider = new Provider();
						provider.Name = providerNode.Attributes["name"].Value;
						provider.Type = providerNode.Attributes["type"].Value;
						foreach (XmlAttribute attribute in providerNode.Attributes)
						{
							 provider.Parameters.Add(attribute.Name, attribute.Value);
						}
				 }
			}
	 }

	 internal class LocalizationConfigurationHandler : IConfigurationSectionHandler
	 {
			public object Create(object parent, object context, XmlNode node)
			{
				 LocalizationConfiguration config = new LocalizationConfiguration();
				 config.LoadConfigValues(node);
				 return config;
			}
	 }
}