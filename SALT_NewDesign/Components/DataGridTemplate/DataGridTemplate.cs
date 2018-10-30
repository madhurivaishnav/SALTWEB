using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Bdw.Application.Salt.DataGridTemplate
{
	
	public class DataGridTemplate : ITemplate
	{
		ListItemType templateType;
		string columnName;
		string controlName;
   
		public DataGridTemplate(ListItemType type, string colname, string ctlname)
		{
			templateType = type;
			columnName = colname;
			controlName = ctlname;
		}

		public void InstantiateIn(System.Web.UI.Control container)
		{
			Literal lc = new Literal();
			TextBox txt = new TextBox();
			switch(templateType)
			{
				case ListItemType.Header:
					lc.Text = "<B>" + columnName + "</B>";
					container.Controls.Add(lc);
					break;
				case ListItemType.Item:
					switch(controlName)
					{
						case("literal"):
							lc.Text = @"<%# DataBinder.Eval(Container.DataItem, """ + columnName + @""") %>";
							container.Controls.Add(lc);
							break;
						case("text"):
							txt.Attributes.Add("text", @"<%# DataBinder.Eval(Container.DataItem, """ + columnName + @""") %>");
							txt.Width = Unit.Pixel(50);
							container.Controls.Add(txt);
							break;
					}
					break;
			}
		}

	}
}
