<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="ComplianceRules.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Unit.ComplianceRules" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
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
		</script>
		<script language="JavaScript">
			function PopulateAllConfirm()
			{
				return confirm(ResourceManager.GetString("ConfirmMessage"));
			}
			
		</script>
	</HEAD>
	<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
		<form id="Form2" method="post" runat="server">
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
						<Localized:Localizedlabel id="lblPageTitle" cssclass="pageTitle" runat="server">Compliance Rules</Localized:Localizedlabel><br>
						<table width="95%" align="left" border="0">
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblUnitNameLabel" key="cmnUnitName" runat="server"></Localized:LocalizedLabel>
								</td>
								<td><asp:label id="lblUnitName" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblCourseLabel" runat="server"></Localized:LocalizedLabel></td>
								<td><asp:dropdownlist id="cboCourse" runat="server" autopostback="True" onselectedindexchanged="cboCourse_SelectedIndexChanged"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblSetAllRules" runat="server"></Localized:LocalizedLabel></td>
								<td>
									<table width="100%" align="left" border="0">
										<tr>
											<td class="formLabel"><Localized:LocalizedLabel id="lblLessFreq" runat="server"></Localized:LocalizedLabel></td>
											<td width="75%"><asp:dropdownlist id="cboLessonFrequency" runat="server">
													<asp:listitem value="0" Text=""></asp:listitem>
													<asp:listitem value="1">1</asp:listitem>
													<asp:listitem value="2">2</asp:listitem>
													<asp:listitem value="3">3</asp:listitem>
													<asp:listitem value="4">4</asp:listitem>
													<asp:listitem value="5">5</asp:listitem>
													<asp:listitem value="6">6</asp:listitem>
													<asp:listitem value="7">7</asp:listitem>
													<asp:listitem value="8">8</asp:listitem>
													<asp:listitem value="9">9</asp:listitem>
													<asp:listitem value="10">10</asp:listitem>
													<asp:listitem value="11">11</asp:listitem>
													<asp:listitem value="12">12</asp:listitem>
													<asp:listitem value="13">13</asp:listitem>
													<asp:listitem value="14">14</asp:listitem>
													<asp:listitem value="15">15</asp:listitem>
													<asp:listitem value="16">16</asp:listitem>
													<asp:listitem value="17">17</asp:listitem>
													<asp:listitem value="18">18</asp:listitem>
													<asp:listitem value="19">19</asp:listitem>
													<asp:listitem value="20">20</asp:listitem>
													<asp:listitem value="21">21</asp:listitem>
													<asp:listitem value="22">22</asp:listitem>
													<asp:listitem value="23">23</asp:listitem>
													<asp:listitem value="24">24</asp:listitem>
													<asp:listitem value="36">36</asp:listitem>
												</asp:dropdownlist><Localized:LocalizedLiteral id="Localizedliteral2" runat="server" key="Months"></Localized:LocalizedLiteral></td>
										</tr>
										<tr>
											<td class="formLabel"><Localized:LocalizedLabel id="lblQuizFreq" runat="server"></Localized:LocalizedLabel></td>
											<td width="75%"><asp:dropdownlist id="cboQuizFrequency" runat="server">
													<asp:listitem value="0" Text=""></asp:listitem>
													<asp:listitem value="1">1</asp:listitem>
													<asp:listitem value="2">2</asp:listitem>
													<asp:listitem value="3">3</asp:listitem>
													<asp:listitem value="4">4</asp:listitem>
													<asp:listitem value="5">5</asp:listitem>
													<asp:listitem value="6">6</asp:listitem>
													<asp:listitem value="7">7</asp:listitem>
													<asp:listitem value="8">8</asp:listitem>
													<asp:listitem value="9">9</asp:listitem>
													<asp:listitem value="10">10</asp:listitem>
													<asp:listitem value="11">11</asp:listitem>
													<asp:listitem value="12">12</asp:listitem>
													<asp:listitem value="13">13</asp:listitem>
													<asp:listitem value="14">14</asp:listitem>
													<asp:listitem value="15">15</asp:listitem>
													<asp:listitem value="16">16</asp:listitem>
													<asp:listitem value="17">17</asp:listitem>
													<asp:listitem value="18">18</asp:listitem>
													<asp:listitem value="19">19</asp:listitem>
													<asp:listitem value="20">20</asp:listitem>
													<asp:listitem value="21">21</asp:listitem>
													<asp:listitem value="22">22</asp:listitem>
													<asp:listitem value="23">23</asp:listitem>
													<asp:listitem value="24">24</asp:listitem>
													<asp:listitem value="36">36</asp:listitem>
												</asp:dropdownlist><Localized:LocalizedLiteral id="Localizedliteral1" runat="server" key="Months"></Localized:LocalizedLiteral></td>
										</tr>
										<tr>
											<td class="formLabel"><Localized:LocalizedLabel id="lblPassMark" runat="server"></Localized:LocalizedLabel></td>
											<td width="75%"><asp:textbox id="txtQuizPassMark" runat="server" maxlength="3" width="20px"></asp:textbox>%</td>
										</tr>
										<!-- business requirement 10 -->
										<!-- TODO: implement the actual functionality -->
										<tr>
											<td class="formLabel">
												<Localized:LocalizedLabel id="lblLessDate" runat="server"></Localized:LocalizedLabel></td>
											<td>
												<asp:dropdownlist id="cboLCompletionDay" Runat="server" />
												<asp:dropdownlist id="cboLCompletionMonth" Runat="server" />
												<asp:dropdownlist id="cboLCompletionYear" Runat="server" />
											</td>
										</tr>
										<!-- end new control -->
										
										<tr>
											<td class="formLabel">
												<Localized:LocalizedLabel id="lblQuizDate" runat="server"></Localized:LocalizedLabel></td>
											<td>
												<asp:dropdownlist id="cboQCompletionDay" Runat="server" />
												<asp:dropdownlist id="cboQCompletionMonth" Runat="server" />
												<asp:dropdownlist id="cboQCompletionYear" Runat="server" />
											</td>
										</tr>
										<tr>
											<td align="left" colspan="2">
												<Localized:Localizedbutton cssclass="populateButton" width="200px" id="btnPopulateAll" runat="server" text="Populate to all Modules" onclick="btnPopulateAll_Click"></Localized:Localizedbutton>&nbsp;
												
												<br><br>
												<asp:label id="lblMessage" runat="server" enableviewstate="False" ></asp:label>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="formLabel"><Localized:LocalizedLabel id="lblSetIndivid" runat="server"></Localized:LocalizedLabel></td>
								<td></td>
							</tr>
							<tr>
								<td colspan="2"><asp:datagrid id="grdModules" runat="server" width="100%" borderstyle="Solid" autogeneratecolumns="False">
										<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
										<itemstyle cssclass="tablerow2"></itemstyle>
										<headerstyle cssclass="tablerowtop"></headerstyle>
										<columns>
											<asp:templatecolumn headertext="Module Name">
												<headerstyle></headerstyle>
												<itemtemplate>
													<asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Name") %>'>
													</asp:Label>
												</itemtemplate>
											</asp:templatecolumn>
											<asp:templatecolumn headertext="Default">
												<headerstyle width="8%"></headerstyle>
												<itemstyle horizontalalign="Center"></itemstyle>
												<itemtemplate>
													<asp:checkbox runat="server" Checked='<%# DataBinder.Eval(Container, "DataItem.UsingDefault") %>' Enabled="False" >
													</asp:checkbox>
												</itemtemplate>
												<edititemtemplate>
													<asp:checkbox id="chkModuleUsingDefault" runat="server" Checked='<%# DataBinder.Eval(Container, "DataItem.UsingDefault") %>' >
													</asp:checkbox>
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:templatecolumn headertext="Lesson Freq.">
												<headerstyle></headerstyle>
												<itemtemplate>
													<asp:Label ID="lblLessonFrequency" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.LessonFrequency") %>'>
													</asp:Label>
													 <Localized:LocalizedLiteral id="lblLessonMonths" runat="server" key="Months"></Localized:LocalizedLiteral>
												</itemtemplate>
												<edititemtemplate>
													<asp:dropdownlist id="cboModuleLessonFrequency" runat="server" SelectedIndex='<%# int.Parse(DataBinder.Eval(Container, "DataItem.LessonFrequency").ToString()) %>' >
														<asp:listitem value="0" Text=""></asp:listitem>
														<asp:listitem value="1">1</asp:listitem>
														<asp:listitem value="2">2</asp:listitem>
														<asp:listitem value="3">3</asp:listitem>
														<asp:listitem value="4">4</asp:listitem>
														<asp:listitem value="5">5</asp:listitem>
														<asp:listitem value="6">6</asp:listitem>
														<asp:listitem value="7">7</asp:listitem>
														<asp:listitem value="8">8</asp:listitem>
														<asp:listitem value="9">9</asp:listitem>
														<asp:listitem value="10">10</asp:listitem>
														<asp:listitem value="11">11</asp:listitem>
														<asp:listitem value="12">12</asp:listitem>
														<asp:listitem value="13">13</asp:listitem>
														<asp:listitem value="14">14</asp:listitem>
														<asp:listitem value="15">15</asp:listitem>
														<asp:listitem value="16">16</asp:listitem>
														<asp:listitem value="17">17</asp:listitem>
														<asp:listitem value="18">18</asp:listitem>
														<asp:listitem value="19">19</asp:listitem>
														<asp:listitem value="20">20</asp:listitem>
														<asp:listitem value="21">21</asp:listitem>
														<asp:listitem value="22">22</asp:listitem>
														<asp:listitem value="23">23</asp:listitem>
														<asp:listitem value="24">24</asp:listitem>
													<asp:listitem value="36">36</asp:listitem>
													</asp:dropdownlist>
													
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:templatecolumn headertext="Quiz Freq.">
												<headerstyle></headerstyle>
												<itemtemplate>
													<asp:Label id="lblQuizFrequency" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.QuizFrequency") %>'>
													</asp:Label>
													 <Localized:LocalizedLiteral id="lblQuizMonths" runat="server" key="Months"></Localized:LocalizedLiteral>
												</itemtemplate>
												<edititemtemplate>
													<asp:dropdownlist id="cboModuleQuizFrequency" runat="server" SelectedIndex='<%# int.Parse(DataBinder.Eval(Container, "DataItem.QuizFrequency").ToString()) %>' >
														<asp:listitem value="0" Text=""></asp:listitem>
														<asp:listitem value="1">1</asp:listitem>
														<asp:listitem value="2">2</asp:listitem>
														<asp:listitem value="3">3</asp:listitem>
														<asp:listitem value="4">4</asp:listitem>
														<asp:listitem value="5">5</asp:listitem>
														<asp:listitem value="6">6</asp:listitem>
														<asp:listitem value="7">7</asp:listitem>
														<asp:listitem value="8">8</asp:listitem>
														<asp:listitem value="9">9</asp:listitem>
														<asp:listitem value="10">10</asp:listitem>
														<asp:listitem value="11">11</asp:listitem>
														<asp:listitem value="12">12</asp:listitem>
														<asp:listitem value="13">13</asp:listitem>
														<asp:listitem value="14">14</asp:listitem>
														<asp:listitem value="15">15</asp:listitem>
														<asp:listitem value="16">16</asp:listitem>
														<asp:listitem value="17">17</asp:listitem>
														<asp:listitem value="18">18</asp:listitem>
														<asp:listitem value="19">19</asp:listitem>
														<asp:listitem value="20">20</asp:listitem>
														<asp:listitem value="21">21</asp:listitem>
														<asp:listitem value="22">22</asp:listitem>
														<asp:listitem value="23">23</asp:listitem>
														<asp:listitem value="24">24</asp:listitem>
													<asp:listitem value="36">36</asp:listitem>
													</asp:dropdownlist>
												
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:TemplateColumn HeaderText="Lesson Completion Date">
												<headerstyle width="15%"></headerstyle>
												<itemtemplate>
													<asp:Label ID="lblLessonCompletionDate" Text='<%# DataBinder.Eval(Container.DataItem,"LessonCompletionDate","{0:dd/MM/yyyy}") %>' runat="server" />
												</itemtemplate>
												<edititemtemplate>
													<nobr>
													<asp:dropdownlist id="cboGridLCompletionDay" Runat="server" />
													<asp:dropdownlist id="cboGridLCompletionMonth" Runat="server" />
													<asp:dropdownlist id="cboGridLCompletionYear" Runat="server" />
													</nobr>
												</edititemtemplate>
											</asp:TemplateColumn>
											<asp:TemplateColumn HeaderText="Quiz Completion Date">
												<headerstyle width="15%"></headerstyle>
												<itemtemplate>
													<asp:Label ID="lblQuizCompletionDate" Text='<%# DataBinder.Eval(Container.DataItem,"QuizCompletionDate","{0:dd/MM/yyyy}") %>' runat="server" />
												</itemtemplate>
												<edititemtemplate>
													<nobr>
													<asp:dropdownlist id="cboGridQCompletionDay" Runat="server" />
													<asp:dropdownlist id="cboGridQCompletionMonth" Runat="server" />
													<asp:dropdownlist id="cboGridQCompletionYear" Runat="server" />
													</nobr>
												</edititemtemplate>
											</asp:TemplateColumn>
											<asp:templatecolumn headertext="Pass Mark">
												<headerstyle></headerstyle>
												<itemtemplate>
													<asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.QuizPassMark") %>'>%
													</asp:Label>
													%
												</itemtemplate>
												<edititemtemplate>
													<nobr>
													<asp:TextBox runat="server" id="txtModuleQuizPassMark" Text='<%# DataBinder.Eval(Container, "DataItem.QuizPassMark") %>' width="20px" MaxLength="3">
													</asp:TextBox>
													%</nobr>
												</edititemtemplate>
											</asp:templatecolumn>
											<asp:editcommandcolumn buttontype="LinkButton" updatetext="Update" headertext="Action" canceltext="Cancel"
												edittext="Modify">
												<headerstyle></headerstyle>
											</asp:editcommandcolumn>
										</columns>
									</asp:datagrid></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><A href="UnitDetails.aspx?UnitID=<%= m_intUnitID%>"><Localized:LocalizedLiteral id="lnkReturn" key="cmnReturnUnitDetails"  runat="server"></Localized:LocalizedLiteral></A></td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
			</table>
		</form>
		</FORM>
	</body>
</HTML>
