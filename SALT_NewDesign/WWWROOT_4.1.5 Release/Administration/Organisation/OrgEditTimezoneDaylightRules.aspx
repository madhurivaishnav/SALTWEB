<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrgEditTimezoneDaylightRules.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.OrgEditTimezoneDaylightRules" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="../../General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="../../General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="../../General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="../../General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="dialogs" Tagname="EScalendar" Src="../../General/UserControls/EmergingControls/EmergingSystemsCalendar.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<HTML>
    <HEAD>
		<title id="pagTitle" runat="server"></title>

		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
		<form id="frmOrgMailSetup" su method="post" runat="server">
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td align="center" valign="top" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr height="100%" align="left" valign="top">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer">
						<navigation:adminmenu runat="server" id="ucAdminMenu"></navigation:adminmenu>
					</td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Edit Timezone Daylight Saving Rules</Localized:LocalizedLabel><br>
						<table align="left" border="0">
							<tr>
								<td>
									<asp:PlaceHolder ID="plhOrgEditDaylight" Runat="server">
                                            <table ID="tblOrgEditDaylight" border="1px" width="100%" rules="none" frame="box">
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblTimezone" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtTimezone" runat="server"></asp:TextBox>
													<Localized:Localizedrequiredfieldvalidator id="validatorTimezone" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the Timezone name." controltovalidate="txtTimezone"></Localized:Localizedrequiredfieldvalidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblFirstYearStart" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtFirstYearStart" runat="server"></asp:TextBox>
                                                        <Localized:Localizedrequiredfieldvalidator id="validatorFirstYearStart" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the First Year Start." controltovalidate="txtFirstYearStart"></Localized:Localizedrequiredfieldvalidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblLastYearStart" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtLastYearStart" runat="server"></asp:TextBox>
                                                        <Localized:Localizedrequiredfieldvalidator id="validatorLastYearStart" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the Last Year End." controltovalidate="txtLastYearStart"></Localized:Localizedrequiredfieldvalidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblOffset" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtOffset" runat="server"></asp:TextBox>
                                                        <Localized:Localizedrequiredfieldvalidator id="validatorOffset" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the Offset." controltovalidate="txtOffset"></Localized:Localizedrequiredfieldvalidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblTimeStart" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtTimeStart" runat="server"></asp:TextBox>
                                                        <Localized:Localizedrequiredfieldvalidator id="validatorTimeStart" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the Start Time." controltovalidate="txtTimeStart"></Localized:Localizedrequiredfieldvalidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblWeekdayStart" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:DropDownList ID="drpWeekdayStart" runat="server">
                                                            <asp:ListItem Value="1">Sunday</asp:ListItem>
                                                            <asp:ListItem Value="2">Monday</asp:ListItem>
                                                            <asp:ListItem Value="3">Tuesday</asp:ListItem>
                                                            <asp:ListItem Value="4">Wednesday</asp:ListItem>
                                                            <asp:ListItem Value="5">Thursday</asp:ListItem>
                                                            <asp:ListItem Value="6">Friday</asp:ListItem>
                                                            <asp:ListItem Value="7">Saturday</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblWeekStart" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:DropDownList ID="drpWeekStart" runat="server">
                                                            <asp:ListItem Value="1">1st</asp:ListItem>
                                                            <asp:ListItem Value="2">2nd</asp:ListItem>
                                                            <asp:ListItem Value="3">3rd</asp:ListItem>
                                                            <asp:ListItem Value="4">4th</asp:ListItem>
                                                            <asp:ListItem Value="5">Last</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblMonthStart" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:DropDownList ID="drpMonthStart" runat="server">
                                                            <asp:ListItem Value="1">January</asp:ListItem>
                                                            <asp:ListItem Value="2">February</asp:ListItem>
                                                            <asp:ListItem Value="3">March</asp:ListItem>
                                                            <asp:ListItem Value="4">April</asp:ListItem>
                                                            <asp:ListItem Value="5">May</asp:ListItem>
                                                            <asp:ListItem Value="6">June</asp:ListItem>
                                                            <asp:ListItem Value="7">July</asp:ListItem>
                                                            <asp:ListItem Value="8">August</asp:ListItem>
                                                            <asp:ListItem Value="9">September</asp:ListItem>
                                                            <asp:ListItem Value="10">October</asp:ListItem>
                                                            <asp:ListItem Value="11">November</asp:ListItem>
                                                            <asp:ListItem Value="12">December</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblTimeEnd" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtTimeEnd" runat="server"></asp:TextBox>
                                                        <Localized:Localizedrequiredfieldvalidator id="validatorTimeEnd" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the End Time." controltovalidate="txtTimeEnd"></Localized:Localizedrequiredfieldvalidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblWeekdayEnd" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:DropDownList ID="drpWeekdayEnd" runat="server">
                                                            <asp:ListItem Value="1">Sunday</asp:ListItem>
                                                            <asp:ListItem Value="2">Monday</asp:ListItem>
                                                            <asp:ListItem Value="3">Tuesday</asp:ListItem>
                                                            <asp:ListItem Value="4">Wednesday</asp:ListItem>
                                                            <asp:ListItem Value="5">Thursday</asp:ListItem>
                                                            <asp:ListItem Value="6">Friday</asp:ListItem>
                                                            <asp:ListItem Value="7">Saturday</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblWeekEnd" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:DropDownList ID="drpWeekEnd" runat="server">
                                                            <asp:ListItem Value="1">1st</asp:ListItem>
                                                            <asp:ListItem Value="2">2nd</asp:ListItem>
                                                            <asp:ListItem Value="3">3rd</asp:ListItem>
                                                            <asp:ListItem Value="4">4th</asp:ListItem>
                                                            <asp:ListItem Value="5">Last</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblMonthEnd" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:DropDownList ID="drpMonthEnd" runat="server">
                                                            <asp:ListItem Value="1">January</asp:ListItem>
                                                            <asp:ListItem Value="2">February</asp:ListItem>
                                                            <asp:ListItem Value="3">March</asp:ListItem>
                                                            <asp:ListItem Value="4">April</asp:ListItem>
                                                            <asp:ListItem Value="5">May</asp:ListItem>
                                                            <asp:ListItem Value="6">June</asp:ListItem>
                                                            <asp:ListItem Value="7">July</asp:ListItem>
                                                            <asp:ListItem Value="8">August</asp:ListItem>
                                                            <asp:ListItem Value="9">September</asp:ListItem>
                                                            <asp:ListItem Value="10">October</asp:ListItem>
                                                            <asp:ListItem Value="11">November</asp:ListItem>
                                                            <asp:ListItem Value="12">December</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <Localized:LocalizedLabel ID="lblDelete" runat="server"></Localized:LocalizedLabel>
                                                    </td>
                                                    <td align="left">
                                                        <asp:CheckBox ID="chkDelete" OnCheckedChanged="chkDelete_Changed" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <Localized:LocalizedButton ID="btnOrgEditDaylightSave" OnClick="btnOrgEditDaylightSave_Click" runat="server" />
                                            <Localized:LocalizedButton ID="btnOrgEditDaylightCancel" OnClick="btnOrgEditDaylightCancel_Click" CausesValidation="false" runat="server" />
									</asp:PlaceHolder>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr align="center" valign="bottom">
					<td align="center" valign="middle" colspan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr>
			</table>
		</form>
    </body>
</html>

