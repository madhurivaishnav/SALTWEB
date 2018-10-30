<%@ Control Language="c#" AutoEventWireup="True" CodeBehind="Header.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Navigation.Header"
    TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<div id="NoPrint" name="NoPrint" nowrap="nowrap" width="100%">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr valign="top" id="trOrganisationHeader" class="topmenu">
            <td class="topMenuImageCellLeft">
               <img border="0" src="/General/Images/Transparent.gif" runat=server height="83" width="295">
              
            </td>
            <td class="topMenuImageCellCenter">
                <img border="0" src="/General/Images/Transparent.gif" height="60" width="1">
            </td>
            <td class="topMenuImageCellRight">
                <asp:Label ID="lblSectionTitle" runat="server" /><div class="SaltLogo" id="imgSaltLogo"
                    runat="server" style="display: none;" />
                    
                  <% if (isSaltAdmin)
                   { %>
                <img class="HomePageOrgImage" id="imgHeaderAdmin" height="63" border="0" runat="server" visible="false">
                <% }
                   else
                   {%>
                <img class="HomePageOrgImage" id="imgHeader" height="63" border="0" runat="server" visible="false">
                <% } %>                    
            </td>
        </tr>
    </table>
    <%--<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr valign="top" class="topmenubg" width="100%">
		<td >
			<table border="0">
				<tr style="white-space:nowrap;">
					<label for=lblDefault onclick="javascript:window.location=('/Default.aspx');"><td valign="top" align="left" class="topmenuNav" width="100" onmouseout="this.className='topmenuNav';" onmouseover="this.className='topmenuNavOver';">
						<nobr><a id=lblDefault href="/Default.aspx" class="topmenu" runat="server"><Localized:LocalizedLiteral id="litHome" runat="server"></Localized:LocalizedLiteral></a></nobr></td>
					</label>
					
					<label id="lblMyTraining" runat="server" for=lblMyTraining onclick="javascript:window.location=('/MyTraining.aspx');"><td valign="top" align="left" class="topmenuNav" width="100" onmouseout="this.className='topmenuNav';" onmouseover="this.className='topmenuNavOver';"><nobr><a id=hrefMyTraining href="/MyTraining.aspx" class="topmenu" runat="server"><Localized:LocalizedLiteral id="litMyTraining" runat="server"></Localized:LocalizedLiteral></a></nobr></td>		
					</label>
					
					<label for=lblAdministrationHome onclick="javascript:window.location=('/Administration/AdministrationHome.aspx');"><td valign="top" align="left" class="topmenuNav" width="100" onmouseout="this.className='topmenuNav';" onmouseover="this.className='topmenuNavOver';">
						<nobr><a id=lblAdministrationHome href="/Administration/AdministrationHome.aspx" class="topmenu" runat="server"><Localized:LocalizedLiteral id="litAdministration" runat="server"></Localized:LocalizedLiteral></a></nobr></td>
					</label>
					
					<label for=lblReportingHome onclick="javascript:window.location=('/Reporting/ReportingHome.aspx');"><td valign="top" align="left" class="topmenuNav" width="100" onmouseout="this.className='topmenuNav';" onmouseover="this.className='topmenuNavOver';">
						<nobr><a id=lblReportingHome href="/Reporting/ReportingHome.aspx" class="topmenu" runat="server"><Localized:LocalizedLiteral id="litReports" runat="server"></Localized:LocalizedLiteral></a></nobr></td>
					</label>
					
					<label for=lblLinks onclick="javascript:window.location=('/Links.aspx');"><td valign="top" align="left" class="topmenuNav" width="100" onmouseout="this.className='topmenuNav';" onmouseover="this.className='topmenuNavOver';">
						<nobr><a id=lblLinks href="/Links.aspx" class="topmenu" runat="server"><Localized:LocalizedLiteral id="litLinks" runat="server"></Localized:LocalizedLiteral></a></nobr></td>
					</label>
					
					<label for=lblHelp onclick="javascript:window.location=('/Help.aspx');"><td valign="top" align="left" class="topmenuNav" width="100" onmouseout="this.className='topmenuNav';" onmouseover="this.className='topmenuNavOver';">
						<nobr><a id=lblHelp href="/Help.aspx" class="topmenu" runat="server"><Localized:LocalizedLiteral id="litHelp" runat="server"></Localized:LocalizedLiteral></a></nobr></td>
					</label>
					
					<label for=ucHeader_lnkExit><td valign="top" align="left" class="topmenuNav" width="100" onmouseout="this.className='topmenuNav';" onmouseover="this.className='topmenuNavOver';">
						<nobr><asp:linkbutton runat="server" id="lnkExit" cssclass="topmenu" causesvalidation="False" onclick="lnkExit_Click"><Localized:LocalizedLiteral id="litExit" runat="server"></Localized:LocalizedLiteral></asp:linkbutton></nobr></td>
					</label>
					
					<label for=lblBlank ><td valign="top" align="left" class="topmenuNav" onmouseout="this.className='topmenuNav';" >
						<nobr><a id=lblBlank  class="topmenu" runat="server"></a></nobr></td>
					</label>
					
					
				</tr>
			</table>
		</td>
	</tr>
