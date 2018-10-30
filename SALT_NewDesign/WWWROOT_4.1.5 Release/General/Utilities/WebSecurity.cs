using System;
using System.Collections;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Net;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.Web.Utilities
{
	/// <summary>
	/// This class is used to save and retrieve form authentication data via an authentication ticket, this ticket is saved as an encrypted cookie.
	/// </summary>
	internal abstract class WebSecurity
	{
		/// <summary>
		/// Get Authentication Data from Form authentication ticket, This ticket is saved as an encrypted cookie
		/// </summary>
		/// <returns></returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static string GetAuthData()
		{
			string strUserData;
            FormsIdentity objIdentity = null;
            FormsAuthenticationTicket objTicket = null;
			//1. Get authentication Ticket
            try
            {
                objIdentity = (FormsIdentity)HttpContext.Current.User.Identity;
            }
            catch
            {
                throw new ApplicationException("No User Identity stored in HttpContext?.");
            }
            try
            {
                objTicket = objIdentity.Ticket;
            }
            catch
            {
                throw new ApplicationException("No Ticket or invalid Ticket in HttpContext.Current.User.Identity.");
            }

			//2. Get the stored user-data
            try
            {
                strUserData = objTicket.UserData;
            }
            catch
            {
                throw new ApplicationException("No UserData in Ticket.");
            }


			return strUserData;
		}

		/// <summary>
		/// Save Form authentication ticket. This ticket is saved as an encrypted cookie.
		/// </summary>
		/// <returns></returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static void SetAuthData(string userName, string userData)
		{
			//1. Create authTicket
			FormsAuthenticationTicket objAuthTicket = new FormsAuthenticationTicket(
				1, //version
				userName, // Username
				System.DateTime.Now,  // issue time
				System.DateTime.Now.AddMinutes(600), // expires time minutes
				false, // don't persist cookie
				userData // user Data
				);

			//2. Create auth Cookie		
			HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName);

			//3. Encrypt Cookie
			authCookie.Value = FormsAuthentication.Encrypt(objAuthTicket);

			//4. Add auth cookie 
			HttpContext.Current.Response.Cookies.Add(authCookie);
		}

		/// <summary>
		/// Saves the selected organisation in the user context.
		/// This method is used by the Salt Administrator only.
		/// </summary>
		/// <param name="organisationID"> The new organisation ID to save in the authentication ticket.</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static void SelectOrganisation(int organisationID)
		{
			if(UserContext.UserData.UserType  == UserType.SaltAdmin)
			{
				//1. Set new user data with selected organisationID
				UserData objUserData = new UserData(UserType.SaltAdmin, organisationID,"",true);

				WebSecurity.SetAuthData(UserContext.UserID.ToString(), objUserData.ToString());

				//2. Save the user data in the current context
				UserContext.UserData = objUserData;
			}
		}
		
		/// <summary>
		/// Logged out the user
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static void SignOut()
		{
			FormsAuthentication.SignOut();
			HttpContext.Current.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
			HttpContext.Current.Response.End();
		}
		
		/// <summary>
		/// Check what the admin permission the login user has for this unit
		/// If a user don't have any permission, the system will automatically log out the user
		/// </summary>
		/// <param name="unitID"> ID of the unit to check to permissions for.</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static void CheckUnitAdministrator(int unitID)
		{	
			Unit objUnit = new Unit();
			string strPermission = objUnit.GetPermission(unitID, UserContext.UserID);
			if(strPermission == "")
			{
				WebSecurity.SignOut();
			}
		}

		/// <summary>
		/// Check what the admin permission the login user has for this user
		/// If a admin user don't have any permission, the system will automatically log out the user
		/// </summary>
		/// <param name="userID"> ID of the user to check to permissions for.</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 09/03/2004
		/// Changes:
		/// </remarks>
		public static void CheckUserAdministrator(int userID)
		{	
			User objUser = new User();
			string strPermission = objUser.GetPermission(userID, UserContext.UserID);
			if(strPermission == "")
			{
				WebSecurity.SignOut();
			}
		}

        /// <summary>
        /// Check whether the current user is a SALT Admin, if not the system will 
        /// automatically log out the user
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Gavin Buddis, 24/03/2004
        /// Changes:
        /// </remarks>
        public static void CheckSALTAdministrator()
        {	
            if (UserContext.UserData.UserType != UserType.SaltAdmin)
            {
                WebSecurity.SignOut();
            }
        }
	}
}