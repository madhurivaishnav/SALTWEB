using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace Localization {
	 public class LocalizedGenericControl : HtmlGenericControl, ILocalized {
			#region Fields and Properties
			private string key;
			private bool colon = false;

			public string Key {
				 get { return key; }
				 set { key = value; }
			}

			public bool Colon {
				 get { return colon; }
				 set { colon = value; }
			}
			#endregion


			protected override void Render(HtmlTextWriter writer) {
				string value = string.Empty;
				if (key != null)
					value = ResourceManager.GetString(key);
				else
					value = ResourceManager.GetString(base.ID);

				 if (colon){
						value += ResourceManager.Colon;
				 }
				 base.InnerText = LocalizedUtility.ReplaceParameters(Controls, value);
				 base.Render(writer);
			}
	 }
}