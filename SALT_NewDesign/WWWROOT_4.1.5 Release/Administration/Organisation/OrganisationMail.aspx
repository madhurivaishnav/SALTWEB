<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrganisationMail.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.OrganisationMail" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="../../General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="../../General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="../../General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="../../General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
    <HEAD>
		<title runat="server" id="pagTitle"></title>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1" />
		<meta name="CODE_LANGUAGE" content="C#" />
		<meta name="vs_defaultClientScript" content="JavaScript" />
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	</HEAD>
    <body  ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
        <form id="form1" runat="server">
        
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
                        <td  class="DataContainer">   
                        <Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Organisation Mail Setup</Localized:LocalizedLabel><br />
						    
					            <table align = "left" border = "0" >						    
						        <tr>
						            <td colspan = "2">
						                <b><Localized:LocalizedLiteral ID="ltrEmailServices" runat="server"></Localized:LocalizedLiteral></b>
						                <br />						            
						                <Localized:LocalizedLiteral ID="ltrEmailServicesDesc" runat="server"></Localized:LocalizedLiteral>						            
						                <br />
						            </td>
    						        
						        </tr>
						        <tr>
						            <td align = "left" colspan ="2">
						                <asp:button ID="btnMailFlag" OnClick="btnMailFlag_Click" runat="server" CssClass = "saveButton"  />
						                <br />
						                <br />
						            </td>						        
						        </tr>										    
						        </table>
                                <br />
                                <br />
						        <br />
						        <br />
						        
						        <br />
						        <br />						    
						        <asp:panel id="pnlReminders" Runat="server">
	                            <table style="BORDER-COLLAPSE: collapse" cellSpacing="0" cellPadding="1" border="1">
		                            <tr>
			                            <td>			                                
				                            <table id="tblReminderescalation" cellspacing="0" cellpadding="3" border="1">
                                                <tr class="tablerowtop">
                                                    <td width="300">
                                                        &nbsp;<Localized:LocalizedLabel id="hdrCourseName" runat="server" />
                                                    </td>
                                                    <td align="center" width="80" >
                                                        <Localized:LocalizedLabel id="hdrInitEnrolment" runat="server" />
                                                    </td>
                                                    <td align="center" width="80">
                                                        &nbsp;<Localized:LocalizedLabel id="hdrPreExpiryNotification" runat="server" />
                                                    </td>
                                                    <td align="center" width="80" >
                                                        <Localized:LocalizedLabel id="hdrPostExpiryNotification" runat="server" />
                                                    </td>
                                                    <td align="center" width="160" >
                                                        <Localized:LocalizedLabel id="hdrAction" runat="server" />
                                                    </td>                                                    
                                                </tr>
                                                <asp:Repeater ID="rptReminderEsc" runat="server"  >
                                                    <ItemTemplate>
                                                        <% rowCourseList = (rowCourseList + 1) % 2;
                                                           if (rowCourseList == 0)
                                                            {  %>
                                                        <tr class="tablerow1">
                                                        <% } else {%>
                                                        <tr class="tablerow2">
                                                        <% } %>
                                                            <td width="300">
                                                                <%# DataBinder.Eval(Container.DataItem, "CourseName") %>
                                                            </td>
                                                            <td align="center" width="80" >
                                                                <!-- Status -->
                                                                <%# DataBinder.Eval(Container.DataItem, "RemindUsers") %>
                                                            </td>
                                                            <td align="center" width="80" >
                                                                <!-- Status -->
                                                                <%# DataBinder.Eval(Container.DataItem, "QuizExpiryWarn")%>
                                                            </td>
                                                            <td align="center" width="80" >
                                                                <!-- Status -->
                                                                <%# DataBinder.Eval(Container.DataItem, "PostExpReminder")%>
                                                            </td>
                                                            <td width = "160" >
                                                                <asp:LinkButton ID="lnkToggle" Runat="server" CommandName="toggle" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "RemEscId")%>' Enabled="True" >
                                                                    <%# DataBinder.Eval(Container.DataItem, "dateEnabled")%>
                                                                </asp:LinkButton>&nbsp;&nbsp;
                                                                <asp:LinkButton ID="lnkEdit" Runat="server" CommandName="edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "CourseId")%>' Enabled="True" >
                                                                    <%# DataBinder.Eval(Container.DataItem, "coledit")%>
                                                                </asp:LinkButton>&nbsp;&nbsp;
                                                                <asp:LinkButton ID="lnkDel" Runat="server" CommandName="delete" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "RemEscId")%>' Enabled="True" >
                                                                    <%# DataBinder.Eval(Container.DataItem, "coldel")%>
                                                                </asp:LinkButton>
                                                            </td>                                                           
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </table>
				                        </td>
		                            </tr>		                            
	                            </table>
	                            
	                            <br />
                                <br />
                                <asp:Button id="btnAddnew"  Width = 300 runat=server  CssClass="saveButton" text="Add New Mail Notification" onclick="btnAddNew_Click" />
                            
                            </asp:panel>
                    </td>
                </tr>
            </table>
                               
        </form>
    </body>
</html>
