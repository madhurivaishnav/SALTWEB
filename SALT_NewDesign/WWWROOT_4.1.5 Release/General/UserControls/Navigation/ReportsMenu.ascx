<%@ Control Language="c#" AutoEventWireup="True" CodeBehind="ReportsMenu.ascx.cs"
    Inherits="Bdw.Application.Salt.Web.General.UserControls.Navigation.ReportsMenu"
    TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Register TagPrefix="uc1" TagName="SelectOrganisation" Src="SelectOrganisation.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<div id="NoPrint" name="NoPrint">
    <table cellspacing="0" cellpadding="0" align="left" border="0" class="ReportMenu"
        width="295px">
        <tr>
           <td>
                <uc1:SelectOrganisation ID="SelectOrganisation1" runat="server"></uc1:SelectOrganisation>
            </td>
        </tr>       
        <tr>
            <td>
                <div id='cssmenu'>
                    <ul>
                        <li runat="server" id="trActiivtyReport" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="UserActivityGroup" runat="server"></Localized:LocalizedLabel></a>
                            <ul id="uiActiivtyReport" runat="server">
                                <li id="divPersonalReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkPersonalReport" runat="server"
                                        CausesValidation="False" OnClick="lnkPersonalReport_Click"></Localized:LocalizedLinkButton></li>
                                <li id="divAdminCurrentReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdminCurrentReport" runat="server"
                                        CausesValidation="False" OnClick="lnkAdminCurrentReport_Click"></Localized:LocalizedLinkButton></li>
                                <li id="divAdvancedCourseStatusReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedCourseStatusReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedCourseStatusReport_Click"></Localized:LocalizedLinkButton></li>
                                <li id="divAdvancedCompletedUsersReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedCompletedUsersReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedCompletedUsersReport_Click"></Localized:LocalizedLinkButton></li>
                                <li id="divAdvancedAtRiskReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedAtRiskReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedAtRiskReport_Click"></Localized:LocalizedLinkButton></li>
                                <li id="divAdvancedWarningReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedWarningReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedWarningReport_Click"></Localized:LocalizedLinkButton></li>
                                <li id="divAdvancedProgressReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedProgressReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedProgressReport_Click"></Localized:LocalizedLinkButton></li>
                                <li id="divAdminHistoricalPointReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdminHistoricalPointReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdminHistoricalPointReport_Click"></Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                        <%--		<tr id="AdvancedReport3" runat="server">
			<td align="left"><Localized:Localizedlinkbutton cssclass="ReportMenu" id="lnkAdvancedSummaryReport" runat="server" causesvalidation="False" onclick="lnkAdvancedSummaryReport_Click">Summary Report</Localized:Localizedlinkbutton></td>
		</tr>
		<tr id="AdvancedReport4" runat="server">
			<td align="left"><Localized:Localizedlinkbutton cssclass="ReportMenu" id="lnkAdvancedTrendReport" runat="server" causesvalidation="False" onclick="lnkAdvancedTrendReport_Click">Trend Report</Localized:Localizedlinkbutton></td>
		</tr>--%>
                        <li runat="server" id="trOrganisationReportGroup" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="OrganisationReportGroup" runat="server">Policy Reports</Localized:LocalizedLabel></a>
                            <ul id="uiOrganisationReportGroup" runat="server">
                                <li id="divAdvancedSummaryReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedSummaryReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedSummaryReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                                <li id="divAdvancedTrendReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedTrendReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedTrendReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                        <%--		<tr>
			<td align="left"><Localized:Localizedlinkbutton cssclass="ReportMenu" id="lnkEmailReport" runat="server" causesvalidation="False" onclick="lnkEmailReport_Click">Email Report</Localized:Localizedlinkbutton></td>
		</tr>--%>
                        <%--		<tr id="AdvancedReport5" runat="server">
			<td align="left"><Localized:Localizedlinkbutton cssclass="ReportMenu" id="lnkAdvancedEmailSentReport" runat="server" causesvalidation="False" onclick="lnkAdvancedEmailSentReport_Click">Email Sent Report</Localized:Localizedlinkbutton></td>
		</tr>--%>
                        <li runat="server" id="trEmailReport" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="EmailReportGroup" runat="server">Policy Reports</Localized:LocalizedLabel></a>
                            <ul id="ulEmailReport" runat="server">
                                <li id="divEmailReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkEmailReport" runat="server"
                                        CausesValidation="False" OnClick="lnkEmailReport_Click">Policy Builder Report</Localized:LocalizedLinkButton></li>
                                <li id="divCPDEmailReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lbCPDEmailReport" runat="server"
                                        CausesValidation="False" OnClick="lbCPDEmailReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                                <li id="divPolicyEmailReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lblPolicyEmailReport" runat="server"
                                        CausesValidation="False" OnClick="lbPolicyEmailReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                                <li id="divAdvancedEmailSentReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkAdvancedEmailSentReport"
                                        runat="server" CausesValidation="False" OnClick="lnkAdvancedEmailSentReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                        <%--		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lbUserDetailsReport" runat="server" causesvalidation="False" cssclass="ReportMenu">User Detail Report</Localized:Localizedlinkbutton></TD>
		</TR>
		<TR id="ActiveInactiveReport" runat="server">
			<TD align="left">
				<Localized:Localizedlinkbutton id="lbActiveInactiveReport" runat="server" causesvalidation="False" cssclass="ReportMenu">Licensing Report</Localized:Localizedlinkbutton></TD>
		</TR>
		<tr id="LicensingReport" runat="server">
			<td align="left"><Localized:LocalizedHyperLink cssclass="ReportMenu" id="lnkLicensingReport" NavigateURL="/Reporting/PeriodicReport.aspx?&ReportID=20"
					runat="server" causesvalidation="False">Licensing Report</Localized:LocalizedHyperLink></td>
		</tr>
		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lbUnitPathwayReport" runat="server" causesvalidation="False" cssclass="ReportMenu">Unit Pathway Report</Localized:Localizedlinkbutton></TD>
		</TR>
		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lblUnitComplianceReport" runat="server" causesvalidation="False" cssclass="ReportMenu" onclick="lblUnitComplianceReport_Click">Unit Compliance Report</Localized:Localizedlinkbutton></TD>
		</TR>
		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lblUnitAdminstratorReport" runat="server" causesvalidation="False" cssclass="ReportMenu" onclick="lblUnitAdminstratorReport_Click">Unit Administrator Report</Localized:Localizedlinkbutton></TD>
		</TR>
