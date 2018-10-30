using System;
using System.Globalization;
using System.Threading;
using System.Web;

namespace Localization {
	 /// <summary>
	 /// Summary description for LocalizationHttpModule.
	 /// </summary>
	 public class LocalizationHttpModule : IHttpModule {
			public void Init(HttpApplication context) {
				 context.BeginRequest += new EventHandler(context_BeginRequest);
			}
			public void Dispose() {}
			private void context_BeginRequest(object sender, EventArgs e) {
				 HttpRequest request = ((HttpApplication) sender).Request;
				 HttpContext context = ((HttpApplication)sender).Context;
				 string applicationPath = request.ApplicationPath;
				 if(applicationPath == "/"){
						applicationPath = string.Empty;
				 }
				 string requestPath = request.Url.AbsolutePath.Substring(applicationPath.Length);
				 LoadCulture(ref requestPath);				
				 context.RewritePath(applicationPath + requestPath);
			}
			private void LoadCulture(ref string path) {
				 string[] pathParts = path.Trim('/').Split('/');
				 string defaultCulture = LocalizationConfiguration.GetConfig().DefaultCultureName;
				 if(pathParts.Length > 0 && pathParts[0].Length > 0) {
						try {
							 Thread.CurrentThread.CurrentCulture = new CultureInfo(pathParts[0]);
							 path = path.Remove(0, pathParts[0].Length + 1);
						}catch (Exception ex) {
							 if(!(ex is ArgumentNullException) && !(ex is ArgumentException)) {
									throw;
							 }							 
							 Thread.CurrentThread.CurrentCulture = new CultureInfo(defaultCulture);
						}
				 }else {
						Thread.CurrentThread.CurrentCulture = new CultureInfo(defaultCulture);
				 }
				 Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;
			}
	 }
}