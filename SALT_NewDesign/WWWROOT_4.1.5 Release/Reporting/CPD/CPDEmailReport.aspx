<%@ Page language="c#" Codebehind="CPDEmailReport.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Reporting.CPD.CPDEmailReport" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="criteria" Tagname="reportCriteria" Src="/General/UserControls/ReportCriteria.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="reportsMenu" Src="/General/UserControls/Navigation/ReportsMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<style:style id="ucStyle" runat="server"></style:style>
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="../../General/Js/navigationmenu-jquery-latest.min.js"></script>
<script type="text/javascript" src="../../General/Js/navigationmenuscript.js"></script>

		<script language="javascript">
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
	</HEAD>
	<body MS_POSITIONING="FlowLayout" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td style="HEIGHT: 31px" valign="top" align="center" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr valign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="ReportMenuContainer" width="30">
						<navigation:reportsmenu id="ucReportsMenu" runat="server"></navigation:reportsmenu>
					</td>
					<!-- Body/Content -->
					<td align="left" class="DataContainer">
						<LOCALIZED:LOCALIZEDLABEL id="lblPageTitle" cssclass="pageTitle" runat="server">Continuous Professional Development Email Report</LOCALIZED:LOCALIZEDLABEL>
						<br>
						<asp:label id="lblError" runat="server" forecolor="#FF0000"></asp:label>
						<table width="98%" align="left" border="0">
							<TBODY>
								<asp:placeholder id="plhSearchCriteria" runat="server">
									<TR>
										<TD style="WIDTH: 151px" vAlign="top"><STRONG>
												<Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></STRONG></TD>
										<TD>
											<cc1:TreeView id="trvUnitPath" runat="server" OutputStyle="MultipleSelection" SystemImagesPath="/General/Images/TreeView/"
												NodeText="Unit"></cc1:TreeView></TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top">
											<LOCALIZED:LOCALIZEDLABEL id="lblProfile" runat="server"> Profile</LOCALIZED:LOCALIZEDLABEL></TD>
										<TD>
											<asp:dropdownlist id="cboProfile" runat="server" width="200px"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD></TD>
										<TD><BR>
											<BR>
											<LOCALIZED:LOCALIZEDBUTTON id="btnGenerate" runat="server" cssclass="generateButton" text="Run Report"></LOCALIZED:LOCALIZEDBUTTON>&nbsp;
											<LOCALIZED:LOCALIZEDBUTTON id="btnReset" runat="server" cssclass="resetButton" text="Reset"></LOCALIZED:LOCALIZEDBUTTON></TD>
									</TR>
								</asp:placeholder>
							</TBODY>
							<!-- place holder for Results -->
							<asp:placeholder id="plhReportResults" runat="server">
								<TBODY>
									<TR>
										<TD colSpan="2"><!-- Pagination -->
											<TABLE id="tblPagination" width="100%" align="left" border="0" runat="server">
												<TR>
													<TD colSpan="2">
														<asp:datagrid id="grdPagination" runat="server" width="100%" allowpaging="True" autogeneratecolumns="False"
															borderstyle="Solid" allowsorting="True">
															<alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
															<itemstyle cssclass="tablerow2"></itemstyle>
															<headerstyle cssclass="tablerowtop"></headerstyle>
															<columns>
																<asp:templatecolumn headertext="Email">
																	<itemtemplate>
																		<asp:checkbox id="chkDefault" runat="server" checked='true'></asp:checkbox>
																	</itemtemplate>
																</asp:templatecolumn>
																<asp:boundcolumn datafield="hierarchyname" sortexpression="hierarchyname" headertext="Unit Pathway">
																	<headerstyle></headerstyle>
																</asp:boundcolumn>
																<asp:boundcolumn datafield="lastname" sortexpression="lastname" headertext="Last Name">
																	<headerstyle></headerstyle>
																</asp:boundcolumn>
																<asp:boundcolumn datafield="firstname" sortexpression="firstname" headertext="First Name">
																	<headerstyle></headerstyle>
																</asp:boundcolumn>
																<asp:boundcolumn datafield="useremail" headertext="useremail">
																	<headerstyle></headerstyle>
																</asp:boundcolumn>
																<asp:boundcolumn datafield="userid" headertext="User ID">
																	<headerstyle></headerstyle>
																</asp:boundcolumn>
															</columns>
															<pagerstyle visible="False"></pagerstyle>
														</asp:datagrid></TD>
												</TR>
												<TR class="tablerowbot" id="trPagination" runat="server">
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
														<Localized:LocalizedLinkButton id="btnPrev" runat="server" CausesValidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:LocalizedLinkButton>&nbsp;&nbsp;
														<Localized:LocalizedLinkButton id="btnNext" CausesValidation="False" Runat="server" onclick="btnNext_Click">Next&gt;&gt;</Localized:LocalizedLinkButton></TD>
												</TR>
												<TR>
													<TD>
														<asp:textbox id="txtsubject" runat="server" width="100%">Continuous Professional Development Incomplete</asp:textbox></TD>
												</TR>
												<TR>
													<TD>
														<asp:textbox id="txtEmailBody" Runat="server" TextMode="MultiLine" Height="100px" Width="100%"></asp:textbox></TD>
												</TR>
												<TR>
													<TD>
														<asp:TextBox id="txtUserIDs" style="DISPLAY: none" Runat="server" TextMode="MultiLine" Width="300px"
															Rows="15"></asp:TextBox></TD>
												</TR>
												<TR>
													<TD>
														
														<Localized:LOCALIZEDBUTTON id="btnBack" runat="server" CausesValidation="False" text="Back" cssclass="resetButton" onclick="btnBackToMain_Click"></Localized:LOCALIZEDBUTTON>&nbsp;&nbsp;

														<LOCALIZED:LOCALIZEDBUTTON id="btnSendEmail" runat="server" cssclass="generateButton" text="Send Email"></LOCALIZED:LOCALIZEDBUTTON></TD>
												</TR>
											</TABLE> <!-- Pagination --></TD>
									</TR>
							</asp:placeholder>
							<!----------------- End Second Section -------------------->
							<!----------------- Third Section -------------------->
							<asp:PlaceHolder id="plhComplete" Runat="server" Visible="False">
								<TBODY>
									<TR>
										<TD>
											<Localized:LocalizedLabel id="lblEmailSent" runat="server"></Localized:LocalizedLabel><BR>
											<Localized:LocalizedButton id="btnBackToMain" Runat="server" Text="Return" CssClass="backButton"></Localized:LocalizedButton></TD>
									</TR>
							</asp:PlaceHolder>
							<!----------------- End Third Section --------------------></table>
				<!-- Footer -->
				<tr valign="bottom" align="center">
					<td valign="middle" align="center" colspan="2"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
				</tr>
				</TBODY></table>
		</form>
	</body>
</HTML>
