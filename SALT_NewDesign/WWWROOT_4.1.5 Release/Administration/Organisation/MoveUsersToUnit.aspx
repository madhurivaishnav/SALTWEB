<%@ Page language="c#" Codebehind="MoveUsersToUnit.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Users.MoveUsersToUnit" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title runat="server" id="pagTitle"></title>
    <style:style id="ucStyle" runat="server"></style:style>
    <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    
    <script language="javascript">
		// this stuff is for the checkbox in the grid
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
  </head>
  <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
	
    <form id="frmMoveUsers" method="post" runat="server">
				<table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr valign="top" align="center" width="100%">
					<td valign="top" align="center" width="100%" colspan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr valign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:Localizedlabel id="lblPageTitle" runat="server" cssclass="pageTitle">User Search</Localized:Localizedlabel><br>
						<Localized:Localizedlabel id="lblNoSubUnits" runat="server" visible="False">There are no units.</Localized:Localizedlabel>
						
							
						<table width="95%" align="left" border="0">
							<!-- Search Criteria -->
							<asp:placeholder id="plhCriteria" runat="server">
								
									<TR>
										<TD>
											<TABLE id="tblSearchCriteria" width="100%" align="left" border="0" runat="server">
												<TR>
													<TD class="formLabel" width="30%">
														<Localized:LocalizedLabel id="lblUnit" runat="server"></Localized:LocalizedLabel>
															
													</TD>
													<TD width="70%">
														<cc1:treeview id="trvUnitsSelector" runat="server" outputstyle="MultipleSelection" nodetext="Unit"
															systemimagespath="/General/Images/TreeView/"></cc1:treeview></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblFirstName" runat="server" key="cmnFirstName"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtFirstName" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblLastName" runat="server" key="cmnLastName"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtLastName" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblUserName" runat="server" key="cmnUserName"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:textbox id="txtUsername" runat="server" maxlength="100"></asp:textbox></TD>
												</TR>
												<TR>
													<TD class="formLabel">
														<Localized:LocalizedLabel id="lblShowInactive" runat="server"></Localized:LocalizedLabel></TD>
													<TD>
														<asp:checkbox id="chkInactiveUsers" runat="server" checked="False"></asp:checkbox></TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
													<TD align="left">
														<P>
															<Localized:Localizedbutton id="btnFind" runat="server" cssclass="findButton" text="Search" onclick="btnFind_Click"></Localized:Localizedbutton>&nbsp;
															<Localized:Localizedbutton id="btnReset" runat="server" cssclass="resetButton" text="Reset" onclick="btnReset_Click"></Localized:Localizedbutton></P>
													</TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
													<TD>
														<asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></TD>
												</TR>
												<TR>
													<TD>&nbsp;</TD>
													<TD><A href="/Administration/AdministrationHome.aspx">
															<Localized:LocalizedLiteral id="lnkReturn" runat="server" key="cmnReturn"></Localized:LocalizedLiteral></A></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
							</asp:placeholder>
							<tr>
								<td colspan="2">										
										<asp:label id="lblStatus" runat="server" />
										<br />
										<br />
										<asp:label id="lblError" runat="server" />
								</td>
							</tr>
							<asp:PlaceHolder ID="plhUserResults" runat="server" Visible="False">
							<tr>
								<td>
									<table>
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
											<asp:boundcolumn datafield="LastLogin" headertext="Last Login" dataformatstring="{0:dd/MM/yyyy h:mm:ss tt}">
												<itemstyle width="240px"></itemstyle>
											</asp:boundcolumn>
											<asp:boundcolumn datafield="Pathway" headertext="Unit Pathway">
												<itemstyle width="300px"></itemstyle>
											</asp:boundcolumn>
										</columns>
									<pagerstyle visible="False"></pagerstyle>
									</asp:datagrid>
									<table id="tblPagination" width="100%" runat="server">
                                        <tr id="trPagination" runat="server" >
                                            <td align="left">
												<Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;
												<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;
												<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf" />&nbsp;
												<asp:label id="lblPageCount" runat="server">3</asp:label>:
												<asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;
												<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;
												<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
												<Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral>
                                            </td>
                                            <td align="right">
												<Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
                                                <Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton>
                                            </td>
                                        </tr>
									</table>
									
									</td>
									</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								
								<td class="formlabel">
									<Localized:LocalizedLiteral id="litSelectUnit" runat="server"></Localized:LocalizedLiteral>
								</td>
							</tr>
							
							<tr>
								<td width="70%">
									<cc1:treeview id="trvToUnitsSelector" runat="server" nodetext="Unit" outputstyle="SingleSelection" systemimagespath="/General/Images/TreeView/"></cc1:treeview>
								</td>
							</tr>
							<tr>
								<td align="center">
									<Localized:Localizedbutton id="btnAssign" runat="server" text="Assign Users" cssclass="AssignButton" visible = "false" onclick="btnAssign_Click"></Localized:Localizedbutton><br>
									<asp:textbox id="txtUserIDs" style="DISPLAY: none" runat="server" width="500" autopostback="True" textmode="SingleLine"></asp:textbox>
									<asp:textbox id="txtAllUserIDs" style="DISPLAY: none" runat="server" width="500" autopostback="True" textmode="SingleLine"></asp:textbox>
								</td>
							</tr>

							</asp:PlaceHolder>

						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr valign="bottom" align="center">
				<td valign="middle" align="center" colspan="2">
					<navigation:footer id="ucFooter" runat="server"></navigation:footer>
				</td>
				</tr>
			
		</table>
    </form>
	
  </body>
</html>
