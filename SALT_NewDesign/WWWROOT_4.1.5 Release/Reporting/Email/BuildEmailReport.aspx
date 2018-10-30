<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page language="c#" ValidateRequest="false" Codebehind="BuildEmailReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.Email.BuildEmailReport" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="criteria" Tagname="reportCriteria" Src="/General/UserControls/ReportCriteria.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="cc" Namespace="tinyMCE" Assembly="tinyMCE" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
			<script type="text/javascript" src="../../General/Js/navigationmenu-jquery-latest.min.js"></script>
<script type="text/javascript" src="../../General/Js/navigationmenuscript.js"></script>

		<script language="javascript">
		<!--
		function TreeView_ClickCheckBox(treeViewName, checkBox, nodeID)
		{
		    //var selectedNodes = document.forms[0].item(treeViewName);
		    var selectedNodes = document.forms[0].elements[treeViewName]; 
			if (checkBox.checked)
			{
				selectedNodes.value = TreeView_AddStrArray(nodeID, selectedNodes.value)
			}
			else
			{
				selectedNodes.value = TreeView_RemoveStrArray(nodeID, selectedNodes.value)
			}
		}
		
		//String array functions
		//Check a string is in the comma delimited string array
		//Ex: alert(inStrArray("1","2,1"));		
		function TreeView_InStrArray(val, vals)
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
		}

		//add a string to  the comma delimited string array
		//Ex: alert(addStrArray("1","2,1"));		
		function TreeView_AddStrArray(val, vals)
		{
			return (vals.length==0)?val:(vals+","+ val);	
		}
		
		
		//Remove a string from the comma delimited string array
		//Ex: alert(removeStrArray("1","2,1"));		
		function TreeView_RemoveStrArray(val, vals)
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
		// -->
		</script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td style="HEIGHT: 31px" vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td vAlign="top" align="left" width="10%"><navigation:reportsMenu id="ucReportsMenu" runat="server"></navigation:reportsMenu></td>
					<!-- Body/Content -->
					<td class="DataContainer">
						<navigation:helplink id="ucHelp" runat="Server" desc="" key="10.2.7"></navigation:helplink>
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Email Report</Localized:LocalizedLabel><br>
						<asp:label id="lblError" runat="server"></asp:label>
						<table width="98%" align="left" border="0">
							<!----------------------- First Section ------------------->
							<TBODY>
								<asp:PlaceHolder ID="plhSearchCriteria" Runat="server">
									<TR>
										<TD class="formLabel" vAlign="top" width="20%">
											<Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<cc1:treeview id="trvUnitsSelector" runat="server" SystemImagesPath="/General/Images/TreeView/"
												OutputStyle="MultipleSelection" NodeText="Unit"></cc1:treeview></TD>
									</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 178px" vAlign="top"><STRONG>
												<Localized:LocalizedLabel id="lblCourse" runat="server"></Localized:LocalizedLabel><BR>
											</STRONG>
										</TD>
										<TD>
											<asp:ListBox id="cboCourses" runat="server" Height="250px" Width="230px" SelectionMode="Multiple"></asp:ListBox></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<Localized:LocalizedLabel id="lblCustomClassification" Runat="server">Grouping Option</Localized:LocalizedLabel></TD>
										<TD>
											<asp:DropDownList id="cboCustomClassification" Runat="server" Width="200px"></asp:DropDownList></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<Localized:LocalizedLabel id="lblCourseStatus" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:RadioButtonList id="radCourseModuleStatus" Runat="server" RepeatDirection="Vertical">
												<asp:ListItem Value="Complete" Selected="True"></asp:ListItem>
												<asp:ListItem Value="Incomplete">Incomplete - Includes Failed and Not Started</asp:ListItem>
												<asp:ListItem Value="Failed"></asp:ListItem>
												<asp:ListItem Value="Not Started"></asp:ListItem>
												<asp:ListItem Value="Expired (Time Elapsed)"></asp:ListItem>
												<asp:ListItem Value="Expired (New Content)"></asp:ListItem>
											</asp:RadioButtonList></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<Localized:LocalizedLabel id="lblRecip" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:RadioButtonList id="radRecipientType" Runat="server" RepeatDirection="Vertical">
												<asp:ListItem Value="Administrators"></asp:ListItem>
												<asp:ListItem Value="Users" Selected="True"></asp:ListItem>
											</asp:RadioButtonList></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<Localized:LocalizedLabel id="lblQuizDateRange" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<Localized:LocalizedLiteral id="lblBetween" runat="server"></Localized:LocalizedLiteral>
											<asp:DropDownList id="lstFromDay" Runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstFromMonth" Runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstFromYear" Runat="server"></asp:DropDownList>&nbsp;
											<Localized:LocalizedLiteral id="lblAnd" runat="server"></Localized:LocalizedLiteral>
											&nbsp;
											<asp:DropDownList id="lstToDay" Runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstToMonth" Runat="server"></asp:DropDownList>
											<asp:DropDownList id="lstToYear" Runat="server"></asp:DropDownList></TD>
									</TR>
									<TR>
										<TD class="formLabel" style="WIDTH: 178px"><STRONG>
												<Localized:LocalizedLabel id="lblIncludeInactive" runat="server"></Localized:LocalizedLabel></STRONG></TD>
										<TD>
											<asp:checkbox id="chbInclInactiveUser" Runat="server"></asp:checkbox></TD>
									</TR>
									<TR>
										<TD colSpan="2">&nbsp;
										</TD>
									</TR>
									<TR>
										<TD></TD>
										<TD>
											<Localized:LocalizedButton id="btnGenerateEmail" Runat="server" CssClass="generateButton" Text="Preview Email" onclick="btnGenerateEmail_Click"></Localized:LocalizedButton>&nbsp;
											<Localized:LocalizedButton id="btnReset" Runat="server" CssClass="resetButton" Text="Reset" onclick="btnReset_Click"></Localized:LocalizedButton></TD>
										<TD></TD>
									</TR>
								</asp:PlaceHolder>
								<!----------- End First Section ------------>
								<!----------- Second Section ------------>
								<asp:PlaceHolder ID="plhResults" Runat="server" Visible="False">
									<TR>
										<TD colSpan="2">
											<criteria:reportcriteria id="ucCriteria" runat="server"></criteria:reportcriteria></TD>
									</TR>
									<TR>
										<TD colSpan="2">
											<Localized:Localizedcheckbox id="chkSelectAll" runat="server" autopostback="True" text="Select All" oncheckedchanged="chkSelectAll_CheckedChanged"></Localized:Localizedcheckbox>
											<Localized:Localizedcheckbox id="chkClearAll" runat="server" autopostback="True" text="Clear All" oncheckedchanged="chkClearAll_CheckedChanged"></Localized:Localizedcheckbox>
											<asp:DataGrid id="dgrResults" runat="server" Width="100%" gridlines="Horizontal" AllowPaging="True"
												AutoGenerateColumns="False">
												<SelectedItemStyle CssClass="tablerow2"></SelectedItemStyle>
												<AlternatingItemStyle CssClass="tablerow2"></AlternatingItemStyle>
												<ItemStyle CssClass="tablerow1"></ItemStyle>
												<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
												<Columns>
													<asp:TemplateColumn>
														<HeaderTemplate>
															<Localized:LocalizedLabel key="cmnUsers" runat="server" ID="Localizedlabel1" NAME="Localizedlabel1"></Localized:LocalizedLabel>
														</HeaderTemplate>
														<ItemStyle Width="12%" VerticalAlign="Middle"></ItemStyle>
														<ItemTemplate>
															<asp:CheckBox EnableViewState="True" ID="chkUserID" Text="Email" Runat="server" Checked="True"></asp:CheckBox>
														</ItemTemplate>
													</asp:TemplateColumn>
													<asp:BoundColumn Visible="False" DataField="UserID">
														<ItemStyle Width="100px"></ItemStyle>
													</asp:BoundColumn>
													<asp:BoundColumn DataField="HierarchyName" HeaderText="Unit Pathway">
														<ItemStyle Width="34%"></ItemStyle>
													</asp:BoundColumn>
													<asp:BoundColumn DataField="LastName" HeaderText="Last Name">
														<ItemStyle Width="12%"></ItemStyle>
													</asp:BoundColumn>
													<asp:BoundColumn DataField="FirstName" HeaderText="First Name" DataFormatString="{0}">
														<ItemStyle Width="12%"></ItemStyle>
													</asp:BoundColumn>
													<asp:BoundColumn Visible="false" DataField="UserID">
														<ItemStyle Width="100px"></ItemStyle>
													</asp:BoundColumn>
													<asp:BoundColumn DataField="DateCreated" HeaderText="DateCreated">
														<ItemStyle Width="15%"></ItemStyle>
													</asp:BoundColumn>
													<asp:BoundColumn DataField="DateArchived" HeaderText="Date Archived">
														<ItemStyle Width="15%"></ItemStyle>
													</asp:BoundColumn>
												</Columns>
												<PagerStyle Visible="False"></PagerStyle>
											</asp:DataGrid>
											<TABLE id="tblPagination" width="100%" border="0" runat="server">
												<TR id="trPagination" runat="server">
													<TD align="left">
														<Localized:LocalizedLiteral id="litPage" runat="server"></Localized:LocalizedLiteral>&nbsp;
														<asp:dropdownlist id="cboPage" runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp;
														<Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="litOf"></Localized:LocalizedLiteral>&nbsp;
														<asp:label id="lblPageCount" runat="server">3</asp:label>:
														<asp:label id="lblCurrentPageRecordCount" runat="server">30 - 40</asp:label>&nbsp;
														<Localized:LocalizedLiteral id="litOf" runat="server"></Localized:LocalizedLiteral>&nbsp;
														<asp:label id="lblTotalRecordCount" runat="server">81</asp:label>&nbsp;
														<Localized:LocalizedLiteral id="litDisplayed" runat="server"></Localized:LocalizedLiteral></TD>
													<TD align="right">
														<Localized:Localizedlinkbutton id="btnPrev" runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp;
														<Localized:Localizedlinkbutton id="btnNext" runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
									<TR>
										<TD colSpan="2">
											<asp:TextBox id="txtEmailSubject" Runat="server" Width="100%"></asp:TextBox>
											<asp:TextBox id="txtEmailFromName" style="DISPLAY: none" Runat="server"></asp:TextBox>
											<asp:TextBox id="txtEmailFromEmail" style="DISPLAY: none" Runat="server"></asp:TextBox></TD>
									</TR>
									<TR>
										<TD colSpan="2">
										    <cc:texteditor runat="server" name="content" id="txtEmailBody" Width="100%" Rows="15" Mode="Full" />
											<%--<asp:TextBox id="txtEmailBody" Runat="server" Width="100%" TextMode="MultiLine" Rows="15"></asp:TextBox>--%>
										</TD>
									</TR>
									<TR>
										<TD colSpan="2">
											<Localized:LocalizedButton id="btnBack" Runat="server" CssClass="backButton" Text="Back" onclick="btnBack_Click"></Localized:LocalizedButton>&nbsp;
											<Localized:LocalizedButton id="btnSendEmail" Runat="server" CssClass="sendButton" Text="Send Email" onclick="btnEmailSend_Click"></Localized:LocalizedButton>
											<asp:TextBox id="txtUserIDs" style="DISPLAY: none" Runat="server" Width="300px" TextMode="MultiLine"
												Rows="15"></asp:TextBox>
											<asp:TextBox id="txtMashup" style="DISPLAY: none" Runat="server" Width="300px" TextMode="MultiLine"
												Rows="15"></asp:TextBox>
											<asp:TextBox id="txtAllUserIDs" style="DISPLAY: none" Runat="server" Width="300px" TextMode="MultiLine"
												Rows="15" EnableViewState="True"></asp:TextBox>
											<asp:TextBox id="txtAdminIDs" style="DISPLAY: none" Runat="server" Width="300px" TextMode="MultiLine"
												Rows="15"></asp:TextBox></TD>
									</TR>
								</asp:PlaceHolder>
								<!----------------- End Second Section -------------------->
								<!----------------- Third Section -------------------->
								<asp:PlaceHolder id="plhComplete" Runat="server" Visible="False">
									<TR>
										<TD>
											<Localized:LocalizedLabel id="lblEmailSent" runat="server"></Localized:LocalizedLabel><BR>
											<Localized:LocalizedButton id="btnBackToMain" Runat="server" CssClass="backButton" Text="Return" onclick="btnBackToMain_Click"></Localized:LocalizedButton></TD>
									</TR>
								</asp:PlaceHolder>
								<!----------------- End Third Section -------------------->
							</TBODY>
						</table>
					</td>
					<!--End Body/Content--></tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr>
			</table>
		</form>
		</TD></TR></TBODY></TABLE>
	</body>
</HTML>
