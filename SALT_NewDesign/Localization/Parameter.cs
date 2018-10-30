using System.Web.UI;

namespace Localization {
	 public class Parameter: Control {
			#region Fields and Properties
			private string key;
			private string value;

			public string Key {
				 get { return key; }
				 set { key = value; }
			}

			public string Value {
				 get { return this.value; }
				 set { this.value = value; }
			}
			#endregion


			public Parameter() {}
			public Parameter(string key, string value) {
				 this.key = key;
				 this.value = value;
			}
	 }
}