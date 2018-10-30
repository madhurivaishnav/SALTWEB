<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="cpddetail.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.CPD.cpddetail" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title runat="server" 
id=pagTitle></title>
		<META http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" MS_POSITIONING="FlowLayout">
		<IFRAME id="PreventTimeout" src="/PreventTimeout.aspx" frameBorder=no width=0 height=0 runat="server" />
		<form id="frmPolicyDefault" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer"><navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu></td>
					<!-- Body/Content -->
					 <td class="DataContainer">
						<asp:Panel ID="panTitle" Runat="server">
							<TABLE width="100%">
								<TR>
									<TD>
										<asp:Label id="lblPageTitle" Runat="server" CssClass="pageTitle"></asp:Label>
									</TD>
								</TR>
								<TR>
									<TD>
										<asp:Label id="lblMessage" Runat="server" Font-Bold="True" EnableViewState="False"></asp:Label>
									</TD>
								</TR>
								<tr>
									<td><asp:Label ID="lblMessageGap" Runat="server" Font-Bold="True" EnableViewState="False"></asp:Label></td>
								</tr>
								<tr>
								<td>
								<asp:ValidationSummary ID="CPDValidationSummary" Runat="server" DisplayMode="BulletList" EnableViewState="False" />
								</td>
								</tr>
							</TABLE>
						</asp:Panel><asp:panel id="panCPD" Runat="server">
						<asp:Panel ID="panEnabled" Runat="server">
							<TABLE width="100%">
								<TR>
									<TD width="20%">
										<localized:localizedLabel id="lblProfileName" Runat="server" font-bold="true" />
									</TD>
									<td>
										<asp:TextBox ID="txtProfileName" Runat="server" /> &nbsp;
										<localized:localizedCustomValidator id="cvProfileName" runat="server" text="*" enabled="true" onservervalidate="cvProfileName_ServerValidate" />
									</td>
								</TR>
							</TABLE>
						</asp:Panel>
						<br />
						<asp:Label ID="lblNoPeriod" Runat="server" />
						<asp:Panel ID="panPeriod" Runat="server" BorderWidth="1px" BorderColor="Silver" Width="99%">
							<TABLE width="100%">
								<TR>
									<TD>
										<asp:Label id="lblMultiPeriod" Runat="server" font-bold="True"></asp:Label>
									</TD>
								</TR>
							</table>
							<table width="100%">
								<TR>
									<td width="25px"></td>
									<TD>
										<localized:localizedLabel id=lblProfilePeriod Runat="server"></localized:localizedLabel>
									</TD>
									<TD colSpan=2>
										<asp:dropdownlist id=ddlCurrentDateStartDay Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlCurrentDateStartMonth Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlCurrentDateStartYear Runat="server"></asp:dropdownlist>
										<asp:Label id=lblCurrentTo runat="server"></asp:Label>
										<asp:dropdownlist id=ddlCurrentDateEndDay Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlCurrentDateEndMonth Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlCurrentDateEndYear Runat="server"></asp:dropdownlist>
										&nbsp;
										<localized:localizedCustomValidator id="cvCurrentDate" runat="server" text="*" enabled="true" onservervalidate="cvCurrentDate_ServerValidate" />
									</TD>
								</TR>
								<TR>
									<td width="25px"></td>
									<TD>
										<localized:localizedLabel id="lblRequiredPoints" Runat="server"></localized:localizedLabel>
									</TD>
									<TD>
										<asp:TextBox id="txtCurrentPoints" Runat="server" Width="50px"></asp:TextBox>
										&nbsp;
										<localized:localizedCustomValidator id="cvCurrentPoints" runat="server" text="*" enabled="true" onservervalidate="cvCurrentPoints_ServerValidate" />
									</TD>
								</TR>
							</TABLE>
							<br />
							<TABLE width="100%">
								<TR>
									<TD>
										<localized:localizedLabel id=lblEndOfPeriod Runat="server" font-bold="true" />
									</TD>
								</TR>
							</table>
							<table width="100%">
								<TR>
									<td width="20px"></td>
									<TD>
										<localized:localizedRadioButton ID="rbNoAction" GroupName="rbFuture" Runat="server"  />
									</TD>
								</TR>
								<TR>
									<td width="20px"></td>
									<TD>
										<localized:localizedRadioButton ID="rbAutoIncrementAsCurrent" GroupName="rbFuture" Runat="server"  />
									</TD>
								</TR>
								<TR>
									<td width="20px"></td>
									<TD>
										<localized:localizedRadioButton ID="rbAutoIncrementByMonth" GroupName="rbFuture" Runat="server"  />
										&nbsp;
										<asp:TextBox ID="txtMonth" Runat="server" Width="50px" />
										&nbsp;
										<localized:localizedLabel ID="lblMonth" Runat="server" />	
										&nbsp;
										<localized:localizedCustomValidator id="cvMonth" runat="server" text="*" enabled="true" onservervalidate="cvMonth_ServerValidate" />							
									</TD>
								</TR>
								<TR>
									<td width="20px"></td>
									<TD>
										<localized:localizedRadioButton ID="rbNewFuturePeriod" GroupName="rbFuture" Runat="server"  />
									</TD>
								</TR>
							</table>
							<table width="100%">
								<TR>
									<td width="100px"></td>
									<td>
										<localized:localizedLabel id="lblFutureProfilePeriod" Runat="server" />
									</td>
									<TD colSpan=2>
										<asp:dropdownlist id=ddlFutureDateStartDay Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlFutureDateStartMonth Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlFutureDateStartYear Runat="server"></asp:dropdownlist>
										<asp:Label id="lblFutureTo" runat="server"></asp:Label>
										<asp:dropdownlist id=ddlFutureDateEndDay Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlFutureDateEndMonth Runat="server"></asp:dropdownlist>
										<asp:dropdownlist id=ddlFutureDateEndYear Runat="server"></asp:dropdownlist>
										&nbsp;
										<localized:localizedCustomValidator id="cvFutureDate" runat="server" text="*" enabled="true" onservervalidate="cvFutureDate_ServerValidate" />
									</TD>									
								</TR>
								<TR>
									<td width="100px"></td>
									<TD>
										<localized:localizedLabel id="lblFutureRequiredPoints" Runat="server" />
									</TD>
									<td>
										<asp:TextBox id="txtFuturePoints" Runat="server" Width="50px"></asp:TextBox>
										&nbsp;
										<localized:localizedCustomValidator id="cvFuturePoints" runat="server" text="*" enabled="true" onservervalidate="cvFuturePoints_ServerValidate" />										
									</td>
								</TR>
							</TABLE>
						</asp:Panel>
						<br />
						<asp:Panel ID="panButtons" Runat="server" Width="99%">
							<TABLE width="100%">
								<TR>
									<TD align="right">
									<Localized:Localizedbutton id="btnSaveProfile" runat="server" CssClass="saveButton" key="btnSaveProfile" Text="Save Profile" causesvalidation="true" onclick="btnSaveProfile_Click" />
									&nbsp;
									<Localized:LocalizedButton id="btnCancel" runat="server" CssClass="saveButton" key="cmnCancel" CausesValidation="false" onclick="btnCancel_Click" /> 
									<Localized:Localizedbutton id="btnDeleteFuturePeriod" runat="server" CssClass="saveButton" key="btnDeleteFuturePeriod" Text="Save" width="200px" causesvalidation="false" onclick="btnDeleteFuturePeriod_Click" />
									<Localized:Localizedbutton id="btnNewProfilePeriod" runat="server" CssClass="saveButton" key="btnNewProfilePeriod" Text="New Profile Period" width="200px" causesvalidation="false" onclick="btnNewProfilePeriod_Click" />
									
									</TD>
								</TR>
							</TABLE>
						</asp:Panel>
						<br />
						<asp:Panel ID="panBackToCPDProfile" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td align="right">
										<A href="/Administration/CPD/CPDDefault.aspx"><LOCALIZED:LOCALIZEDLITERAL id="lnkReturnLink" runat="server" key="CPDReturn"></LOCALIZED:LOCALIZEDLITERAL></A>&nbsp;&nbsp;
									</td>
								</tr>
							</table>
						</asp:Panel>
						<br />
						<asp:Panel ID="panTabs" Runat="server" Width="99%">
							<TABLE width="100%">
								<TR>
									<TD>
									<localized:localizedLinkButton id="lnkAssignPoints" Runat="server" CausesValidation=False onclick="lnkAssignPoints_Click" /> 
									&nbsp;|&nbsp;
									<localized:localizedLinkButton id="lnkAssignUnits" Runat="server" CausesValidation=False onclick="lnkAssignUnits_Click" /> 
									&nbsp;|&nbsp;
									<localized:localizedLinkButton id="lnkAssignUsers" Runat="server" CausesValidation=False onclick="lnkAssignUsers_Click" />
									&nbsp;|&nbsp;
									<localized:localizedLinkButton id="lnkViewUsers" Runat="server" CausesValidation=False onclick="lnkViewUsers_Click" />
									</TD>
								</TR>
							</TABLE>
						</asp:Panel>
						<br />
						<asp:Panel ID="panAssignPoints" Runat="server" Width="99%">
							<table width=100%>
								<tr>
									<td>
										<localized:localizedLabel id="lblAssignPoints" runat="server" CssClass="pageTitle" />
									</td>
								</tr>
							</table>
							<table width="100%">
								<asp:Panel ID="panAssignQuizLesson" Runat="server" >
									<tr>
										<td width="150px">
											<localized:localizedLabel id="lblPointsTo" runat="server" font-bold="true" />
										</td>
										<td>
											<localized:localizedCheckBox id="cmnQuiz" runat="server" />
										</td>
									</tr>
									<tr>
										<td width="150px"></td>
										<td>
											<localized:localizedCheckBox id="cmnLesson" runat="server" />
										</td>
									</tr>
								</asp:Panel>
								<tr>
									<td width="150px" style="vertical-align:top">
										<localized:localizedLabel id="lblCourse" runat="server" font-bold="true" />
										&nbsp;
										<localized:localizedCustomValidator id="cvModulePoints" runat="server" text="*" enabled="true" onservervalidate="cvModulePoints_ServerValidate" />
									</td>
									<td>
										<!-- Course Module Grids to go here - dynamically added from code behind-->
										<asp:PlaceHolder ID="phCourseModuleList" Runat="server" />
										<asp:Label ID="lblNoCourse" Runat="server" Visible="False" />
									</td>
								</tr>
								<tr>
									<td width="150px"></td>
									<td>
										<localized:localizedLabel id="lblModulePoints" runat="server" font-bold="true" width="300px" font-align="right" />
										<asp:Label id="lblModulePointsTotal" runat="server" font-bold="true" font-align="right" />
										
									</td>
								</tr>
								<tr>
									<td width="150px" style="vertical-align:top">
										<localized:localizedLabel id="lblPolicy" runat="server" font-bold="true" />
										&nbsp;
										<localized:localizedCustomValidator id="cvPolicyPoints" runat="server" text="*" enabled="true" onservervalidate="cvPolicyPoints_ServerValidate" />
									</td>
									<td>
										<asp:Label ID="lblNoPolicy" Runat="server" Visible="False" />
										<!-- Policy Grid to go here -->
										<asp:Panel ID="panPolicyPoints" Runat="server">
											<table width="100%">
												<tr>
													<td>
														<asp:DataGrid ID="grdPolicyPoints" Runat="server" AutoGenerateColumns="False">
															<AlternatingItemStyle CssClass="tablerow1"></AlternatingItemStyle>
															<ItemStyle CssClass="tablerow2"></ItemStyle>
															<HeaderStyle CssClass="tablerowtop"></HeaderStyle>
															<Columns>
																<asp:boundcolumn datafield="ProfilePointsID" headertext="ProfilePointsID" Visible=False>
																	<headerstyle cssclass="tablerowtop" width="250" height="25"></headerstyle>
																</asp:boundcolumn>
																<asp:boundcolumn datafield="PolicyID" headertext="PolicyID" Visible=False>
																	<headerstyle cssclass="tablerowtop" width="250" height="25"></headerstyle>
																</asp:boundcolumn>
																<asp:TemplateColumn HeaderText="Policy Name">
																	<ItemTemplate>
																		<%# DataBinder.Eval(Container.DataItem, "PolicyName")%>
																	</ItemTemplate>
																</asp:TemplateColumn>
																<asp:TemplateColumn HeaderText="Points">
																	<ItemTemplate>
																		<asp:TextBox ID="txtPolicyPoints" Runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "PolicyPoints") %>' Width="50" ></asp:TextBox>
																	</ItemTemplate>
																</asp:TemplateColumn>
															</Columns>
														</asp:DataGrid>
													</td>
												</tr>
												<tr>
													<td>
													<localized:localizedLabel id="lblPolicyPoints" runat="server" font-bold="true" width="300px" font-align="right" />
													<asp:Label id="lblPolicyPointsTotal" runat="server" font-bold="true" font-align="right" />
													</td>
												</tr>
											</table>
										</asp:Panel> 
									</td>
								</tr>
								<asp:Panel ID="panAssignPointsTo" Runat="server">
									<tr>
										<td width="150px"></td>
										<td>
											<localized:localizedLabel id="lblApplyChanges" runat="server" font-bold="true" />
										</td>
									</tr>
									<tr>
										<td width="150px"></td>
										<td>
											<localized:localizedRadioButton id="rbAllUsersIncluding" runat="server" groupname="ApplyPoints" />	
										</td>
									</tr>
									<tr>
										<td width="150px"></td>
										<td>
											<localized:localizedRadioButton id="rbAllUsersExcluding" runat="server" groupname="ApplyPoints" checked="true" />	
										</td>
									</tr>
								</asp:Panel>
								<asp:Panel ID="panSaveAll" Runat="server">
									<tr>
										<td width="150px"></td>
										<td align="right">
											<asp:Label ID="lblPointsAssignMessage" Runat="server" Visible="False" />
											<localized:localizedButton id="btnSavePoints" runat="server" CssClass="saveButton" key="btnSaveAll" causesvalidation="false" onclick="btnSavePoints_Click" />
										</td>
									</tr>
								</asp:Panel>
							</table>
						</asp:Panel>
						<asp:Panel ID="panAssignUnits" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td>
										<localized:localizedLabel id="lblAssignUnits" runat="server" CssClass="pageTitle" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panAssignUsers" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td>
										<localized:localizedLabel id="lblAssignUsers" runat="server" CssClass="pageTitle" />
									</td>
								</tr>
								<tr>
									<td width="150px" style="vertical-align:top"></td>
									<td><asp:Label ID="lblUserMessage" Runat="server" Visible="False" /></td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panViewUsers" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td>
										<localized:localizedLabel id="lblViewUsers" runat="server" CssClass="pageTitle" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panUnitSelect" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td width="150px" style="vertical-align:top">
										<localized:localizedLabel id="lblSelectUnits" runat="server" font-bold="true" />
									</td>
									<td>
										<cc1:treeview id="trvUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/" 
															nodetext="Unit" outputstyle="MultipleSelection"  />
										<asp:Label ID="lblUnitMessage" Runat="server" Visible="False" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panAssign" Runat="server" Width="99%">
							<br />
							<table width=100%>								
								<tr>
									<td width="150px"></td>
									<td align="right">
										<asp:Label ID="lblUnitAssignMessage" Runat="server" Visible="True" />
										<localized:localizedButton id="btnAssign" runat="server" CssClass="SaveButton" key="cmnAssign" causesvalidation="false"  onclick="btnAssign_Click" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panUserUnitSelect" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td width="150px" style="vertical-align:top">
										<localized:localizedLabel id="lblSelectUserUnits" runat="server" font-bold="true" />
									</td>
									<td>
										<cc1:treeview id="trvUserUnitsSelector" runat="server" systemimagespath="/General/Images/TreeView/" 
															nodetext="Unit" outputstyle="MultipleSelection"  />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panUnitSaveAll" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td width="150px"></td>
									<td align="right">										
										<localized:localizedButton id="btnUnitSaveAll" runat="server" CssClass="SaveButton" key="btnSaveAll" causesvalidation="false" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panUserDetails" Runat="server" Width="99%">
							<table>
								<tr>
									<td width="150px">
										<localized:localizedLabel id="cmnFirstName" runat="server" font-bold="true" />
									</td>
									<td>
										<asp:TextBox ID="txtFirstName" Runat="server" Width="200px" />
									</td>
								</tr>
								<tr>
									<td width="150px">
										<localized:localizedLabel id="cmnLastName" runat="server" font-bold="true" />
									</td>
									<td>
										<asp:TextBox ID="txtLastName" Runat="server" Width="200px" />
									</td>
								</tr>
								<tr>
									<td width="150px">
										<localized:localizedLabel id="cmnUserName" runat="server" font-bold="true" />
									</td>
									<td>
										<asp:TextBox ID="txtUserName" Runat="server" Width="200px" />
									</td>
								</tr>
								<tr>
									<td width="150px">
										<localized:localizedLabel id="cmnEmail" runat="server" font-bold="true" />
									</td>
									<td>
										<asp:TextBox ID="txtEmail" Runat="server" Width="200px" />
									</td>
								</tr>
								<tr>
									<td width="150px">
										<localized:localizedLabel id="lblExternalID" runat="server" font-bold="true" />
									</td>
									<td>
										<asp:TextBox ID="txtExternalId" Runat="server" Width="200px" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						
						<asp:Panel ID="panSearchReset" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td width="150px"></td>
									<td align="right">
										<localized:localizedButton id="btnSearch" runat="server" CssClass="SaveButton" key="btnSearch" causesvalidation="false"  onclick="btnSearch_Click" />
										&nbsp;
										<localized:localizedButton id="btnReset" runat="server" CssClass="SaveButton" key="btnReset" causesvalidation="false" onclick="btnReset_Click" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panUserSearchMessage" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td width="150px"></td>
									<td>
										<asp:Label ID="lblNoUsers" Runat="server" />
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panUserSearchResults" Runat="server" Width="99%">
							<table width="100%">								
								<tr>
									<td>
										<asp:label id="lblUserCount" runat="server" Visible="False"></asp:label>
										<asp:datagrid id="grdResults" runat="server" width="100%" autogeneratecolumns="False" allowsorting="True" allowpaging="True" >
											<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
											<itemstyle cssclass="tablerow2"></itemstyle>
											<headerstyle cssclass="tablerowtop"></headerstyle>
											<columns>
												<asp:templatecolumn sortexpression="Pathway" headertext="Unit Pathway">
													<itemtemplate>
														<%# DataBinder.Eval(Container.DataItem, "Pathway")%>
													</itemtemplate>
												</asp:templatecolumn>
												<asp:templatecolumn sortexpression="LastName" headertext="Last Name">
													<headerstyle></headerstyle>
													<itemtemplate>
														<%# DataBinder.Eval(Container.DataItem, "LastName")%>
													</itemtemplate>
												</asp:templatecolumn>
												<asp:templatecolumn sortexpression="FirstName" headertext="First Name">
													<headerstyle></headerstyle>
													<itemtemplate>
														<%# DataBinder.Eval(Container.DataItem, "FirstName")%>
													</itemtemplate>
												</asp:templatecolumn>
												<asp:TemplateColumn HeaderText="Assign">
													<HeaderStyle></HeaderStyle>
													<ItemTemplate >
														<asp:CheckBox id="chkAssign" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "Granted")%>' enableviewstate="True" />
													</ItemTemplate>
												</asp:TemplateColumn>
												<asp:boundcolumn datafield="UserID" headertext="UserID" Visible=False>
													<headerstyle cssclass="tablerowtop" width="250" height="25"></headerstyle>
												</asp:boundcolumn>
											</columns>
											<pagerstyle mode="NumericPages" position="Bottom"></pagerstyle>
										</asp:datagrid>
									</td>
								</tr>
							</table>
						</asp:Panel>
						<asp:Panel ID="panUserList" Runat="server" Width="99%">
							User List
						</asp:Panel>
						<asp:Panel ID="panUserSaveAll" Runat="server" Width="99%">
							<table width="100%">
								<tr>
									<td width="150px"></td>
									<td align="right">
										<asp:Label ID="lblUserAssignMessage" Runat="server" Visible="False" />
										<localized:localizedButton id="btnUserSaveAll" runat="server" CssClass="SaveButton" key="btnSaveAll" causesvalidation="false" onclick="btnUserSaveAll_Click" />
									</td>
								</tr>
							</table>
						</asp:Panel>
					</td>
				</tr>
				</asp:Panel>				
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
