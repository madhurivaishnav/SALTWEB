﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MailThroughput.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Application.MailThroughput" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Mail Throughput</title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
        <meta name="CODE_LANGUAGE" content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta http-equiv="refresh" content="30" />    
</head>
    <body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
        <form id="MailThroughputForm" method="post" runat="server">
            <table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
                <!-- Header -->
                <tr align="center" valign="top" width="100%">
                    <td align="center" valign="top" width="100%" colspan="2">
                        <navigation:header id="Header1" runat="server"></navigation:header>
                    </td>
                </tr>
                <tr height="100%" align="left" valign="top">
                    <!-- Left Navigation -->
                    <td class="AdminMenuContainer">
                        <navigation:adminmenu id="ucadminMenu" runat="server"></navigation:adminmenu>
                    </td>
                    <!-- Body/Content -->
                    <td class="DataContainer">
                        <asp:label id="lblPageTitle" cssclass="pageTitle" runat="server">Mail Throughput</asp:label><br />
                        <table align="left" width="100%" border="0">
                            <tr>
                                <asp:button ID  ="btnServiceToggle" OnClick="btnServiceToggle_Click" runat="server" CssClass = "saveButton" text ="stop/start services"/>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:PlaceHolder runat="server">
                                        <asp:GridView ID="MailThroughputGrid"
                                            AllowPaging="true" AllowSorting="true"
                                            OnPageIndexChanging="MailThroughputGrid_PageIndexChanging"
                                            OnSorting="GridView1_Sorting"
                                            DataKeyNames="OrganisationName" 
                                            AutoGenerateColumns="false"
                                            HorizontalAlign="Left"
                                            runat="server">
                                            <Columns>
                                                <asp:HyperLinkField
                                                    HeaderText="OrganisationName" DataTextField="OrganisationName"
                                                    DataNavigateUrlFields="OrganisationName"
                                                    DataNavigateUrlFormatString="MailThroughputDetails.aspx?OrganisationName={0}"
                                                    SortExpression="OrganisationName" />
                                                <asp:HyperLinkField
                                                    HeaderText="Emails delivered in last hour" DataTextField="Emails delivered in last hour"
                                                    DataNavigateUrlFields="OrganisationName"
                                                    DataNavigateUrlFormatString="MailThroughputDetails.aspx?OrganisationName={0}&EmailinHour=true"
                                                    SortExpression="Emails delivered in last hour" />
                                                <asp:HyperLinkField
                                                    HeaderText="Emails delivered in last day" DataTextField="Emails delivered in last day"
                                                    DataNavigateUrlFields="OrganisationName"
                                                    DataNavigateUrlFormatString="MailThroughputDetails.aspx?OrganisationName={0}&EmailinDay=true"
                                                    SortExpression="Emails delivered in last day" />
                                                <asp:BoundField
                                                    HeaderText="Percent of Expected Emails"
                                                    DataField="Percent of Expected Emails"
                                                    DataFormatString="{0}%" 
                                                    SortExpression="Percent of Expected Emails" />
                                            </Columns>
                                            <RowStyle CssClass="tablerow1" />
                                            <AlternatingRowStyle CssClass="tablerow2" />
                                            <HeaderStyle CssClass="tablerowtop" />
                                        </asp:GridView>
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
    </form>
</body>
</html>