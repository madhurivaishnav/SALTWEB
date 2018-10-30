using System.Collections.Specialized;

namespace Localization
{
	/// <summary>
	/// Reprensents the necessary information to load a resource manager provider
	/// </summary>
	public class Provider
	{
		#region Fields and Properties
		private string type;
		private string name;
		private NameValueCollection parameters;

		/// <summary>
		/// The type string must be of format Namespace.ClassName, AssemblyName (see web.config for examples)
		/// </summary>
		/// <remarks>
		/// If your assembly is stored in the GAC, you must provider the full strong-name (publicKey, culture, version)
		/// </remarks>
		public string Type
		{
			get { return type; }
			set { type = value; }
		}

		public string Name
		{
			get { return name; }
			set { name = value; }
		}

		/// <summary>
		/// Any attribute in the web.config which isn't type or name will be added to this collection and passed
		/// to the constructor of the actual provider
		/// </summary>
		public NameValueCollection Parameters
		{
			get
			{
				if (parameters == null)
				{
					parameters = new NameValueCollection();
				}
				return parameters;
			}
		}
		#endregion


		#region Constructors
		public Provider()
		{}
		#endregion
	}
}