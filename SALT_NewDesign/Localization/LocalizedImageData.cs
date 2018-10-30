namespace Localization
{
	/// <summary>
	/// Represents the data necessary to displaying a localized image
	/// </summary>
	public class LocalizedImageData
	{
		#region Fields and Properties
		private int width;
		private int height;
		private string alt;
		public int Width
		{
			get { return width; }
			set { width = value; }
		}
		public int Height
		{
			get { return height; }
			set { height = value; }
		}
		public string Alt
		{
			get { return alt; }
			set { alt = value; }
		}
		#endregion 

		#region Constructors
		public LocalizedImageData()
		{
		}
		public LocalizedImageData(int width, int height, string alt)
		{
			this.width = width;
			this.height = height;
			this.alt = alt;
		}
		#endregion 
	}
}