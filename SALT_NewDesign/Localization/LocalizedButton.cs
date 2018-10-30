using System.Web.UI;
using System.Web.UI.WebControls;

namespace Localization
{
	 public class LocalizedButton : Button, ILocalized
	 {
			#region Fields and Properties
			private string key;
			private bool colon = false;
			public string Key
			{
				 get { return key; }
				 set { key = value; }
			}
			public bool Colon
			{
				 get { return colon; }
				 set { colon = value; }
			}
			#endregion

			protected override void Render(HtmlTextWriter writer)
			{
				string value = string.Empty;
				if (key != null)
					value = ResourceManager.GetString(key);
				else
					value = ResourceManager.GetString(base.ID);

				if (colon)
					value += ResourceManager.Colon;
	
				string buttonValue = value;

				//-- Simulates min-width on buttons. Ie doesn't support min-width css :(
				if (buttonValue.Length <= 10) 
				{
					int fillFactor = (10 - buttonValue.Length);

					System.Text.StringBuilder sb = new System.Text.StringBuilder();

					for (int counter = 0; counter < fillFactor; counter++)
						sb.Append(" ");

					string fillString = sb.ToString();
					buttonValue = fillString + buttonValue + fillString;
				}
				base.Text = LocalizedUtility.ReplaceParameters(Controls, buttonValue);
				base.Render(writer);
			}
	 }
}