using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Net;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Drawing;
//using System.Xml.Linq;
using System.Collections.Generic;
using System.Linq;

using System.Runtime.Serialization;
using System.Net;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;


using System.Security.Principal;
using System.Web.Script.Serialization;

namespace Bdw.Application.Salt.Web
{
    public partial class SCORMPlayer : System.Web.UI.Page
    {
       

        protected void Page_Load(object sender, EventArgs e)
        {
            //string url = "https://adaptive.saltcompliance.com/api/v1/shc/learn.jsonp?doorId=dd5a3f37-36e8-44b8-8f79-95a0cb388177&scormPackageId=903dbfd2-39b3-412b-857c-07477f1aa8ae&secret=15yCNdluE8V8RE6u_BtY3QH8ji53&lmsUserId=1jkl18&callback=asda111";
            //string id = "", temp = "";


            //HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            //request.UseDefaultCredentials = true;
            //request.Proxy = WebProxy.GetDefaultProxy();
            //request.Credentials = new NetworkCredential("saltadmin", "Y0uG0tTh3M0v3s");
            //request.ContentType = "Accept: application/xml";
            //request.Proxy.Credentials = CredentialCache.DefaultCredentials;
            //request.Referer = "https://adaptive.saltcompliance.com/api/v1/welcome";
            //request.Headers.Add("Authorization", "5c2481f4-0617-4d4b-a929-b5c53888919c");
            //HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            //if (response.StatusCode == HttpStatusCode.OK)
            //{
            //    Stream receiveStream = response.GetResponseStream();

            //    // Pipes the stream to a higher level stream reader with the required encoding format.
            //    StreamReader readStream = new StreamReader(receiveStream, Encoding.UTF8);
            //    temp = readStream.ReadToEnd();

               

                


            }
        }

        //private string SendHttpRequest(string url, string method, object postData, string contentType)
        //{
        //    bool isPost = method.Equals("POST", StringComparison.CurrentCultureIgnoreCase);

        //    byte[] content = new ASCIIEncoding().GetBytes( "");

        //    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

        //    request.AllowAutoRedirect = true;
        //    request.Method = method;
        //    request.ContentType = contentType;
        //    request.ContentLength = postData == null ? 0 : content.Length;

        //    if (isPost && postData != null)
        //    {
        //        Stream reqStream = request.GetRequestStream();
        //        reqStream.Write(content, 0, content.Length);
        //    }

        //    HttpWebResponse response = null;

        //    //Get the response via request.GetResponse, but if that fails,
        //    //retrieve the response from the exception
        //    try
        //    {
        //        response = (HttpWebResponse)request.GetResponse();
        //    }
        //    catch (WebException ex)
        //    {
        //        response = (HttpWebResponse)ex.Response;
        //    }

        //    string result;

        //    using (StreamReader sr = new StreamReader(response.GetResponseStream()))
        //    {
        //        result = sr.ReadToEnd();
        //    }
        //    //statusCode = (int)response.StatusCode;

        //    response.Close();

        //    return result;
        //}

        //public bool AcceptAllCertifications(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certification, System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors)
        //{
        //    return true;
        //}
        //private string GetEncodedCredentials()
        //{
        //    string mergedCredentials = string.Format("{0}:{1}", "saltadmin", "Y0uG0tTh3M0v3s");
        //    byte[] byteCredentials = UTF8Encoding.UTF8.GetBytes(mergedCredentials);
        //    return Convert.ToBase64String(byteCredentials);
        //}

        //public void Upload(string token)
        //{
        //    string URL_Domain = "https://adaptive.saltcompliance.com/api/v1/";

        

        //    string Url = URL_Domain + "users/upload";


        //    HttpWebRequest request = WebRequest.Create(Url) as HttpWebRequest;
        //    request.Method = "POST";
        //    request.ContentType = " text/json";
        //    request.Headers.Add("Authorization", token);



        //    string data = "[{\"Id\":\"\",\"FirstName\":\"Ed\",\"LastName\":\"test\",\"Username\":\"testusername1\",\"EmailAddress\":\"test@test.com\",\"ActiveStatus\":0,\"ExternalId\":\"39\",\"CustomFields\":{},\"DepartmentId\": \"deb8238d-f0d6-40b6-a71d-6bc8ed9a983d\"}]";
        //    using (var streamWriter = new StreamWriter(request.GetRequestStream()))
        //    {
        //        streamWriter.Write(data);
        //        streamWriter.Flush();
        //        streamWriter.Close();
        //    }
        //    HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        //    if (response.StatusCode.ToString().ToLower() == "ok")
        //    {
        //        string contentType = response.ContentType;
        //        Stream content = response.GetResponseStream();
        //        if (content != null)
        //        {
        //            StreamReader contentReader = new StreamReader(content);
        //            Response.ContentType = contentType;
        //            Response.Write(contentReader.ReadToEnd());
        //        }
        //    }
        //    // Get response  
        //    HttpWebResponse myWebResponse = (HttpWebResponse)request.GetResponse();
        //    // Get the response stream  
        //    StreamReader reader = new StreamReader(myWebResponse.GetResponseStream());

        //    // Console application output  
        //    Console.WriteLine(reader.ReadToEnd());
        //    Console.ReadLine();

        //}
    //}
    #region Start
    interface ICustomPrincipal : IPrincipal
    {
        int UserId { get; set; }
        string FirstName { get; set; }
        string LastName { get; set; }
    }
    public class CustomPrincipal : ICustomPrincipal
    {
        public IIdentity Identity { get; private set; }
        public bool IsInRole(string role) { return false; }

        public CustomPrincipal(string email)
        {
            this.Identity = new GenericIdentity(email);
        }

        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
    public class CustomPrincipalSerializeModel
    {
        //public int UserId { get; set; }
        public string UseAccountWithEmail { get; set; }
        public string UseAccountWithAccountName { get; set; }
        public string SetEmailTo { get; set; }
        public string SetAccountNameTo { get; set; }
        public string SetDisplayNameTo { get; set; }
        public string SetPreferredLocaleTo { get; set; }
        public string SetPasswordTo { get; set; }
    }
    public class User1
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string AccessLevel { get; set; }
        public bool DisableMessages { get; set; }
        public bool Active { get; set; }
        public DateTime LastLogin { get; set; }
        public string LoginKey { get; set; }
        public bool IsCustomUsername { get; set; }
        public bool SkipFirstLogin { get; set; }
        public string TimeZone { get; set; }
    }
    public class CookieAwareWebClient : WebClient
    {
        public CookieAwareWebClient()
        {
            CookieContainer = new CookieContainer();
        }
        public CookieContainer CookieContainer { get; private set; }

        protected override WebRequest GetWebRequest(Uri address)
        {
            var request = (HttpWebRequest)base.GetWebRequest(address);
            request.CookieContainer = CookieContainer;
            return request;
        }
    }

    #endregion
}
