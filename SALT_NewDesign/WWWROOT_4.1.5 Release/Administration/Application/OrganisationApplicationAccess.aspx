<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Page language="c#" Codebehind="OrganisationApplicationAccess.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.OrganisationApplicationAccess" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title runat="server" 
id=pagTitle></title>
<STYLE:STYLE id=ucStyle runat="server"></Style:Style>
<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
<meta content=C# name=CODE_LANGUAGE>
<meta content=JavaScript name=vs_defaultClientScript>
<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </HEAD>
<body bottomMargin=0 leftMargin=0 topMargin=0 rightMargin=0 
MS_POSITIONING="FlowLayout">
<form id=frmOrganisationApplicationAccess method=post runat="server">
<table height="100%" cellSpacing=0 cellPadding=0 width="100%" align=center 
border=0>
				<!-- Header -->
  <tr vAlign=top align=center width="100%">
    <td vAlign=top align=center width="100%" colSpan=2><navigation:header id=ucHeader runat="server"></navigation:header></TD></TR>
  <tr vAlign=top align=left height="100%">
					<!-- Left Navigation -->
    <td class=AdminMenuContainer><navigation:adminmenu id=ucAdminMenu runat="server"></navigation:adminmenu></TD>
					<!-- Body/Content -->
     <td class="DataContainer"><LOCALIZED:LOCALIZEDLABEL id=lblPageTitle runat="server" cssclass="pageTitle"></Localized:Localizedlabel><!--Configuration 
						Values--><br>
      <table width="95%" align=left border=0>
							<!--tr>
								<td align="left" colspan="2"><asp:label id="lblMessage" runat="server" enableviewstate="False"></asp:label></td>
							</tr>
							<tr>
								<td colspan="2">
									<Localized:LocalizedLabel id="lblNote" runat="server"></Localized:LocalizedLabel>
								</td>
							</tr-->
        <tr>
          <td colSpan=2>
            <% rowOrganisationList = 0; %>
            <asp:Repeater id="rptOrganisationList" runat="server">
                <HeaderTemplate>
                <tr class="tablerowtop">
                <td style="width: 50%;"><Localized:LocalizedLabel id="grid_Org" runat="server"></Localized:LocalizedLabel></td>
                <td style="width: 13%;"><Localized:LocalizedLabel id="grid_CPDPoints" runat="server"></Localized:LocalizedLabel></td>
                <td style="width: 13%;"><Localized:LocalizedLabel id="grid_PolicyBuilder" runat="server"></Localized:LocalizedLabel></td>
                <td style="width: 13%;"><Localized:LocalizedLabel id="grid_Ebook" runat="server"></Localized:LocalizedLabel></td>
				<!-- Madhuri CPD Event Start -->
				<td style="width: 13%;"><Localized:LocalizedLabel id="grid_CPDEvent" runat="server"></Localized:LocalizedLabel></td>
				<!-- Madhuri CPD Event End -->
                </HeaderTemplate>
												<ItemTemplate>
                <%  rowOrganisationList = (rowOrganisationList + 1) % 2;
                    if (rowOrganisationList == 0)
                    {  %>
                <tr class="tablerow1">
                <% } else {%>
                <tr class="tablerow2">
                <% } %>
                <td>
                <asp:hiddenfield id="organisationID" runat="server" value ='<%# DataBinder.Eval(Container, "DataItem.OrganisationID") %>' />
                <%# DataBinder.Eval(Container, "DataItem.OrganisationName") %></td>
                <td><asp:checkbox id="chkCPDProfile" runat="server" Checked='<%# GetAccessStatus(DataBinder.Eval(Container.DataItem, "cpd profile")) %>' /></td>
                <td><asp:checkbox id="chkPolicy" runat="server" Checked='<%# GetAccessStatus(DataBinder.Eval(Container.DataItem, "policy")) %>' /></td>
                <td><asp:checkbox id="chkEbook" runat="server" Checked='<%# GetAccessStatus(DataBinder.Eval(Container.DataItem, "ebook")) %>' /></td>
				<!-- Madhuri CPD Event Start -->				
				<td><asp:checkbox id="chkCPDEvent" runat="server" Checked='<%# GetAccessStatus(DataBinder.Eval(Container.DataItem, "cpd event")) %>' /></td>
				<!-- Madhuri CPD Event End -->
                </tr>
												</ItemTemplate>
            </asp:Repeater>

			</td></tr>
        <tr>
          <td><A href="/Administration/AdministrationHome.aspx" ><LOCALIZED:LOCALIZEDLITERAL 
            id=lnkReturn runat="server" 
            key="cmnReturn"></Localized:LocalizedLiteral></A></TD>
          <td >
				<asp:Label ID="lblUpdMessage" Runat="server" Visible="False" />
				<LOCALIZED:LOCALIZEDBUTTON id=butSaveAll runat="server" cssclass="saveButton" key="btnSaveAll" text="Save All" onclick="butSaveAll_Click"></Localized:LocalizedButton></TD></TR></TABLE></TD></TR>
				<!-- Footer -->
  <tr vAlign=bottom align=center>
    <td vAlign=middle align=center colSpan=2><navigation:footer id=ucFooter runat="server"></navigation:footer></TD></TR></TABLE></FORM>
	</body>
</HTML>
