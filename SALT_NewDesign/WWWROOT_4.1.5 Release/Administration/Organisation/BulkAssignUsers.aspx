<%@ Page language="c#" Codebehind="BulkAssignUsers.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.BulkAssignUsers" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
  <head>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<script language="javascript">
		//This must be placed on each page where you want to use the client-side resource manager
		var ResourceManager = new RM();
		
		function RM()
		{
			this.list = new Array();
		};
		
		RM.prototype.AddString = function(key, value)
		{
			this.list[key] = value;
		};
		
		RM.prototype.GetString = function(key)
		{
			var result = this.list[key];  
			for (var i = 1; i < arguments.length; ++i)
			{
				result = result.replace("{" + (i-1) + "}", arguments[i]);
			}
			return result;
		};
		
		// this stuff is for the checkbox
		function Control_ClickCheckBox(controlName, checkBox, nodeID)
		{
			var selectedNodes = document.forms[0].item(controlName);
			if (checkBox.checked)
			{
				selectedNodes.value = Control_AddStrArray(nodeID, selectedNodes.value)
			}
			else
			{
				selectedNodes.value = Control_RemoveStrArray(nodeID, selectedNodes.value)
			}
		}

		/* dont think we need this here
		//String array functions
		//Check a string is in the comma delimited string array
		//Ex: alert(inStrArray("1","2,1"));		
		function Control_InStrArray(val, vals)
		{
			var valArray = vals.split(",");
			
			for(var i=0;i<valArray.length;i++)
			{
				if (valArray[i]==val)
					break;
			}
			if (i==valArray.length)
				return false;
			else
				return true;	
		} */

		//add a string to  the comma delimited string array
		//Ex: alert(addStrArray("1","2,1"));		
		function Control_AddStrArray(val, vals)
		{
			return (vals.length==0)?val:(vals+","+ val);	
		}


		//Remove a string from the comma delimited string array
		//Ex: alert(removeStrArray("1","2,1"));		
		function Control_RemoveStrArray(val, vals)
		{
			var valArray = vals.split(",");
			var newArray = new Array();
			
			for(var i=0, j=0;i<valArray.length;i++)
			{
				if (valArray[i]!=val)
					newArray[j++]=valArray[i];
			}
			
			return 	newArray.join(",");
		}
		
		</script>
		<script language="javascript" type="text/javascript">
		 <!--
		 function ConfirmAssign(oSrc, args)
			{
				args.IsValid = confirm(ResourceManager.GetString("ConfirmMessage"));
			}
			
			-->

		</script>
</head>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout" onload="try{document.frmBulkAssign.btnAssign.focus();}catch(ex){}">
		<form id="frmBulkAssign" method="post" runat="server">
			<table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr valign="top" align="center" width="100%">
					<td style="HEIGHT: 31px" valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr valign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Content -->
					 <td class="DataContainer"><Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Assign Users to Unit</Localized:Localizedlabel><br>
						<asp:label id="lblError" runat="server"></asp:label>
						<br>
						<Localized:Localizedcustomvalidator clientvalidationfunction="ConfirmAssign" runat="server" errormessage="You have chosen not to assign these users at this time."
							id="Customvalidator1"></Localized:Localizedcustomvalidator>
						<table width="95%" align="left" border="0">
							<asp:placeholder id="plhSelectUserUnit" runat="server">
        <TBODY>
        <tr>
          <td class="formLabel" valign="top" width="20%"><Localized:LocalizedLiteral id="litSelectUnit" runat="server"></Localized:LocalizedLiteral></td>
          <td width="98%">
                <cc1:treeview id="trvUnitsSelector" runat="server" nodetext="Unit" outputstyle="SingleSelection" systemimagespath="/General/Images/TreeView/"></cc1:treeview></td></tr>
                        <tr>
                        <td class="formLabel" valign="top"><Localized:LocalizedLiteral id="litUsers" runat="server"></Localized:LocalizedLiteral></td>
                        <td>
                                <Localized:Localizedcheckbox id="chkSelectAll" runat="server" text="Select All" autopostback="True" oncheckedchanged="chkSelectAll_CheckedChanged"></Localized:Localizedcheckbox>
                                <asp:datagrid id="dgrResults" runat="server" width="100%" autogeneratecolumns="False" allowpaging="True">
												<selecteditemstyle cssclass="tablerow2"></selecteditemstyle>
												<alternatingitemstyle cssclass="tablerow2"></alternatingitemstyle>
												<itemstyle cssclass="tablerow1"></itemstyle>
												<headerstyle cssclass="tablerowtop"></headerstyle>
												<columns>
													<asp:templatecolumn>
														<headerstyle></headerstyle>
														<itemstyle width="100px" verticalalign="Middle"></itemstyle>
														<itemtemplate>
															<Localized:Localizedcheckbox id="chkAddUser" runat="server" text="Add To Unit" enableviewstate="True"></Localized:Localizedcheckbox>
														</itemtemplate>
													</asp:templatecolumn>
													<asp:boundcolumn visible="False" datafield="UserID">
														<itemstyle width="100px"></itemstyle>
													</asp:boundcolumn>
													<asp:boundcolumn datafield="LastName" headertext="Last Name">
														<itemstyle width="100px"></itemstyle>
													</asp:boundcolumn>
													<asp:boundcolumn datafield="FirstName" headertext="First Name" dataformatstring="{0}">
														<itemstyle width="100px"></itemstyle>
													</asp:boundcolumn>
													<asp:boundcolumn datafield="DateUpdated" headertext="Last Updated" dataformatstring="{0:dd/MM/yyyy h:mm:ss tt}">
														<itemstyle width="240px"></itemstyle>
													</asp:boundcolumn>
												</columns>
												<pagerstyle visible="False"></pagerstyle>
											</asp:datagrid>
            <table id="tblPagination" width="100%" runat="server">
                                            <tr id="trPagination" runat="server">
                                                <td align="left"><Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;<asp:label id="lblPageCount" runat="server">3</asp:label>:
                                                    <asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
                                                    <Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                                </td>
                                                <td align="right"><Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                    <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></td>
                                            </tr></table></td></tr>
        <tr>
          <td>&nbsp;</td>
          <td>
<Localized:Localizedbutton id="btnAssign" runat="server" text="Assign Users" cssclass="AssignButton" onclick="btnAssign_Click"></Localized:Localizedbutton><br>
<asp:textbox id="txtUserIDs" style="DISPLAY: none" runat="server" width="500" autopostback="True" textmode="SingleLine"></asp:textbox>
<asp:textbox id="txtAllUserIDs" style="DISPLAY: none" runat="server" width="500" autopostback="True" textmode="SingleLine"></asp:textbox></td></tr>
							</asp:placeholder>
							<asp:placeholder id="plhResults" runat="server" visible="False">
        <tr>
          <td class="formLabel" colspan="2">
<asp:label id="lblStatus" runat="server"></asp:label></td></tr>
        <tr>
			<td></td>
          <td><a href="BulkAssignUsers.aspx"><Localized:LocalizedLiteral id="lnkReturnAssign" runat="server"></Localized:LocalizedLiteral></a></td></tr>
							</asp:placeholder>
															<tr>
															<td></td>
									<td>
									<a href="/Administration/AdministrationHome.aspx"><Localized:LocalizedLiteral id="lnkReturnAdmin" key="cmnReturn" runat="server"></Localized:LocalizedLiteral></a>
</td>
								</tr></table></TD></TR>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr></TBODY></TABLE>
		</form>
	</body>
</html>
