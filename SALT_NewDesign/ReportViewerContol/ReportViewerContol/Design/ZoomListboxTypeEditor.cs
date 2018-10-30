/*=====================================================================
  File:     ZoomListboxTypeEditor.cs

  Summary:  This class is an implementation of the ListboxTypeEditor abstract class
						for the zoom listbox.

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
	public class ZoomListboxTypeEditor : ListboxTypeEditor
	{
		/// <summary>
		/// Fill a ListBox with zoom values.
		/// </summary>
		/// <param name="pContext"></param>
		/// <param name="pProvider"></param>
		/// <param name="pListBox"></param>
		protected override void FillInList(ITypeDescriptorContext pContext, IServiceProvider pProvider, ListBox pListBox)
		{
			pListBox.Items.Add("10%");
			pListBox.Items.Add("25%");
			pListBox.Items.Add("50%");
			pListBox.Items.Add("75%");
			pListBox.Items.Add("100%");
			pListBox.Items.Add("150%");
			pListBox.Items.Add("200%");
			pListBox.Items.Add("500%");
			pListBox.BorderStyle = BorderStyle.None;
		}
	} 
}
