using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace Localization
{
	 /// <summary>
	 /// Summary description for LocalizedHtmlImage.
	 /// </summary>
	 public class LocalizedHtmlImage : HtmlImage, ILocalized
	 {
			#region fields and properties
			private const string imageUrlFormat = "{0}/{1}/{2}";
			private string key;
			private bool colon = false;
			public bool Colon
			{
				 get { return colon; }
				 set { colon = value; }
			}
			public string Key
			{
				 get { return key; }
				 set { key = value; }
			}
			#endregion

			protected override void Render(HtmlTextWriter writer)
			{
				 LocalizedImageData data = ResourceManager.GetImage(key);
				 if (data != null)
				 {
						base.Src = string.Format(imageUrlFormat, LocalizationConfiguration.GetConfig().ImagePath, ResourceManager.CurrentCultureName, base.Src);
						base.Width = data.Width;
						base.Height = data.Height;
						base.Alt = data.Alt;
				 }
				 if (colon)
				 {
						base.Alt += ResourceManager.Colon;
				 }
				 base.Render(writer);
			}
	 }
}