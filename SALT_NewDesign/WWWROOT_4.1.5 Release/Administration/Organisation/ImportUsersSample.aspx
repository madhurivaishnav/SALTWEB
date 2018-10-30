<%@ Page language="c#" Codebehind="ImportUsersSample.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.ImportUsersSample" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server"></Style:Style>
    <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  </head>
  <body MS_POSITIONING="FlowLayout">
	
    <form id="Form1" method="post" runat="server">
	<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Sample CSV and XML Files.</Localized:LocalizedLabel>
    <table width="100%">
         <tr>
            <td class="tablerowtop">
				<Localized:LocalizedLabel id="lblCSVFormat" runat="server"></Localized:LocalizedLabel>
				<br> <Localized:LocalizedLabel id="lblCSVExample" runat="server"></Localized:LocalizedLabel>
				<br> <Localized:LocalizedLabel id="lblCSVNote" runat="server"></Localized:LocalizedLabel>
            </td>
        </tr>
        <tr>
            <td class="tablerow1">
                JSMITH,MyPassword,John,Smith,j.smith@organisation.com.au,1,24,1,State,NSW,N,N,Y,j.jones@domain2.com.au
            </td>
        </tr>
        <tr>
            <td class="tablerow2">
                BBLOGGS,ThisPassword,Bill,Bloggs,b.bloggs@organisation.com.au,2,24,0,State,NSW
            </td>
        </tr>
         <tr>
            <td class="tablerow1">
                CJONES,aPassword,Cliff,Jones,c.jones@organisation.com.au,1,28,1,State,QLD
            </td>
        </tr>
        <tr>
            <td class="tablerowbottom">
                <br>
            </td>
        </tr>
        <tr>
            <td class="tablerowtop">
				<Localized:LocalizedLabel id="lblXMLFormat" runat="server"></Localized:LocalizedLabel>
            </td>
        </tr>
        <tr>
            <td class="tablerow1">
                
<pre>
&lt;?xml version="1.0" encoding="windows-1252"?&gt;
<asp:label ID="lblNameSpace" Runat="server"></asp:label>
	&lt;User Username="username1" Password="password1" Firstname="Imported" 
	    Lastname="User1" Email="imported.user1@org.com" ExternalID="IU1" UnitID="" Archive=""
	    NotifyUnitAdmin="N" NotifyOrgAdmin="N" ManagerNotification="Y" 
	    ManagerToNotify="joe.smith@domain1.com"&gt;
		&lt;CustomClassifications&gt;
		    &lt;CustomClassification Name="State" Option="NSW"/&gt;
		&lt;/CustomClassifications&gt;
	&lt;/User&gt;
	&lt;User Username="username2" Password="password2" Firstname="Imported" 
	    Lastname="User2" Email="imported.user2@org.com" ExternalID="IU2" UnitID="1" Archive="1"&gt;
		&lt;CustomClassifications&gt;
		    &lt;CustomClassification Name="State" Option="ACT"/&gt;
		&lt;/CustomClassifications&gt;
	&lt;/User&gt;
	&lt;User Username="username3" Password="password3" Firstname="Imported" 
	    Lastname="User3" Email="imported.user3@org.com" ExternalID="IU3" UnitID="2" Archive="0"&gt;
		&lt;CustomClassifications&gt;
		    &lt;CustomClassification Name="State" Option="ACT"/&gt;
		&lt;/CustomClassifications&gt;
	&lt;/User&gt;
<asp:label ID="lblEndTag" Runat="server"></asp:label> 
</pre>  
            </td>
        </tr> 
        </table>
       
     </form>
	
  </body>
</html>
