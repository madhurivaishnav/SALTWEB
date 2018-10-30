<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeZoneEdit.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.TimeZoneEdit" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register assembly="Uws.Framework.WebControl" namespace="Uws.Framework.WebControl" tagprefix="cc1" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">

<html>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
	<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0"
		onload="document.frmTimezoneDetails.txtTimezoneName.focus();">
		<form id="frmTimezoneDetails" method="post" runat="server">

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
						
                        <Localized:Localizedlabel id="lblPageTitle" Runat="server" CssClass="pageTitle"></Localized:Localizedlabel><br>
                        
						<table align="left" border="0">
							<tr>
								<td>
									<asp:PlaceHolder ID="plhTimeZoneDetails" Runat="server">
										<TABLE border="0">
											<TR>
												<TD class="formLabel">
													<Localized:LocalizedLabel id="lblTimeZoneName" runat="server"></Localized:LocalizedLabel>
                                                    &nbsp;</TD>
												<TD>
													<asp:textbox id="txtTimezoneName" runat="server" columns="40" textmode="SingleLine" maxlength="50"></asp:textbox>
													<asp:textbox id="txtTimezoneID" runat="server" columns="40" textmode="SingleLine" maxlength="50" Visible="False"></asp:textbox>
													<Localized:Localizedrequiredfieldvalidator id="validatorTimeZoneName" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the timezone name." controltovalidate="txtTimezoneName"></Localized:Localizedrequiredfieldvalidator></TD>
											</TR>

											<TR>
												<TD class="formLabel">
													<Localized:LocalizedLabel id="lblOffset" runat="server"></Localized:LocalizedLabel>
                                                    &nbsp;
                                                </TD>
												<TD style="HEIGHT: 20px">
													<asp:dropdownlist id="offsetList" runat="server">
														<asp:listitem value="-720">{UTC -12:00}</asp:listitem>
														<asp:listitem value="-690">{UTC -11:30}</asp:listitem>
														<asp:listitem value="-660">{UTC -11:00}</asp:listitem>
														<asp:listitem value="-630">{UTC -10:30}</asp:listitem>
														<asp:listitem value="-600">{UTC -10:00}</asp:listitem>
														<asp:listitem value="-570">{UTC -09:30}</asp:listitem>
														<asp:listitem value="-540">{UTC -09:00}</asp:listitem>
														<asp:listitem value="-510">{UTC -08:30}</asp:listitem>
														<asp:listitem value="-480">{UTC -08:00}</asp:listitem>
														<asp:listitem value="-450">{UTC -07:30}</asp:listitem>
														<asp:listitem value="-420">{UTC -07:00}</asp:listitem>
														<asp:listitem value="-390">{UTC -06:30}</asp:listitem>
														<asp:listitem value="-360">{UTC -06:00}</asp:listitem>
														<asp:listitem value="-330">{UTC -05:30}</asp:listitem>
														<asp:listitem value="-300">{UTC -05:00}</asp:listitem>
														<asp:listitem value="-270">{UTC -04:30}</asp:listitem>
														<asp:listitem value="-240">{UTC -04:00}</asp:listitem>
														<asp:listitem value="-210">{UTC -03:30}</asp:listitem>
														<asp:listitem value="-180">{UTC -03:00}</asp:listitem>
														<asp:listitem value="-150">{UTC -02:30}</asp:listitem>
														<asp:listitem value="-120">{UTC -02:00}</asp:listitem>
														<asp:listitem value="-90">{UTC -01:30}</asp:listitem>
														<asp:listitem value="-60">{UTC -01:00}</asp:listitem>
														<asp:listitem value="-30">{UTC -00:30}</asp:listitem>
														<asp:listitem value="0">{UTC +00:00}</asp:listitem>
														<asp:listitem value="30">{UTC +00:30}</asp:listitem>
														<asp:listitem value="60">{UTC +01:00}</asp:listitem>
														<asp:listitem value="90">{UTC +01:30}</asp:listitem>
														<asp:listitem value="120">{UTC +02:00}</asp:listitem>
														<asp:listitem value="150">{UTC +02:30}</asp:listitem>
														<asp:listitem value="180">{UTC +03:00}</asp:listitem>
														<asp:listitem value="210">{UTC +03:30}</asp:listitem>
														<asp:listitem value="240">{UTC +04:00}</asp:listitem>
														<asp:listitem value="270">{UTC +04:30}</asp:listitem>
														<asp:listitem value="300">{UTC +05:00}</asp:listitem>
														<asp:listitem value="330">{UTC +05:30}</asp:listitem>
														<asp:listitem value="360">{UTC +06:00}</asp:listitem>
														<asp:listitem value="390">{UTC +06:30}</asp:listitem>
														<asp:listitem value="420">{UTC +07:00}</asp:listitem>
														<asp:listitem value="450">{UTC +07:30}</asp:listitem>
														<asp:listitem value="480">{UTC +08:00}</asp:listitem>
														<asp:listitem value="510">{UTC +08:30}</asp:listitem>
														<asp:listitem value="540">{UTC +09:00}</asp:listitem>
														<asp:listitem value="570">{UTC +09:30}</asp:listitem>
														<asp:listitem value="600">{UTC +10:00}</asp:listitem>
														<asp:listitem value="630">{UTC +10:30}</asp:listitem>
														<asp:listitem value="660">{UTC +11:00}</asp:listitem>
														<asp:listitem value="690">{UTC +11:30}</asp:listitem>
														<asp:listitem value="720">{UTC +12:00}</asp:listitem>
													
													</asp:dropdownlist>&nbsp;
											    </TD>
											</TR>

											<TR>
												<TD class="formLabel">
													<Localized:LocalizedLabel id="lblDisplayName" runat="server"></Localized:LocalizedLabel>
                                                    &nbsp;</TD>
												<TD>
													<asp:textbox id="txtTimezoneDisplayName" runat="server" columns="40" textmode="SingleLine" maxlength="50"></asp:textbox>
													<Localized:Localizedrequiredfieldvalidator id="validatorTimezoneDisplayName" runat="server" CssClass="ValidatorMessage" display="Dynamic"
														errormessage="You must specify the timezone display name." controltovalidate="txtTimezoneDisplayName"></Localized:Localizedrequiredfieldvalidator>
												</TD>
														
														
											</TR>
											<TR>
												<TD class="formLabel">
													<Localized:LocalizedLabel id="lblDelete" runat="server"></Localized:LocalizedLabel>
                                                    &nbsp;
                                                </TD>
    											<TD>
	                                                <asp:CheckBox ID="deleteTimezone" runat="server" />												
												</TD>
											</TR>
											<TR>
												<TD class="formLabel">
													<Localized:LocalizedLabel id="lblDayLight" runat="server"></Localized:LocalizedLabel>
                                                    &nbsp;
                                                </TD>
												<TD>
                                                    <asp:datagrid id="dtgDLSRule" runat="server" width="30%" 
                                                        autogeneratecolumns="False" borderstyle="Solid"  
                                                        AllowPaging="True" onpageindexchanged="onPageIndexChanged" BorderColor="Black" BorderWidth="1">
                                                        <PagerStyle HorizontalAlign="Left" Mode="NumericPages" />
                                                        <alternatingitemstyle cssclass="tablerow1"></alternatingitemstyle>
                                                        <itemstyle cssclass="tablerow2"></itemstyle>
                                                        <columns>
                                                            
                                                            
                                                            <asp:TemplateColumn HeaderText="Start Year">
                                                                <headerstyle cssclass="tablerowtop" width="100" height="25"></headerstyle>
                                                                <itemstyle horizontalalign="left"></itemstyle>
                                                                 <ItemTemplate>
                                                                 <asp:HyperLink ID="hyLink" Text='<%# DataBinder.Eval(Container.DataItem, "year") %>' NavigateUrl='<%#"OrgEditTimeZoneDaylightRules.aspx?timezone="+txtTimezoneID.Text + "&ruleid=" + DataBinder.Eval(Container.DataItem, "ruleid")%>' Runat="server"></asp:HyperLink>
                                                                     </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            
                                                        </columns>
                                                    </asp:datagrid>                                                
                                                </TD>
											</TR>


                                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>


                                           <tr>
                                                <td align="center" colspan="2" width="30%">
                                                    <Localized:LocalizedButton ID="btnSave" Runat="server" OnClick="btnSave_Click"></Localized:LocalizedButton>
                                                </td>
                                           </tr>
                                           
										</TABLE>
										<asp:label runat="server" id="lblMessage" enableviewstate="False"></asp:label>
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
