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
//using System.Xml.Linq;

namespace Bdw.Application.Salt.Web
{
    public partial class SCROMPlayer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string URL_Domain = "https://adaptive.saltcompliance.com/api/v1";
            string Url = URL_Domain;
            HttpWebRequest request = WebRequest.Create(Url) as HttpWebRequest;
            request.Method = "POST";
            request.ContentType = "text";
            HttpWebResponse myWebResponse = (HttpWebResponse)request.GetResponse();
            // Get the response stream  
            StreamReader reader = new StreamReader(myWebResponse.GetResponseStream());

            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            var jsonObject = serializer.DeserializeObject(reader.ReadToEnd());

            //token = jsonObject.ToString();
        }
    }
}
