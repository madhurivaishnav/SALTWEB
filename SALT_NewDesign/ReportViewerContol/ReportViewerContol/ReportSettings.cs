using System;
using System.Xml;
using System.Xml.Serialization;

namespace Bdw.SqlServer.Reporting
{
	/// <summary>
	/// Summary description for ReportSettings.
	/// </summary>
	[Serializable]
	public class ReportSettings
	{
		#region Private member variables

		private string _ReportServer;
		private string _ReportFolder;
		private string _SystemFolder;
		private string _CredentialDomain;
		private string _CredentialUserName;
		private string _CredentialPassword;
		private bool _SessionValidation;

		#endregion

		#region Constructors, destructors and initializers
		public ReportSettings()
		{
			_ReportServer="http://localhost/reportserver";
			_ReportFolder="";
			_SystemFolder="/reportviewer";
			_CredentialUserName="";
			 _SessionValidation=true;
		}
		#endregion

		#region Public properties

		//[XmlAttribute()]
		//[XmlAttribute(DataType="string", AttributeName="Name")]
		/// <summary>
		/// Gets or set reporting service server url such as http://localhost/reportserver
		/// </summary>
		public string ReportServer
		{
			get{ return _ReportServer;}
			set{ _ReportServer = value;}
		}

		/// <summary>
		/// Gets or set the report folder
		/// </summary>
		public string ReportFolder
		{
			get{ return _ReportFolder;}
			set{ _ReportFolder = value;}
		}

		
		/// <summary>
		/// Gets or sets the system folder that contains the navigation image, style sheets, and other supported files
		/// </summary>
		public string SystemFolder
		{
			get{ return _SystemFolder;}
			set{ _SystemFolder = value;}
		}

		/// <summary>
		/// The domain name of the credential that is used to access reporting service.
		/// If the Domain name is empty, the report viewer will use default credentials,
		/// by default, it is Network Services in windows 20003, ASPNET in windows 2000 
		/// </summary>
		public string CredentialDomain
		{
			get{ return this._CredentialDomain;}
			set{ _CredentialDomain = value;}
		}


		/// <summary>
		/// The user name of the credential that is used to access reporting service.
		/// If the user name is empty, the report viewer will use default credentials,
		/// by default, it is Network Services in windows 20003, ASPNET in windows 2000 
		/// </summary>
		public string CredentialUserName
		{
			get{ return _CredentialUserName;}
			set{ _CredentialUserName = value;}
		}

		/// <summary>
		/// The password of the credential
		/// </summary>
		public string CredentialPassword
		{
			get{ return _CredentialPassword;}
			set{ _CredentialPassword = value;}
		}

		/// <summary>
		/// Validate the session ID
		/// </summary>
		public bool SessionValidation
		{
			get{ return this._SessionValidation ;}
			set{ _SessionValidation = value;}
		}



		#endregion


	}
}
