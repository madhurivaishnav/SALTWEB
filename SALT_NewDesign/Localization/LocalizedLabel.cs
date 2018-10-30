using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Localization {
	 /// <summary>
	 ///		 
	 /// </summary>
	 /// <remarks>
	 ///		 Since the literal doesn't allow us to have child controls, I had to change this to a lable
	 ///		 However, I did create a LocalizedNoParameterLiteral control that takes a literal, but you won't
	 ///		 be able to use it to pass parameters.
	 /// </remarks>
	 public class LocalizedLabel : Label, ILocalized {

			#region fields and properties
			private string key;
			private bool colon = false;
	 
			public bool Colon {
				 get { return colon; }
				 set { colon = value; }
			}

			public string Key {
				 get { return key; }
				 set { key = value; }
			}
			#endregion

			protected override void Render(HtmlTextWriter writer) 
			{
				string value = string.Empty;
				if (key != null)
					value = ResourceManager.GetString(key);
				else
					value = ResourceManager.GetString(base.ID);
				 if (colon){
						value += ResourceManager.Colon;
				 }
				 for (int i = 0; i < Controls.Count; i++){
						Parameter parameter = Controls[i] as Parameter;						
						if(parameter != null){
							 string k = parameter.Key;
							 string v = parameter.Value;
							 value = value.Replace('{' + k.ToUpper() + '}', v);
						}
				 }
				 base.Text = value;
				 base.Render(writer);
			}
	 }
}