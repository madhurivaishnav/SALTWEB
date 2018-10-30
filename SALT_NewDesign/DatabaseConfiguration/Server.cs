using System;
using System.Runtime.InteropServices;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
	#region Server Type Enumeration
    /// <summary>
    /// Server Type Enumeration
    /// </summary> 
	public enum ServerTypeEnum : uint
	{
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
		None = 0,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        ALL = 0xFFFFFFFF,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        WORKSTATION = 0x00000001,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        SERVER = 0x00000002,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        SQLSERVER = 0x00000004,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DOMAIN_CTRL = 0x00000008,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DOMAIN_BAKCTRL = 0x00000010,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        TIME_SOURCE = 0x00000020,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        AFP = 0x00000040,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        NOVELL = 0x00000080,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DOMAIN_MEMBER = 0x00000100,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        PRINTQ_SERVER = 0x00000200,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DIALIN_SERVER = 0x00000400,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        XENIX_SERVER = 0x00000800,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        NT = 0x00001000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        WFW = 0x00002000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        SERVER_MFPN = 0x00004000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        SERVER_NT = 0x00008000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        POTENTIAL_BROWSER = 0x00010000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        BACKUP_BROWSER = 0x00020000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        MASTER_BROWSER = 0x00040000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DOMAIN_MASTER = 0x00080000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        SERVER_OSF = 0x00100000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        SERVER_VMS = 0x00200000,
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        WINDOWS = 0x00400000, /* Windows95 and above */
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DFS = 0x00800000, /* Root of a DFS tree */
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        CLUSTER_NT = 0x01000000, /* NT Cluster */
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DCE = 0x10000000, /* IBM DSS (Directory and Security Services) or equivalent */
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        ALTERNATE_XPORT = 0x20000000, /* return list for alternate transport */
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        LOCAL_LIST_ONLY = 0x40000000, /* Return local list only */
        /// <summary>
        /// ServerTypeEnum
        /// </summary>
        DOMAIN_ENUM = 0x80000000
	}

	#endregion

	/// <summary>
	/// Summary description for Server.
	/// </summary>
	public abstract class ServerList
	{
		#region Win32 API Struct and Methods
		[System.Runtime.InteropServices.StructLayoutAttribute(LayoutKind.Sequential, CharSet=CharSet.Auto)]
			private struct SERVER_INFO_101
		{
			public int dwPlatformID;
			public System.IntPtr lpszServerName;
			public int dwVersionMajor;
			public int dwVersionMinor;
			public int dwType;
			public int lpszComment;
		}

		[DllImport("kernel32.dll")]
		private static extern uint CopyMemory(
			[MarshalAs(UnmanagedType.AsAny)] object Destination,
			[MarshalAs(UnmanagedType.AsAny)] object Source,
			int Length);

		[DllImport("netapi32.dll")]
		unsafe private static extern uint NetServerEnum(
			[MarshalAs(UnmanagedType.LPWStr)] string ServerName,
			uint level,
			uint* bufptr,
			uint prefmaxlen,
			ref uint entriesread,
			ref uint totalentries,
			uint servertype,
			[MarshalAs(UnmanagedType.LPWStr)] string domain,
			uint resume_handle);
		#endregion

		#region Public Methods
        /// <summary>
        /// Gets the string array
        /// </summary>
        /// <param name="serverType">server type enumeration</param>
        /// <returns></returns>
		public static string[] Get(ServerTypeEnum serverType)
		{
			string[] servers;
			string serverName = null;
			string domain = null; 
			uint level = 101, prefmaxlen = 0xFFFFFFFF, entriesread = 0, totalentries = 0;
			uint resume_handle = 0;

			try
			{
				unsafe
				{
					//Get a pointer to the server info structure
					SERVER_INFO_101* si = null;
					SERVER_INFO_101* pTmp; //Temp pointer for use when looping through returned	(pointer) array
					
					//this api requires a pointer to a byte array...which is actually a pointer to an array
					//of SERVER_INFO_101 structures
					 //If the domain parameter is NULL, the primary domain is implied. 
					uint nRes = NetServerEnum(serverName, level, (uint *) &si, prefmaxlen, ref entriesread, ref totalentries, (uint)serverType, domain, resume_handle);
					servers = new string[entriesread];

					if (nRes == 0)
					{
						//Assign the temp pointer
						if ((pTmp = si) != null) 
						{
							//Loop through the entries
							for (int i = 0; i < entriesread; i++)
							{
								try
								{
									servers[i] = Marshal.PtrToStringAuto(pTmp->lpszServerName);
								}
								catch (Exception e)
								{
									string error = e.Message;
								}
								//Increment the pointer...essentially move to the next structure in	the array
								pTmp++;
							} 
						} 
					} 
				} 
			}
			catch (Exception /*e*/)
			{
				return null;
			}

			return servers;
		} 
		#endregion
	} 
}
