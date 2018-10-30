/*=====================================================================
  File:     FormatListboxTypeEditor.cs

  Summary:  This class is an implementation of the ListboxTypeEditor abstract class.

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
	public class FormatListboxTypeEditor : ListboxTypeEditor
	{
		/// <summary>
		/// Fill a ListBox with format types.
		/// </summary>
		/// <param name="pContext"></param>
		/// <param name="pProvider"></param>
		/// <param name="pListBox"></param>
		protected override void FillInList(ITypeDescriptorContext context, IServiceProvider provider, ListBox listBox)
		{
			listBox.Items.Add("HTML3.2");
			listBox.Items.Add("PDF");
			listBox.Items.Add("HTMLOWC");
			listBox.Items.Add("CSV");
			listBox.Items.Add("HTML4.0");
			listBox.Items.Add("MHTML");
			listBox.Items.Add("IMAGE");
			listBox.Items.Add("XML");
			listBox.BorderStyle = BorderStyle.None;

		}
	} 
}
