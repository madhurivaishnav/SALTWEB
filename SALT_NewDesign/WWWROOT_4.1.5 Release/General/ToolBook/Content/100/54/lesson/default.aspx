<%@ Page language="c#" AutoEventWireup="false" Inherits="Bdw.Application.Salt.InfoPath.DefaultLesson" %>
<%@ Register TagPrefix="uc1" TagName="Style" Src="/General/InfoPath/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title><asp:Literal id="pagTitle" runat="server"></asp:Literal></title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<uc1:style id="ucStyle" runat="server"></uc1:style>
		<script src="/General/InfoPath/Include/Javascript.js"></script>
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
				<asp:placeholder id="plhContent" runat="server" />
		</form>
	</body>
</HTML>