</table>--%>
   <ul id="menu">
        <span class="headermenuspan"><a style="cursor:pointer;" href="/Default.aspx">Home</a></span><span class="headermenuspan">
            <asp:LinkButton runat="server" ID="lnkExit" CssClass="topmenu" CausesValidation="False"
                OnClick="lnkExit_Click">
                <Localized:LocalizedLiteral ID="litExit" runat="server"></Localized:LocalizedLiteral></asp:LinkButton>
        </span>
        <li><span class="headermenuspantext">&nbsp;</span><span class="hamburger">
            <img border="0" src="/General/Images/hamburger.png" style="background-position: center"
                class="hamburgerimage" /></span>
            <ul>
                <li onclick="javascript:window.location=('/Default.aspx');"><span><a id="lblDefault"
                    href="/Default.aspx" class="topmenu" runat="server">
                    <Localized:LocalizedLiteral ID="litHome" runat="server"></Localized:LocalizedLiteral></a></span>
                </li>
                <li id="lblMyTraining" runat="server" onclick="javascript:window.location=('/MyTraining.aspx');">
                    <span><a id="hrefMyTraining" href="/MyTraining.aspx" class="topmenu" runat="server">
                        <Localized:LocalizedLiteral ID="litMyTraining" runat="server"></Localized:LocalizedLiteral></a></span>
                </li>
                <li onclick="javascript:window.location=('/Administration/AdministrationHome.aspx');">
                    <span><a id="lblAdministrationHome" href="/Administration/AdministrationHome.aspx"
                        class="topmenu" runat="server">
                        <Localized:LocalizedLiteral ID="litAdministration" runat="server"></Localized:LocalizedLiteral></a></span>
                </li>
                <li onclick="javascript:window.location=('/Reporting/ReportingHome.aspx');"><span><a
                    id="lblReportingHome" href="/Reporting/ReportingHome.aspx" class="topmenu" runat="server">
                    <Localized:LocalizedLiteral ID="litReports" runat="server"></Localized:LocalizedLiteral></a>
                </span></li>
                <li onclick="javascript:window.location=('/Links.aspx');"><span><a id="lblLinks"
                    href="/Links.aspx" class="topmenu" runat="server">
                    <Localized:LocalizedLiteral ID="litLinks" runat="server"></Localized:LocalizedLiteral></a>
                </span></li>
                <li onclick="javascript:window.location=('/Help.aspx');"><span style="border: 0px;"><a id="lblHelp" href="/Help.aspx"
                    class="topmenu" runat="server">
                    <Localized:LocalizedLiteral ID="litHelp" runat="server"></Localized:LocalizedLiteral></a>
                </span></li>
                <%--<li><span style="border: 0px; width:150px">                    
                        <asp:LinkButton runat="server" ID="lnkExit" CssClass="topmenu" CausesValidation="False"
                            OnClick="lnkExit_Click" >
                            <Localized:LocalizedLiteral ID="litExit" runat="server"></Localized:LocalizedLiteral></asp:LinkButton>                    
                </span></li>--%>
                <li style="display: none;"><span>
                    <label for="lblBlank">
                        <a id="lblBlank" class="topmenu" runat="server"></a>
                    </label>
                </span></li>
            </ul>
        </li>
    </ul>
</div>
