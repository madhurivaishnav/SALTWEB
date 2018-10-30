using System.Web.UI;
using System.Web.UI.WebControls;

namespace Localization {


	#region RangeValidator
	public class LocalizedRangeValidator : RangeValidator, ILocalized 
	{
		#region fields and properties
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
			{
				value += ResourceManager.Colon;
			}
			base.ErrorMessage = LocalizedUtility.ReplaceParameters(Controls, value);
			base.Render(writer);
		}
	}
	#endregion

	#region RequiredFieldValidator
	public class LocalizedRequiredFieldValidator : RequiredFieldValidator, ILocalized 
	{
		#region fields and properties
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
			{
				value += ResourceManager.Colon;
			}
			base.ErrorMessage = LocalizedUtility.ReplaceParameters(Controls, value);
			base.Render(writer);
		}
	}
	#endregion

	#region RegularExpressionValidator
	public class LocalizedRegularExpressionValidator : RegularExpressionValidator, ILocalized 
	{
		#region fields and properties
		private string key;
		private bool newLine = false;
		private bool colon = false;

		public bool NewLine 
		{
			get { return newLine; }
			set { newLine = value; }
		}

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
			{
				value += ResourceManager.Colon;
			}
			base.ErrorMessage = LocalizedUtility.ReplaceParameters(Controls, value);
			base.Render(writer);
		}
	}
	#endregion

	#region CustomValidator
	public class LocalizedCustomValidator : CustomValidator, ILocalized 
	{
		#region fields and properties
		private string key;
		private bool newLine = false;
		private bool colon = false;

		public bool NewLine 
		{
			get { return newLine; }
			set { newLine = value; }
		}

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
			{
				value += ResourceManager.Colon;
			}
			base.ErrorMessage = LocalizedUtility.ReplaceParameters(Controls, value);
			base.Render(writer);
		}
	}
	#endregion

	#region CompareValidator
	public class LocalizedCompareValidator : CompareValidator, ILocalized 
	{
		#region fields and properties
		private string key;
		private bool newLine = false;
		private bool colon = false;

		public bool NewLine 
		{
			get { return newLine; }
			set { newLine = value; }
		}

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
			{
				value += ResourceManager.Colon;
			}
			base.ErrorMessage = LocalizedUtility.ReplaceParameters(Controls, value);
			base.Render(writer);
		}
	}
	#endregion
}