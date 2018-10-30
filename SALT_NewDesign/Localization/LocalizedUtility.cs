using System.Text;
using System.Web.UI;

namespace Localization {
	 public sealed class LocalizedUtility {
			private LocalizedUtility() {}
			public static string ReplaceParameters(ControlCollection controls, string text) {
				 if(controls == null || controls.Count == 0){
						return text;
				 }
				 StringBuilder sb = new StringBuilder(text);
				 for (int i = 0; i < controls.Count; i++){
						Parameter parameter = controls[i] as Parameter;						
						if(parameter != null){
							 string key = parameter.Key;
							 string value = parameter.Value;
							 sb.Replace('{' + key.ToUpper() + '}', value);
						}
				 }
				 return sb.ToString();
			}
	 }
}