--%>
                        <li runat="server" id="trAdmininistrationReports" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="AdminReportGroup" runat="server">Policy Reports</Localized:LocalizedLabel>
                        </a>
                            <ul runat="server" id="ulAdmininistrationReports">
                                <li id="divUserDetailsReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lbUserDetailsReport" runat="server"
                                        CausesValidation="False" OnClick="lbUserDetailsReport_Click">Policy Builder Report</Localized:LocalizedLinkButton></li>
                                <li id="divActiveInactiveReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lbActiveInactiveReport"
                                        runat="server" CausesValidation="False" OnClick="lbActiveInactiveReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                                <li id="divLicensingReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkLicensingReport" runat="server"
                                        CausesValidation="False" OnClick="lnkLicensingReport_Click">Policy Builder Report</Localized:LocalizedLinkButton></li>
                                <li id="divUnitPathwayReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lbUnitPathwayReport" runat="server"
                                        CausesValidation="False" OnClick="lbUnitPathwayReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                                <li id="divUnitComplianceReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lblUnitComplianceReport"
                                        runat="server" CausesValidation="False" OnClick="lblUnitComplianceReport_Click">Policy Builder Report</Localized:LocalizedLinkButton></li>
                                <li id="divUnitAdminstratorReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lblUnitAdminstratorReport"
                                        runat="server" CausesValidation="False" OnClick="lblUnitAdminstratorReport_Click">Policy Email Report</Localized:LocalizedLinkButton></li>
                                <li id="divEbookDownloadReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkEbookDownloadReport"
                                        runat="server" CausesValidation="False" OnClick="lnkEbookDownloadReport_Click"></Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                        <%--		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lbCPDReport" runat="server" causesvalidation="False" cssclass="ReportMenu">CPD Report</Localized:Localizedlinkbutton></TD>
		</TR>
		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lbCPDEmailReport" runat="server" causesvalidation="False" cssclass="ReportMenu">CPD Email Report</Localized:Localizedlinkbutton></TD>
		</TR>--%>
                        <li runat="server" id="trCPDReports" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="CPDReportGroup" runat="server">Policy Reports</Localized:LocalizedLabel></a>
                            <ul id="ulCPDReports" runat="server">
                                <li id="divCPDReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lbCPDReport" runat="server"
                                        CausesValidation="False" OnClick="lbCPDReport_Click">Policy Builder Report</Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                        <%--		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lbPolicyBuilderReport" runat="server" causesvalidation="False" cssclass="ReportMenu" onclick="lbPolicyBuilderReport_Click">Policy Builder Report</Localized:Localizedlinkbutton></TD>
		</TR>
		<TR>
			<TD align="left">
				<Localized:Localizedlinkbutton id="lblPolicyEmailReport" runat="server" causesvalidation="False" cssclass="ReportMenu" onclick="lbPolicyEmailReport_Click">Policy Email Report</Localized:Localizedlinkbutton></TD>
		</TR>
--%>
                        <li runat="server" id="trPolicyReports" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="PolicyReportGroup" runat="server">Policy Reports</Localized:LocalizedLabel></a>
                            <ul id="ulPolicyReports" runat="server">
                                <li id="divPolicyBuilderReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lbPolicyBuilderReport" runat="server"
                                        CausesValidation="False" OnClick="lbPolicyBuilderReport_Click">Policy Builder Report</Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                        <li runat="server" id="trPeriodicReports" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="lblReportPeriodic" runat="server">Periodic Reports</Localized:LocalizedLabel></a>
                            <ul runat="server" id="ulPeriodicReports">
                                <li id="divPeriodicReport" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="ReportMenu" ID="lnkPeriodicReport" runat="server"
                                        CausesValidation="False" OnClick="lnkPeriodicReport_Click">Periodic Report Delivery</Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td align="left">
                <br>
                <b>
            </td>
        </tr>
    </table>
</div>
