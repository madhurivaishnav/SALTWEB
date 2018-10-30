/*=====================================================================
  File:     UITypeListboxEditor.cs

  Summary:  This class is an abstract class for a Listbox UITypeEditor.

---------------------------------------------------------------------
  This file is part of Microsoft SQL Server Code Samples.
  
  Copyright (C) Microsoft Corporation.  All rights reserved.

 This source code is intended only as a supplement to Microsoft
 Development Tools and/or on-line documentation.  See these other
 materials for detailed information regarding Microsoft code samples.

 THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
 KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
 PARTICULAR PURPOSE.
=====================================================================*/

using System;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Design;
using System.Windows.Forms;
using System.Windows.Forms.ComponentModel;
using System.Windows.Forms.Design;
using System.Collections;

namespace Bdw.SqlServer.Reporting.WebControls.Design
{
	public abstract class ListboxTypeEditor : UITypeEditor
	{
		#region Private Member Variables
		private IWindowsFormsEditorService _formEditorService = null;
		#endregion
		
		protected abstract void FillInList(ITypeDescriptorContext context, IServiceProvider provider, ListBox listBox);

		/// <summary>
		/// Create a drop down list box.
		/// </summary>
		/// <param name="context"></param>
		/// <returns></returns>
		public override UITypeEditorEditStyle GetEditStyle(ITypeDescriptorContext context)
		{
			if (context != null && context.Instance != null) 
			{
				return UITypeEditorEditStyle.DropDown;
			}
			return base.GetEditStyle(context);
		}
		
		/// <summary>
		/// Create the ListBox control for the property grid.
		/// </summary>
		/// <param name="context"></param>
		/// <param name="provider"></param>
		/// <param name="newValue"></param>
		/// <returns></returns>
		public override object EditValue(ITypeDescriptorContext context, IServiceProvider provider, object newValue)
		{
			if (context != null
				&& context.Instance != null
				&& provider != null) 
				try
				{
					// get the editor service
					this._formEditorService = (IWindowsFormsEditorService)
						provider.GetService(typeof(IWindowsFormsEditorService));

					// create the control for the UI
					ListBox listBox = new ListBox();
					listBox.Click += new EventHandler(List_Click);
            
					// modify the control properties
					FillInList(context, provider, listBox);

					// set the list selection
					listBox.SelectedItem = newValue;
         
					// editor service renders control and manages control events
					this._formEditorService.DropDownControl(listBox);
   
					// return the updated newValue
					return listBox.SelectedItem;
				} 
				finally
				{
					this._formEditorService = null;
				}
			else
				return newValue;

		} 
		/// <summary>
		/// Handle click event.
		/// </summary>
		/// <param name="pSender"></param>
		/// <param name="pArgs"></param>
		protected void List_Click(object sender, EventArgs args)
		{
			this._formEditorService.CloseDropDown();
		} 
		
		
	}
}
