<%@ Page language="c#" Codebehind="Disclaimer.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Disclaimer" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<html>
  <head>
    <title id="pagTitle" runat="server"></title>
    <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link href="/general/css/terms_style.css" rel="stylesheet" type="text/css">
  </head>
  <body bgcolor="#CCCCCC" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

    <form id="Form1" method="post" runat="server">
		<div id="Main">
            <!-- Insert Main Section here -->
            <p align="center"><strong><font size="5"><Localized:LocalizedLabel id="lblDisclaimerTitle" runat="server"></Localized:LocalizedLabel></font></strong></p>
            <hr align="center" noshade>
            <p>
				<Localized:LocalizedLabel id="lblDisclaimerContent" runat="server"></Localized:LocalizedLabel>
			</p>
            <p align="center"><a href="javascript: this.close();"><img src="/general/images/close.gif" width="114" height="32" border="0"></a></p>
            <p>&nbsp;</p>
        </div>
     </form>
	
  </body>
</html>
